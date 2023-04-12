local ok, fidget = pcall(require, "fidget")

if ok then
    fidget.setup()
else
    print("Module fidget not found")
end
