---@class LinterShim
---@field name string
---@field cmd string
---@field args string[]
---@field res_to_diagnostics fun(res: string, set_file_diagnostics: fun(file: string, diagnostics: vim.Diagnostic[]), on_err: fun(msg: string))

local linter_ns = vim.api.nvim_create_namespace 'linter-runner'

---@type table<string, boolean>
local running_linters = {}

return {

  get_running = function()
    return running_linters
  end,

  ---@param linter LinterShim
  ---@param on_complete? fun()
  run_linter = function(linter, on_complete)
    local progress = require 'fidget.progress'

    local p_handle = progress.handle.create {
      title = '',
      message = 'Launching ...',
      lsp_client = { name = linter.name },
    }

    -- NOTE: dont run linter if already running
    if running_linters[linter.name] then
      p_handle.message = linter.name .. ' is already running'
      p_handle:cancel()
      return
    end

    running_linters[linter.name] = true

    local uv = vim.loop

    local chunks = {}
    local err_chunks = {}

    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()

    uv.spawn(linter.cmd, {
      args = linter.args,
      stdio = { nil, stdout, stderr },
    }, function(code, signal)
      -- on exit
    end)

    uv.read_start(stdout, function(err, data)
      assert(not err, err)
      if data then
        p_handle.message = 'Processing stdout ...'
        -- read data from stdout
        chunks[#chunks + 1] = data
      else
        -- stdout stream ended
        local res = table.concat(chunks, '')
        linter.res_to_diagnostics(res, function(file, diagnostics)
          p_handle.message = 'Updating diagnostics ...'
          local buf = vim.fn.bufnr(file, true)
          vim.fn.bufload(buf)
          vim.diagnostic.set(linter_ns, buf, diagnostics, { severity_sort = true })
        end, function(msg)
          p_handle.message = 'Error: ' .. msg
        end)

        running_linters[linter.name] = false
        p_handle:finish()
        if on_complete then
          vim.schedule(on_complete)
        end
      end
    end)

    uv.read_start(stderr, function(err, data)
      assert(not err, err)
      if data then
        -- print('stderr chunk', stderr, data)
        err_chunks[#err_chunks + 1] = data
      else
        -- local res = table.concat(err_chunks, '')
        -- end of stream
      end
    end)
  end,
}
