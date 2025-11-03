local inventoryModule = {}


function inventoryModule.HasItem(item, count)
    local fw = Modules["framework"]
    if fw then
        return fw.HasItem(item, count)
    end
    return false
end

Modules["inventory"] = inventoryModule


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("inventory", inventoryModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Inventory module loaded") end


exports('HasItem', function(item, count) return inventoryModule.HasItem(item, count) end)
