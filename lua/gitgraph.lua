---@return string[]
local function gitgraph()
  -- build a git commit graph
  --
  -- NOTE: you may be interested in knowin the difference between
  --       git log 'author date' and 'commit date'
  --
  --       author date is the original date of the commit when it was first made
  --       commit date is the date at which the commit was modified, i.e by an ammend
  --       or by a rebase or any other action that could modify the commit
  --
  local git_cmd = [[git log --all --pretty='format:%s%x00%aD%x00%H%x00%P']]
  -- local git_cmd = [[git log --all --pretty='format:{{%H}} {{%P}}']]
  local handle = io.popen(git_cmd)
  if not handle then
    print 'no handle?'
    return {}
  end

  ---@type string
  local log = handle:read '*a'

  handle:close()

  ---@class I.Row
  ---@field cells I.Cell[]
  ---@field commit I.Commit? -- there's a single comit for every even "second"

  -- TODO: make this into a proper class OO
  --       should have the following methods
  --       - hash : would return the commit hash or nil if cell is not a commit
  --       - conn : would return the connector symbol or nil if cell is not a connector
  --       - str  : would return the string representation
  --
  ---@class I.Cell
  ---@field is_commit boolean? -- when true this cell is a real commit
  ---@field commit I.Commit? -- a cell is associated with a commit, but the empty column gaps don't have them
  ---@field connector string? -- a cell is eventually given a connector
  ---@field emphasis boolean? -- when true indicates that this is a direct parent of cell on previous row

  ---@class I.Commit
  ---@field hash string
  ---@field is_void boolean -- used for the "reservation" logic ... a bit confusing I have to admit
  ---@field msg string
  ---@field debug string?
  ---@field author_date string
  ---@field explored boolean
  ---@field i integer
  ---@field j integer
  ---@field parents string[]
  ---@field children string[]
  ---@field merge_children string[]
  ---@field branch_children string[]
  ---
  ---@type table<string, I.Commit>
  local commits = {}

  ---@type string[]
  local hashes = {}

  for line in log:gmatch '[^\r\n]+' do
    local iter = line:gmatch '([^%z]+)'
    local msg = iter()
    local author_date = iter()
    local hash = iter()
    local parent_iter = (iter() or ''):gmatch '[^%s]+'

    hashes[#hashes + 1] = hash
    local parents = {}
    for p in parent_iter do
      parents[#parents + 1] = p
    end

    commits[hash] = {
      explored = false,
      msg = msg,
      author_date = author_date,
      hash = hash,
      i = -1,
      j = -1,
      parents = parents,
      is_void = false,
      children = {},
      merge_children = {},
      branch_children = {},
    }
  end

  -- populate children
  -- for _, c in pairs(commits) do
  -- NOTE: you want to be very careful here with the order
  --       keep in mind that `pairs` does not keep an order
  --       while `ipairs` does keep an order
  for _, h in ipairs(hashes) do
    local c = commits[h]

    -- children
    for _, h in ipairs(c.parents) do
      local p = commits[h]
      p.children[#p.children + 1] = c.hash
    end

    -- branch children
    local h = c.parents[1]
    if h then
      local p = commits[h]
      p.branch_children[#p.branch_children + 1] = c.hash
    end

    -- merge children
    for i = 2, #c.parents do
      local h = c.parents[i]
      local p = commits[h]
      p.merge_children[#p.merge_children + 1] = c.hash
    end
  end

  ---@type I.Commit[]
  local sorted_commits = {}

  local function create_visitor()
    ---@type integer
    local i = 1

    ---@param commit I.Commit
    local function visit(commit)
      if not commit.explored then
        commit.explored = true
        for _, h in ipairs(commit.children) do
          visit(commits[h])
        end
        commit.i = i
        i = i + 1
        sorted_commits[#sorted_commits + 1] = commit
      end
    end

    return visit
  end

  local visit = create_visitor()

  for _, h in ipairs(hashes) do
    visit(commits[h])
  end

  ---@type I.Row[]
  local graph = {}

  ---@type I.Row[]
  local graph_1 = {}

  ---@type I.Row[]
  local graph_2 = {}

  local debug_intervals = {}

  ---@param sorted_commits I.Commit[]
  local function straight_j(sorted_commits)
    ---@param cells I.Cell[]
    ---@return I.Cell[]
    local function propagate(cells)
      local new_cells = {}
      for _, cell in ipairs(graph[#graph].cells) do
        if cell.connector then
          new_cells[#new_cells + 1] = { connector = ' ' }
        else
          assert(cell.commit)
          new_cells[#new_cells + 1] = { commit = cell.commit }
        end
      end
      return new_cells
    end

    ---@param cells I.Cell[]
    ---@param hash string
    ---@param start integer?
    ---@return integer?
    local function find(cells, hash, start)
      local start = start or 1
      for idx = start, #cells do
        -- for idx, c in ipairs(cells) do
        local c = cells[idx]
        if c.commit and c.commit.hash == hash then
          return idx
        end
      end
      return nil
    end

    ---@param cells I.Cell[]
    ---@param start integer?
    ---@return integer
    local function next_vacant_j(cells, start)
      local start = start or 1
      for i = start, #cells, 2 do
        local cell = cells[i]
        if cell.connector == ' ' then
          return i
        end
      end
      return #cells + 1
    end

    for i, c in ipairs(sorted_commits) do
      ---@type I.Cell[]
      local rowc = {}

      ---@type integer?
      local j = nil

      do
        --
        -- commit row
        --
        if #graph > 0 then
          rowc = propagate(graph[#graph].cells)
          j = find(graph[#graph].cells, c.hash)
        end

        -- if reserved location use it
        if j then
          c.j = j
          rowc[j] = { commit = c, is_commit = true }

          -- clear any supurfluous reservations
          for k = j + 1, #rowc do
            local v = rowc[k]
            if v.commit and v.commit.hash == c.hash then
              rowc[k] = { connector = ' ' }
            end
          end
        else
          j = next_vacant_j(rowc)
          c.j = j
          rowc[j] = { commit = c, is_commit = true }
          rowc[j + 1] = { connector = ' ' }
        end

        graph[#graph + 1] = { cells = rowc, commit = c }
      end

      do
        -- connector row (reservation row)
        --
        -- first we propagate
        local rowc = propagate(graph[#graph].cells)

        local num_active = 0
        for _, cell in ipairs(rowc) do
          if cell.commit then
            num_active = num_active + 1
          end
        end

        if num_active > 1 or #c.parents > 0 then
          --
          -- connector row
          --
          -- at this point we should have a valid position for our commit (we have 'inserted' it)
          assert(j)
          local our_loc = j

          -- now we proceed to add the parents of the commit we just added
          --

          if #c.parents > 0 then
            ---@param rem_parents string[]
            local function reserve_remainder(rem_parents)
              --
              -- reserve the rest of the parents in slots to the right of us
              --
              -- ... another alternative is to reserve rest of the parents of c if they have not already been reserved
              -- for i = 2, #c.parents do
              for _, h in ipairs(rem_parents) do
                local j = find(graph[#graph].cells, h, our_loc)
                if not j then
                  local j = next_vacant_j(rowc, our_loc)
                  rowc[j] = { commit = commits[h], emphasis = true }
                  rowc[j + 1] = { connector = ' ' }
                else
                  rowc[j].emphasis = true
                end
              end
            end

            -- we start by peeking at next commit and seeing if it is one of our parents
            -- we only do this if one of our propagating branches is already destined for this commit

            local next_commit = sorted_commits[i + 1]
            ---@type I.Cell?
            local tracker = nil
            if next_commit then
              for _, cell in ipairs(rowc) do
                if cell.commit and cell.commit.hash == next_commit.hash then
                  tracker = cell
                  break
                end
              end
            end

            local next_p_idx = nil -- default to picking first parent
            if tracker and next_commit then
              -- this loop updates next_p_idx to the next commit if they are identical
              for k, h in ipairs(c.parents) do
                if h == next_commit.hash then
                  next_p_idx = k
                  break
                end
              end
            end

            -- add parents
            if next_p_idx then
              assert(tracker)
              -- if next commit is our parent then we do some complex logic
              if #c.parents == 1 then
                -- simply place parent at our location
                rowc[our_loc].commit = commits[c.parents[1]]
                rowc[our_loc].emphasis = true
              else
                -- void the cell at our location (will be replaced by our parents in a moment)
                rowc[our_loc] = { connector = ' ' }

                -- put emphasis on tracker for the special parent
                tracker.emphasis = true

                -- only reserve parents that are different from next commit
                ---@type string[]
                local rem_parents = {}
                for k, h in ipairs(c.parents) do
                  if k ~= next_p_idx then
                    rem_parents[#rem_parents + 1] = h
                  end
                end

                assert(#rem_parents == #c.parents - 1, 'unexpected amount of rem parents')
                reserve_remainder(rem_parents)
              end
            else
              -- simply add first parent at our location and then reserve the rest
              rowc[our_loc].commit = commits[c.parents[1]]
              rowc[our_loc].emphasis = true

              local rem_parents = {}
              for k = 2, #c.parents do
                rem_parents[#rem_parents + 1] = c.parents[k]
              end

              reserve_remainder(rem_parents)
            end

            graph[#graph + 1] = { cells = rowc }
          else
            graph[#graph + 1] = { cells = { { connector = ' ' }, { connector = ' ' } } }
          end
        end
      end
    end
  end

  straight_j(sorted_commits)

  ---@param graph_1 I.Row[]
  ---@param graph_2 I.Row[]?
  ---@return string[]
  local function graph_to_lines(graph_1, graph_2)
    if graph_1 and graph_2 then
      print 'we have both graphs'
    end

    ---@type string[]
    local lines = {}

    local function char_generator()
      local alphabet = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W' }
      local ctr = 1
      return function()
        local char = alphabet[(ctr % #alphabet) + 1]
        ctr = ctr + 1
        return char
      end
    end

    local next_char = char_generator()

    ---@param cell I.Cell
    ---@return string
    local function commit_cell_symb(cell)
      assert(cell.is_commit)
      if #cell.commit.parents > 1 then
        -- merge commit
        return #cell.commit.children == 0 and GMCME or GMCM
      else
        -- regular commit
        return #cell.commit.children == 0 and GRCME or GRCM
      end
    end

    ---@param row I.Row
    ---@return string
    local function row_to_str(row)
      local row_str = ''
      for i = 1, #row.cells do
        local cell = row.cells[i]
        if cell.connector then
          row_str = row_str .. cell.connector
        else
          assert(cell.commit)
          row_str = row_str .. commit_cell_symb(cell)
        end
      end
      return row_str
    end

    ---@param row I.Row
    ---@return string
    local function row_to_debg(row)
      local row_str = ''

      for i = 1, #row.cells do
        local cell = row.cells[i]
        if cell.connector then
          row_str = row_str .. cell.connector
        else
          assert(cell.commit)
          local symbol = cell.commit.msg
          row_str = row_str .. symbol
        end
      end

      return row_str
    end

    for idx = 1, #graph_1 do
      local row_1 = graph_1[idx]
      local row_2 = graph_2 and graph_2[idx]

      local row_str = ''

      -- part 1
      row_str = row_str .. ((row_1 and row_2) and row_to_debg(row_1) or row_to_str(row_1))

      -- part 2
      if row_2 then
        row_str = row_str .. (' '):rep(15 - #row_1.cells)
        row_str = row_str .. row_to_str(row_2)
      end

      local c = row_1.commit
      if c then
        local h = c.hash:sub(1, 7)
        local ah = c.author_date
        row_str = row_str .. (' '):rep(15 - #row_1.cells) .. h .. ' [' .. ah .. '] ' .. c.msg
      else
        local parents = ''
        for _, h in ipairs(graph[idx - 1].commit.parents) do
          local p = commits[h]
          parents = parents .. ' ' .. p.msg
        end
        row_str = row_str .. (' '):rep(15 - #row_1.cells) .. '-> ' .. parents
      end

      lines[#lines + 1] = row_str
    end

    return lines
  end

  -- if true then
  --   return graph_to_lines(graph)
  -- end

  -- print '---- stage 1 ---'
  -- show_graph(graph)
  -- print '----------------'

  -- store stage 1 graph
  graph_1 = vim.deepcopy(graph)
  --

  -- inserts vertical and horizontal pipes
  for i = 2, #graph - 1 do
    local row = graph[i]

    ---@param cells I.Cell[]
    local function count_live(cells)
      local n = 0
      for _, r in ipairs(cells) do
        if r.commit or r.connector == GVER then
          n = n + 1
        end
      end
      return n
    end

    ---@param cells I.Cell[]
    local function count_emph(cells)
      local n = 0
      for _, c in ipairs(cells) do
        if c.commit and c.emphasis then
          n = n + 1
        end
      end
      return n
    end

    local num_emphasized = count_emph(graph[i].cells)

    -- vertical connections
    for j = 1, #row.cells do
      local this = graph[i].cells[j]
      local below = graph[i + 1].cells[j]

      ---@param c I.Cell?
      ---@return string?
      local function hash(c)
        return c and c.commit and c.commit.hash
      end

      local tch, bch = hash(this), hash(below)

      if not this.is_commit and not this.connector then
        -- local ch = row.commit and row.commit.hash
        -- local row_commit_is_child = ch and vim.tbl_contains(this.commit.children, ch)
        -- local trivial_continuation = (not row_commit_is_child) and (new_columns < 1 or ach == tch or acc == GVER)
        -- local trivial_continuation = (new_columns < 1 or ach == tch or acc == GVER)
        local ignore_this = (num_emphasized > 1 and (this.emphasis or false))

        if not ignore_this and bch == tch then -- and trivial_continuation then
          local has_repeats = false
          local first_repeat = nil
          for k = 1, #row.cells, 2 do
            local cell_k, cell_j = row.cells[k], row.cells[j]
            local rkc, rjc = (not cell_k.connector and cell_k.commit), (not cell_j.connector and cell_j.commit)

            -- local rkc, rjc = row.cells[k].commit, row.cells[j].commit

            if k ~= j and (rkc and rjc) and rkc.hash == rjc.hash then
              has_repeats = true
              first_repeat = k
              break
            end
          end

          if not has_repeats then
            local cell = graph[i].cells[j]
            cell.connector = GVER
          else
            local k = first_repeat
            local this_k = graph[i].cells[k]
            local below_k = graph[i + 1].cells[k]

            local bkc, tkc = (not below_k.connector and below_k.commit), (not this_k.connector and this_k.commit)

            -- local bkc, tkc = below_k.commit, this_k.commit
            if (bkc and tkc) and bkc.hash == tkc.hash then
              local cell = graph[i].cells[j]
              cell.connector = GVER
            end
          end
        end
      end
    end

    -- horizontal connections
    --
    -- a stopped connector is one that has a void cell below it
    --
    local stopped = {}
    for j = 1, #row.cells do
      local this = graph[i].cells[j]
      local below = graph[i + 1].cells[j]
      if not this.connector and below.connector == ' ' then
        assert(this.commit)
        stopped[#stopped + 1] = j
      end
    end
    -- now lets get the intervals between the stopped connetors
    -- and other connectors of the same commit hash
    local intervals = {}
    local curr = 1
    for _, j in ipairs(stopped) do
      for k = curr, j do
        local cell_k, cell_j = row.cells[k], row.cells[j]
        local rkc, rjc = (not cell_k.connector and cell_k.commit), (not cell_j.connector and cell_j.commit)
        if (rkc and rjc) and (rkc.hash == rjc.hash) then
          if j > k then
            intervals[#intervals + 1] = { start = k, stop = j }
          end
          curr = j
          break
        end
      end
    end

    -- add intervals for the connectors of merge children
    -- these are where we have multiple connector commit hashes
    -- for a single merge child, that is, more than one connector
    --
    -- TODO: this method presented here is probably universal and covers
    --       also for the previously computed intervals ... two birds one stone?
    do
      local low = #row.cells
      local high = 1
      for j = 1, #row.cells do
        local c = row.cells[j]
        if not c.connector and c.commit then
          if j > high then
            high = j
          end
          if j < low then
            low = j
          end
        end
      end

      if high > low then
        intervals[#intervals + 1] = { start = low, stop = high }
      end
    end

    for _, interval in ipairs(intervals) do
      local a, b = interval.start, interval.stop
      for j = a + 1, b - 1 do
        local this = graph[i].cells[j]
        if this.connector == ' ' then
          this.connector = GHOR
        end
      end
    end

    debug_intervals[#debug_intervals + 1] = intervals
  end

  -- print '---- stage 2 -------'

  -- insert symbols on connector rows
  --
  -- note that there are 8 possible connections
  -- under the assumption that any connector cell
  -- has at least 2 neighbors but no more than 3
  --
  -- there are 4 ways to make the connections of three neighbors
  -- there are 6 ways to make the connections of two neighbors
  -- however two of them are the vertical and horizontal connections
  -- that have already been taken care of
  --
  for i = 1, #graph do
    -- we assert that our cells know associated commits when
    -- appropriate
    local cells = graph[i].cells
    for _, cell in ipairs(cells) do
      local con = cell.connector
      if con ~= ' ' and con ~= GHOR then
        assert(cell.commit, 'expected commit')
      end
    end
  end

  for i = 2, #graph, 2 do
    local row = graph[i]
    local above = graph[i - 1]
    local below = graph[i + 1]

    -- heuristic to check if this row contains a "crossing" of branches
    -- effectively, if this is a connector row, and the next commit being
    -- introduced on the row below us is repeated in our conector row
    -- with a gap in it, such as ABA, then we have a crossing
    ---@return boolean, 'l' | 'r' | nil
    local function get_is_crossing()
      if i % 2 == 1 then
        -- we're not  a connector row NOTE: 1 indexing of lua
        return false
      end

      local next_commit = graph[i + 1].commit
      assert(next_commit, 'expected a next commit')

      local locations = {}
      for loc, c in ipairs(row.cells) do
        if c.commit and c.commit.hash == next_commit.hash then
          locations[#locations + 1] = loc
        end
      end

      if #locations < 2 then
        return false, nil
      end

      -- get destination of "drain"
      -- helpful later when chosing what symbol to use
      local dest = 'l'
      local max_loc = locations[#locations]
      if max_loc < next_commit.j then
        dest = 'r'
      end

      -- search for something sandwiched between, so that would be B in ABA
      for k = 1, #locations - 1 do
        local start, stop = locations[k], locations[k + 1]
        for l = start + 1, stop - 1 do
          local cell = row.cells[l]
          if cell.commit and cell.commit.hash ~= next_commit.hash then
            return true, dest
          end
        end
      end

      return false, nil
    end

    local is_crossing, destination = get_is_crossing()

    for j = 1, #row.cells do
      local this = row.cells[j]

      if this.connector == GVER then
        -- because they are already taken care of
        goto continue
      end

      local lc = row.cells[j - 1]
      local rc = row.cells[j + 1]
      local uc = above and above.cells[j]
      local dc = below and below.cells[j]

      local l = lc and (lc.connector ~= ' ' or lc.commit) or false
      local r = rc and (rc.connector ~= ' ' or rc.commit) or false
      local u = uc and (uc.connector ~= ' ' or uc.commit) or false
      local d = dc and (dc.connector ~= ' ' or dc.commit) or false

      -- number of neighbors
      local nn = 0

      local symb_id = ''
      for _, b in ipairs { l, r, u, d } do
        if b then
          nn = nn + 1
          symb_id = symb_id .. '1'
        else
          symb_id = symb_id .. '0'
        end
      end

      local symbol = ({
        -- two neighbors (no straights)
        ['1010'] = GCLU,
        ['1001'] = GCLD,
        ['0110'] = GCRU,
        ['0101'] = GCRD,
        -- three neighbors
        ['1110'] = GLRU,
        ['1101'] = GLRD,
        ['1011'] = GLUD,
        ['0111'] = GRUD,
      })[symb_id] or '?'

      ---@type 'u' | 'd' |  nil -- placement of commit vertically if immediately above or below us
      local clv = nil
      local commit_dir_above = below.commit and below.commit.j == j
      local commit_dir_below = above.commit and above.commit.j == j
      if commit_dir_above and commit_dir_below then
        clv = #above.commit.parents > 1 and 'u' or 'd'
      elseif commit_dir_above then
        clv = 'd'
      elseif commit_dir_below then
        clv = 'u'
      end

      --[[ FIXME: the following is an example of a bug to render
      --          correctly the T junction bellow and right of 5f948ee at laiout-core repo
      --
      --          the fix involves using the `clh_above` parameter ... etc ... which
      --          is defined further down vvv
      --
⓸─⓷               ->  Merge branch 'dev' into staging Merge branch '846-whitelist-importable-svg-groups' into 'dev'
│ ⓮               4d653c3 [Tue, 4 Jul 2023 16:50:11 +0000] Merge branch '846-whitelist-importable-svg-groups' into 'dev'
│ ⓸─╮             ->  Merge branch '845-zones-shrink-from-a-single-edge-when-an-edge-is-passed' into 'dev' layout: whitelist importable SVG groups
│ │ ⓚ             8ce1ae9 [Tue, 4 Jul 2023 18:35:21 +0200] layout: whitelist importable SVG groups
│ │ │             ->  Merge branch '845-zones-shrink-from-a-single-edge-when-an-edge-is-passed' into 'dev'
⓮ │ │             5f948ee [Tue, 4 Jul 2023 16:26:14 +0200] Merge branch 'dev' into staging
⓸─┤ │             ->  Merge branch 'dev' into staging Merge branch '845-zones-shrink-from-a-single-edge-when-an-edge-is-passed' into 'dev'
│ │ │ ⓛ           b20cdf3 [Tue, 4 Jul 2023 16:03:59 +0200] layout: comment out all `MutationDirection`
│ │ │ │           ->  scenarios: turn off Growh, add EffectiveWidth
│ │ │ ⓚ           2daa986 [Tue, 4 Jul 2023 15:00:36 +0200] scenarios: turn off Growh, add EffectiveWidth
│ │ │ │           ->  layout: pass furniture preferences to mutations
│ │ │ ⓚ           669cbd7 [Tue, 4 Jul 2023 12:26:17 +0200] layout: pass furniture preferences to mutations
      --]]

      ---@type 'l' | 'r' | nil -- placement of commit horizontally, only relevant if this is a connector row and if the cell is not immediately above or below the commit
      local clh_above = nil
      local commit_above = above.commit and above.commit.j ~= j
      if commit_above then
        clh_above = above.commit.j < j and 'l' or 'r'
      end

      ---@type 'l' | 'r' | nil -- placement of commit horizontally, only relevant if this is a connector row and if the cell is not immediately above or below the commit
      local clh_below = nil
      local commit_below = below.commit and below.commit.j ~= j
      if commit_below then
        clh_below = below.commit.j < j and 'l' or 'r'
      end

      if clh_above and symbol == GLRD then
        if clh_above == 'l' then
          symbol = GLRDCL -- '<'
        elseif clh_above == 'r' then
          symbol = GLRDCR -- '>'
        end
      elseif clh_below and symbol == GLRU then
        if clh_below == 'l' then
          symbol = GLRUCL -- '<'
        elseif clh_below == 'r' then
          symbol = GLRUCR -- '>'
        end
      end

      if clv and symbol == GLUD then
        if clv == 'd' then
          symbol = GLUDCD
        elseif clv == 'u' then
          symbol = GLUDCU
        end
      elseif clv and symbol == GRUD then
        if clv == 'd' then
          symbol = GRUDCD
        elseif clv == 'u' then
          symbol = GRUDCU
        end
      end

      if nn == 4 then
        if is_crossing then
          if destination == 'l' then
            symbol = GLUD
          else
            symbol = GRUD
          end
        else
          symbol = GFORKU
        end
      end

      -- if is_crossing then
      --   symbol = '#'
      -- end

      if row.cells[j].commit then
        row.cells[j].connector = symbol
        -- row.cells[j] = { connector = symbol }
      end

      ::continue::
      --
    end
  end

  graph_2 = graph

  -- print '---- stage 3 ---'
  -- show_graph(graph)
  -- print '----------------'
  -- return graph_to_lines(graph_1, graph_2)
  return graph_to_lines(graph_2)
end

return gitgraph
