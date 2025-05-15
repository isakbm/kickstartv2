--[[

  TODO:

    >> gitgraph and perhaps other non file buffers should also display the
       branch name we're on?

    >> auto close diffview on :Git commit ? with :tabclose

    >> add keymap to quickly go back to state before changes to buffer
       so basically go back to last save state, equivalent to S marker in the undo tree 

    >> have something like gd (goto definition), but that opens up new buffer for it
       hint just a combination of Ctrl + w , v and then gd inside that buffer

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
do
  -- I'm tired of netrw, gives me bad vibes, so we disable it
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

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
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true -- yes use tempr gui colors
vim.opt.wrap = false -- don't wrap lines
vim.opt.fillchars:append({ diff = '' }) -- { diff = '/' } -- fillchars for diffview?
vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false -- Don't show the mode, since it's already in status line
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- ... actually lets make it sensitive if an upper case is involved
vim.opt.signcolumn = 'yes:1' -- Keep signcolumn on by default
vim.opt.splitright = true -- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.list = true -- Sets how neovim will display certain whitespace in the editor.
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
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

WIN_BORDER = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

local getWorkspaceName = function()
  local workdir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not workdir then workdir = vim.fn.getcwd() end
  local workdirBasename = vim.fn.fnamemodify(workdir, ':t')
  return workdirBasename, workdir
end

local isWorkspaceDirty = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in pairs(bufs) do
    local unsaved = vim.api.nvim_get_option_value('modified', { buf = buf })
    local bufname = vim.api.nvim_buf_get_name(buf)
    if unsaved and bufname ~= '' then return true end
  end
  return false
end

local isBufferDirty = function() return vim.api.nvim_get_option_value('modified', { buf = 0 }) end

--=========================== KEYMAPS =============================

local KEY = vim.keymap.set
local CMD = vim.api.nvim_create_user_command
local AUTO = vim.api.nvim_create_autocmd

KEY('n', 'U', '<cmd>earlier 1f<cr>', { desc = 'undo all the way to previous (earlier) save' })
KEY('n', 'W', '<cmd>later 1f<cr>', { desc = 'redo all the way to later save' })

KEY('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'hide higlights after hitting <Esc>' })

KEY('n', '<C-f>', '<NOP>', { desc = 'disable windowfull scroll down' })
KEY('n', '<C-b>', '<NOP>', { desc = 'disable windowfull scroll up' })

KEY('n', '*', require('nice_star'), { desc = 'highlight all occurrences of current word BETTER than default' })

KEY('n', '<C-j>', ':m+1<cr>', { desc = 'swap line with line below' })
KEY('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' })

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

-- Alt + j / k now glide you up and down in a nice scrolled way
KEY({ 'v', 'n' }, '<M-j>', require('glide')('j'), { desc = 'glide in the j direction' })
KEY({ 'v', 'n' }, '<M-k>', require('glide')('k'), { desc = 'glide in the k direction' })

-- starts us off where we left off in buffer
require('recall_buf_position')

-- This brings you into block visual select mode ... on windows it's Ctrl + Q, and on Linux Ctrl + V ... cool to have something OS independent :)
-- Experimental alternative to `Ctrl + V` which is blocked by some terminals
KEY('n', 'VV', '<C-v>')

--
-- Diagnostic keymaps
--

-- we want high priority, higher than gitsigns and marks
vim.diagnostic.config({ signs = { priority = 100 } })

KEY('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
KEY('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
KEY('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
KEY('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- useful for figuring out what higlight groups are relevant for stuff under cursor
KEY('n', '<leader>I', function() vim.show_pos() end)

CMD('Lint', require('lint-runner').lint_workspace, { desc = 'workspace lint' })
CMD('LintClear', require('lint-runner').clear_diagnostics, { desc = 'clear workspace lint' })

KEY('n', '<leader>F', require('lint-runner').mark_fixed, { desc = '[lint] mark as fixed' })

KEY('n', ']n', ':cnext<CR>', { noremap = true, silent = true })
KEY('n', '[n', ':cprev<CR>', { noremap = true, silent = true })

KEY('n', '<leader>gc', ':!git commit<cr>:DiffviewClose<cr>', { desc = 'git commit' })

-- highlight when yanking
AUTO('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
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
end ---@diagnostic disable-next-line: undefined-field
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
    'mbbill/undotree', -- Nice file change history
    config = function() KEY('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' }) end,
  },

  {
    'rose-pine/neovim',
    priority = 999,
    name = 'rose-pine',
    config = function()
      local function tweakHighlights()
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

          -- hide line numbers
          local hlg = vim.api.nvim_get_hl(0, { name = 'TreesitterContext' })
          ---@diagnostic disable-next-line
          vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = hlg.bg, bg = hlg.bg })

          -- make bottom same as rest of context background
          vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { link = 'TreesitterContext' })
        end
      end

      ---@param contrast "high" | "normal"
      local function update_highlight(contrast)
        print('updating highlights')

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

      -- toggle between light and dark modes
      KEY('n', '<leader>T', function()
        vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
        update_highlight(vim.g.contrast)
      end, { desc = 'toggle between light and dark modes' })

      KEY('n', '<leader>C', function()
        vim.g.contrast = vim.g.contrast == 'normal' and 'high' or 'normal'
        update_highlight(vim.g.contrast)
      end, { desc = 'toggle between light and dark modes' })

      if host == 'mac' then
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

        vim.loop.new_timer():start(0, 1500, function() job:start() end)
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
        on_select_commit = function(commit) vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!') end,
        on_select_range_commit = function(from, to) vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash) end,
      },
      log_level = vim.log.levels.INFO,
    },
    keys = {
      {
        '<leader>gl',
        function() require('gitgraph').draw({}, { all = true }) end,
        desc = 'GitGraph - Draw',
      },
      {
        '<leader>gt',
        function() require('gitgraph').test() end,
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
        cond = function() return vim.fn.executable('make') == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
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
          cache_picker = { num_pickers = 10 },
          file_ignore_patterns = { '.git/' },
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
      KEY('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end, { desc = '[S]earch [F]iles' })
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
      KEY(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep({
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          })
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your neovim configuration files
      KEY('n', '<leader>sn', function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end, { desc = '[S]earch [N]eovim files' })
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
            if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
          end
          vim.g.diffview_tp = nil
        end

        --- check for local changes using git
        local function has_local_changes()
          local handle = io.popen('git status --porcelain 2>/dev/null')
          if not handle then return false end
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

        print('about to check for local changes?')

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
          local map = function(keys, func, desc) KEY('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

          local tele = require('telescope.builtin')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', tele.lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', function() tele.lsp_references({ show_line = false }) end, '[G]oto [R]eferences')

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

            local hover_res = vim.lsp.buf_request_sync(0, 'textDocument/hover', vim.lsp.util.make_position_params(), 200)

            if not hover_res then return end

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
                  if original_handler then original_handler(err, result, ctx, config) end
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
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- NOTE: Lets give the hover information stuff a bit more style
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = WIN_BORDER,
            title = ' hover ',
          })
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
        tsserver = {},
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
        if vim.g.disable_conform or vim.b[bufnr].disable_conform then return end

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

            local function dhl(unsaved, group)
              local hlg = mode == 'active' and group or 'MiniStatuslineInactive'
              local unsavedHlg = mode == 'active' and 'MiniStatuslineModeCommand' or '@variable.builtin'
              return unsaved and unsavedHlg or hlg
            end

            local function shortenPath(path)
              if #path > 24 then
                local ff = vim.fn.split(path, '/')
                if #ff > 3 then path = ff[1] .. '/.../' .. ff[#ff - 1] .. '/' .. ff[#ff] end
              end
              return path
            end

            local saveStateIcon = {
              hl = dhl(fileUnsaved or workspaceDirty, 'MiniStatuslineFileinfo'),
              strings = { fileUnsaved and '✗' or (workspaceDirty and '!' or '✓') },
            }

            local workdir = {
              hl = dhl(fileUnsaved, 'MiniStatuslineFilename'),
              strings = { workdirPath },
            }

            local filename = {
              hl = dhl(fileUnsaved, 'MiniStatuslineFilename'),
              strings = { shortenPath(vim.fn.expand('%')) },
            }

            local workspace = {
              hl = dhl(workspaceDirty, 'MiniStatuslineFileinfo'),
              strings = { workspaceName },
            }

            local branch = {
              hl = dhl(fileUnsaved, 'MiniStatuslineFileinfo'),
              strings = { git },
            }

            local bufnr = vim.api.nvim_get_current_buf()

            local fmt_disabled = vim.b[bufnr].disable_conform

            local formatter = {
              hl = 'Added',
              strings = { (fmt_disabled and '✗ ' or '') .. 'fmt' },
            }

            local fileInfo = {
              hl = 'MinistatuslineFileInfo',
              strings = { MiniStatusline.section_fileinfo({ trunc_width = 2000 }) },
            }

            local search = {
              hl = 'MinistatuslineFileInfo',
              strings = {
                MiniStatusline.section_searchcount({ trunc_width = 75 }),
              },
            }

            local location = {
              hl = 'MinistatuslineFileInfo',
              strings = { MiniStatusline.section_location({ trunc_width = 75 }) },
            }

            local lines = {
              hl = 'MinistatuslineFileInfo',
              strings = { '%L' },
            }

            return MiniStatusline.combine_groups({
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
        statusline.section_location = function() return '%2l:%-2v' end

        -- statusline.section_diff(args)
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      multiline_threshold = 1,
      separator = ' ',
    },
    init = function()
      KEY('n', '[c', function() require('treesitter-context').go_to_context(vim.v.count1) end, { silent = true, desc = 'jump to line of parent context' })
    end,
  },

  {
    'andymass/vim-matchup',
    -- TODO: I do not think this lazy = false is necessary
    lazy = false, -- or true with an event
    config = function() vim.g.matchup_matchparen_offscreen = {} end,
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
