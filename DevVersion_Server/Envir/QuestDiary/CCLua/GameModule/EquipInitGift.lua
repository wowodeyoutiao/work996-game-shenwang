EquipInitGift = {}

--�츳���� �Զ������Ե���ʼ����λ 7
local SAVE_POS_START = 7

--��ʼ��װ�����츳���ԣ�����ı�װ������ʾ����
function EquipInitGift.InitEquipGiftAB(actor, equipitem)
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return false
    end

    --���������ĸ�����
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
        
    --�����Գ�������������츳����
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
    BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_3, '[�츳����]:'..cfgInitInfo.extname, cfgInitInfo.extnamecolor)    
    local srcitemname = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_SRCNAME)
    if srcitemname ~= '' then
        changeitemname(actor, -2, cfgInitInfo.extname..srcitemname, equipitem)
    end
    refreshitem(actor, equipitem)

    --����Ƿ����ԣ����¼װ���ļ���
    if cfgInitInfo.ID == 1 then
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_ATTACK_SPEEDUP_INITGIFT, randValue, equipitem)    
    end
    
    return true
end

return EquipInitGift