---@class I.UpdateOpts
---@field clear boolean?

return {

  --- update highlights based on input color palette
  ---@param colorPalette table<string, table<string, string>>
  ---@param mode "light" | "dark"
  ---@param theme Colorscheme
  ---@param opts? I.UpdateOpts
  update_highlights = function(colorPalette, mode, theme, opts)
    local c = colorPalette[mode]

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

    cset('Search        ', { bg = c.teal, fg = c.pear33 }, 'tweak')
    cset('IncSearch     ', { fg = c.sand }, 'tweak')
    cset('NormalFloat   ', { fg = c.white, bg = nil })
    cset('Normal        ', { fg = c.white, bg = c.blackboard })
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
    cset('Keyword')
    cset('Repeat')
    cset('ColorEditTitle')
    cset('Conditional')
    cset('Operator')
    cset('WinSeparator')
    cset('TelescopeBorder')
    cset('@keyword.type')
    cset('@tag.delimiter')
    cset('@constructor.lua')
    cset('LeapLabelPrimary')

    cset('Type', { fg = c.sand })
    cset('Number')
    cset('Boolean')
    cset('String')
    cset('Structure')
    cset('GitSignsChange')
    cset('@constructor')
    cset('DiffviewFilePanelPath')
    cset('@type.builtin')

    cset('Identifier', { fg = c.white })
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

    cset('LineNr', { fg = c.gray3 })
    cset('CursorLineNr', { fg = c.pear2 })

    cset('CursorLine', { bg = c.gray5 })
    cset('FoldColumn', { bg = c.gray5 })
    cset('Folded', { bg = c.gray5 })

    cset('TodoBgTODO', { reverse = true, fg = mode == 'dark' and c.pear or c.pear2 })
    cset('TodoBgNOTE')
    cset('TodoBgWARN', { reverse = true, fg = c.pink2 })
    cset('TodoBgFIX')
    cset('TodoBgFIXME')
    cset('TodoBgSTORE', { reverse = true, fg = c.orange })
    cset('TodoBgWARN', { reverse = true, fg = c.sand })

    cset('Special', { fg = c.orange })

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
    cset('MiniStatuslineChanges          ', { fg = c.sand2, bg = slbg })
    cset('MiniStatuslineDiagnostics      ', { fg = c.teal2, bg = slbg })
    cset('MiniStatuslineFileinfo         ', { fg = c.teal2, bg = slbg })
    cset('MiniStatuslineLocation         ', { fg = slbg, bg = c.sand2 })

    cset('MiniStatuslineLines', { fg = slbg, bg = c.teal2 })
    cset('MiniStatuslineSearch', { fg = slbg, bg = c.teal2 })

    cset('MiniStatuslineFilename', { fg = c.pear, bg = slbg })
    cset('MiniStatuslineFilenameUnsaved', { fg = c.pink2, bg = slbg })

    cset('MiniStatuslineModeNormal       ', { fg = slbg, bg = c.sand2 })
    cset('MiniStatuslineModeVisual       ', { fg = slbg, bg = c.pink3 })
    cset('MiniStatuslineModeInsert       ', { fg = slbg, bg = c.teal2 })

    cset('Visual', { bg = c.pear33 })
    cset('MatchParen', { bg = c.pear33 })

    ---@diagnostic disable-next-line: undefined-field
    theme:apply(opts)
  end,
}
