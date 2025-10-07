--[[

  TODO:

    >> <leader>dd is great ... I can imagine it being greater though, like you go go go
        so repeated use of it just slides things to the left and closes, ... so you always
        have only two windows open!

    >> we are currently using a heuristic that looks at files with long lines of code
       to turn off certain features that would otherwise stall nvim ... it looks however
       like the issue is not really long lines, but just large files in general, so
       perhaps we should change the heuristic to simply act on the file size ...?

    >> context breadcrumbs could be cool

    >> when writing commands with : or / etc, it would be nice to see them somewhere a bit
       more local and in view, than in the command line, for example, when you have two buffer
       windows side by side in a split, the command line is all the way down on lower left
       perhaps it would be more convenient to have it closer to the active window 

    >> Project idea that has nothing to do with nvim config, but that I would like to write
       down somewhere. You know those cogs with holes, and you put a pencil inside the hole
       and you drag the cog around another cog, and it produces these nice patterns if you complete
       several revolutions. Make a simulation of that in THREE.js.

    >> Would be great to have a history of prompts, or at least to be able to see the most recent
       prompt

    >> The GPT scratch buffer should be something that we can keep open, but it should not be
       'in the way' like it currently is. Perhaps some kind of keybinding to quickly bring it to
       front or send it to background?

    >> should be possible to jump up and down commits in a branch lane maybe?

    >> the new git commit window <leader>gic will cause the workspace to think it has
       unmodified changes, we should filter out the file that is associated with this

    >> we currently show whether or not buffer is saved in the statusline, also show in a very simple
       and similar way whether or not we have uncommitted changes (ahead of remote)

    >> backup and version your dotfiles

       - .wezterm.lua
       - < ghostty configuration >
       - .config/tmux.conf
       - .bashrc .profile ... should we just go all in on .zsh ? or the oh my ... something

    >> gitgraph and perhaps other non file buffers should also display the
       branch name we're on?

    >> auto close diffview on :Git commit ? with :tabclose

    >> add single branch mode for gitgraph, make it easy to select which
       branch you want to see, consider display a subset of branches, not just ONE

    >> auto update the git graph

    >> we are going to want to find a way to show ONLY unsaved changes

    >> disable or remap the cO in diffview, scary that it would pick
       resolutions for all conflicts and at the same time is nearly
       identical to resolving a single conflcit with co

    >> strange highlighting on dockerfiles

       1. open a dockerfile
       2. find a list of commands like a bunch of rows with COPY < ...>
       3. move your cursor up and down to above and below rows ...

    >> popup window reminindg you to stretch and drink water

    >> add a little toolbox window that you can open at any time
       Make it searchable.
       Have tool slike `to uppercase` `to hex` etc etc :D

    >> get a nice way to jump to parent scopes locally. Currently
       we can do something like this with treesitter-context, but
       that jumps to the context that is 'off screen' try '[c'

    >> find out how to quickly switch to previous buffer

    >> find a way to do grep search over subset of files

--]]
--
--
--
local KEY = vim.keymap.set
local CMD = vim.api.nvim_create_user_command
local AUTO = vim.api.nvim_create_autocmd

do
  -- I'm tired of netrw, gives me bad vibes, so we disable it
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

-- since gx stopped using wslview recently ... we force it here
-- only for wslview though ...
if vim.fn.has('wsl') == 1 then
  local function open_in_windows(url)
    -- Escape quotes
    url = url:gsub('"', '\\"')
    -- Prefer wslview if available
    local has_wslview = vim.fn.executable('wslview') == 1
    if has_wslview then
      vim.fn.jobstart({ 'wslview', url }, { detach = true })
    else
      vim.fn.jobstart({ 'explorer.exe', url }, { detach = true })
    end
  end

  -- Override vim.ui.open globally
  vim.ui.open = function(path)
    open_in_windows(path)
  end
end

-- I use this constant in several places to decide whether or not to turn off
-- certain features that would otherwise freeze up nvim, such as tressitter or lsps
vim.g.max_line_len = 1000

-- :help localleader
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' ' --- Set <space> as the local leader key
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed

-- :help option-list
--
-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
vim.opt.clipboard = 'unnamedplus' --  See `:help 'clipboard'`
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 1000 -- Decrease mapped sequence wait time
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.termguicolors = true -- yes use tempr gui colors
vim.opt.wrap = false -- don't wrap lines
vim.opt.fillchars:append({
  diff = '', -- better looking diff (remove) regions
  -- vert = ' ', -- used for WinSeparator
  -- horiz = ' ', -- used for WinSeparator
})
vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false -- Don't show the mode, since it's already in status line
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- ... actually lets make it sensitive if an upper case is involved
vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default
vim.opt.splitright = true -- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.list = true -- Sets how neovim will display certain whitespace in the editor.
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.cursorline = false -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode

vim.opt.foldcolumn = 'auto'

-- vim.opt.foldmethod = 'expr'
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.opt.runtimepath:prepend('/home/isak/.opam/default/share/ocp-indent/vim')

---@type "wsl2" | "linux" | "mac" | "unknown"
local host = 'unknown'

do
  local osname = vim.loop.os_uname()
  local host_fingerprint = string.lower(table.concat(vim.tbl_values(osname), ' '))
  local wsl2 = string.find(host_fingerprint, 'wsl2') ~= nil
  local mac = string.find(host_fingerprint, 'darwin') ~= nil
  local linux = string.find(host_fingerprint, 'linux') ~= nil -- FIXME
  if wsl2 then
    host = 'wsl2'
  elseif mac then
    host = 'mac'
  elseif linux then
    host = 'linux'
  end
end

-- WIN_BORDER = { '', '█', '', '█', '', '█', '', '█' }
WIN_BORDER = { '█', '█', '█', '█', '█', '█', '█', '█' }
-- WIN_BORDER = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

local getWorkspaceName = function()
  local workdir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not workdir then
    workdir = vim.fn.getcwd()
  end
  local workdirBasename = vim.fn.fnamemodify(workdir, ':t')
  return workdirBasename, workdir
end

local isWorkspaceDirty = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in pairs(bufs) do
    local unsaved = vim.api.nvim_get_option_value('modified', { buf = buf })
    local bufname = vim.api.nvim_buf_get_name(buf)
    if unsaved and bufname ~= '' then
      return true
    end
  end
  return false
end

--- very useful for creating a centered floating window
---@param buf integer
---@param title string?
---@param width integer?
---@param height integer?
---@return integer window
local function new_centered_float_win(buf, title, width, height)
  local winWidth = vim.o.columns
  local winHeight = vim.o.lines
  local width = math.min(winWidth, width or 64)
  local height = math.min(winHeight, height or 32)

  local deltaWidth = winWidth - width
  local deltaHeight = winHeight - height

  local offsetX = math.ceil(deltaWidth / 2)
  local offsetY = math.ceil(deltaHeight / 2)

  return vim.api.nvim_open_win(buf, false, {
    title_pos = 'center',
    title = title and ' ' .. title .. ' ',
    width = width,
    height = height,
    relative = 'editor',
    row = offsetY,
    col = offsetX,
    border = WIN_BORDER,
    style = 'minimal',
  })
end

local popup_open = false
---@type integer?
local popup_win = nil

