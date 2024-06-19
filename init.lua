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
    A1: <leader>dt    <- diff this buffer (includes unsaved change) !!!
    A2: <leader>gd    <- entire workspace (does not include unsaved changes) !!!

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

    >> `export class Foo` in typescript, then `class` is not getting highlighted
        correctly, it should be some keyword in language, but instead it's highlighted
        as being part of the definition of the custom type ...

    >> popup window with a tip like

        `cob` will `check out branch` under cursor when in git graph view

    >> popup window reminindg you to stretch and drink water

    >> popup window with fun animation when you are waiting for something perhaps you pushed code
       or perhaps you are compiling

    >> Make it possible to exit out of git status window with ESC ESC 

    >> Something is wrong with the nerdfont icons, they are sometimes
       cut short on their right hand side. See `:Mason` and `:Lazy` and
       the icons used at the beginning of every list item there.

    >> Add a little toolbox window that you can open at any time
       Make it searchable.
       Have tool slike `to uppercase` `to hex` etc etc :D

    >> Find a way to jump to a web URL without using mouse  

    >> Shift F is now bound to leap ... but F is good for finding backwards ...

    >> find better way of typoing [ ] and { } on a norwegian keyboard?

    >> Get a nice way to jump to parent scopes locally. Currently
       we can do something like this with treesitter-context, but
       that jumps to the context that is 'off screen' try '[c'

    >> when doing an action using `fugitive` like `:Git checkout -b foo`
       it would be ideal if any open `flog` buffer would update so
       that we can see the effect the command had on the graph!

    >> find out how to quickly switch to previous buffer

    >> find out how to close a buffer without using :q

    >> even if contents of file are identical to those when you started
       vim still thinks your buffer has changes if you added and deleted
       something. vim only knows that the fil has not chnaged if you
       literally go back with undo ... can this be changed in a setting?

    >> its nice that our statusline says what type of lsp mode we're in
       and what branch we're on etc, however, when using plugins that
       launch other tabs or buffers like `flog` for the git log or
       `:Git` for git status, we see that this information is no longer
       in the statusline, because the statusline is looking at metadata
       regarding the current active buffer, which in the case of those
       plugins is not a tracked code file ...

    >> find a way to do grep search over subset of files
    
    >> I REALLY need a way to quickly see the changes in the buffer that
       have not been saved to file

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

---@param ho string
---@param ve string
---@param ll string
---@param lr string
---@param ur string
---@param ul string
function border_maker(ho, ve, ul, ur, lr, ll)
  return {
    ul,
    ho,
    ur,
    ve,
    lr,
    ho,
    ll,
    ve,
  }
end

WIN_BORDER = border_maker('─', '│', '╭', '╮', '╯', '╰')

--=========================== KEYMAPS =============================
--
-- The follow keymaps are suppsed to be independet of plugins.
--
-- NOTE: hide higlights after hitting <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-f>', '<NOP>')

-- NOTE: swap lines like in vscode
--
--   we've bound <M-*> so the `Alt` or `Modifier` key, however, see :h :map-alt and you'll notice that
--   nvim is not able to distinguish between `Esc` and `Alt` if key press is fast enough, we'll just live
--   with this, it rarely causes issues, but if you press `Esc` + j  or `Esc + k` very quickly while
--   in normal mode, you'll also trigger the below keymaps.
vim.keymap.set('n', '<C-j>', ':m+1<cr>', { desc = 'swap line with line below' }) -- vscode <alt> + <up>
vim.keymap.set('n', '<C-k>', ':m-2<cr>', { desc = 'swap line with line above' }) -- vscode <alt> + <down>

vim.keymap.set('n', 'Q', '/')

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

local hlgs = {}

--- works by searching for string of the form "#RRGGBB"
--- keeps a list of created highlght groups and reuses
--- them, ... only searches in the current visible part
--- of the buffer, and only upates on changes
local function hex_color_highlight()
  local top = vim.fn.line 'w0'
  local bot = vim.fn.line 'w$'

  --- @type table<string, string>
  ---
  ---
  -- local hlgs = vim.g.hex_highlight_groups
  if not hlgs then
    hlgs = {}
  end

  local text = vim.api.nvim_buf_get_lines(0, top, bot, true)

  for idx, line in pairs(text) do
    local offset = 1
    for m in line:gmatch '["\']#%x%x%x%x%x%x["\']' do
      local loc = line:find(m, offset, true)
      offset = loc + 9
      local row = idx + top
      local col_start = loc
      local col_end = offset

      local hlg = false
      local sm = m:sub(3, 8)
      for _, c_hlg in pairs(hlgs) do
        if c_hlg == sm then
          hlg = true
          break
        end
      end

      if not hlg then
        vim.api.nvim_set_hl(0, sm, { fg = '#' .. sm })
        hlgs[#hlgs + 1] = sm
      end

      if col_start and col_end then
        vim.api.nvim_buf_add_highlight(0, 0, sm, row - 1, col_start - 1, col_end - 1)
      end
    end
  end
end

-- TODO: should add TextChanged
-- "#AAAAAA" "#FFAABB"
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinScrolled' }, {
  callback = function()
    hex_color_highlight()
  end,
})

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
    border = WIN_BORDER,
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

