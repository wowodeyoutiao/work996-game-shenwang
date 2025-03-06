EquipInitGift = {}

--天赋属性 自定义属性的起始保存位 7
local SAVE_POS_START = 7

--初始化装备的天赋属性，还会改变装备的显示名字
function EquipInitGift.InitEquipGiftAB(actor, equipitem)
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return false
    end

    --计算生成哪个属性
    local randnum = math.random(1, 10000)
    local cfgInitInfo = nil
    local currnum = 0
    for _, value in pairs(cfgEquipInitGift) do
        currnum = currnum + value.giftprop
        if currnum >= randnum then
            cfgInitInfo = value
            break
        end
    end
    if cfgInitInfo == nil then
        return false
    end
        
    --从属性池子中随机生成天赋属性
    local abTab = BF_GetRandomTab(cfgInitInfo.abilitypool_tab, -1);
    if abTab == nil then
        return false
    end
    
    local saveCurrPos = SAVE_POS_START
    local createABTab = {}
    local randValue = abTab.min
    if abTab.max > abTab.min then
        randValue = math.random(abTab.min, abTab.max)
    end
    local singleAB = {id=abTab.id, value=randValue, savepos=saveCurrPos, color=cfgInitInfo.extnamecolor, ispercentage=abTab.ispercentage}       
    createABTab[#createABTab+1] = singleAB
    BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_3, '[天赋属性]:'..cfgInitInfo.extname, cfgInitInfo.extnamecolor)    
    local srcitemname = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_SRCNAME)
    if srcitemname ~= '' then
        changeitemname(actor, -2, cfgInitInfo.extname..srcitemname, equipitem)
    end
    refreshitem(actor, equipitem)

    --如果是风属性，则记录装备的加速
    if cfgInitInfo.ID == 1 then
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_ATTACK_SPEEDUP_INITGIFT, randValue, equipitem)    
    end
    
    return true
end

return EquipInitGift