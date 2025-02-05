vim.g.zig_fmt_autosave = 0

vim.filetype.add({
  extension = {
    frag = "glsl",
    vert = "glsl"
  }
})

require('dap').configurations.zig = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = '${workspaceFolder}/zig-out/bin/project_inception',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
-- zig test -femit-bin=zig-out/bin/test src/dsa/sparse.zig
