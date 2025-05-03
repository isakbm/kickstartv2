# Troubleshooting

`:checkhealth`

`:Lazy`

`:Mason`

`~/.local/state/nvim/lsp.log`

## Keybinding Conflicts

`:verbose nmap <the key binding>`

## Color issues etc with tmux

Make sure your tmux profile is set to use the same
terminal as your terminal emulator, to see which
terminal you are using, exit tmux and do `echo $TERM`

You may need to kill your tmux servers for changes to
have an effect

To check issues with colors, simply do `:CheckReds`
if all is good you should see a nice continuous
gradient between black and red, if not you'll see
discotinuous steps and repeats of the same color

## Syntax highlighting, configure using mini.collors

`:InspectTree` 

# Basics Getting Started

`:Tutor`

`:help lua-guide`

`:help`

https://learnxinyminutes.com/docs/lua/

`<leader>sh`

`<leader>sk`

# Favorite motions

> :help text-object

> ciw caw cip dap dapu
>
> vi] vi} va] va} vap vip

> D C I A O P Y
>
> _ 0 $ %

# OS Keys ?

    Map `Capslock` to `<Esc>` in your operating system

    Also consider similar mappings of other keys like

```~ ` $```

# FAQ

how can I open a url?

> ``` gx ```

how do I swap lines?

> ``` Ctrl + j / k  when in normal mode ```

how do I do something like Ctrl + backspace when in insert mode?

> ``` Ctrl + w ```

how do I see my current changes in a nice way?

> ``` <leader>dt    <- diff this buffer (includes unsaved change) !!! ```

> ``` <leader>gd    <- entire workspace (does not include unsaved changes) !!! ```

how do I see changes intoruded by a single commit?

> ``` <leader>gl   place cursor on a commit and hit <enter> ```

how do I see changes introduced by a range of commits, like diff a..b?

> ``` <leader>gl   visual selection and then hit <enter> ```

how do I refactor a variable name or function name?

> ``` <leader>rn ```

