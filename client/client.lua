DecorRegister("WARV_TEAMID", 2)

-- Register the client event and trigger the callback function with data
RegisterNetEvent("WARV_TEAMSELECT")
AddEventHandler("WARV_TEAMSELECT", function(callback)
    local cb = ""
    
    callback(cb)
end)


-- Function to get a player's clothing components and hat prop
function GetPlayerClothingAndProp(player)
    local ped = GetPlayerPed(player)
    local components = {}
    for i = 0, 12 do -- Iterate through all possible clothing components
        local drawable = GetPedDrawableVariation(ped, i)
        local texture = GetPedTextureVariation(ped, i)
        local palette = GetPedPaletteVariation(ped, i)
        table.insert(components, {
            drawable = drawable,
            texture = texture,
            palette = palette
        })
    end

    local propIndex = GetPedPropIndex(ped, 0) -- 0 is the hat prop index
    local propDrawable = GetPedDrawableVariation(ped, propIndex)
    local propTexture = GetPedTextureVariation(ped, propIndex)

    return components, {
        drawable = propDrawable,
        texture = propTexture
    }
end

-- Function to apply clothing components and hat prop to a player
function ApplyPlayerClothingAndProp(player, data)
    local ped = GetPlayerPed(player)
    for i, component in ipairs(data.components) do
        SetPedComponentVariation(ped, i - 1, component.drawable, component.texture, component.palette)
    end

    local hatPropData = data.hatProp
    if not hatPropData or not hatPropData.drawable or not hatPropData.texture then
        error("Invalid hat prop data provided.")
    end

    SetPedPropIndex(ped, 0, hatPropData.drawable, hatPropData.texture, true)
end

-- Function to encode a player's clothing components and hat prop as a string
function EncodePlayerClothing(player)
    local components, hatProp = GetPlayerClothingAndProp(player)
    local encodedData = ""

    for i, component in ipairs(components) do
        encodedData = encodedData .. component.drawable .. "," .. component.texture .. "," .. component.palette .. ";"
    end

    encodedData = encodedData .. hatProp.drawable .. "," .. hatProp.texture

    return encodedData
end

-- Function to decode a string of encoded player clothing and hat prop data
function DecodePlayerClothing(player, encodedData)
    local components = {}
    local componentIndex = 0
    for componentData in encodedData:gmatch("([^;]+);") do
        local drawable, texture, palette = componentData:match("(%d+),(%d+),(%d+)")
        table.insert(components, {
            drawable = tonumber(drawable),
            texture = tonumber(texture),
            palette = tonumber(palette)
        })
        componentIndex = componentIndex + 1
    end

    local hatPropData = encodedData:match("%d+,%d+$")
    if not hatPropData then
        error("Invalid encoded data provided.")
    end
    local hatPropDrawable, hatPropTexture = hatPropData:match("(%d+),(%d+)")
    if not hatPropDrawable or not hatPropTexture then
        error("Invalid hat prop data provided.")
    end

    ApplyPlayerClothingAndProp(player, {
        components = components,
        hatProp = {
            drawable = tonumber(hatPropDrawable),
            texture = tonumber(hatPropTexture)
        }
    })
end