do
  local dt = 10
  local n = 10

  --- @param dir 'j' | 'k'
  local function glide(dir)
    return function()
      local d = vim.api.nvim_get_mode()
      for i = 0, n do
        vim.fn.timer_start(i * dt, function()
          vim.api.nvim_feedkeys(dir, d.mode, false)
        end)
      end
    end
  end

  vim.keymap.set({ 'v', 'n' }, '<M-j>', glide 'j')
  vim.keymap.set({ 'v', 'n' }, '<M-k>', glide 'k')
end

-- useful for figuring out what higlight groups are relevant for stuff under cursor
vim.keymap.set('n', '<leader>I', function()
  vim.show_pos()
end)

-- Nice to start off where you left off
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Start off where you left off',
  group = vim.api.nvim_create_augroup('kickstart-buf-enter', { clear = true }),
  -- NOTE: this is just the command '"  in lua [[ and ]] are similar to ``` in other languages
  callback = function()
    local ok, pos = pcall(vim.api.nvim_buf_get_mark, 0, [["]])
    if ok and pos[1] > 0 then
      -- protected mode because sometimes this will fail, for example on NON FILE BUFFERS
      pcall(vim.api.nvim_win_set_cursor, 0, pos)
    end
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

-- takes buffer number and removes the ESC ESC local keybinding
--- @param buf integer
local function cancel_esc_esc_once_buf(buf)
  pcall(vim.keymap.del, 'n', '<Esc><Esc>', { buffer = buf })
end

-- any parent tab page, useful for handy closeing of plugins that
-- spawn their own tabpages
--- @param buf integer
local function esc_esc_once_buf(buf)
  vim.keymap.set('n', '<Esc><Esc>', function()
    vim.cmd ':tabc'
    cancel_esc_esc_once_buf(buf)
  end, { buffer = buf })
  -- NOTE: we also need to register an autocommand that will clear the above keymap
  --       if the buffer is leaving the window it was in
  --       :
end

-- returns true if buffer is trivial
--- @param buf integer -- 0 is current buffer
--- @return boolean
local function buf_is_trivial(buf)
  local n = vim.api.nvim_buf_line_count(buf)
  if n == 0 then
    return true
  end
  if n == 1 then
    local c = #vim.api.nvim_buf_get_lines(buf, 0, 1, true)[1]
    if c == 0 then
      return true
    end
  end
  return false
end

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

  -- {
  --   'chentoast/marks.nvim',
  --   opts = {},
  -- },

  {
    'ggandor/leap.nvim',
    config = function()
      local leap = require 'leap'
      leap.opts.labels = 'sfnjklhodweimbuyvrgtaqpcxzSFNJKLHODWEIMBUYVRGTAQPCXZ'
      leap.opts.safe_labels = ''
      vim.keymap.set({ 'n', 'x', 'o' }, 'L', '<Plug>(leap)', { desc = '[L]eap' })
    end,
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
      require('which-key').setup { window = { border = WIN_BORDER } }

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
        defaults = {
          mappings = {
            -- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            i = { ['<Esc><Esc>'] = require('telescope.actions').close },
            n = { ['<Esc><Esc>'] = require('telescope.actions').close },
          },
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
      vim.keymap.set('n', '<leader>gl', function()
        -- whenever we enter a flog buffer we want to register
        -- this autocommand ONCE, it in turn registers the esc esc
        -- key binding on the buffer in it such that it's easy to
        -- leave flog
        vim.api.nvim_create_autocmd({ 'BufEnter' }, {
          callback = function(ctx)
            -- this helps us catch any bugs, if we see this in the fidget history
            -- then we know that we did not deregister the autocommand correctly, the use of once should make this automatic
            require('fidget').notify('flog - buf enter', '@comment.error', { annote = 'FLOG' })
            esc_esc_once_buf(ctx.buf)
          end,
          once = true,
        })
        vim.cmd [[:Flog -all -max-count=999999 -date=relative]]
        vim.fn.timer_start(60, function()
          vim.fn.search 'HEAD ->'
          vim.api.nvim_feedkeys('zz', 'n', false)
          vim.keymap.del({ 'n', 'i' }, '<CR>', { buffer = vim.api.nvim_get_current_buf() })
        end)
      end, { desc = '[G]it [L]og' })
      -- vim.keymap.set('n', '<leader>gl', ':Flog -format=%ar%x20[%h]%x20%d%x20%an <cr>', { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>gs', ':Git<cr>', { desc = '[G]it [S]tatus', silent = true })
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = 'fugitive:/*',
        callback = function(ctx)
          vim.keymap.set('n', '<Esc><Esc>', ':q<cr>', { buffer = ctx.buf, silent = true })
        end,
      })

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
      vim.keymap.set('n', '[h', ':Gitsigns next_hunk<cr>', { desc = '[G]it [N]ext hunk' })
      vim.keymap.set('n', ']h', ':Gitsigns prev_hunk<cr>', { desc = '[G]it [P]rev hunk' })
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
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-web-devicons',
    },
    opts = {
      -- enhanced_diff_hl = true,
      hooks = {
        view_leave = function()
          local buf = vim.api.nvim_get_current_buf()
          -- print('leaving view: buf =', buf)
          cancel_esc_esc_once_buf(buf)
        end,
        view_enter = function()
          local buf = vim.api.nvim_get_current_buf()
          -- print('entering view: buf =', buf)
          esc_esc_once_buf(buf)
        end,
        diff_buf_read = function(buf)
          -- print('diffview read buf: ', buf)
          vim.opt_local.cursorline = false
          esc_esc_once_buf(buf)
        end,
        view_opened = function()
          -- print 'opening view'
          vim.fn.timer_start(100, function()
            local tp = vim.api.nvim_get_current_tabpage()
            local wins = vim.api.nvim_tabpage_list_wins(tp)
            local win = wins[3]

            local buf = vim.api.nvim_win_get_buf(wins[3])
            if buf_is_trivial(buf) then
              print 'no change'
              vim.cmd [[:DiffviewClose]]
              return
            end

            if win then
              vim.api.nvim_set_current_win(win)
              vim.api.nvim_win_set_cursor(0, { 1, 0 })
            end
          end)
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

          vim.cmd [[:DiffviewOpen]]
          vim.fn.timer_start(
            100, -- delay ms ... increase this if you dont see desired result
            function()
              -- this delayed callback is optional
              -- it effectively goes to where you were in the file
              -- NOTE at this point in "time" our current window
              --      is the the active window in the diffview, diffview hooks may impact which window this is

              if buf_is_trivial(0) then
                print 'no changes'
                -- vim.cmd [[:DiffviewClose]]
                return
              end

              local n = vim.api.nvim_buf_line_count(0)

              if pos[1] <= n then
                vim.api.nvim_win_set_cursor(0, pos) -- note that 0 -> current window which is now the diff window after 100 ms
                vim.api.nvim_feedkeys('zz', 'n', false)
              end
            end
          )
        end,
        {
          desc = '[G]it [D]iff',
        }
      )
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
          map('<leader>rn', function()
            local res = vim.lsp.buf_request_sync(0, 'textDocument/hover', vim.lsp.util.make_position_params(), 200)[1]
            if res and not res.error and res.result and res.result.range then
              --- @class I.Loc
              --- @field character integer
              --- @field line integer

              local file_buf = vim.api.nvim_get_current_buf()
              local s = res.result.range['start'] --- @type I.Loc
              local e = res.result.range['end'] --- @type I.Loc
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
                vim.lsp.buf.rename(new_name, { bufnr = file_buf })
                vim.fn.timer_start(60, function()
                  vim.cmd.stopi()
                end)
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

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold' }, {
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
            border = WIN_BORDER,
            -- add the title in hover float window
            title = ' hover ',
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
        pyright = {},
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        tsserver = {},
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
          border = WIN_BORDER,
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
        python = { 'isort', 'black' },
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

  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = function(opts)
      local keywords = {
        -- NOTE: lowercase keywords will also match full uppercase
        fixme = { color = 'error' },
        fix = { color = 'error' },
        todo = { color = 'info' },
        -- NOTE: only matches uppercase
        NOTE = { color = 'hint' },
      }

      for word, _ in pairs(keywords) do
        -- this ensure that lowercase will also match uppercase keyword
        keywords[word].alt = { string.upper(word) }
      end
      return vim.tbl_extend('force', opts, {
        signs = false,
        highlight = {
          after = '',
          pattern = [[.*<(KEYWORDS)\s*(:|\s|$)]],
          keyword = 'bg',
        },
        merge_keywords = false,
        keywords = keywords,
      })
    end,
  },

  {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      do
        -- everything related to color theme goes here inside this block
        require('mini.colors').setup {}

        ---@type Colorscheme
        local theme = MiniColors.get_colorscheme 'retrobox'
        ---@type table<string, vim.api.keyset.highlight>
        local hl = theme.groups

        hl.Function = { fg = hl.Identifier.fg }
        -- hl.Identifier = { fg = '#AAEE88' }
        hl.Identifier = { fg = '#88CC66' }
        hl.Comment = { fg = '#404040' }
        hl.Operator = { fg = hl.Delimiter.fg }

        -- hl.markdownBlockQuote = { fg = hl.Identifier.fg }
        hl['@markup.raw'] = { fg = hl.Identifier.fg }

        hl.LeapBackdrop = { fg = hl.Comment.fg }
        hl.LeapLabelPrimary = { link = 'Keyword' }

        -- hl.CursorLine.bg = cs.bg_statusline

        hl.DiffAdd = { bg = '#003530' }
        hl.DiffChange = { link = 'DiffAdd' }
        hl.DiffText = { bg = '#004040' }
        hl.DiffDelete = { fg = '#F00000' }
        hl.Structure = { link = 'Type' }

        hl['@tag'] = { link = 'Function' }
        hl['@tag.attribute'] = { fg = hl.Identifier.fg }
        hl['@tag.delimiter'] = { link = 'Delimiter' }
        hl['@tag.builtin'] = { link = 'Function' }
        hl['@constructor'] = { link = 'Type' }
        hl['@type.builtin'] = { link = 'Type' }
        hl['@spell.tsx'] = { link = 'String' }
        hl['@function.builtin'] = { link = 'Function' }
        hl['@constant.builtin'] = { link = 'Constant' }

        -- hl.DiffviewDiffDeleteDim = { fg = '#FF0000' }
        --
        -- hl.Folded = { bg = 'none', fg = cs.magenta2, underline = true }
        --
        -- hl.GitSignsAdd = { fg = hl.DiffAdd.bg }
        -- hl.GitSignsDelete = { fg = hl.DiffDelete.fg }
        -- hl.GitSignsChange = { fg = hl.DiffAdd.bg }
        -- hl.GitSignsChange = { fg = cs.magenta }
        --
        -- hl.FoldColumn = hl.LineNr
        --
        -- hl.TreesitterContext.bg = nil
        --
        hl.MiniStatuslineBranch = { fg = hl.Keyword.fg, bg = hl.StatusLine.fg }
        hl.MiniStatuslineWorkspace = { fg = hl.Function.fg, bg = hl.StatusLine.fg }
        hl.MiniStatuslineWorkspaceUnsaved = { fg = hl.Keyword.fg, bg = hl.StatusLine.fg }
        -- hl.MiniStatuslineChanges = { fg = hl.Keyword.fg, bg = hl.StatusLine.fg }
        hl.MiniStatuslineDiagnostics = { fg = hl.String.fg, bg = hl.StatusLine.fg }
        -- hl.MiniStatuslineFilename = { fg = cs.hint, bg = cs.bg_statusline }
        -- hl.MiniStatuslineFilenameUnsaved = { fg = cs.red, bg = cs.bg_statusline }
        --
        hl.MiniStatuslineModeNormal = { fg = hl.StatusLine.fg, bg = hl.String.fg }
        hl.MiniStatuslineModeVisual = { fg = hl.StatusLine.fg, bg = hl.Identifier.fg }
        hl.MiniStatuslineModeInsert = { fg = hl.StatusLine.fg, bg = hl.Number.fg }

        hl.NormalFloat = { bg = nil }
        hl.WinSeparator = { fg = hl.String.fg }

        -- hl.String.fg = hl.Number.fg
        hl.Number.fg = hl.String.fg
        hl.Boolean.fg = hl.String.fg

        -- needed for transparent background
        -- hl.Normal = { bg = nil }
        -- hl.NormalNC = { bg = nil }
        -- hl.VertSplit.bg = nil
        -- hl.WhichKeyFloat = { bg = nil }
        -- hl.SignColumn = { bg = nil }
        -- hl.TelescopeNormal = { bg = nil }
        -- hl.TelescopeBorder = { bg = nil }
        -- hl.TelescopePromptBorder = { bg = nil }
        -- hl.TelescopePromptTitle = { bg = nil }
        -- hl.NotifyBackground = { bg = nil }
        -- hl.NotifyINFOBody = { bg = nil }

        ---@diagnostic disable-next-line: undefined-field
        theme:apply()
      end

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

              -- do we have any unsaved buffers?
              local bufs = vim.api.nvim_list_bufs()
              local workspace_hl = 'MiniStatuslineWorkspace'
              for _, buf in pairs(bufs) do
                local unsaved = vim.api.nvim_get_option_value('modified', { buf = buf })
                if unsaved then
                  workspace_hl = 'MiniStatuslineWorkspaceUnsaved'
                  break
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

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --   TODO: - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --   TODO: - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      --
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
