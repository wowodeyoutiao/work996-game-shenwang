
CCBoxEquipItemCompare = {}

function CCBoxEquipItemCompare.ShowEquipCompare(sparam)
    if sparam ~= '' then
        local infoTab = SL:JsonDecode(sparam, false)
        if infoTab and type(infoTab) == "table" then
            local makeindex = infoTab.newitemmakeidx
            local data = SL:GetMetaValue("ITEM_DATA_BY_MAKEINDEX", makeindex)
            if not data then
                return
            end
            local showinfoTab = {itemData = data, pos = infoTab.pos, from = SL:GetMetaValue("ITEMFROMUI_ENUM").BAG, issuperbox = true}
            SL:OpenItemTips(showinfoTab)            
        end
    end
end

return CCBoxEquipItemCompare
