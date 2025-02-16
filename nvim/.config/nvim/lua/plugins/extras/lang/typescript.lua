---@type LazySpec[]
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npx jest --coverage --ci",
          env = { NODE_OPTIONS = "--experimental-vm-modules" },
        },
        ["neotest-vitest"] = {
          vitestCommand = "npx vitest --coverage --run",
          filter_dir = function(name, _, _)
            return name ~= "node_modules"
          end,
        },
      },
    },
  },
  {
    "danymat/neogen",
    opts = {
      languages = {
        typescript = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
      },
    },
  },
}
