return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    -- Only register shellcheck if it's actually installed.
    -- Attempting to run a missing binary causes a SIGSEGV in the static build.
    local have_shellcheck = vim.fn.executable("shellcheck") == 1

    -- Configure which linters to use for each filetype
    lint.linters_by_ft = {
      sh   = have_shellcheck and { "shellcheck" } or {},
      bash = have_shellcheck and { "shellcheck" } or {},
    }

    if have_shellcheck then
      -- Configure shellcheck linter
      --format json: Output JSON for parsing
      --shell sh: Force POSIX sh mode for portability
      lint.linters.shellcheck = {
        cmd = "shellcheck",
        stdin = true,
        args = {
          "--format", "json",
          "--shell", "sh",
          "-",
        },
        ignore_exitcode = true,
        parser = function(output, bufnr)
          if output == "" then
            return {}
          end

          local ok, decoded = pcall(vim.json.decode, output)
          if not ok then
            return {}
          end

          local diagnostics = {}
          for _, item in ipairs(decoded) do
            table.insert(diagnostics, {
              lnum = item.line - 1,
              end_lnum = item.endLine - 1,
              col = item.column - 1,
              end_col = item.endColumn - 1,
              severity = item.level == "error" and vim.diagnostic.severity.ERROR
                      or item.level == "warning" and vim.diagnostic.severity.WARN
                      or vim.diagnostic.severity.INFO,
              message = item.message,
              source = "shellcheck",
              code = item.code,
            })
          end

          return diagnostics
        end,
      }
    end

    -- This variable will hold our "active" timer.
    -- We define it outside the function so it persists between different events.
    local lint_timer = nil

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufReadPost" }, {
      group = vim.api.nvim_create_augroup("nvim-lint-debounced", { clear = true }),
      callback = function()
        -- STEP 1: Check if a timer is already "counting down" from a previous change.
        -- If it is, we KILL it. This is the "Debounce" part.
        -- If you type 10 letters quickly, this kills the timer 9 times.
        if lint_timer then
          lint_timer:stop()
          lint_timer:close()
          lint_timer = nil
        end

        -- STEP 2: Create a new timer (a delayed function).
        -- This says: "Wait 500ms, and if nobody kills me first, run the code inside."
        lint_timer = vim.defer_fn(function()
          -- Clear the variable so we know the timer has finished/expired
          lint_timer = nil

          -- Trigger the actual linter (shellcheck)
          lint.try_lint()
        end, 500) -- The '500' is the "pause" duration in milliseconds
      end,
    })

    -- STEP 3: Handle the "Save" event separately.
    -- When you manually save (:w), you usually want the linter to update
    -- IMMEDIATELY to confirm the file is clean before you close it.
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("nvim-lint-immediate", { clear = true }),
      callback = function()
        -- If a delayed timer was still counting down, kill it so we don't
        -- run the linter twice (once now, and once in 500ms).
        if lint_timer then
          lint_timer:stop()
          lint_timer:close()
          lint_timer = nil
        end

        -- Run the linter right now
        lint.try_lint()
      end,
    })
  end,
}
