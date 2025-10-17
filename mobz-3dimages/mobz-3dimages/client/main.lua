local rtStore = {}

local function debugPrint(...)
    if Config.Debug then print("[billboards]", ...) end
end

-- Simple clamp
local function clamp(x, a, b) return math.max(a, math.min(b, x)) end

-- Create runtime texture from URL
local function ensureTexture(item)
    if rtStore[item.id] then return rtStore[item.id] end

    local txd = CreateRuntimeTxd("txd_"..item.id)
    local dui = CreateDui(item.url, 512, 512)
    local handle = GetDuiHandle(dui)
    CreateRuntimeTextureFromDuiHandle(txd, "img_"..item.id, handle)

    rtStore[item.id] = { txd="txd_"..item.id, txn="img_"..item.id, dui=dui }
    debugPrint("Created texture for", item.id)
    return rtStore[item.id]
end

-- Bounce helper
local function applyBounce(pos, bounce)
    if not bounce or not bounce.enabled then return pos end
    local t = GetGameTimer() / 1000.0
    local offset = math.sin(t * (bounce.speed or 1.0) * math.pi*2) * (bounce.amplitude or 0.2)
    local axis = bounce.axis or 'z'
    if axis == 'x' then return pos + vec3(offset,0,0)
    elseif axis == 'y' then return pos + vec3(0,offset,0)
    else return pos + vec3(0,0,offset) end
end

-- Draw loop
CreateThread(function()
    while true do
        Wait(0)
        local cam = GetGameplayCamCoord()

        for _, item in ipairs(Config.Billboards) do
            local tex = ensureTexture(item)
            local pos = applyBounce(item.coords, item.bounce)
            local dist = #(pos - cam)
            if dist <= (item.drawDistance or 100.0) then
                SetDrawOrigin(pos.x, pos.y, pos.z, 0)
                DrawSprite(tex.txd, tex.txn, 0.0, 0.0, item.width/10.0, (item.height or item.width)/10.0, 0.0, 255,255,255,255)
                ClearDrawOrigin()
                if Config.Debug then
                    SetTextScale(0.3,0.3)
                    SetTextCentre(1)
                    SetTextFont(0)
                    BeginTextCommandDisplayText("STRING")
                    AddTextComponentSubstringPlayerName(item.id.." ("..math.floor(dist).."m)")
                    EndTextCommandDisplayText(0.5,0.5)
                end
            end
        end
    end
end)

-- Cleanup
AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        for _, tex in pairs(rtStore) do
            if tex.dui then DestroyDui(tex.dui) end
        end
    end
end)
