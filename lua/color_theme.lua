---@class I.UpdateOpts
---@field clear boolean?

return {

  --- update highlights based on input color palette
  ---@param colorPalette table<string, string>
  ---@param mode "light" | "dark"
  ---@param theme Colorscheme
  ---@param opts? I.UpdateOpts
  update_highlights = function(colorPalette, mode, theme, opts)
    local c = colorPalette

    local cset = (function()
      ---@type vim.api.keyset.highlight
      local last_hl = { fg = c.sand }

      ---@param name string
      ---@param hl? vim.api.keyset.highlight
      ---@param tweak? "tweak"
      return function(name, hl, tweak)
        local name = vim.trim(name)
        local hl_groups = theme.groups or {}
        if hl then last_hl = hl end
        if tweak then
          hl_groups[name] = hl_groups[name] or {}
          hl_groups[name] = vim.tbl_extend('force', hl_groups[name], last_hl)
        else
          hl_groups[name] = last_hl
        end
      end
    end)()

    cset('Search        ', { bg = c.orange, fg = c.black })
    cset('IncSearch     ', { bg = c.orange, fg = c.black })
    cset('Visual        ', { bg = c.blue3, fg = c.black })

    cset('NormalFloat   ', { fg = c.white, bg = nil })
    cset('Normal        ', {
      fg = mode == 'dark' and c.white or c.black,
      bg = mode == 'dark' and c.black or c.white,
    })
    cset('SignColumn    ')

    cset('DiagnosticUnderlineError', { undercurl = true }, 'tweak')

    cset('Directory', { fg = c.teal })
    cset('Statement')
    cset('Function')
    cset('Macro')
    cset('@tag')
    cset('@function.builtin')
    cset('@tag.builtin')
    cset('@lsp.type.formatSpecifier')

    cset('Delimiter', { fg = c.brown })
    cset('Repeat')
    cset('ColorEditTitle')
    cset('Conditional')
    cset('Operator')
    cset('WinSeparator')
    cset('TelescopeBorder')
    cset('@tag.delimiter')
    cset('@constructor.lua')
    cset('LeapLabelPrimary')

    cset('Keyword', { fg = c.brown })
    cset('@keyword.type')

    cset('@keyword.return', { bold = true, fg = c.pink2 })
    cset('Special', { bold = true, fg = c.pink2 })

    cset('Type', { fg = c.sand })
    cset('Number')
    cset('Boolean')
    cset('String')
    cset('Structure')
    cset('GitSignsChange')
    cset('@constructor')
    cset('DiffviewFilePanelPath')
    cset('@type.builtin')

    cset('Identifier', { fg = mode == 'dark' and c.white or c.black })
    cset('Identifier')
    cset('@markup.raw')
    cset('@tag.attribute')
    cset('markdownBlockQuote')

    cset('Include', { fg = mode == 'dark' and c.pear or c.pear2 })
    cset('Label')
    cset('Title')
    cset('ColorEditTitleActive')
    cset('TelescopeTitle')
    cset('GitSignsAdd')
    cset('@lsp.type.namespace')
    cset('@module')

    cset('Constant', { fg = c.pink })
    cset('SpecialChar')
    cset('GitSignsDelete')
    cset('@constant.builtin')
    cset('@lsp.type.lifetime')
    cset('@lsp.typemod.keyword.async')
    cset('@lsp.typemod.operator.controlFlow')
    cset('DiffviewFilePanelTitle')

    cset('Comment', { fg = c.comment })
    cset('LeapBackdrop')

    cset('LineNr', { fg = mode == 'dark' and c.gray3 or c.comment })

    cset('CursorLineNr', { fg = c.pear2 })
    cset('CursorLine', { bg = mode == 'dark' and c.black or c.white })

    cset('FoldColumn', { bg = c.black })
    cset('Folded', { bg = c.black })

    cset('TodoBgTODO', { reverse = true, fg = mode == 'dark' and c.pear or c.pear2 })
    cset('TodoBgNOTE')
    cset('TodoBgWARN', { reverse = true, fg = c.pink2 })
    cset('TodoBgFIX')
    cset('TodoBgFIXME')
    cset('TodoBgSTORE', { reverse = true, fg = c.orange })
    cset('TodoBgWARN', { reverse = true, fg = c.sand })

    cset('GitGraphBranch1   ', { fg = c.blue3 })
    cset('GitGraphBranch2   ', { fg = c.pink })
    cset('GitGraphBranch3   ', { fg = c.sand })
    cset('GitGraphBranch4   ', { fg = mode == 'dark' and c.pear or c.pear2 })
    cset('GitGraphBranch5   ', { fg = c.orange })

    cset('GitGraphHash      ', { fg = c.teal })

    cset('GitGraphTimestamp ', { fg = c.sand })
    cset('GitGraphAuthor    ', { fg = c.brown })
    cset('GitGraphBranchName', { fg = mode == 'dark' and c.pear or c.pear2 })
    cset('GitGraphBranchTag ', { fg = c.pink })
    cset('GitGraphBranchMsg ', { fg = c.gray })

    cset('DiffAdd               ', { bg = c.diffadd })
    cset('DiffChange            ', { bg = c.diffchange })
    cset('DiffText              ', { bg = c.difftext })
    cset('DiffDelete            ', { fg = c.pink2 })
    cset('DiffviewDiffDeleteDim ', { fg = c.pink })

    local slbg = mode == 'dark' and c.gray2 or c.black

    cset('MiniStatuslineBranch           ', { fg = mode == 'dark' and c.sand or c.blackboard, bg = slbg })
    cset('MiniStatuslineWorkspace        ', { reverse = true, fg = c.pear, bg = slbg })
    cset('MiniStatuslineWorkspaceUnsaved ', { reverse = true, fg = c.pink2, bg = slbg })
    cset('MiniStatuslineChanges          ', { fg = c.sand, bg = slbg })
    cset('MiniStatuslineDiagnostics      ', { fg = c.teal, bg = slbg })
    cset('MiniStatuslineFileinfo         ', { fg = c.teal, bg = slbg })
    cset('MiniStatuslineLocation         ', { fg = slbg, bg = c.sand })

    cset('MiniStatuslineLines', { fg = slbg, bg = c.teal })
    cset('MiniStatuslineSearch', { fg = slbg, bg = c.teal })

    cset('MiniStatuslineFilename', { fg = c.pear, bg = slbg })
    cset('MiniStatuslineFilenameUnsaved', { fg = c.pink2, bg = slbg })

    cset('MiniStatuslineModeNormal       ', { fg = slbg, bg = c.sand })
    cset('MiniStatuslineModeVisual       ', { fg = slbg, bg = c.pink })
    cset('MiniStatuslineModeInsert       ', { fg = slbg, bg = c.teal })

    cset('MatchParen', { bold = true, underline = true, fg = mode == 'dark' and c.pear or c.darkblue })

    ---@diagnostic disable-next-line: undefined-field
    theme:apply(opts)
  end,
}
