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
  local git_cmd = [[git log --all --pretty='format:{{%s}} {{%aD}} {{%H}} {{%P}}']]
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
  ---@field commit I.Commit? -- a cell is either a commit or a connector
  ---@field connector string? -- see above
  ---@field children I.Cell[]? -- FIXME: might not need this? ... dont confuse this with child commits (subtly different)
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
    local iter = line:gmatch '{{([^{]+)}}'
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
      -- msg = 'A',
      -- author_date = author_date,
      author_date = 'temp',
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
      if not p then
        print('NO P for hash = ', h)
      end
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

  for _, h in ipairs(hashes) do
    visit(commits[h])
  end

  ---@type I.Row[]
  local graph = {}

  local debug_intervals = {}

  ---@param sorted_commits I.Commit[]
  local function curve_j(sorted_commits)
    ---@param cells I.Cell[]
    ---@return I.Cell[]
    local function propagate(cells)
      local new_cells = {}
      for _, cell in ipairs(graph[#graph].cells) do
        if cell.connector then
          new_cells[#new_cells + 1] = { connector = ' ' }
        else
          assert(cell.commit)
          new_cells[#new_cells + 1] = { commit = cell.commit, children = { cell } }
        end
      end
      return new_cells
    end

    ---@param cells I.Cell[]
    ---@param hash string
    ---@return integer?
    local function find(cells, hash)
      for idx, c in ipairs(cells) do
        if c.commit and c.commit.hash == hash then
          return idx
        end
      end
      return nil
    end

    ---@param cells I.Cell[]
    ---@return integer
    local function next_vacant_j(cells)
      for i = 1, #cells, 2 do
        local cell = cells[i]
        if cell.connector == ' ' then
          return i
        end
      end
      return #cells + 1
    end

    for _, c in ipairs(sorted_commits) do
      --
      do
        ---@type I.Cell[]
        local rowc = {}

        ---@type integer?
        local j = nil

        if #graph > 0 then
          rowc = propagate(graph[#graph].cells)
          j = find(graph[#graph].cells, c.hash)
        end

        -- if reserved location use it
        if j then
          -- use reserved location and maintain prev children from propagation step
          rowc[j].commit = c

          -- clear any supurfluous reservations
          for i = j + 1, #rowc do
            local v = rowc[i]
            if v.commit and v.commit.hash == c.hash then
              rowc[i] = { connector = ' ' }
            end
          end
        else
          j = next_vacant_j(rowc)
          -- add new reservation, NOTE that it has no children
          rowc[j] = { commit = c }
          rowc[j + 1] = { connector = ' ' }
        end

        graph[#graph + 1] = { cells = rowc, commit = c }

        -- at this point we should have a valid position for our commit (we have 'inserted' it)
        assert(j)

        -- now we proceed to add the parents of the commit we just added
        --
        -- first we propagate
        local rowc = propagate(graph[#graph].cells)

        if #c.parents > 0 then
          -- reserve the first parent at our location, and preserve its children
          rowc[j].commit = commits[c.parents[1]]
          rowc[j].emphasis = true

          -- reserve rest of the parents of c if they have not already been reserved
          for i = 2, #c.parents do
            local h = c.parents[i]

            local j_child = graph[#graph].cells[j]
            local j = find(graph[#graph].cells, h)

            if not j then
              local j = next_vacant_j(rowc)
              -- prev cell at j is the child
              rowc[j] = { commit = commits[h], emphasis = true, children = { j_child } }
              rowc[j + 1] = { connector = ' ' }
            else
              -- prev cell at j is +1 child
              rowc[j].children[#rowc[j].children + 1] = j_child
              rowc[j].emphasis = true
            end
          end
        end

        graph[#graph + 1] = { cells = rowc }
      end
    end
  end

  curve_j(sorted_commits)

  ---@param graph I.Row[]
  ---@return string[]
  local function graph_to_lines(graph)
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

    for idx, row in ipairs(graph) do
      local row_str = ''
      for _, c in ipairs(row.cells) do
        -- if not c.connector and not c.commit.debug then
        --   c.commit.debug = next_char()
        -- end

        -- if c.commit then
        --   c.commit.debug = c.commit.msg
        -- end

        if c.commit then
          local child_row = graph[idx - 1]
          local child_row_commit = child_row and child_row.commit
          local child_row_commit_cell = nil

          if child_row_commit then
            for _, cell in ipairs(child_row.cells) do
              if cell.commit and cell.commit.hash == child_row_commit.hash then
                child_row_commit_cell = cell
                break
              end
            end
          end

          -- if child_row_commit_cell and vim.tbl_contains(c.children, child_row_commit_cell) then
          if c.emphasis then
            row_str = row_str .. c.commit.msg:lower()
            -- row_str = row_str .. c.commit.msg
          else
            row_str = row_str .. c.commit.msg
          end
        else
          assert(c.connector)
          row_str = row_str .. c.connector
        end
      end

      local c = row.commit
      if c then
        local h = c.hash:sub(1, 7)
        local ah = c.author_date
        row_str = row_str .. (' '):rep(15 - #row.cells) .. h .. ' [' .. ah .. '] ' .. c.msg
      else
        -- since there may be some annoying trailing whitespace
        row_str = row_str:gsub('%s+$', '')
      end

      lines[#lines + 1] = row_str
    end

    return lines
  end

  ---@param graph I.Row[]
  local function show_graph(graph)
    for _, line in ipairs(graph_to_lines(graph)) do
      print(line)
    end
  end

  -- if true then
  --   return graph_to_lines(graph)
  -- end

  -- print '---- stage 1 ---'
  -- show_graph(graph)
  -- print '----------------'

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

    local new_columns = count_live(graph[i].cells) - count_live(graph[i - 1].cells)

    local num_emphasized = count_emph(graph[i].cells)

    -- vertical connections
    for j = 1, #row.cells do
      local above = graph[i - 1].cells[j]
      local this = graph[i].cells[j]
      local below = graph[i + 1].cells[j]

      ---@param c I.Cell?
      ---@return string?
      local function hash(c)
        return c and c.commit and c.commit.hash
      end

      ---@param c I.Cell?
      ---@return string?
      local function conn(c)
        return c and c.connector
      end

      local ach, tch, bch = hash(above), hash(this), hash(below)
      local acc = conn(above)

      if this.commit then
        -- local ch = row.commit and row.commit.hash
        -- local row_commit_is_child = ch and vim.tbl_contains(this.commit.children, ch)
        -- local trivial_continuation = (not row_commit_is_child) and (new_columns < 1 or ach == tch or acc == GVER)
        -- local trivial_continuation = (new_columns < 1 or ach == tch or acc == GVER)
        local ignore_this = (num_emphasized > 1 and this.emphasis)

        if not ignore_this and bch == tch then -- and trivial_continuation then
          local has_repeats = false
          local first_repeat = nil
          for k = 1, #row.cells, 2 do
            local rkc, rjc = row.cells[k].commit, row.cells[j].commit

            if k ~= j and (rkc and rjc) and rkc.hash == rjc.hash then
              has_repeats = true
              first_repeat = k
              break
            end
          end

          if not has_repeats then
            graph[i].cells[j] = { connector = GVER }
          else
            local k = first_repeat
            local this_k = graph[i].cells[k]
            local below_k = graph[i + 1].cells[k]
            local bkc, tkc = below_k.commit, this_k.commit
            if (bkc and tkc) and bkc.hash == tkc.hash then
              graph[i].cells[j] = { connector = GVER }
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
      if this.commit and not below.commit then
        stopped[#stopped + 1] = j
      end
    end
    -- now lets get the intervals between the stopped connetors
    -- and other connectors of the same commit hash
    local intervals = {}
    local curr = 1
    for _, j in ipairs(stopped) do
      for k = curr, j do
        local rkc, rjc = row.cells[k].commit, row.cells[j].commit
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
        if c.commit then
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
  for i = 2, #graph, 2 do
    local row = graph[i]
    local above = graph[i - 1]
    local below = graph[i + 1]
    for j = 1, #row.cells do
      local lc = row.cells[j - 1]
      local rc = row.cells[j + 1]
      local uc = above and above.cells[j]
      local dc = below and below.cells[j]

      local l = lc and (lc.connector ~= ' ' or lc.commit) or false
      local r = rc and (rc.connector ~= ' ' or rc.commit) or false
      local u = uc and (uc.connector ~= ' ' or uc.commit) or false
      local d = dc and (dc.connector ~= ' ' or dc.commit) or false

      local symb_id = ''
      for _, b in ipairs { l, r, u, d } do
        if b then
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

      if row.cells[j].commit then
        row.cells[j] = { connector = symbol }
      end
    end
  end

  -- print '---- stage 3 ---'
  -- show_graph(graph)
  -- print '----------------'
  return graph_to_lines(graph)
end

return gitgraph
