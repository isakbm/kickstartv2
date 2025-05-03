--[[========================= WELCOME =============================
 WARN: Troubleshooting

    :checkhealth
    :Lazy
    :Mason
    ~/.local/state/nvim/lsp.log

    NOTE: Keybinding Conflicts

      :verbose nmap <the key binding>

    NOTE: Color issues etc with tmux

      Make sure your tmux profile is set to use the same
      terminal as your terminal emulator, to see which
      terminal you are using, exit tmux and do `echo $TERM`

      You may need to kill your tmux servers for changes to
      have an effect

      To check issues with colors, simply do `:CheckReds`
         if all is good you should see a nice continuous
         gradient between black and red, if not you'll see
         discotinuous steps and repeats of the same color

    NOTE: Syntax highlighting, configure using mini.collors
          and checkout `:InspectTree` 

  ---------------------------------------------------------------

 WARN: Getting Started

    :Tutor
    :help lua-guide
    :help

    https://learnxinyminutes.com/docs/lua/

    <leader>sh   and   <leader>sk

 WARN: Motions

    :help text-object

    ciw caw cip dap dapu
    vi] vi} va] va} vap vip

    D C I A O P Y
    _ 0 $ %

  ---------------------------------------------------------------

 NOTE: OS Keys ?

    Map `Capslock` to `<Esc>` in your operating system

    Also consider similar mappings of other keys like

        ~
        `
        $

  ---------------------------------------------------------------

 NOTE: F A Q

    Q: how can I open a url
    A: gx

    Q: how do I swap lines
    A: Ctrl + j / k  when in normal mode

    Q: how do I do something like Ctrl + backspace when in insert mode
    A: Ctrl + w

    Q: how do I see my current changes in a nice way
    A1: <leader>dt    <- diff this buffer (includes unsaved change) !!!
    A2: <leader>gd    <- entire workspace (does not include unsaved changes) !!!

    Q: how do I see changes intoruded by a single commit?
    A: <leader>gl   place cursor on a commit and hit <enter>

    Q: how do I see changes introduced by a range of commits, like diff a..b
    A: <leader>gl   visual selection and then hit <enter>

    Q: how do I refactor a variable name or function name
    A: <leader>rn

  TODO:

    >> add keymap to quickly go back to state before changes to buffer
       so basically go back to last save state, equivalent to S marker in the undo tree 

    >> have something like gd (goto definition), but that opens up new buffer for it
       hint just a combination of Ctrl + w , v and then gd inside that buffer

    >> have something that works like `*` but operates on actual symbol or variable rather
       that text literal


    >> add single branch mode for gitgraph, make it easy to select which
       branch you want to see, consider display a subset of branches, not just ONE

    >> there seems to be an awkward bug with `diffview`

       1. make a modification to a file
       2. stage it
       3. make another modification to the same file in the same area
       4. stage it ...

    >> make telescope "sg" remember what you searched for last, or even just keep in memory
       what you searched for... on the other hand you could just add things to quickfix list?

       if you're really feeling it, implement a global search (gs) search history, so you can search fo searches
       using telescope ... telescope search search XD

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

    >> popup window with fun animation when you are waiting for something perhaps you pushed code
       or perhaps you are compiling

    >> add a little toolbox window that you can open at any time
       Make it searchable.
       Have tool slike `to uppercase` `to hex` etc etc :D

    >> find better way of typing [ ] and { } on a norwegian keyboard?

    >> get a nice way to jump to parent scopes locally. Currently
       we can do something like this with treesitter-context, but
       that jumps to the context that is 'off screen' try '[c'

    >> find out how to quickly switch to previous buffer

    >> find out how to close a buffer without using :q

    >> even if contents of file are identical to those when you started
       vim still thinks your buffer has changes if you added and deleted
       something. vim only knows that the fil has not chnaged if you
       literally go back with undo ... can this be changed in a setting?

    >> find a way to do grep search over subset of files

=================================================================--]]

-- NOTE: :help localleader
-- testytest
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' ' --- Set <space> as the local leader key
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed

-- NOTE::help option-list
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
vim.opt.fillchars:append { diff = '' } -- { diff = '/' } -- fillchars for diffview?
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
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
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

vim.opt.runtimepath:prepend '/home/isak/.opam/default/share/ocp-indent/vim'

WIN_BORDER = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }

--=========================== KEYMAPS =============================

-- NOTE: hide higlights after hitting <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: disabling some imo useless default keybindings
vim.keymap.set('n', '<C-f>', '<NOP>', { desc = 'disable windowfull scroll down' })
vim.keymap.set('n', '<C-b>', '<NOP>', { desc = 'disable windowfull scroll up' })

-- NOTE: like * but doesn't move you around
vim.keymap.set('n', '*', function()
  -- NOTE yes this a bit convoluted, but avoids issues with the old way ... the old way would sometimes change
  --      scroll position of buffer if scrolloff is set
  --
  -- OLD WAY
  --
  --      vim.keymap.set('n', '*', '/<C-R><C-W><cr>N', { desc = 'highlight all occurrences of current word' })
  --
  local word = vim.fn.expand '<cword>'
  local pattern = [[\C\<]] .. word .. [[\>]] -- NOTE: pattern to match full word only
  vim.fn.setreg('/', pattern)
  vim.opt.hlsearch = true
  vim.fn.searchcount { recompute = 1 }
end, { desc = 'highlight all occurrences of current word' })

--   we've bound <M-*> so the `Alt` or `Modifier` key, however, see :h :map-alt and you'll notice that
--   nvim is not able to distinguish between `Esc` and `Alt` if key press is fast enough, we'll just live
--   with this, it rarely causes issues, but if you press `Esc` + j  or `Esc + k` very quickly while
--   in normal mode, you'll also trigger the below keymaps.
vim.keymap.set('n', '<C-j>', ':m+1<cr>', { desc = 'swap line with line below' }) -- vscode <alt> + <up>
vim.keymap.set('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' }) -- vscode <alt> + <down>

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
vim.keymap.set('n', 'R', '"0PlD', { desc = 'replace rest of line with yanked' }) -- vscode <alt> + <down>

vim.keymap.set('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' }) -- vscode <alt> + <down>

vim.keymap.set('n', '<leader>N', ':set number!<cr>:set relativenumber!<cr>', { desc = 'toggle line numbering' })

vim.keymap.set('n', '<leader>dd', function()
  vim.cmd 'wincmd v'
  require('telescope.builtin').lsp_definitions()
end, { desc = 'open definition in new window' })

-- Fun little utility to places boxes around visually selected lines of text
vim.keymap.set('v', '<leader>b', function()
  local buf = vim.api.nvim_get_current_buf()

  local _, start_line, _, _ = unpack(vim.fn.getpos 'v')
  local _, end_line, _, _ = unpack(vim.fn.getpos '.')

  -- handle reversed selection
  if start_line > end_line then
    local sep = start_line - end_line
    start_line = end_line
    end_line = start_line + sep
  end

  local lines = vim.api.nvim_buf_get_text(buf, start_line - 1, 0, end_line - 1, -1, {})

  -- set box width to max line width
  local max_width = 0
  for _, line in pairs(lines) do
    if max_width < string.len(line) then
      max_width = string.len(line)
    end
  end

  -- box in the lines
  local box_width = max_width
  local box_indent = string.rep(' ', 4)

  local boxed_lines = { [1] = box_indent .. '╭' .. string.rep('─', box_width + 2) .. '╮' }
  for i, line in pairs(lines) do
    print('LINE:' .. line)
    local line_width = #line
    if line_width < box_width then
      -- lines[i] = '| ' .. line .. string.rep(' ', box_width - line_width) .. ' |'
      boxed_lines[i + 1] = box_indent .. '│ ' .. line .. string.rep(' ', box_width - line_width) .. ' │'
    else
      -- lines[i] = '| ' .. line .. ' |'
      boxed_lines[i + 1] = box_indent .. '│ ' .. line .. ' │'
    end
  end

  boxed_lines[#boxed_lines + 1] = box_indent .. '╰' .. string.rep('─', box_width + 2) .. '╯'

  -- simulate hitting the esc key to go into normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  -- vim.api.nvim_buf_set_lines(buf, start_line, end_line + 1, false, { 'hello world' })
  vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, boxed_lines)
end)

--                                                                                --
--   here I have some dumb utils that I don't want to pollyte this config with    --
--                                                                                --

-- checking if you have good smooth color gradients, if you don't, something is wrong with your setup
require 'check_reds'

-- Alt + j / k now glide you up and down in a nice scrolled way
require 'glide'

-- starts us off where we left off in buffer
require 'recall_buf_position'

---@type "light" | "dark"
local colorThemeMode = 'dark'
local myColors = require 'colors'

-- an unorganized place for my utils
local utils = require 'utils'

-- NOTE: this brings you into block visual select mode ... on windows it's Ctrl + Q, and on Linux Ctrl + V ... cool to have something OS independent :)
--
-- Experimental alternative to `Ctrl + V` which is blocked by some terminals
vim.keymap.set('n', 'VV', '<C-v>')

---@param mode "light" | "dark"
local function initColorTheme(mode)
  -- TODO: unfiy with this / take inspiration -> https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

  -- everything related to color theme goes here inside this block
  require('mini.colors').setup {}

  ---@type Colorscheme
  local theme = MiniColors.get_colorscheme 'retrobox'

  local update_highlights = require('color_theme').update_highlights
  local color_edit_ui = require('color_edit_ui').color_edit_ui

  local on_color_update = function(colors)
    update_highlights(colors, mode, theme, { clear = false })
  end

  vim.keymap.set('n', '<leader>C', function()
    color_edit_ui(on_color_update, mode)
  end, { desc = 'color picker' })

  update_highlights(myColors, mode, theme)
end

-- toggle between light and dark modes
vim.keymap.set('n', '<leader>T', function()
  if colorThemeMode == 'dark' then
    colorThemeMode = 'light'
  else
    colorThemeMode = 'dark'
  end
  initColorTheme(colorThemeMode)
end)

--
-- Diagnostic keymaps
--

-- we want high priority, higher than gitsigns and marks
vim.diagnostic.config { signs = { priority = 100 } }

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- useful for figuring out what higlight groups are relevant for stuff under cursor
vim.keymap.set('n', '<leader>I', function()
  vim.show_pos()
end)

-- My dumb custom workspac linting thing
-- NOTE: currently only set up for tsc + eslint in a node.js project
vim.api.nvim_create_user_command('Lint', function()
  local runner = require 'lint-runner'

  -- run tsc and eslint in parallel
  local tsc = require 'linters_tsc'
  local eslint = require 'linters_eslint'
  runner.run_linter(tsc)
  runner.run_linter(eslint)
end, { desc = 'workspace lint' })

vim.api.nvim_create_user_command('LintClear', function()
  local runner = require 'lint-runner'
  runner.clear_diagnostics()
end, { desc = 'clear workspace lint' })

vim.keymap.set('n', '<leader>F', function()
  local runner = require 'lint-runner'

  local namespaces = runner.get_namespaces()

  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum = pos[1] - 1

  for _, namespace in ipairs(namespaces) do
    local rem_diagnostics = vim.tbl_filter(function(e)
      return e.lnum ~= lnum
    end, vim.diagnostic.get(0, { namespace = namespace }))
    vim.diagnostic.reset(namespace, 0)
    vim.diagnostic.set(namespace, 0, rem_diagnostics)
  end
end, { desc = '[lint] mark as fixed' })

vim.keymap.set('n', ']n', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '[n', ':cprev<CR>', { noremap = true, silent = true })

--=========================== PLUGIN KEYMAPS =============================
--
-- we configure plugins here using Lazy, and we define keybindings
-- that rely on them here as well

-- NOTE: Highlight when yanking (copying) text
--
--  -> :help lua-guide-autocommands
--  -> :help vim.highlight.on_yank()
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
--
--    This bootstraps lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.keymap.set('n', '<leader>U', function()
  local code = vim.fn.input 'u:'
  local char = vim.fn.nr2char(code)
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, col) .. char .. line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = 'insert unicode' })

require('lazy').setup({
  {
    'mbbill/undotree', -- Nice file change history
    config = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
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
      log_level = vim.log.levels.INFO,
    },
    keys = {
      {
        '<leader>gl',
        function()
          require('gitgraph').draw({}, { all = true })
        end,
        desc = 'GitGraph - Draw',
      },
      {
        '<leader>gt',
        function()
          require('gitgraph').test()
        end,
        desc = 'GitGraph - Draw',
      },
      {
        '<leader>gR',
        function()
          require('gitgraph').random()
        end,
        desc = 'random gitgraph',
      },
    },
    init = function()
      --- update gitgraph whenever we run a fugitive :Git command
      vim.api.nvim_create_autocmd('User', {
        pattern = 'FugitiveChanged',
        callback = function() -- WARN: TODO:
          -- TODO: FIXME: this conflicts with fugitive for merge commits where
          --       fugitive wants to open a buffer where you write commit message etc
          --       ... the issue is then that instead of seeing this buffer gitgraph
          --       replaces the active buffer with itself ... and so we never get to complete
          --       the message ... maybe we can find some workaround ...
          -- require('gitgraph').draw({}, { all = true })
        end,
      })
    end,
  },

  {
    'michaelb/sniprun',
    build = 'bash ./install.sh',
    opts = {
      selected_interpreters = { 'Lua_nvim' },
      display = { 'Classic' },
    },
    init = function()
      vim.keymap.set('n', '<leader>r', ':SnipRun<CR>', { desc = 'run curr line with sniprun' })
      vim.keymap.set('v', '<leader>r', ":'<,'>SnipRun<CR>", { desc = 'run curr selection with sniprun' })
    end,
  },

  {
    -- NOTE: very nice search util
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
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
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files { hidden = true }
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sp', builtin.pickers, { desc = '[S]earch [P]icker' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          -- previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
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
      vim.keymap.set('n', ']h', ':Gitsigns next_hunk<cr>', { desc = '[G]it [N]ext hunk' })
      vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<cr>', { desc = '[G]it [P]rev hunk' })
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<cr>', { desc = '[G]it [P]review hunk' })
      vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<cr>', { desc = '[G]it [R]eset hunk' })
      vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [B]lame toggle' })

      -- diff this
      vim.keymap.set('n', '<leader>dt', function()
        local function close_diffthis()
          local tabp = vim.api.nvim_get_current_tabpage()
          for _, win in pairs(vim.api.nvim_tabpage_list_wins(tabp)) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)
            pcall(vim.keymap.del, 'n', '<Esc><Esc>', { buffer = 0 })
            if string.match(buf_name, 'gitsigns:.*git.*') then
              vim.api.nvim_win_close(win, false)
            end
          end
        end
        ---@type boolean
        local diff = vim.api.nvim_get_option_value('diff', { win = 0 })
        if diff then
          close_diffthis()
        else
          vim.cmd [[:Gitsigns diffthis]]
          vim.fn.timer_start(50, function()
            local tabp = vim.api.nvim_get_current_tabpage()
            for _, win in pairs(vim.api.nvim_tabpage_list_wins(tabp)) do
              local buf = vim.api.nvim_win_get_buf(win)
              vim.keymap.set('n', '<Esc><Esc>', close_diffthis, { buffer = buf })
            end
            -- NOTE this is a dumb hack to work around an issue that sometimes happens
            --      ... sometimes the scroll bind comes out of aligment during loading
            --      buffers. simply going to top of document, then to the bottom, and
            --      then back to where we were does the trick
            --
            --      this is all most likely due to a bug in gitsigns diffview ...
            --      it seems to only happen near end of buffer, and most likely
            --      because gitsigns is trying to center text vertically with `zz`
            --      but a race condition happens ... ... we should consider trying
            --      to fix this in a fork of gitsigns, and potentially make a pull\
            --      request if this hunch is true ^
            do
              local pos = vim.api.nvim_win_get_cursor(0)
              vim.fn.timer_start(30, function()
                vim.cmd [[:0]]
              end)
              vim.fn.timer_start(31, function()
                vim.api.nvim_win_set_cursor(0, pos)
                vim.api.nvim_feedkeys('zz', 'n', false)
              end)
            end
          end)
        end
      end, { desc = '[d]iff [t]his file' })
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
          vim.cmd [[:DiffviewClose]]
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
      vim.keymap.set('n', '<leader>gd', function()
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
          local handle = io.popen 'git status --porcelain 2>/dev/null'
          if not handle then
            return false
          end
          local result = handle:read '*a'
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

        print 'about to check for local changes?'

        local changes = has_local_changes()
        if not changes then
          print 'no changes'
          return
        end

        -- fir check if there's a meaningful dif ... diffview doesn't do that ...

        -- first we get current cursor location in the file we're in
        -- it is used in the hooks of diffview above so that we can
        -- go direclty to file and line that we're currently on when executing <leader>gd
        vim.g.diffview_cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.g.diffview_just_entered = true
        vim.cmd [[:DiffviewOpen]]
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
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', function()
            require('telescope.builtin').lsp_references { show_line = false }
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', function()
            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            local hover_res = vim.lsp.buf_request_sync(0, 'textDocument/hover', vim.lsp.util.make_position_params(), 200)

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
              vim.keymap.set({ 'n' }, '<Esc><Esc>', ':q<cr>', { buffer = buf })
              vim.keymap.set({ 'n', 'i' }, '<cr>', function()
                local new_name = vim.api.nvim_buf_get_text(0, 0, 0, 0, 256, {})[1]
                vim.api.nvim_win_close(win, true)
                if new_name == old_name then
                  print 'no change'
                  return
                end
                if #new_name == 0 then
                  print 'cannot name to empty string'
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
      require('mason').setup {
        ui = {
          border = WIN_BORDER,
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

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
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
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
      }
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

        -- you can use this debian package instead of lemminx if you run into trouble
        -- xml = { 'xmllint' },
        -- svg = { 'xmllint' },

        -- You can use a sub-list to tell conform to run *until* a formatter is found.
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>tc', function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr].disable_conform = not vim.b[bufnr].disable_conform
      end, { desc = 'toggle conform.nvim' })
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
      local cmp = require 'cmp'
      cmp.setup {
        completion = { completeopt = 'menu,menuone,noinsert' },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      initColorTheme(colorThemeMode)

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- highlight word under cursor, style with highlight group MiniCursorword
      require('mini.cursorword').setup {}

      do
        local hipatterns = require 'mini.hipatterns'

        local keywords = {
          { key = 'FIX', group = 'TodoBgFIXME' },
          { key = 'FIXME', group = 'TodoBgFIXME' },
          { key = 'HACK', group = 'TodoBgWARN' },
          { key = 'WARN', group = 'TodoBgWARN' },
          { key = 'TODO', group = 'TodoBgTODO' },
          { key = 'NOTE', group = 'TodoBgNote' },
        }

        local highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        }

        local bdrPattern = "[^a-zA-Z0-9'_()-]"

        for _, kw in pairs(keywords) do
          for _, key in pairs { kw.key, string.lower(kw.key) } do
            highlighters[key] = { pattern = bdrPattern .. '%f[%w]()' .. key .. '()%f[%W]' .. bdrPattern, group = kw.group }
            highlighters[key .. '_'] = { pattern = bdrPattern .. '%f[%w]()' .. key .. '()%f[%W]$', group = kw.group }
          end
        end

        hipatterns.setup { highlighters = highlighters }
      end

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      do -- Simple and easy statusline.
        local statusline = require 'mini.statusline'

        -- set use_icons to true if you have a Nerd Font
        statusline.setup {
          use_icons = vim.g.have_nerd_font,
          content = {
            active = function()
              local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
              local git = MiniStatusline.section_git { trunc_width = 40 }
              local diff = MiniStatusline.section_diff { icon = 'Δ', trunc_width = 75 }
              local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
              local lsp = MiniStatusline.section_lsp { trunc_width = 75 }

              -- local filename = MiniStatusline.section_filename { trunc_width = 140 }
              local filename = vim.fn.expand '%f'
              local filenam_hl = 'MiniStatuslineFilename'
              do
                if #filename > 24 then
                  local ff = vim.fn.split(filename, '/')
                  if #ff > 3 then
                    filename = ff[1] .. '/.../' .. ff[#ff - 1] .. '/' .. ff[#ff]
                  end
                end

                local unsaved = vim.api.nvim_get_option_value('modified', { buf = 0 })
                if unsaved then
                  filenam_hl = 'MiniStatuslineFilenameUnsaved'
                  filename = filename .. ' *'
                end
              end

              -- do we have any unsaved buffers?
              local bufs = vim.api.nvim_list_bufs()
              local workspace_hl = 'MiniStatuslineWorkspace'
              local unsaved_bufs = false
              for _, buf in pairs(bufs) do
                local unsaved = vim.api.nvim_get_option_value('modified', { buf = buf })
                local bufname = vim.api.nvim_buf_get_name(buf)
                if unsaved and bufname ~= '' then
                  workspace_hl = 'MiniStatuslineWorkspaceUnsaved'
                  unsaved_bufs = true
                  break
                end
              end

              do
                local c = colorThemeMode == 'light' and myColors.light or myColors.dark
                if vim.fn.reg_recording() ~= '' then
                  vim.api.nvim_set_hl(0, 'CursorLine', { bg = c.yellow })
                elseif unsaved_bufs then
                  vim.api.nvim_set_hl(0, 'CursorLine', { bg = c.red })
                else
                  vim.api.nvim_set_hl(0, 'CursorLine', { bg = c.gray5 })
                end
              end

              local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
              local location = MiniStatusline.section_location { trunc_width = 75 }
              local search = MiniStatusline.section_searchcount { trunc_width = 75 }

              -- get root_dir of the lsp client attached to this buffer
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients()
              local client = nil
              local root_dir = nil
              for _, c in pairs(clients) do
                if c.attached_buffers[bufnr] ~= nil then
                  client = c
                  root_dir = client.root_dir
                  break
                end
              end

              return MiniStatusline.combine_groups {
                { hl = mode_hl, strings = { mode } },
                { hl = 'MiniStatuslineBranch', strings = { git } },
                { hl = workspace_hl, strings = { vim.fs.basename(root_dir) } },
                { hl = 'MiniStatuslineChanges', strings = { diff } },
                { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics, lsp } },
                '%<', -- Mark general truncate point
                { hl = filenam_hl, strings = { filename } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = mode_hl, strings = { search, location } },
              }
            end,
          },
        }

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
    },
    init = function()
      vim.keymap.set('n', '[c', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'jump to line of parent context' })
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'dockerfile', 'rust', 'typescript', 'tsx', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'javascript' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
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
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- utility to get us color and information about the
      -- symbol under the cursor
      vim.keymap.set('n', '<leader>J', function()
        local info = vim.inspect_pos()
        local ts = info.treesitter
        local st = info.semantic_tokens

        local links = {}

        for _, sti in pairs(st) do
          if sti and sti.opts and sti.opts.hl_group_link then
            links[#links + 1] = sti.opts.hl_group_link
          end
        end

        for _, tsi in pairs(ts) do
          local link = tsi.hl_group_link
          if link then
            links[#links + 1] = link
          end
        end

        local node = vim.treesitter.get_node()
        local nt = '?'
        if node then
          nt = node:type()
        end

        for _, link in ipairs(links) do
          local hlg = vim.api.nvim_get_hl(0, { name = link })
          if hlg.fg then
            local color = string.format('%X', hlg.fg)
            vim.fn.setreg('c', [["]] .. '#' .. color .. [["]])
            print('found color:', color, 'from', link, 'for', nt)
            break
          end
        end
      end)
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- put them in the right spots if you want.
  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
  --
  --  Here are some example plugins that I've included in the kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
