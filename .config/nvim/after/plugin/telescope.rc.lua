local telescope_ok, telescope = pcall(require, "telescope")
if (not telescope_ok) then
    return
end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            }
        }
    },
    extensions = {
        file_browser = {
            theme = "dropdown",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                -- your custom insert mode mappings
                ["i"] = {
                    ["<C-w>"] = function()
                        vim.cmd('normal vbd')
                    end
                },
                ["n"] = {
                    -- your custom normal mode mappings
                    ["N"] = fb_actions.create,
                    ["D"] = fb_actions.remove,
                    ["R"] = fb_actions.rename,
                    ["h"] = fb_actions.goto_parent_dir,
                    ["/"] = function()
                        vim.cmd('startinsert')
                    end
                }
            }
        }
    }
}

telescope.load_extension("file_browser")

vim.keymap.set('n', '<leader>?', builtin.oldfiles, {
    desc = '[?] Find recently opened files'
})
vim.keymap.set('n', '<leader><space>', builtin.buffers, {
    desc = '[ ] Find existing buffers'
})
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false
    })
end, {
    desc = '[/] Fuzzily search in current buffer]'
})

vim.keymap.set('n', '<leader>sf', builtin.find_files, {
    desc = '[S]earch [F]iles'
})
vim.keymap.set('n', '<leader>sgf', builtin.find_files, {
    desc = '[S]earch [G]it [F]iles'
})
vim.keymap.set('n', '<leader>sh', builtin.help_tags, {
    desc = '[S]earch [H]elp'
})
vim.keymap.set('n', '<leader>sw', builtin.grep_string, {
    desc = '[S]earch current [W]ord'
})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {
    desc = '[S]earch by [G]rep'
})
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {
    desc = '[S]earch [D]iagnostics'
})

-- Git
vim.keymap.set('n', '<leader>gs', builtin.git_status, {
    desc = '[G]it [S]tatus'
})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {
    desc = '[G]it [C]ommits'
})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {
    desc = '[G]it [B]ranches'
})

vim.keymap.set("n", "<leader>fb", function()
    telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        cwd = telescope_buffer_dir(),
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = "normal",
        layout_config = {
            height = 40
        }
    })
end, {
    desc = '[F]ile [B]rowser'
})
