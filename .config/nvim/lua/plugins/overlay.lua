return {
  -- backdrop
  -- https://github.com/nvim-telescope/telescope.nvim/issues/3020
  "stopdesign/overlay.nvim",
  dir = vim.fn.stdpath("config") .. "/lua/custom/",
  lazy = false,
  -- dev = { true },
  config = function()
    require("custom.overlay").setup({})

    -- Display OVERLAY under any Telescope window, remove on window close
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopePrompt",
      callback = function()
        require("custom.overlay").show()
      end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
      callback = function()
        if vim.bo.filetype == "TelescopePrompt" then
          require("custom.overlay").hide()
        end
      end,
    })
  end,
}
