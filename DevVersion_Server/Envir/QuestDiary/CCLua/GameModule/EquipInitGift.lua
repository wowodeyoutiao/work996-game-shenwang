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
    local showtext = '[天赋属性]:'..cfgInitInfo.extname  --'<IMG:res/private/cc_common/nature_icon_'..cfgInitInfo.ID..'.png>'
    BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_3, showtext, cfgInitInfo.extnamecolor)    
    local srcitemname = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_SRCNAME)
    if srcitemname ~= '' then
        changeitemname(actor, -2, cfgInitInfo.extname..srcitemname, equipitem)
    end
    refreshitem(actor, equipitem)

    --保存装备的天赋类型 天赋加成点数
    if cfgInitInfo.ID > 0 then
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_INITGIFT_TYPE, cfgInitInfo.ID, equipitem)        
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_ADDPOINT_INITGIFT, randValue, equipitem)    
    end
    
    return true
end

function EquipInitGift.GetInitGiftPic(gifttype, pictype)
    if (gifttype >= 1) and (gifttype <= 4) then
        return 'private/cc_common/nature_icon_'..gifttype..'.png'
    end
    return ''
end

function EquipInitGift.UpdateEquipposInitGiftIcon(actor, equippos)
    if BF_IsNullObj(actor) then
        return
    end
    if (equippos ~= CommonDefine.EQUIPPOS_NECKLACE) and (equippos ~= CommonDefine.EQUIPPOS_ARMRING_L) and
       (equippos ~= CommonDefine.EQUIPPOS_ARMRING_R) and (equippos ~= CommonDefine.EQUIPPOS_RING_L) and
       (equippos ~= CommonDefine.EQUIPPOS_RING_R) and (equippos ~= CommonDefine.EQUIPPOS_BELT) and
       (equippos ~= CommonDefine.EQUIPPOS_BOOTS) then
        return
    end

    local buttonid = 0    
    local gifttype = 0
    local picx = 0
    local picy = 0
    local equipitem = linkbodyitem(actor, equippos)
    if not BF_IsNullObj(equipitem) then
        gifttype = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_INITGIFT_TYPE, equipitem)
    end
    if equippos == CommonDefine.EQUIPPOS_NECKLACE then        
        picx = 280
        picy = 204
        buttonid = CommonDefine.ADD_BUTTON_ID_10
    elseif equippos == CommonDefine.EQUIPPOS_ARMRING_L then
        picx = 0
        picy = 324
        buttonid = CommonDefine.ADD_BUTTON_ID_11
    elseif equippos == CommonDefine.EQUIPPOS_ARMRING_R then
        picx = 280
        picy = 324
        buttonid = CommonDefine.ADD_BUTTON_ID_12
    elseif equippos == CommonDefine.EQUIPPOS_RING_L then
        picx = 0
        picy = 384
        buttonid = CommonDefine.ADD_BUTTON_ID_13
    elseif equippos == CommonDefine.EQUIPPOS_RING_R then
        picx = 280
        picy = 384
        buttonid = CommonDefine.ADD_BUTTON_ID_14
    elseif equippos == CommonDefine.EQUIPPOS_BELT then
        picx = 112
        picy = 444
        buttonid = CommonDefine.ADD_BUTTON_ID_15
    elseif equippos == CommonDefine.EQUIPPOS_BOOTS then
        picx = 172
        picy = 444
        buttonid = CommonDefine.ADD_BUTTON_ID_16
    end

    if buttonid > 0 then
        delbutton(actor, CommonDefine.WINDOWS_ID_EQUIPMENT, buttonid)
        if gifttype~=nil and gifttype > 0 then
            local buttonstr = '<Img|x='..picx..'|y='..picy..'|height=25|width=25|img=private/cc_common/nature_icon_'..gifttype..'.png>'
            addbutton(actor, CommonDefine.WINDOWS_ID_EQUIPMENT, buttonid, buttonstr)
        end
    end 
end

--更新玩家的风雨雷电的临时属性记录
function EquipInitGift.UpdateEquipGiftAbilityInfo(actor)
    if BF_IsNullObj(actor) then
        return
    end
    
    local giftabilitylist = {0, 0, 0, 0}
    for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
        local equipitem = linkbodyitem(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        if not BF_IsNullObj(equipitem) then
            local giftid = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_INITGIFT_TYPE, equipitem)
            if giftid~=nil and giftid > 0 and giftid <= #giftabilitylist then                
                local naddnum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_ADDPOINT_INITGIFT, equipitem)
                if naddnum ~= nil then 
                    giftabilitylist[giftid] = giftabilitylist[giftid] + naddnum
                end                    
            end
        end
    end

    setplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_1, giftabilitylist[1])
    setplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_2, giftabilitylist[2])
    setplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_3, giftabilitylist[3])
    setplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_4, giftabilitylist[4])    
end

return EquipInitGift