--- very useful for creating a popup notification
---@param message string[]
---@return integer? window
local function new_popup(message)
  -- prevent more than one popup from being created at a time
  if popup_open then
    return popup_win
  end
  popup_open = true
  local buf = vim.api.nvim_create_buf(false, true)
  local popup_win = new_centered_float_win(buf, ' note ', 20, 10)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, message)
  vim.api.nvim_set_current_win(popup_win)
  vim.api.nvim_create_autocmd('WinLeave', {
    buffer = 0,
    callback = function()
      popup_open = false
    end,
  })

  return popup_win
end

do
  --- popup remindin me to do stuff
  local timer = vim.loop.new_timer()
  local minutes = 30
  local interval = minutes * 60 * 1000
  timer:start(
    interval,
    interval,
    vim.schedule_wrap(function()
      new_popup({ 'remember to stretch', 'and', 'watch your posture!' })
    end)
  )
end

--- @param prompt string
--- @param buf integer
--- @param win integer
local function gpt(prompt, buf, win)
  local api_key = os.getenv('OPENAI_API_KEY')
  if not api_key then
    vim.api.nvim_err_writeln('Missing OPENAI_API_KEY')
    return
  end

  -- Prepare JSON payload (escape double quotes in prompt)
  local payload = vim.fn.json_encode({
    model = 'gpt-4o-mini',
    messages = {
      { role = 'user', content = prompt },
    },
    stream = true,
  })

  -- Build curl command
  local cmd = {
    'curl',
    '-sN',
    '-H',
    'Authorization: Bearer ' .. api_key,
    '-H',
    'Content-Type: application/json',
    '-d',
    payload,
    -- TODO: use the responses endpoint instead
    'https://api.openai.com/v1/chat/completions',
  }

  --- NOTE: you may change this, it controls the wrapping width of things outside of code blocks
  local wrap_n = 50

  --- NOTE: dont touch these vars
  local wrap = true
  local wrap_upd_line = 0
  local line_ctr = 1
  local current_line = ''

  --- @type 'text' | 'code'
  local mode = 'text'

  --- @param line string
  --- @param pattern string
  --- @return 'begin' | 'end' | 'inside' | 'outside'
  local function process_code_block_delim(line, pattern)
    if wrap_upd_line ~= line_ctr and line:sub(1, 3) == pattern then
      wrap = not wrap
      wrap_upd_line = line_ctr
      local previous_mode = mode -- needed for return
      mode = mode == 'text' and 'code' or 'text' -- update mode
      return previous_mode == 'text' and 'begin' or 'end'
    end
    return mode == 'text' and 'outside' or 'inside'
  end

  -- Start the async curl job
  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        -- Filter out empty lines or "data: [DONE]"
        if line:match('^data: ') then
          local json_str = line:match('^data: (.+)')
          if json_str and json_str ~= '[DONE]' then
            local ok, decoded = pcall(vim.fn.json_decode, json_str)
            if ok and decoded and decoded.choices then
              --- @class Delta
              --- @field content string
              local delta = decoded.choices[1].delta
              if delta and delta.content then
                local nl_s = delta.content:find('\n')
                local multi_nl = delta.content:find('\n\n') ~= nil

                -- can you give me three examples of rust code with a bit of a short explanation between each snippet?

                if nl_s then
                  -- Append to the current line and write it
                  local current_line_1 = string.gsub(current_line .. delta.content:sub(0, nl_s - 1), '\n', '')
                  local current_line_2 = string.gsub(delta.content:sub(nl_s + 1), '\n', '')

                  process_code_block_delim(current_line_1, '```')

                  current_line = current_line_2

                  line_ctr = line_ctr + 1

                  if multi_nl then
                    line_ctr = line_ctr + 1
                  end

                  vim.schedule(function()
                    local last = vim.api.nvim_buf_line_count(buf)

                    vim.api.nvim_buf_set_lines(buf, last - 1, -1, false, { current_line_1 })

                    if multi_nl then
                      vim.api.nvim_buf_set_lines(buf, last, -1, false, { '' })
                      last = last + 1
                    end

                    vim.api.nvim_buf_set_lines(buf, last, -1, false, { current_line_2 })
                    vim.api.nvim_win_set_cursor(win, { last + 1, #current_line_2 })
                  end)
                else
                  -- Append to the current line and write it
                  local current_line_1 = string.gsub(current_line .. delta.content, '\n', '')
                  local current_line_2 = ''

                  process_code_block_delim(current_line_1, '```')

                  current_line = current_line_1

                  if wrap then
                    if #current_line_1 > wrap_n then
                      for i = wrap_n, 1, -1 do
                        local c = current_line_1:sub(i, i)
                        if c == ' ' and i < wrap_n then
                          current_line_2 = current_line_1:sub(i + 1)
                          current_line_1 = current_line_1:sub(0, i - 1)
                          current_line = current_line_2
                          line_ctr = line_ctr + 1
                          break
                        end
                      end
                    end
                  end

                  vim.schedule(function()
                    local last = vim.api.nvim_buf_line_count(buf)

                    vim.api.nvim_buf_set_lines(buf, last - 1, -1, false, { current_line_1 })
                    vim.api.nvim_win_set_cursor(win, { last, #current_line_1 })

                    if #current_line_2 > 0 then
                      vim.api.nvim_buf_set_lines(buf, last, -1, false, { current_line_2 })
                      vim.api.nvim_win_set_cursor(win, { last + 1, #current_line_2 })
                    end
                  end)
                end
              end
            end
          end
        end
      end
    end,
    on_stderr = function(_, err)
      if err then
        print('stderr: ', vim.inspect(err))
      end
    end,
    on_exit = function(_, code, _)
      if code ~= 0 then
        vim.api.nvim_err_writeln('GPT stream exited with code ' .. code)
      end
    end,
  })

  -- Add an empty line to buffer to start writing
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
end

local function get_visual_selection()
  vim.cmd([[normal! "vy]])
  ---@diagnostic disable-next-line: assign-type-mismatch, param-type-mismatch
  local content = vim.fn.getreg('v', 1, true) --- @type string[]
  return content
end

--- @param lines string[]
local function remove_indent(lines)
  local min_indent = math.huge
  for _, line in ipairs(lines) do
    local indent = line:match('^(%s*)')
    local line_empty = line:match('^%s*$') ~= nil
    if not line_empty then
      local indent_n = indent and #indent or 0
      if min_indent > indent_n then
        min_indent = indent_n
      end
    end
  end

  for i, line in ipairs(lines) do
    lines[i] = line:sub(min_indent + 1)
  end
end

local function open_gpt_window()
  local lname = ({
    javascript = 'js',
    typescript = 'ts',
    typescriptreact = 'tsx',
    javascriptreact = 'jsx',
  })[vim.bo.filetype]
  lname = lname or vim.bo.filetype

  local wrapped_code = { '', '```' .. lname }

  local code = get_visual_selection()

  -- remove the indenting
  remove_indent(code)

  -- add surrounding quotes
  vim.list_extend(wrapped_code, code)
  vim.list_extend(wrapped_code, { '```' })

  local buf = vim.api.nvim_create_buf(false, true)
  local win = new_centered_float_win(buf, ' chat-gpt ', 100, 40)
  vim.api.nvim_set_current_win(win)

  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, wrapped_code)

  --- place us two lines below the code text
  vim.cmd([[normal! G]])
  vim.cmd([[normal! 2o]])
  vim.cmd('startinsert')

  KEY('n', 'K', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local query = table.concat(
      vim.list_extend(lines, {
        'please be very terse and code oriented, avoid very long lines of text. also always write code inside ``` blocks.',
      }),
      '\n'
    )

    --- add some lines to separate our promtp from the result
    local last = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_buf_set_lines(buf, last, -1, false, { '', '', ' --- response --- ', '', '' })

    gpt(query, buf, win)
  end, { buffer = 0, desc = 'gpt: send prompt' })

  KEY({ 'n', 'i' }, '<C-x>', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  end, { buffer = 0, desc = 'gpt: clear the prompt buffer' })
end

local function iso_to_utc_timestamp(iso)
  -- Parse ISO (basic YYYY-MM-DDTHH:MM:SS), ignoring timezone suffixes

  ---@diagnostic disable-next-line: unused-local
  local y, m, d, H, M, S, _ms = iso:match('(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%.(%d+)Z')
  if not y then
    return nil, 'Invalid ISO format'
  end

  -- Convert to number
  -- y, m, d, H, M, S = tonumber(y), tonumber(m), tonumber(d), tonumber(H), tonumber(M), tonumber(S)

  -- Convert to timestamp as if local time
  local t = os.time({ year = y, month = m, day = d, hour = H, min = M, sec = S })

  -- Adjust for local timezone offset to get UTC timestamp
  ---@diagnostic disable-next-line: param-type-mismatch
  local local_offset = os.difftime(t, os.time(os.date('!*t', t)))
  return t - local_offset
end

-- Get current UTC timestamp
local function now_utc()
  local now = os.time()
  ---@diagnostic disable-next-line: param-type-mismatch
  local offset = os.difftime(now, os.time(os.date('!*t', now)))
  return now - offset
end

-- Calculate elapsed time in seconds
local function elapsed_since(iso)
  local ts, err = iso_to_utc_timestamp(iso)
  if not ts then
    return nil, err
  end
  return now_utc() - ts
end

-- calculate some text string describing age based on seconds input
---@param seconds integer
local function seconds_to_age_str(seconds)
  local rem = seconds
  local s = rem % 60
  rem = (rem - s) / 60
  local min = rem % 60
  rem = (rem - min) / 60
  local hours = rem % 24
  rem = (rem - hours) / 24
  local days = rem % 7
  rem = (rem - days) / 7
  local weeks = rem % 4
  rem = (rem - weeks) / 4
  local months = rem % 12
  rem = (rem - months) / 12
  local years = rem

  if years > 0 then
    return years .. ' years and ' .. months .. ' months'
  elseif months > 0 then
    return months .. ' months and ' .. weeks .. ' weeks'
  elseif weeks > 0 then
    return weeks .. ' weeks and ' .. days .. ' days'
  elseif days > 0 then
    return days .. ' days and ' .. hours .. ' hours'
  elseif hours > 0 then
    return hours .. ' hours and ' .. min .. ' min'
  elseif min > 0 then
    return min .. ' minutes and ' .. s .. ' seconds'
  end
end

local isBufferDirty = function()
  return vim.api.nvim_get_option_value('modified', { buf = 0 })
end

--=========================== KEYMAPS =============================

KEY('n', 'U', '<cmd>earlier 1f<cr>', { desc = 'undo all the way to previous (earlier) save' })
KEY('n', 'W', '<cmd>later 1f<cr>', { desc = 'redo all the way to later save' })

KEY('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'hide higlights after hitting <Esc>' })

KEY('n', '<C-f>', '<NOP>', { desc = 'disable windowfull scroll down' })
KEY('n', '<C-b>', '<NOP>', { desc = 'disable windowfull scroll up' })

KEY('n', '*', require('nice_star'), { desc = 'highlight all occurrences of current word BETTER than default' })

KEY('n', '<C-j>', ':m+1<cr>', { desc = 'swap line with line below' })
KEY('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' })

-- better macro
KEY({ 'v', 'n' }, 'q', '<NOP>', { desc = 'disable regular macro biding', noremap = true })
KEY('n', 'mr', 'q', { desc = 'start/stop recording macro', noremap = true })
KEY('n', 'ma', '@', { desc = 'apply macro', noremap = true })

-- GPT
KEY({ 'v', 'n' }, '<leader>G', open_gpt_window, { desc = 'chat gpt' })

KEY('n', '<leader>X', function()
  local winid = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(winid)
  local height = vim.api.nvim_win_get_height(winid)
  print('Width:', width, 'Height:', height)
end, { desc = 'get window dimensions' })

-- NOTE: this overrides the default shift + r "aka R" replace ... but I don't find that useful
--       instead this is quite useful, I often find myself wanting to replace the remaining text on the
--       line with what I have in my copy buffer or whatever it's called, so something I just yanked or deleted
--
--       so imagine you are at the colon ":" in this line of code
--
--           foo: Vector2[];
--           bar: float;
--
--       you want to copy Vector2[]; and replace float; with that ... :)
--
KEY('n', 'R', '"0PlD', { desc = 'replace rest of line with yanked' }) -- vscode <alt> + <down>

KEY('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' }) -- vscode <alt> + <down>

KEY('n', '<leader>N', ':set number!<cr>:set relativenumber!<cr>', { desc = 'toggle line numbering' })

KEY('n', '<leader>J', require('color_inspect'), { desc = 'Inspect Color Under Cursor' })

KEY('v', '<leader>b', require('boxes'), { desc = 'draw nice box ... lol' })

KEY('n', '<leader>dd', function()
  vim.cmd('wincmd v')
  require('telescope.builtin').lsp_definitions()
end, { desc = 'open definition in new window' })

-- checking if you have good smooth color gradients, if you don't, something is wrong with your setup
require('check_reds')

local function macro_stop_wrap(foo)
  return function()
    if vim.fn.reg_recording() ~= '' then
      new_popup({ 'macro recording' })
      return
    end
    foo()
  end
end

-- Alt + j / k now glide you up and down in a nice scrolled way
KEY({ 'v', 'n' }, '<M-j>', macro_stop_wrap(require('glide')('j')), { desc = 'glide in the j direction' })
KEY({ 'v', 'n' }, '<M-k>', macro_stop_wrap(require('glide')('k')), { desc = 'glide in the k direction' })

-- starts us off where we left off in buffer
require('recall_buf_position')

-- This brings you into block visual select mode ... on windows it's Ctrl + Q, and on Linux Ctrl + V ... cool to have something OS independent :)
-- Experimental alternative to `Ctrl + V` which is blocked by some terminals
KEY('n', 'VV', '<C-v>')

-- KEY('n', '<M-u>', '<C-e>', { desc = 'scroll down' })
-- KEY('n', '<M-i>', '<C-y>', { desc = 'scroll up' })

--
-- Diagnostic keymaps
--

-- we want high priority, higher than gitsigns and marks
vim.diagnostic.config({ signs = { priority = 100 } })

KEY('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
KEY('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- useful for figuring out what higlight groups are relevant for stuff under cursor
KEY('n', '<leader>I', function()
  vim.show_pos()
end)

CMD('Lint', require('lint-runner').lint_workspace, { desc = 'workspace lint' })
CMD('LintClear', require('lint-runner').clear_diagnostics, { desc = 'clear workspace lint' })

KEY('n', '<leader>F', require('lint-runner').mark_fixed, { desc = '[lint] mark as fixed' })

KEY('n', ']n', ':cnext<CR>', { noremap = true, silent = true })
KEY('n', '[n', ':cprev<CR>', { noremap = true, silent = true })

-- highlight when yanking
AUTO('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- bootstrap lazy -_-
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

KEY('n', '<leader>U', function()
  local code = vim.fn.input('u:')
  local char = vim.fn.nr2char(code)
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, col) .. char .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = 'insert unicode' })

require('lazy').setup({

  {
    'nvim-tree/nvim-tree.lua', -- file tree
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        hijack_netrw = false, -- NOTE: otherwise tree is opened by default
      })
      -- NOTE: find something better, this conflicts with `find` `'s'`
      -- KEY('n', 'fs', ':NvimTreeToggle<cr>', { desc = 'toggle file tree', silent = true })
    end,
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    dependencies = {
      'epheien/outline-treesitter-provider.nvim',
    },
    opts = {
      providers = {
        priority = { 'lsp', 'treesitter' },
      },
      outline_items = {
        highlight_name = true,
      },
      symbols = {
        -- Filter by kinds (string) for symbols in the outline.
        -- Possible kinds are the Keys in the icons table below.
        -- A filter list is a string[] with an optional exclude (boolean) field.
        -- The symbols.filter option takes either a filter list or ft:filterList
        -- key-value pairs.
        -- Put  exclude=true  in the string list to filter by excluding the list of
        -- kinds instead.
        -- Include all except String and Constant:
        --   filter = { 'String', 'Constant', exclude = true }
        -- Only include Package, Module, and Function:
        --   filter = { 'Package', 'Module', 'Function' }
        -- See more examples below.
        filter = nil,
        icons = {
          File = { icon = '󰈔', hl = 'Identifier' },
          Module = { icon = '󰅩', hl = 'Include' },
          Namespace = { icon = '󰨑', hl = 'Include' },
          Package = { icon = '󰏗', hl = 'Include' },
          Class = { icon = '𝓒', hl = 'Type' },

          Constructor = { icon = '󰆦', hl = '@constructor' },
          Method = { icon = '󰆧', hl = 'Function' },
          StaticMethod = { icon = '󰆦', hl = 'Function' },
          Field = { icon = '', hl = '@property' },
          Property = { icon = '', hl = '@property' },

          Function = { icon = '', hl = 'Function' },

          Enum = { icon = 'ℰ', hl = 'Type' },
          EnumMember = { icon = '', hl = 'Identifier' },

          Constant = { icon = '', hl = 'Constant' },
          Interface = { icon = '󰠳', hl = 'Type' },
          Variable = { icon = '󱕃', hl = '@variable' },

          String = { icon = '󰬴', hl = 'String' },
          Number = { icon = '', hl = 'Number' },
          Boolean = { icon = '', hl = 'Boolean' },
          Array = { icon = '󰅪', hl = 'Constant' },
          Object = { icon = '󰅩', hl = 'Type' },
          Struct = { icon = '󰅩', hl = 'Structure' },

          Key = { icon = '󰌆', hl = 'Type' },
          Null = { icon = 'NULL', hl = 'Type' },

          Event = { icon = '🗲', hl = 'Type' },
          Operator = { icon = '+', hl = 'Identifier' },

          TypeParameter = { icon = '󰊄', hl = 'Identifier' },
          TypeAlias = { icon = '󰊄', hl = 'Type' },

          Component = { icon = '󰅴', hl = 'Function' },
          Fragment = { icon = '󰅴', hl = 'Constant' },
          Parameter = { icon = '', hl = 'Identifier' },
          Macro = { icon = '', hl = 'Function' },
        },
      },
    },
  },

  {
    'mbbill/undotree', -- Nice file change history
    config = function()
      KEY('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
    end,
  },

  {
    'rose-pine/neovim',
    priority = 999,
    name = 'rose-pine',
    config = function()
      local function tweakHighlights()
        do
          local cline_bg = vim.api.nvim_get_hl(0, { name = 'CursorLine' }).bg
          local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

          -- do
          --   -- line number
          --   local hlg = vim.api.nvim_get_hl(0, { name = 'LineNr' })
          --   ---@diagnostic disable-next-line
          --   vim.api.nvim_set_hl(0, 'LineNr', { fg = hlg.fg, bg = cline_bg })
          -- end
          do
            -- cursor line number
            local hlg = vim.api.nvim_get_hl(0, { name = 'CursorLineNr' })
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = hlg.fg, bg = cline_bg })
          end
          -- do
          --   -- sign column
          --   local hlg = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
          --   ---@diagnostic disable-next-line
          --   vim.api.nvim_set_hl(0, 'SignColumn', { fg = hlg.fg, bg = cline_bg })
          -- end
          -- do
          --   -- fold column
          --   local hlg = vim.api.nvim_get_hl(0, { name = 'FoldColumn' })
          --   ---@diagnostic disable-next-line
          --   vim.api.nvim_set_hl(0, 'FoldColumn', { fg = hlg.fg, bg = cline_bg })
          -- end
          do
            -- window separator
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'WinSeparator', { fg = cline_bg, bg = bg })
          end
          do
            -- win separator in statusline
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'StatusLine', { bg = bg })
            vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = bg })
          end

          do
            -- window border and title
            local norm_float = vim.api.nvim_get_hl(0, { name = 'NormalFloat' })
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'FloatBorder', { fg = norm_float.bg, bg = bg })
            vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = norm_float.bg, bg = bg })
            local ftg = vim.api.nvim_get_hl(0, { name = 'FloatTitle' })
            vim.api.nvim_set_hl(0, 'FloatTitle', { fg = ftg.fg, bg = norm_float.bg })
            vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = ftg.fg, bg = norm_float.bg })
          end

          do
            -- win separator in statusline
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'StatusLineWedgeActive', { fg = cline_bg, bg = bg })
            local g = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename' })
            vim.api.nvim_set_hl(0, 'StatusLineWedgeInactive', { fg = g.bg, bg = bg })

            local unsaved_fg = vim.api.nvim_get_hl(0, { name = '@variable.builtin' }).fg
            local inactive_bg = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename' }).bg

            do
              vim.api.nvim_set_hl(0, 'StatusLineWedgeUnsaved', { fg = unsaved_fg, bg = bg })
            end

            do
              vim.api.nvim_set_hl(0, 'StatusLineUnsavedInactive', { fg = unsaved_fg, bg = inactive_bg })
            end
          end
        end

        do
          -- statusline
          do
            local g = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename' })
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', g)
          end

          local otherHLG = vim.api.nvim_get_hl(0, { name = '@constructor' })

          do
            local hlg = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineDevinfo' })
            hlg.fg = otherHLG.fg --- tonumber('0xFF0000', 16)
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', hlg)
          end

          do
            local hlg = vim.api.nvim_get_hl(0, { name = 'MiniStatuslineFilename' })
            hlg.fg = otherHLG.fg --- tonumber('0xFF0000', 16)
            ---@diagnostic disable-next-line
            vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', hlg)
          end
        end

        do
          -- gitgraph

          vim.api.nvim_set_hl(0, 'GitGraphBranch1', { link = '@variable.builtin' })
          vim.api.nvim_set_hl(0, 'GitGraphBranch2', { link = '@property' })
          vim.api.nvim_set_hl(0, 'GitGraphBranch3', { link = '@function.method' })
          vim.api.nvim_set_hl(0, 'GitGraphBranch4', { link = 'String' })
          vim.api.nvim_set_hl(0, 'GitGraphBranch5', { link = 'Keyword' })

          vim.api.nvim_set_hl(0, 'GitGraphHash', { link = '@variable.builtin' })
          vim.api.nvim_set_hl(0, 'GitGraphTimestamp', { link = '@function.method' })
          vim.api.nvim_set_hl(0, 'GitGraphAuthor', { link = 'Keyword' })
          vim.api.nvim_set_hl(0, 'GitGraphBranchName', { link = '@property' })
          vim.api.nvim_set_hl(0, 'GitGraphBranchTag', { link = '@property' })
          vim.api.nvim_set_hl(0, 'GitGraphBranchMsg', { link = 'Comment' })
        end

        do
          -- treesitter context
          local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
          ---@diagnostic disable-next-line
          vim.api.nvim_set_hl(0, 'TreesitterContext', { fg = normal.fg, bg = normal.bg })

          -- hide line numbers
          local hlg = vim.api.nvim_get_hl(0, { name = 'TreesitterContext' })
          ---@diagnostic disable-next-line
          vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = hlg.bg, bg = hlg.bg })

          -- make bottom same as rest of context background
          -- vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { link = 'TreesitterContext' })
          vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { link = 'WinSeparator' })
        end
      end

      ---@param contrast "high" | "normal"
      local function update_highlight(contrast)
        require('rose-pine').setup({
          dark_variant = 'main',
          styles = {
            italic = false,
          },
          palette = {
            main = contrast == 'high' and {
              base = '#000000',
              overlay = '#131313',
              surface = '#151515',
            },
            dawn = contrast == 'high' and {
              base = '#ffffff',
              overlay = '#fdfded',
              surface = '#faf4ed',
            },
          },
        })

        vim.cmd('colorscheme rose-pine')
        tweakHighlights()
      end

      ---@type "high" | "normal"
      vim.g.contrast = 'normal'

      update_highlight(vim.g.contrast)

      -- zoom feature
      KEY('n', '<leader>z', function()
        if vim.t.zoomed then
          -- we're in a zoomed tab, so close it
          vim.cmd('tabclose')
        else
          -- mark this tab as not zoomed (just in case)
          vim.t.zoomed = false

          -- open zoomed version in new tab
          vim.cmd('tabnew %')
          vim.t.zoomed = true
        end
      end, { desc = 'zoom into current buffer - toggles' })

      -- toggle between light and dark modes
      KEY('n', '<leader>T', function()
        vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
        update_highlight(vim.g.contrast)
      end, { desc = 'toggle between light and dark modes' })

      KEY('n', '<leader>C', function()
        vim.g.contrast = vim.g.contrast == 'normal' and 'high' or 'normal'
        update_highlight(vim.g.contrast)
      end, { desc = 'toggle between light and dark modes' })

      --- TODO: remove this entirely or just fix it?
      if false then -- host == 'mac' then
        -- FIXME: currently we somehow use up jobs or something keep an eye out, we have increased from 250 ms to 1500 ms
        local Job = require('plenary.job')

        local prevDarkmode = vim.o.background

        local job = Job:new({
          command = 'osascript',
          args = {
            '-e',
            'tell app "system events" to tell appearance preferences to get dark mode',
          },
          on_exit = function(j, return_val)
            if return_val ~= 0 then
              error('osascript err: ' .. vim.inspect(j:stderr_result()))
              return
            end

            ---@type string[]
            local result = j:result()
            if #result == 0 then
              error('osascript no result')
              return
            end

            local newDarkmode = result[1] == 'true' and 'dark' or 'light'
            if newDarkmode ~= prevDarkmode then
              prevDarkmode = newDarkmode
              vim.schedule(function()
                vim.o.background = newDarkmode
                update_highlight(vim.g.contrast)
              end)
            end
          end,
        })

        vim.loop.new_timer():start(0, 1500, function()
          job:start()
        end)
      end
    end,
  },

  {
    -- yay my own gitgraph plugin :)
    -- NOTE: `dev = true` => lazy then knows to look in my dev place see h: lazy.nvim-configuration
    'gitgraph.nvim',
    dev = true,
    opts = {
      symbols = {
        merge_commit = 'M',
        commit = '*',
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        on_select_commit = function(commit)
          vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
        end,
        on_select_range_commit = function(from, to)
          vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        end,
      },
      log_level = vim.log.levels.ERROR,
    },
    keys = {
      {
        '<leader>gal',
        function()
          require('gitgraph').draw({}, { all = true, max_count = 2500 })
        end,
        desc = 'GitGraph - Draw all branches',
      },
      {
        '<leader>gl',
        function()
          require('gitgraph').draw({}, { max_count = 2500 })
        end,
        desc = 'GitGraph - Draw current branch',
      },
      {
        '<leader>gt',
        function()
          require('gitgraph').test()
        end,
        desc = 'GitGraph - Draw',
      },
    },
  },

  {
    'michaelb/sniprun',
    build = 'bash ./install.sh',
    opts = {
      selected_interpreters = { 'Lua_nvim' },
      display = { 'Classic' },
    },
    init = function()
      KEY('n', '<leader>r', ':SnipRun<CR>', { desc = 'run curr line with sniprun' })
      KEY('v', '<leader>r', ":'<,'>SnipRun<CR>", { desc = 'run curr selection with sniprun' })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local w = WIN_BORDER
      --       1     2     3     4     5     6     7     8
      --   { '',   '█',  '',  '█',  '',  '█',  '',  '█' }
      --   { '╭',   '─',  '╮',  '│',  '╯',  '─',  '╰',  '│' }
      --   { "─",   "│",  "─",  "│",  "╭",  "╮",  "╯",  "╰" }
      local borderchars = { w[2], w[4], w[6], w[8], w[1], w[3], w[5], w[7] }

      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup({
        defaults = {
          mappings = {
            -- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            i = { ['<Esc><Esc>'] = require('telescope.actions').close },
            n = { ['<Esc><Esc>'] = require('telescope.actions').close },
          },
          borderchars = borderchars,
          cache_picker = { num_pickers = 10 },
          file_ignore_patterns = { '.git/' },
          vimgrep_arguments = {
            -- vvv default args see :h telescope.nvim vvv
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            -- ^^^ default args see :h telescope.nvim ^^^
            --
            -- vvv CUSTOM vvv
            '--hidden', -- include hidden files
            --
            -- if you want to disregard gitignore  '--no-ignore',      -- do NOT respect .gitignore
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')
      KEY('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      KEY('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      KEY('n', '<leader>sf', function()
        builtin.find_files({ hidden = true })
      end, { desc = '[S]earch [F]iles' })
      KEY('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      KEY('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      KEY('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      KEY('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      KEY('n', '<leader>sp', builtin.pickers, { desc = '[S]earch [P]icker' })
      KEY('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      KEY('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      KEY('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      KEY('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          -- previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      KEY('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your neovim configuration files
      KEY('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      sign_priority = 9,
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame_opts = {
        delay = 200,
      },
    },
    init = function()
      KEY('n', ']h', ':Gitsigns next_hunk<cr>', { desc = '[G]it [N]ext hunk' })
      KEY('n', '[h', ':Gitsigns prev_hunk<cr>', { desc = '[G]it [P]rev hunk' })

      KEY('n', '<leader>gp', ':Gitsigns preview_hunk<cr>', { desc = '[G]it [P]review hunk' })
      KEY('n', '<leader>gr', ':Gitsigns reset_hunk<cr>', { desc = '[G]it [R]eset hunk' })
      KEY('n', '<leader>gR', ':Gitsigns reset_buffer<cr>', { desc = '[G]it [R]eset buffer' })
      KEY('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [B]lame toggle' })
      KEY('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = '[G]it [S]tage hunk' })
    end,
  },

  {
    -- NOTE: we configure diffivew to not persiste too many diffview tabpages
    --       we do that with two strategies, youll find those marked with comments
    --       [strat 1] and [strat 2]
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-web-devicons' },
    opts = {
      hooks = {
        view_leave = function()
          -- [strat 1] close tabpage before leaving
          vim.g.diffview_tp = nil
          vim.cmd([[:DiffviewClose]])
        end,
        diff_buf_win_enter = function(buf, cwin, ctx)
          vim.g.diffview_tp = vim.api.nvim_get_current_tabpage()
          if ctx.symbol == 'b' and vim.g.diffview_just_entered then
            vim.g.diffview_just_entered = false
            vim.schedule(function()
              vim.api.nvim_set_current_win(cwin)
              local n = vim.api.nvim_buf_line_count(buf)
              local pos = vim.g.diffview_cursor_pos
              if pos and pos[1] <= n then
                vim.api.nvim_win_set_cursor(0, pos) -- note that 0 -> current window which is now the diff window after 100 ms
                vim.api.nvim_feedkeys('zz', 'n', false)
              end
            end)
          end
        end,
      },
    },
    init = function()
      KEY('n', '<leader>gd', function()
        --- [strat 2] if there's already a diffivew tap page then close that first
        local tp = vim.g.diffview_tp
        if tp then
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end
          end
          vim.g.diffview_tp = nil
        end

        --- check for local changes using git
        local function has_local_changes()
          local handle = io.popen('git status --porcelain 2>/dev/null')
          if not handle then
            return false
          end
          local result = handle:read('*a')
          handle:close()
          return result ~= ''
        end

        --- this print statement is here to debug something that sometimes happens when trying to do <leader>gd
        ---
        ---      E5108: Error executing lua: vim/_editor.lua:0: nvim_exec2(): Vim:Not a repo (or any parent), or no supported VCS adapter!
        ---      stack traceback:
        ---      [C]: in function 'nvim_exec2'
        ---      vim/_editor.lua: in function 'cmd'
        ---      /home/isak/.config/nvim/init.lua:753: in function </home/isak/.config/nvim/init.lua:717>

        local changes = has_local_changes()
        if not changes then
          print('no changes')
          return
        end

        -- fir check if there's a meaningful dif ... diffview doesn't do that ...

        -- first we get current cursor location in the file we're in
        -- it is used in the hooks of diffview above so that we can
        -- go direclty to file and line that we're currently on when executing <leader>gd
        vim.g.diffview_cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.g.diffview_just_entered = true
        vim.cmd([[:DiffviewOpen]])
      end, {
        desc = '[G]it [D]iff',
      })
    end,
  },

  {
    -- :Git command shim
    'tpope/vim-fugitive',

    init = function()
      -- git shortcuts because we got tired of fugitive ^ ^
      do
        KEY('n', '<leader>gif', ':Git fetch<cr>', { desc = 'git fetch', silent = true })
        KEY('n', '<leader>gip', ':Git pull<cr>', { desc = 'git pull', silent = true })
        KEY('n', '<leader>giP', ':Git push<cr>', { desc = 'git push', silent = true })
        KEY('n', '<leader>gic', ':Git commit<cr>', { desc = 'git commit', silent = true })
        KEY('n', '<leader>giC', ':Git commit --amend<cr>', { desc = 'git commit ammend', silent = true })
        KEY('n', '<leader>git', ':Git<cr>', { desc = 'git interactive', silent = true })

        KEY('n', '<leader>gg', function()
          vim.ui.input({ prompt = 'commit message: ' }, function(input)
            if input then
              vim.fn.system('git add .')
              vim.fn.system('git commit -m "' .. input .. '"')
              vim.fn.system('git push')
            end
          end)
        end, { desc = 'git gg yolo ... adds everything asks for commit meshes and pushes all in one go', silent = true })

        KEY('n', '<leader>gis', function()
          local group_id = 45 -- change this if you want, you can find it under dots in UI
          local win_width = 128
          local username = 'isakbm'

          if not vim.env.GITLAB_TOKEN then
            print('missing api key')
            return
          end

          local curl = require('plenary.curl')

          local page_size = 100
          local max_pages = 3
          local show_debug_ctr = false

          local function opts_page(page)
            return '?per_page=' .. page_size .. '&page=' .. page .. '&t'
          end
          local filt_assignee = '&assignee_username=' .. username
          local filt_opened = '&state=opened'

          local gitlab_url = 'https://gitlab.laiout.app'

          local json_issues = {}

          for i = 1, max_pages do
            local response = curl.get(gitlab_url .. '/api/v4/groups/' .. group_id .. '/issues' .. opts_page(i) .. filt_assignee .. filt_opened, {
              headers = {
                ['PRIVATE-TOKEN'] = vim.env.GITLAB_TOKEN,
              },
            })

            if response.status == 200 then
              local more_json_issues = vim.json.decode(response.body)
              vim.list_extend(json_issues, more_json_issues)

              if #more_json_issues < 100 then
                -- because we only expect to need to go further if we saturated page size
                break
              end
            else
              print('Failed to fetch issues: ' .. response.status)
            end
          end

          -- print(vim.inspect(json_issues))

          local issues = {}
          ---@class Loc
          ---@field col integer
          ---@field row integer
          ---@field text string
          ---@field end_col integer

          ---@type Loc[]
          local link_locs = {}

          local ctr = 1
          for _, issue in ipairs(json_issues) do
            local space_pad = '        '
            local issue_id = string.format('%d', issue.iid)

            local created_at = issue.created_at
            local age, err = elapsed_since(created_at)

            if err then
              error('error in elapsed_since(): ' .. err)
            end

            local age_str = age and seconds_to_age_str(age) or '?'

            issues[#issues + 1] = ''

            --- todo replace me with actual useful values
            local id_pad_n = 5 - #issue_id
            link_locs[#link_locs + 1] = {
              row = #issues,
              col = 1 + id_pad_n,
              text = issue_id,
              end_col = 1 + id_pad_n + #issue.web_url,
            }

            issues[#issues + 1] = string.rep(' ', 1 + id_pad_n)
              .. issue.web_url
              .. ' -> '
              .. (show_debug_ctr and string.format('%03d', ctr) .. ' - ' or '')
              .. issue.title
            issues[#issues + 1] = ''

            for _, assignee in ipairs(issue.assignees) do
              issues[#issues + 1] = space_pad .. '  ' .. assignee.name
            end

            issues[#issues + 1] = ''
            issues[#issues + 1] = space_pad .. '󱦟  ' .. age_str .. ' old'
            issues[#issues + 1] = ''
            -- issues[#issues + 1] = space_pad .. (issue.state == 'opened' and 'OPEN' or 'CLOSED')
            -- issues[#issues + 1] = ''
            issues[#issues + 1] = space_pad .. '󰓹  ' .. table.concat(issue.labels, ' ')
            issues[#issues + 1] = ''
            issues[#issues + 1] = string.rep('─', win_width)
            ctr = ctr + 1
          end

          local buf = vim.api.nvim_create_buf(false, true)

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, issues)
          local win = new_centered_float_win(buf, 'gitlab issues', win_width)
          vim.api.nvim_set_current_win(win)

          vim.api.nvim_buf_set_option(0, 'modifiable', false)
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = 'nc'
          local ns = vim.api.nvim_create_namespace('mylinks')
          for _, link in ipairs(link_locs) do
            vim.api.nvim_buf_set_extmark(buf, ns, link.row, link.col, {
              end_col = link.end_col - #link.text + 1,
              conceal = '*',
              virt_text = { { link.text, 'Underlined' } }, -- can use your own highlight group
              virt_text_pos = 'overlay',
              -- hl_mode = 'combine',
            })
          end
        end, { desc = 'gitlab issues', silent = true })
      end

      -- makes :Git commands open in a nicer floating window
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'FugitiveEditor', 'FugitiveIndex' },
        callback = function(evnt)
          local win = new_centered_float_win(evnt.buf, 'git commit')
          vim.api.nvim_win_close(0, false)
          vim.api.nvim_set_current_win(win)
        end,
      })
    end,
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',

    -- package_installed = "◍ ",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              -- this makes notifications have transparent background
              winblend = 0,
            },
          },
        },
      },
      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer
      AUTO('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            KEY('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local tele = require('telescope.builtin')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', tele.lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', function()
            tele.lsp_references({ show_line = false })
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          map('gI', tele.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          map('<leader>D', tele.lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current workspace
          map('<leader>ws', tele.lsp_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local client = vim.lsp.get_clients({ bufnr = 0 })[1] -- assume first is best
            local utf_enc = client and client.offset_encoding or 'utf-16'
            local hover_res = vim.lsp.buf_request_sync(0, 'textDocument/hover', vim.lsp.util.make_position_params(0, utf_enc), 200)
            if not hover_res then
              return
            end

            local hover = hover_res[1]

            if hover and not hover.error and hover.result and hover.result.range then
              --- @class I.Loc
              --- @field character integer
              --- @field line integer

              local file_buf = vim.api.nvim_get_current_buf()

              local s = hover.result.range['start'] --- @type I.Loc
              local e = hover.result.range['end'] --- @type I.Loc
              local old_name = vim.api.nvim_buf_get_text(0, s.line, s.character, e.line, e.character, {})[1]

              local row = vim.fn.winline()
              local col = vim.fn.wincol()
              local buf = vim.api.nvim_create_buf(false, true)
              local win = vim.api.nvim_open_win(buf, false, {
                relative = 'win',
                title = ' new name ',
                row = row,
                col = col,
                width = 25,
                height = 1,
                border = WIN_BORDER,
                style = 'minimal',
              })

              vim.api.nvim_set_current_win(win)
              vim.api.nvim_buf_set_lines(0, 0, 2, false, { old_name })
              KEY({ 'n' }, '<Esc><Esc>', ':q<cr>', { buffer = buf })
              KEY({ 'n', 'i' }, '<cr>', function()
                local new_name = vim.api.nvim_buf_get_text(0, 0, 0, 0, 256, {})[1]
                vim.api.nvim_win_close(win, true)
                if new_name == old_name then
                  print('no change')
                  return
                end
                if #new_name == 0 then
                  print('cannot name to empty string')
                  return
                end

                -- custom handler to avoid race conditions, we want to do some extra
                -- pos renaming logic, like going back to normal mode, and positioning
                -- the cursor where it was
                local original_handler = vim.lsp.handlers['textDocument/rename']
                vim.lsp.handlers['textDocument/rename'] = function(err, result, ctx, config)
                  if original_handler then
                    original_handler(err, result, ctx, config)
                  end
                  if not err and result then
                    vim.cmd.stopi()
                    cursor_pos[2] = cursor_pos[2] + 1
                    vim.api.nvim_win_set_cursor(0, cursor_pos)
                  end
                  vim.lsp.handlers['textDocument/rename'] = original_handler
                end
                vim.lsp.buf.rename(new_name, { bufnr = file_buf })
              end, { buffer = buf })
            end
          end, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', function()
            vim.lsp.buf.hover({ border = WIN_BORDER, title = ' hover ' })
          end, 'Hover Documentation')
          -- map('K', function() vim.lsp.buf.hover({ border = WIN_BORDER'rounded', title = ' hover ' }) end, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        pyright = {},
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
            },
          },
        },
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        lemminx = {},
        jdtls = {},
        -- ocamllsp = {},
        tsserver = {
          on_attach = function(client, bufnr)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local has_long_lines = false
            for _, line in ipairs(lines) do
              if #line > vim.g.max_line_len then
                has_long_lines = true
                break
              end
            end

            if has_long_lines then
              require('fidget').notify('stopping lsp', vim.log.levels.WARN)
              -- print('WARN: stopping lsp')
              client.stop()
            end
          end,
        },
        terraformls = {},
        prismals = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              workspace = {
                checkThirdParty = false,
              },
              diagnostics = {
                globals = { 'vim' },
                disable = { 'redefined-local' },
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup({
        ui = {
          border = WIN_BORDER,
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      })

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- NOTE: At the time of writing stylua that comes with Mason does not support lua52
        --       this can cause issues with goto statements not getting auto formatted correctly
        --       by formatters like conform.nvim. To get around this simply do (assuming you have rust / cargo)
        --       1. cargo install stylua --features lua52.
        --       2. go to the directory of your mason plugins, should be somewhere like ~/.local/share/nvim/mason
        --       3. inside mason/packages/stylua delete or rename stylua to old_stylua, now the stylua you installed will be used instead
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason-lspconfig').setup({
        ensure_installed = { 'tsserver' },
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_conform or vim.b[bufnr].disable_conform then
          return
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        json = { 'jq' },

        terraform = { 'terraform_fmt' },

        -- you can use this debian package instead of lemminx if you run into trouble
        -- xml = { 'xmllint' },
        -- svg = { 'xmllint' },

        -- You can use a sub-list to tell conform to run *until* a formatter is found.
        html = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
      formatters = {
        terraform_fmt = {
          command = 'tofu',
          args = { 'fmt', '-' },
          stdin = true,
        },
      },
    },
    init = function()
      KEY('n', '<leader>tc', function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr].disable_conform = not vim.b[bufnr].disable_conform
      end, { desc = 'toggle conform.nvim' })

      KEY('n', '<leader>cl', function()
        local formatters = require('conform').list_formatters()
        print('formatters:', vim.inspect(formatters))
      end, { desc = 'list formatters for current buffer' })
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require('cmp')
      cmp.setup({
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = cmp.mapping.confirm({ select = true }),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete({}),
        }),
        sources = {
          -- lsp completion
          { name = 'nvim_lsp' },
          -- completion of function parameters
          { name = 'nvim_lsp_signature_help' },
          -- completion of file paths
          { name = 'path' },
        },
      })
    end,
  },

  {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- initColorTheme(colorThemeMode)

      -- Better Around/Inside textobjects
      --
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      do
        local hipatterns = require('mini.hipatterns')

        local keywords = {
          { key = 'FIX', group = 'MiniHipatternsFixme' },
          { key = 'FIXME', group = 'MiniHipatternsFixme' },
          { key = 'HACK', group = 'MiniHipatternsHack' },
          { key = 'WARN', group = 'MiniHipatternsHack' },
          { key = 'TODO', group = 'MiniHipatternsTodo' },
          { key = 'NOTE', group = 'MiniHipatternsNote' },
        }

        local highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        }

        local bdrPattern = "[^a-zA-Z0-9'_()-]"

        for _, kw in pairs(keywords) do
          for _, key in pairs({ kw.key, string.lower(kw.key) }) do
            highlighters[key] = { pattern = bdrPattern .. '%f[%w]()' .. key .. '()%f[%W]' .. bdrPattern, group = kw.group }
            highlighters[key .. '_'] = { pattern = bdrPattern .. '%f[%w]()' .. key .. '()%f[%W]$', group = kw.group }
          end
        end

        hipatterns.setup({ highlighters = highlighters })
      end

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      do -- Simple and easy statusline.
        local statusline = require('mini.statusline')

        -- NOTE this is done outside the callback because it is slow
        -- WARN ... that means it gets outdated if you switch to a different workspace
        local workspaceName, workdirPath = getWorkspaceName()

        ---comment
        ---@param mode "active" | "inactive"
        ---@return function
        local makeStatusline = function(mode)
          return function()
            -- local _mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })

            local fileUnsaved = isBufferDirty()
            local workspaceDirty = isWorkspaceDirty()
            local has_formatter = #require('conform').list_formatters() > 0

            local function dhl(group)
              local hlg = mode == 'active' and group or 'MiniStatuslineInactive'
              return hlg
            end

            local function dhl_unsaved(unsaved, group)
              local hlg = dhl(group)
              local unsavedHlg = mode == 'active' and 'MiniStatuslineModeCommand' or 'StatusLineUnsavedInactive'
              return unsaved and unsavedHlg or hlg
            end

            local function shortenPath(path)
              if #path > 24 then
                local ff = vim.fn.split(path, '/')
                if #ff > 3 then
                  path = ff[1] .. '/.../' .. ff[#ff - 1] .. '/' .. ff[#ff]
                end
              end
              return path
            end

            local saveStateIcon = {
              hl = dhl_unsaved(fileUnsaved or workspaceDirty, 'MiniStatuslineFileinfo'),
              strings = { fileUnsaved and '✗' or (workspaceDirty and '!' or '✓') },
            }

            local workspace = {
              hl = dhl_unsaved(workspaceDirty, 'MiniStatuslineFileinfo'),
              strings = { workspaceName },
            }

            local workdir = {
              hl = 'MiniStatuslineFilename',
              strings = { workdirPath },
            }

            local filename = {
              hl = dhl('MiniStatuslineFilename'),
              strings = { shortenPath(vim.fn.expand('%')) },
            }

            local branch = {
              hl = dhl('MiniStatuslineFileinfo'),
              strings = { git },
            }

            local bufnr = vim.api.nvim_get_current_buf()

            local fmt_disabled = vim.b[bufnr].disable_conform

            local formatter = {
              hl = dhl('Added'),
              strings = { (fmt_disabled and '✗ ' or '') .. 'fmt' },
            }

            local fileInfo = {
              hl = dhl('MinistatuslineFileInfo'),
              strings = { MiniStatusline.section_fileinfo({ trunc_width = 2000 }) },
            }

            local search = {
              hl = dhl('MinistatuslineFileInfo'),
              strings = {
                MiniStatusline.section_searchcount({ trunc_width = 75 }),
              },
            }

            local location = {
              hl = dhl('MinistatuslineFileInfo'),
              strings = { MiniStatusline.section_location({ trunc_width = 75 }) },
            }

            local lines = {
              hl = dhl('MinistatuslineFileInfo'),
              strings = { '%L' },
            }

            local stuff = MiniStatusline.combine_groups({
              saveStateIcon,
              workspace,
              '%<', -- Mark general truncate point
              filename.strings[1] ~= '' and filename or workdir,
              branch,
              '%=', -- End left alignment
              has_formatter and formatter,
              fileInfo,
              search,
              location,
              lines,
            })

            local wedge_left_hl = mode == 'active' and 'StatusLineWedgeActive' or 'StatusLineWedgeInactive'
            local wedge_right_hl = mode == 'active' and 'StatusLineWedgeActive' or 'StatusLineWedgeInactive'

            if mode == 'active' and fileUnsaved then
              wedge_left_hl = 'StatusLineWedgeUnsaved'
            end

            -- really ricing it up ^ ^
            return '%#Normal#  ' .. '%#' .. wedge_left_hl .. '#' .. stuff .. '%#' .. wedge_right_hl .. '#█' .. '%#Normal#  '
            -- return '%#Normal#  ' .. '#' .. ' ' .. '#█' .. '%#Normal#  '
          end
        end

        -- set use_icons to true if you have a Nerd Font
        statusline.setup({
          use_icons = vim.g.have_nerd_font,
          content = {
            active = makeStatusline('active'),
            inactive = makeStatusline('inactive'),
          },
        })

        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end

        -- statusline.section_diff(args)
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      multiline_threshold = 1,
      separator = '─',
      -- max_lines = '1%',
    },
    init = function()
      KEY('n', '[C', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'jump to line of parent scope in context' })

      KEY('n', '[c', function()
        require('treesitter-context').go_to_parent(vim.v.count1)
      end, { silent = true, desc = 'jump to line of parent scope' })
    end,
  },

  {
    'andymass/vim-matchup',
    -- TODO: I do not think this lazy = false is necessary
    lazy = false, -- or true with an event
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'make',
        'terraform',
        'c',
        'dockerfile',
        'rust',
        'typescript',
        'prisma',
        'tsx',
        'html',
        'lua',
        'markdown',
        'vim',
        'vimdoc',
        'javascript',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },

        disable = function(lang, buf)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
            if #line > vim.g.max_line_len then -- adjust threshold
              require('fidget').notify('disabling treesitter highlight', vim.log.levels.WARN)
              return true
            end
          end
          return false
        end,
      },

      -- for 'andymass/vim-matchup' integration so that it can use treesitter
      matchup = {
        enable = true, -- mandatory, enables treesitter integration
        disable_virtual_text = true,
      },

      -- indent = { enable = true, disable = { 'ruby', 'lua' } },
      -- incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  -- TODO: could be of interest as examples for debugger ...
  -- require 'kickstart.plugins.debug',
}, {
  dev = {
    path = '~/code/nvim-plugins',
  },
  ui = {
    border = WIN_BORDER,
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
