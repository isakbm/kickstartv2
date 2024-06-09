--[[========================= WELCOME =============================
 WARN: Troubleshooting

    :checkhealth
    :Lazy
    :Mason
    ~/.local/state/nvim/lsp.log

    NOTE: Keybinding Conflicts

      :checkhealth which-key
      :verbose nmap <the key binding>

      which-key warnings can be safely ignored
      https://github.com/folke/which-key.nvim/issues/218#issuecomment-2117036351

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

    Q: how do I swap lines
    A: Atl + j / k  when in normal mode

    Q: how do I do something like Ctrl + backspace when in insert mode
    A: Ctrl + w

    Q: how do I get back to where I was in the file when I closed it
    A: `"    when in normal mode thanks to marks

    Q: how do I see my current changes in a nice way
    A: <leader>gd

    Q: how do I see my carrot changes relative to some older commit
    A: <leader>gl  and then hover some older commit and press ','

    Q: how do I see changes intoruded by a single commit?
    A: <leader>gl  and then hover some commit and press ';'

    Q: how do I see changes introduced by a range of commits, like diff a..b
    A: <leader>gl  put cursor on b hit enter place cursor on a hit -

    Q: can I mark places to go to somehow?
    A: use vim marks, see h: marks.nvim and h: mark. also there's a plugin I've added
       that shows you in the signs column where your jumps are,
       not that mark signs take precedence over gitsigns ...

       - dm<space> -> delete all marks
       - dmx -> delete mark x
       - mx -> create mark x

  TODO:

    >> Figure out how to get better suggestions for autocomplete of
       function args.

    >> Get a nice way to jump to parent scopes locally. Currently
       we can do something like this with treesitter-context, but
       that jumps to the context that is 'off screen' try '[c'

    >> [x and ]x are clearly very common vim keybindings
       on a Norwegian keyboard these are a pain to type
       Need to figure out some clever bindings in auto hotkey maybe.

    >> Currently you can move a line up or down with <C-i> and <C-j>.
       Consider also supporting this in visual line mode for several lines.

    >> when doing gr to go to references, telescope is shwing
       file path and the start of the line of code ...
       would be nice to only show file path, because the start of code
       obscures long file paths.

    >> when doing an action using `fugitive` like `:Git checkout -b foo`
       it would be ideal if any open `flog` buffer would update so
       that we can see the effect the command had on the graph!

=================================================================--]]

-- NOTE: :help localleader
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' ' --- Set <space> as the local leader key
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed
-- vim.g.enable_whichkey = false -- Set to true when learning, turn off later for better flow :)

-- NOTE::help option-list
--
-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
vim.opt.clipboard = 'unnamedplus' --  See `:help 'clipboard'`
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time : Displays which-key popup sooner
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
-- vim.opt.smartindent = true -- ... smart indentation --- need to figure out what to do, want vscode like auto indenting when opening a function or { ... local foo = function() <cr> does not indend body of function in lua for instance
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

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

--=========================== KEYMAPS =============================
--
-- The follow keymaps are suppsed to be independet of plugins.
--
-- NOTE: hide higlights after hitting <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: these maps are to try to save me some pain with index finger always reaching for : . -  .... not sure what to do about that these maps are probably not sufficient
vim.keymap.set('n', '<leader>W', ':w<CR>', { desc = ':w -> write buffer' })
vim.keymap.set('n', '<leader>Q', ':q<CR>', { desc = ':q -> quit buffer' })
vim.keymap.set('n', '<leader>C', ':', { desc = ': -> command' })
vim.keymap.set({ 'i', 'n' }, '§', '.', { desc = 'replacement for . key' })

-- NOTE: swap lines like in vscode
--
--   we've bound <M-*> so the `Alt` or `Modifier` key, however, see :h :map-alt and you'll notice that
--   nvim is not able to distinguish between `Esc` and `Alt` if key press is fast enough, we'll just live
--   with this, it rarely causes issues, but if you press `Esc` + j  or `Esc + k` very quickly while
--   in normal mode, you'll also trigger the below keymaps.
vim.keymap.set('n', '<C-j>', ':m+1<cr>', { desc = 'swap line with line below' }) -- vscode <alt> + <up>
vim.keymap.set('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' }) -- vscode <alt> + <down>

-- NOTE: Jump between tabs using 'Alt + number'
for i = 1, 9 do
  vim.keymap.set('n', '<M-' .. i .. '>', i .. 'gt', { desc = '[T]ab ' .. i })
end

-- NOTE: this brings you into block visual select mode ... on windows it's Ctrl + Q, and on Linux Ctrl + V ... cool to have something OS independent :)
--
-- Experimental alternative to `Ctrl + V` which is blocked by some terminals
vim.keymap.set('n', 'VV', '<C-v>')

vim.diagnostic.config {
  signs = {
    priority = 100, -- we want high priority, higher than gitsigns and marks
  },
}

vim.api.nvim_create_user_command('CheckReds', function()
  local height = vim.api.nvim_win_get_height(0)
  local num_shades = math.max(height - 4, 4)
  local colors = {}
  for idx = 0, num_shades do
    local val = string.format('%02x', (idx * 255) / num_shades)
    colors[#colors + 1] = '#' .. val .. '0000'
  end
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'win',
    row = 1,
    col = 3,
    width = 7,
    height = #colors,
    border = 'single',
    style = 'minimal',
  })
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_buf_set_lines(0, 0, 2, false, colors)
  for idx, c in ipairs(colors) do
    local rgb = string.sub(c, 2)
    local hl_name = 'ColorCheck-' .. rgb
    vim.api.nvim_set_hl(0, hl_name, { bg = c, fg = '#000000' })
    vim.api.nvim_buf_add_highlight(0, 0, hl_name, idx - 1, 0, -1)
  end
end, { desc = 'Test your colors' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- useful for figuring out what higlight groups are relevant for stuff under cursor
vim.keymap.set('n', '<leader>I', function()
  vim.show_pos()
end)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Nice to start off where you left off
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Start off where you left off',
  group = vim.api.nvim_create_augroup('kickstart-buf-enter', { clear = true }),
  -- NOTE: this is just the command '"  in lua [[ and ]] are similar to ``` in other languages
  callback = function()
    local ok, pos = pcall(vim.api.nvim_buf_get_mark, 0, [["]])
    if ok and pos[1] > 0 then
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

vim.api.nvim_create_autocmd('TabNewEntered', {
  desc = 'Add some tab local keymaps',
  -- group = vim.api.nvim_create_augroup('kickstart-tab-enter', { clear = true }),
  -- NOTE: this is just the command '"  in lua [[ and ]] are similar to ``` in other languages
  callback = function()
    local tab = vim.api.nvim_get_current_tabpage()
    vim.fn.timer_start(100, function()
      local wins = vim.api.nvim_tabpage_list_wins(tab)
      for _, win in pairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        vim.keymap.set('n', '<leader>T', ':tabc<cr>', {
          desc = 'Close tabpage also <Esc><Esc> works',
          buffer = buf,
        })
        vim.keymap.set('n', '<Esc><Esc>', ':tabc<cr>', {
          desc = 'Close tabpage',
          buffer = buf,
        })
      end
    end)
  end,
})

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

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'mbbill/undotree', -- Nice file change history
    config = function()
      vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'Toggle Undotree' })
    end,
  },

  {
    'chentoast/marks.nvim',
    opts = {},
  },

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    init = function()
      vim.keymap.set('n', '<leader>n', ':Trouble diagnostics next <cr>')
    end,
    -- config = function(opts)
    -- require('trouble').setup(opts)
    -- vim.keymap.set('n', '<leader>n', function()
    -- require('trouble').next { skip_groups = true, jump = true }
    -- end, { desc = 'goto next trouble' })
    -- end,
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    enabled = vim.g.enable_whichkey, -- To allow easy toggling of this above
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup { window = { border = 'single' } }

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]ab', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
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
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
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
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
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

  -- TODO: CONSIDER neogit ....
  -- NOTE: Git plugins ...
  {
    'rbong/vim-flog',
    dependencies = {
      'tpope/vim-fugitive',
      'sindrets/diffview.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gl', ':Flog -all -max-count=999999 -date=relative<cr>', { desc = '[G]it [L]og' })
      -- vim.keymap.set('n', '<leader>gl', ':Flog -format=%ar%x20[%h]%x20%d%x20%an <cr>', { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>gs', ':Git<cr>', { desc = '[G]it [S]tatus' })

      -- Returns the selected commit by fugitive, the one selected by hitting enter
      -- ... we are able to do this by finding the loaded buffer for fugitive
      -- that flog uses, and extract its commit hash
      --- @return string
      local function flogSelectedCommit()
        local buffers = vim.api.nvim_list_bufs()
        for _, buffer in ipairs(buffers) do
          local name = vim.api.nvim_buf_get_name(buffer)
          local loaded = vim.api.nvim_buf_is_loaded(buffer)
          if loaded and name then
            local isFugitive = string.match(name, 'fugitive:.*git//%x*')
            if isFugitive then
              local h = string.match(name, '%x*$')
              if h then
                return string.sub(h, 1, 7)
              end
            end
          end
        end
        return ''
      end

      -- get the commit under the cursor
      --- @return boolean, string asdfasdf
      local function flogCommitUnderCursor()
        return pcall(vim.fn['flog#Format'], '%H')
      end

      -- NOTE: opens up diffview relative to commit under cursor
      vim.keymap.set('n', ',', function()
        local ok, commit = flogCommitUnderCursor()
        if ok then
          return ':DiffviewOpen ' .. commit .. '<cr>'
        end
      end, { expr = true, desc = 'display changes of HEAD relative to commit under cursor' })

      -- NOTE: opens up diffview for change introduced by commit under cursor
      vim.keymap.set('n', ';', function()
        local ok, commit = flogCommitUnderCursor()
        if ok then
          return ':DiffviewOpen ' .. commit .. '^!<cr>'
        end
      end, { expr = true, desc = 'display changes introduced by commit under cursor' })

      vim.keymap.set('n', '-', function()
        local ok, cc = flogCommitUnderCursor()
        if ok then
          local h = flogSelectedCommit()
          if h == '' then
            return
          end
          return ':DiffviewOpen ' .. cc .. '..' .. h .. '<cr>'
        end
      end, { expr = true })
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
      -- hunks
      vim.keymap.set('n', '<leader>gn', ':Gitsigns next_hunk<cr>', { desc = '[Git] [N]ext diff hunk' })
      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<cr>', { desc = '[G]it [P]review hunk' })
      vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<cr>', { desc = '[G]it [R]eset hunk' })

      -- blame
      vim.keymap.set('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [B]lame toggle' })

      -- diff this
      -- TODO: improve this
      vim.keymap.set('n', '<leader>dt', ':Gitsigns diffthis<cr>', { desc = 'See changes in the current buffer' })
    end,
  },

  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-web-devicons',
    },
    opts = {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_read = function()
          vim.opt_local.cursorline = false
        end,
      },
    },
    init = function()
      vim.keymap.set(
        'n',
        '<leader>gd',
        --[[
             1. open diffview
             2. turn off any highlighted search matches
             3. jump two windows (should end us up at current buffer)
             4. go to last location in buffer ... not we have to do this
                after a delay ... 100 ms seems to be sufficient, increase
                if you don't get deisred result
        --]]
        --
        function()
          -- first we get current cursor location in the file we're in
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.fn.timer_start(
            100, -- delay ms ... increase this if you dont see desired result
            function()
              -- this delayed callback is optional
              -- it effectively goes to where you were in the file
              -- and centers on it
              -- vim.cmd [[norm '"]]
              -- vim.cmd [[norm zz]]
              vim.api.nvim_win_set_cursor(0, pos) -- note that 0 -> current window which is now the diff window after 100 ms
              vim.api.nvim_feedkeys('zz', 'n', false)
            end
          )
          return [[:DiffviewOpen<cr>:nohlsearch<cr><C-w><C-w><C-w><C-w>]]
        end,

        {
          desc = '[G]it [D]iff',
          expr = true,
        }
      )
    end,
  },

  {
    -- NOTE: we currently only use this for typescript projects, see on_attach for tsserver further down
    'artemave/workspace-diagnostics.nvim',
    config = function()
      require('workspace-diagnostics').setup {
        workspace_files = function()
          -- require('fidget').notify('hello world', '@comment.error', { annote = 'LOADING DIAGNOSTICS' })
          -- TODO: find better way to guess project root .. see documentation of root_dir for tsserver etc
          local root_dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
          -- TODO: filter out directories or files that we don't want?
          -- print('git path: ' .. vim.inspect(root_dir))
          -- local workspace_files = vim.fn.split(vim.fn.system('git ls-files ' .. root_dir), '\n')
          local workspace_files = vim.fn.split(vim.fn.system('git ls-files ' .. root_dir .. [[ | grep -E "\.(ts|tsx|js|jsx|json|mjs|mts|cjs|cts)$"]]), '\n')
          -- print 'workspace files ... '
          -- print(vim.inspect(workspace_files))
          -- local num = #workspace_files
          -- print('we got ' .. num .. ' workspace files')
          return workspace_files
        end,
      }
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
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
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.clear_references()
              end,
            })
          end

          if client and client.name == 'tsserver' then
            if vim.g.tsserver_loaded_workspace then
            -- do nothing
            else
              local buffer = vim.api.nvim_get_current_buf()
              require('fidget').notify(client.id .. 'starting diagnostics ...' .. ' name: ' .. client.name, '@comment.error', { annote = 'DIAG' })
              require('fidget').notify(client.id .. 'starting diagnostics ...' .. ' buf: ' .. buffer, '@comment.error', { annote = 'DIAG' })
              require('workspace-diagnostics').populate_workspace_diagnostics(client, buffer)
              require('fidget').notify(client.id .. 'completed diagnostics ...', '@comment.error', { annote = 'DIAG' })
              vim.g.tsserver_loaded_workspace = true
            end
          end

          -- wraps normal diagnostics callback so we can get some extra information
          -- useful to tell whether or not we are still loading workspace
          vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, res, ctx)
            local uri = res.uri
            require('fidget').notify('-> ', '@comment.error', { key = 'diagnostic', annote = uri })
            vim.lsp.diagnostic.on_publish_diagnostics(err, res, ctx)
          end

          -- Lets give the hover information stuff a bit more style
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            -- Use a sharp border with `FloatBorder` highlights
            border = 'single',
            -- add the title in hover float window
            title = 'hover',
          })
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
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
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              workspace = {
                checkThirdParty = 'Disable',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
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
          border = 'single',
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
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- TODO: actually configure to use prettier for javascript + typescript
        -- javascript = { { "prettierd", "prettier" } },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

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
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          -- ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      -- TODO: add function args ... see docs
      on_colors = function(colors)
        colors.black = '#000000'
      end,
      on_highlights = function(hl, colors)
        hl.CursorLine.bg = colors.bg_statusline

        hl.TodoBgFIX = {
          bg = colors.error,
          fg = colors.black,
        }
        hl.DiffAdd = {
          bg = colors.diff.change,
        }
        hl.DiffChange = {
          bg = colors.diff.change,
        }
        hl.DiffText = {
          bg = colors.diff.add,
          underline = true,
        }

        hl.Folded = {
          bg = 'none',
          fg = colors.magenta2,
          underline = true,
        }

        hl.GitSignsAdd = {
          fg = colors.hint,
        }

        hl.GitSignsChange = {
          fg = colors.magenta,
        }

        hl.FoldColumn = hl.LineNr

        hl.TreesitterContext.bg = nil
        -- hl.TreesitterContextSeparator = { fg = colors.magenta2 }

        hl.DiffviewDiffDeleteDim = { fg = colors.git.delete } -- { fg = colors.diff.delete }

        hl.Comment.style.italic = false

        hl.MiniStatuslineBranch = { fg = colors.magenta, bg = colors.bg_highlight } --  bg = colors.magenta }
        hl.MiniStatuslineWorkspace = { fg = colors.hint, bg = colors.bg_highlight } --  bg = colors.magenta }
        hl.MiniStatuslineChanges = { fg = colors.blue, bg = colors.bg_highlight } --  bg = colors.blue }
        hl.MiniStatuslineDiagnostics = { fg = colors.red, bg = colors.bg_highlight } --  bg = colors.red }
        hl.MiniStatuslineFilename = { fg = colors.hint, bg = colors.bg_statusline } --  bg = colors.red }
        hl.MiniStatuslineFilenameUnsaved = { fg = colors.red, bg = colors.bg_statusline } --  bg = colors.red }

        do
          -- here we set some backgrounds to transparent ...
          -- it's just a fun little test we're doing ^ ^
          local groups = {
            'Normal',
            'NormalNC',
            --
            'NormalFloat',
            'FloatBorder',
            'WhichKeyFloat',
            --
            'SignColumn',
            --
            'TelescopeNormal',
            'TelescopeBorder',
            'TelescopePromptBorder',
            'TelescopePromptTitle',
            --
            'NotifyBackground',
            'NotifyINFOBody',
          }
          for _, group in pairs(groups) do
            local g = hl[group]
            if g then
              g.bg = nil
            end
          end
        end

        -- hack to get a list of all the colors without bloat
        -- ... to show the list type fg_____ or bg_____ in the search bar of :Telescope highlights
        local ccolors = {}
        for k, v in pairs(colors) do
          if type(v) == 'table' then
            for kk, vv in pairs(v) do
              ccolors[k .. '.' .. kk] = vv
            end
          else
            ccolors[k] = v
          end
        end

        local ucolors = {}
        for k, v in pairs(ccolors) do
          for _, cc in pairs(ucolors) do
            if v == cc then
              -- print('collision: ' .. k .. ' <> ' .. kk)
              goto continue
            end
          end
          ucolors[k] = v
          ::continue::
        end

        local n = 0
        for name, color in pairs(ucolors) do
          if type(color) == 'table' then
            -- print('skipping: ' .. name .. vim.inspect(color))
            goto continue
          end
          n = n + 1
          hl['bg_' .. n .. '_________' .. name] = {
            bg = color,
            fg = '#000000',
          }
          hl['fg_' .. n .. '_________' .. name] = {
            fg = color,
            bg = '#000000',
          }
          ::continue::
        end
      end,
    },

    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

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
                { hl = 'MiniStatuslineWorkspace', strings = { vim.fs.basename(root_dir) } },
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

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end

        -- statusline.section_diff(args)
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
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
      ensure_installed = { 'bash', 'c', 'rust', 'typescript', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'javascript' },
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

      -- testing treesitter nodes ...
      vim.keymap.set('n', '<leader>J', function()
        local node = vim.treesitter.get_node()
        if node then
          print('node type is: ' .. node:type())
        end
      end)

      vim.keymap.set('n', '<C- >', function()
        local id = vim.api.nvim_create_buf(true, true)
        -- vim.api.nvim_buf_set_name(id, 'yoyoma')

        -- TODO: now that we know how to create a buffer somewhat ... lets find out how to make a window that kinda pops up?
        ------------------------------r  c  r  c
        vim.api.nvim_buf_set_text(id, 0, 0, 0, 0, {
          'hello world? why is this allowed?',
          'this is surely not allowed?',
          'oh it seems like it just takes up as much space as is available if 0 0 0 0 is passed?',
        })

        -- sets the buffer we just create to the active window
        vim.api.nvim_win_set_buf(0, id)

        -- demonstrating how one can listen to events in a buffer
        vim.api.nvim_buf_attach(id, true, {
          on_lines = function()
            print 'on_lines'
          end,
          on_detach = function()
            print 'on_detach'
          end,
          on_changedtick = function()
            print 'on_changedtick'
          end,
          on_bytes = function()
            print 'on_bytes'
          end,
          on_reload = function()
            print 'on_reloa'
          end,
        })
      end)

      vim.keymap.set('n', '<C-e>', function()
        for _, id in pairs(vim.api.nvim_list_bufs()) do
          local name = vim.api.nvim_buf_get_name(id)
          local isLoaded = vim.api.nvim_buf_is_loaded(id)
          local isValid = vim.api.nvim_buf_is_valid(id)

          -- vim.api.nvim_buf_set_name(id, 'YoYoMa')
          local status = 'invalid'
          if isValid then
            status = 'valid'
          end

          -- vim.api.nvim_buf_get_option(id, name)
          if isLoaded then
            print('buffer -> ' .. id .. ' called ' .. name .. ' is ' .. status)
          end
        end
      end)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --   TODO: - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --   TODO: - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
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
  ui = {
    border = 'single',
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
