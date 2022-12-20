local git_ok, git = pcall(require, "git")
if (not git_ok) then
    return
end

git.setup({
    keymaps = {
        -- Open blame window
        blame = "<Leader>gbl",
        -- Open file/folder in git repository
        browse = "<Leader>go"
    }
})
