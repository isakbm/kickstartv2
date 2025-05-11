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
        return
        -- local name = vim.trim(name)
        -- local hl_groups = theme.groups or {}
        -- if hl then last_hl = hl end
        -- if tweak then
        --   hl_groups[name] = hl_groups[name] or {}
        --   hl_groups[name] = vim.tbl_extend('force', hl_groups[name], last_hl)
        -- else
        --   hl_groups[name] = last_hl
        -- end
      end
    end)()

    cset('NormalFloat   ', { fg = c.foreground, bg = nil })
    cset('Normal        ', { fg = c.foreground, bg = c.background })
    cset('SignColumn    ')

    cset('Search        ', { bg = c.orange, fg = c.background })
    cset('IncSearch     ', { bg = c.orange, fg = c.background })
    cset('Visual        ', { bg = c.blue3, fg = c.background })

    cset('MatchParen', { bold = true, underline = true, fg = c.pear })

    cset('DiagnosticUnderlineError', { undercurl = true }, 'tweak')

    --- FUNCTION
    cset('Directory', { fg = c.func })
    cset('Statement')
    cset('Function')
    cset('Macro')
    cset('@tag')
    cset('@function.builtin')
    cset('@tag.builtin')
    cset('@lsp.type.formatSpecifier')

    --- KEYWORD
    cset('Delimiter', { fg = c.keyword })
    cset('Repeat')
    cset('ColorEditTitle')
    cset('Conditional')
    cset('Operator')
    cset('WinSeparator')
    cset('TelescopeBorder')
    cset('@tag.delimiter')
    cset('@constructor.lua')
    cset('LeapLabelPrimary')
    cset('Keyword')
    cset('@keyword.type')

    --- SPECIAL
    cset('@keyword.return', { bold = true, fg = c.special })
    cset('Special')
    cset('@lsp.type.lifetime')
    cset('@lsp.typemod.keyword.async')
    cset('@lsp.typemod.operator.controlFlow')
    cset('SpecialChar')

    --- TYPE
    cset('Type', { fg = c.type })
    cset('Number')
    cset('Boolean')
    cset('String')
    cset('Structure')
    cset('@constructor')
    cset('DiffviewFilePanelPath')
    cset('@type.builtin')

    --- CONSTANT
    cset('Constant', { fg = c.constant })
    cset('@constant.builtin')

    --- IDENTIFIER
    cset('Identifier', { fg = c.identifier })
    cset('Identifier')
    cset('@markup.raw')
    cset('@tag.attribute')
    cset('markdownBlockQuote')

    --- TITLE
    cset('Label', { fg = c.title })
    cset('Title')
    cset('ColorEditTitleActive')
    cset('TelescopeTitle')
    cset('DiffviewFilePanelTitle')

    --- NAMESPACE
    cset('Include', { fg = c.namespace })
    cset('@lsp.type.namespace')
    cset('@module')

    --- GITSIGN
    cset('GitSignsAdd', { fg = c.gitsignadd })
    cset('GitSignsDelete', { fg = c.gitsigndelete })
    cset('GitSignsChange', { fg = c.gitsignchange })

    --- COMMENT
    cset('Comment', { fg = c.comment })

    cset('LineNr', { fg = c.gray3 })

    cset('CursorLineNr', { fg = c.pear2 })
    cset('CursorLine', { bg = c.black })

    cset('FoldColumn', { bg = c.black })
    cset('Folded', { bg = c.black })

    --- TODO
    cset('TodoBgTODO', { reverse = true, fg = c.pear })
    cset('TodoBgNOTE')
    cset('TodoBgWARN', { reverse = true, fg = c.hotpink })
    cset('TodoBgFIX')
    cset('TodoBgFIXME')
    cset('TodoBgSTORE', { reverse = true, fg = c.orange })
    cset('TodoBgWARN', { reverse = true, fg = c.sand })

    --- GIT GRAPH
    cset('GitGraphBranch1   ', { fg = c.blue3 })
    cset('GitGraphBranch2   ', { fg = c.pink })
    cset('GitGraphBranch3   ', { fg = c.sand })
    cset('GitGraphBranch4   ', { fg = c.pear })
    cset('GitGraphBranch5   ', { fg = c.orange })
    cset('GitGraphHash      ', { fg = c.teal })
    cset('GitGraphTimestamp ', { fg = c.sand })
    cset('GitGraphAuthor    ', { fg = c.brown })
    cset('GitGraphBranchName', { fg = c.pear })
    cset('GitGraphBranchTag ', { fg = c.pink })
    cset('GitGraphBranchMsg ', { fg = c.gray })

    --- DIFF
    cset('DiffAdd               ', { bg = c.diffadd })
    cset('DiffChange            ', { bg = c.diffchange })
    cset('DiffText              ', { bg = c.difftext })
    cset('DiffDelete            ', { fg = c.hotpink })
    cset('DiffviewDiffDeleteDim ', { fg = c.pink })

    --- STATUSLINE
    cset('MiniStatuslineBranch           ', { fg = c.sand, bg = c.gray2 })
    cset('MiniStatuslineWorkspace        ', { reverse = true, fg = c.pear, bg = c.gray2 })
    cset('MiniStatuslineWorkspaceUnsaved ', { reverse = true, fg = c.hotpink, bg = c.gray2 })
    cset('MiniStatuslineChanges          ', { fg = c.sand, bg = c.gray2 })
    cset('MiniStatuslineDiagnostics      ', { fg = c.teal, bg = c.gray2 })
    cset('MiniStatuslineFileinfo         ', { fg = c.teal, bg = c.gray2 })
    cset('MiniStatuslineLocation         ', { fg = c.gray2, bg = c.sand })

    cset('MiniStatuslineLines', { fg = c.gray2, bg = c.teal })
    cset('MiniStatuslineSearch', { fg = c.gray2, bg = c.teal })

    cset('MiniStatuslineFilename', { fg = c.pear, bg = c.gray2 })
    cset('MiniStatuslineFilenameUnsaved', { fg = c.hotpink, bg = c.gray2 })

    cset('MiniStatuslineModeNormal       ', { fg = c.gray2, bg = c.sand })
    cset('MiniStatuslineModeVisual       ', { fg = c.gray2, bg = c.pink })
    cset('MiniStatuslineModeInsert       ', { fg = c.gray2, bg = c.teal })

    ---@diagnostic disable-next-line: undefined-field
    theme:apply(opts)
  end,
}
