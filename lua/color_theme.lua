return {
  --- update highlights based on input color palette
  ---@param c table<string, string>
  ---@param theme Colorscheme
  ---@param opts? I.UpdateOpts
  update_highlights = function(c, theme, opts)
    local cset = (function()
      ---@type vim.api.keyset.highlight
      local last_hl = { fg = c.sand }

      ---@param name string
      ---@param hl? vim.api.keyset.highlight
      ---@param tweak? "tweak"
      return function(name, hl, tweak)
        local name = vim.trim(name)
        local hl_groups = theme.groups or {}
        if hl then
          last_hl = hl
        end
        if tweak then
          hl_groups[name] = hl_groups[name] or {}
          hl_groups[name] = vim.tbl_extend('force', hl_groups[name], last_hl)
        else
          hl_groups[name] = last_hl
        end
      end
    end)()

    cset('Search        ', { fg = c.teal }, 'tweak')
    cset('IncSearch     ', { fg = c.sand }, 'tweak')
    cset('NormalFloat   ', { fg = c.white, bg = nil })
    cset('Normal        ', { fg = c.white, bg = c.blackboard })
    cset 'SignColumn    '

    cset('DiagnosticUnderlineError', { undercurl = true }, 'tweak')

    cset('Directory', { fg = c.teal })
    cset 'Statement'
    cset 'Function'
    cset 'Macro'
    cset '@tag'
    cset '@function.builtin'
    cset '@tag.builtin'
    cset '@lsp.type.formatSpecifier'

    cset('Delimiter', { fg = c.brown })
    cset 'Keyword'
    cset 'Repeat'
    cset 'ColorEditTitle'
    cset 'Conditional'
    cset 'Operator'
    cset 'WinSeparator'
    cset 'TelescopeBorder'
    cset '@keyword.type'
    cset '@tag.delimiter'
    cset '@constructor.lua'
    cset 'LeapLabelPrimary'

    cset('Type', { fg = c.sand })
    cset 'Number'
    cset 'Boolean'
    cset 'String'
    cset 'Structure'
    cset 'GitSignsChange'
    cset '@constructor'
    cset 'DiffviewFilePanelPath'
    cset '@type.builtin'

    cset('Identifier', { fg = c.white })
    cset 'Identifier'
    cset '@markup.raw'
    cset '@tag.attribute'
    cset 'markdownBlockQuote'

    cset('Include', { fg = c.pear })
    cset 'Label'
    cset 'Title'
    cset 'ColorEditTitleActive'
    cset 'TelescopeTitle'
    cset 'TodoBgTODO'
    cset 'TodoBgNOTE'
    cset 'GitSignsAdd'
    cset '@lsp.type.namespace'
    cset '@module'

    cset('Constant', { fg = c.pink })
    cset 'SpecialChar'
    cset 'GitSignsDelete'
    cset '@constant.builtin'
    cset '@lsp.type.lifetime'
    cset '@lsp.typemod.keyword.async'
    cset '@lsp.typemod.operator.controlFlow'
    cset 'DiffviewFilePanelTitle'

    cset('Comment', { fg = c.gray })
    cset 'LeapBackdrop'

    cset('LineNr', { fg = c.gray3 })
    cset('CursorLineNr', { fg = c.pear2 })

    cset('CursorLine', { bg = c.gray4 })

    cset('TodoBgWARN', { fg = c.pink2 })
    cset 'TodoBgFIX'
    cset 'TodoBgFIXME'

    cset('TodoBgWARN', { fg = c.sand })

    cset('Special', { fg = c.orange })

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

    cset('DiffAdd               ', { bg = '#003530' })
    cset('DiffChange            ', { bg = '#003530' })
    cset('DiffText              ', { bg = '#004040' })
    cset('DiffDelete            ', { fg = c.pink2 })
    cset('DiffviewDiffDeleteDim ', { fg = c.pink })

    cset('MiniStatuslineBranch           ', { fg = c.pear, bg = c.gray2 })
    cset('MiniStatuslineWorkspace        ', { fg = c.pear, bg = c.gray2 })
    cset('MiniStatuslineWorkspaceUnsaved ', { fg = c.pink2, bg = c.gray2 })
    cset('MiniStatuslineChanges          ', { fg = c.sand, bg = c.gray2 })
    cset('MiniStatuslineDiagnostics      ', { fg = c.teal, bg = c.gray2 })
    cset('MiniStatuslineFileinfo         ', { fg = c.teal, bg = c.gray2 })
    cset('MiniStatuslineModeNormal       ', { fg = c.gray2, bg = c.sand })
    cset('MiniStatuslineModeVisual       ', { fg = c.gray2, bg = c.pink })
    cset('MiniStatuslineModeInsert       ', { fg = c.gray2, bg = c.teal })

    cset('Visual', { bg = c.pear33 })

    ---@diagnostic disable-next-line: undefined-field
    theme:apply(opts)
  end,
}
