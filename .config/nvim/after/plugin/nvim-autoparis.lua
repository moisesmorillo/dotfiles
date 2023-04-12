local ok, autopairs = pcall(require, "nvim-autopairs")

if ok then
    autopairs.setup()
else
    print("Module nvim-autopairs not found")
end
