Item = {}

--检查idx是否是货币
function Item.isCurrency(idxOrName)
    local stdmode = getstditeminfo(idxOrName, CommonDefine.STDITEMINFO_STDMODE)
    return stdmode == 41
end

function Item.GetItemQualityLvByID(itemid)
    local qualitylv = CommonDefine.ITEM_QUALITY_WHITE
    if itemid == nil then
        return qualitylv
    end
    local cfgInfo = cfg_equip[itemid]
    if cfgInfo == nil then
        cfgInfo = cfg_item[itemid]
    end
    if cfgInfo == nil then
        return qualitylv
    end    
    if cfgInfo.QualityLv == nil then
        return qualitylv
    else
        qualitylv = cfgInfo.QualityLv
    end
    return qualitylv
end

--返回道具的品质
function Item.GetItemQualityLv(actor, equipitem)
    local qualitylv = CommonDefine.ITEM_QUALITY_WHITE
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return qualitylv
    end
    local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
    return Item.GetItemQualityLvByID(itemid)
end

--返回道具的品质颜色id
function Item.GetItemQualityColor(actor, equipitem)
    local qualitylv = Item.GetItemQualityLv(actor, equipitem)  
    return CSS.GetQualityColor(qualitylv)
end

--返回道具对应的特效，根据功能不同而区分
function Item.GetUIShowEffect(itemid, functionid)
    local effectid = 0
    if (itemid == nil) or (functionid == nil) then
        return effectid
    end

    local qualitylv = Item.GetItemQualityLvByID(itemid)
    if functionid == CommonDefine.FUNC_ID_COMPOSE then
        --先判断装备的天赋属性

        if qualitylv == CommonDefine.ITEM_QUALITY_PINK then
            return 15009
        elseif qualitylv == CommonDefine.ITEM_QUALITY_GOLD then
            return 15010
        elseif qualitylv == CommonDefine.ITEM_QUALITY_RED then
            return 15011
        end
    elseif (functionid == CommonDefine.FUNC_ID_SOUL_STONE) or (functionid == CommonDefine.FUNC_ID_BAOZHU) then
        if qualitylv == CommonDefine.ITEM_QUALITY_GREEN then
            return 15018
        elseif qualitylv == CommonDefine.ITEM_QUALITY_BLUE then
            return 15019
        elseif qualitylv == CommonDefine.ITEM_QUALITY_PURPLE then
            return 15020
        elseif qualitylv == CommonDefine.ITEM_QUALITY_PINK then
            return 15022
        elseif qualitylv == CommonDefine.ITEM_QUALITY_GOLD then
            return 15024
        elseif qualitylv == CommonDefine.ITEM_QUALITY_RED then
            return 15025
        end
    else
        if qualitylv == CommonDefine.ITEM_QUALITY_PURPLE then
            return 15061
        elseif qualitylv == CommonDefine.ITEM_QUALITY_PINK then
            return 15062
        elseif qualitylv == CommonDefine.ITEM_QUALITY_GOLD then
            return 15067
        elseif qualitylv == CommonDefine.ITEM_QUALITY_RED then
            return 15063
        end
    end
    
    return effectid
end

--当前神王版本使用
function Item.IsEquipment(stdmode)
    if (stdmode == CommonDefine.ITEM_STDMODE_WEAPON) or (stdmode == CommonDefine.ITEM_STDMODE_DRESS) or (stdmode == CommonDefine.ITEM_STDMODE_HELMET) or 
       (stdmode == CommonDefine.ITEM_STDMODE_NECKLACE) or (stdmode == CommonDefine.ITEM_STDMODE_RING) or (stdmode == CommonDefine.ITEM_STDMODE_ARMRING) or 
       (stdmode == CommonDefine.ITEM_STDMODE_BOOTS) or (stdmode == CommonDefine.ITEM_STDMODE_BELT) then
        return true
    else
        return false
    end
end

function Item.GetEquipposByStdmode(stdmode)
    if stdmode == CommonDefine.ITEM_STDMODE_WEAPON then
        return CommonDefine.EQUIPPOS_WEAPON, -1
    elseif stdmode == CommonDefine.ITEM_STDMODE_DRESS then
        return CommonDefine.EQUIPPOS_DRESS, -1
    elseif stdmode == CommonDefine.ITEM_STDMODE_HELMET then
        return CommonDefine.EQUIPPOS_HELMET, -1
    elseif stdmode == CommonDefine.ITEM_STDMODE_NECKLACE then
        return CommonDefine.EQUIPPOS_NECKLACE, -1
    elseif stdmode == CommonDefine.ITEM_STDMODE_RING then
        return CommonDefine.EQUIPPOS_RING_L, CommonDefine.EQUIPPOS_RING_R
    elseif stdmode == CommonDefine.ITEM_STDMODE_ARMRING then
        return CommonDefine.EQUIPPOS_ARMRING_L, CommonDefine.EQUIPPOS_ARMRING_R
    elseif stdmode == CommonDefine.ITEM_STDMODE_BOOTS then
        return CommonDefine.EQUIPPOS_BOOTS, -1
    elseif stdmode == CommonDefine.ITEM_STDMODE_BELT then
        return CommonDefine.EQUIPPOS_BELT, -1
    end
    return -1, -1
end

--返回装备的战斗力
function Item.CalCombatScore(itemobj)
    if BF_IsNullObj(itemobj) then
        return 0
    end

    ---------------------------??????针对装备的完整属性，进行战力的计算-----------------------
    ---------------------------??????针对装备的完整属性，进行战力的计算-----------------------
    ---------------------------??????针对装备的完整属性，进行战力的计算-----------------------
    ------------------------------??????针对装备的完整属性，进行战力的计算-----------------------
    ------------------------------??????针对装备的完整属性，进行战力的计算-----------------------??????????

end

local function DoCompareTwoEquipItem(actor, equipitem1, equipitem2)
    if BF_IsNullObj(equipitem1) then
        return 0
    end
    if BF_IsNullObj(equipitem2) then
        return 1
    end
    local itemid1 = getiteminfo(actor, equipitem1, CommonDefine.ITEMINFO_ITEMIDX)
    local itemid2 = getiteminfo(actor, equipitem2, CommonDefine.ITEMINFO_ITEMIDX)
    local cfgEquip1 = cfg_equip[itemid1]
    local cfgEquip2 = cfg_equip[itemid2]
    if (cfgEquip1==nil) or (cfgEquip2==nil) then
        return 0
    end
    if cfgEquip1.NeedLevel > cfgEquip2.NeedLevel then
        return 1
    elseif cfgEquip1.NeedLevel < cfgEquip2.NeedLevel then
        return -1
    else
        if cfgEquip1.QualityLv > cfgEquip2.QualityLv then
            return 1
        elseif cfgEquip1.QualityLv < cfgEquip2.QualityLv then
            return -1
        end
    end
    return 0
end

--比较背包中的装备和对应装备位上装备哪个更好   1表示背包好 -1表示装备位好 0表示无合适比对
function Item.CompareBagItemToEquipment(actor, bagitem)

    if BF_IsNullObj(actor) or BF_IsNullObj(bagitem) then
        return 0, -1
    end

    local itemid = getiteminfo(actor, bagitem, CommonDefine.ITEMINFO_ITEMIDX)
    local stdmode = getstditeminfo(itemid, CommonDefine.STDITEMINFO_STDMODE)
    if not Item.IsEquipment(stdmode) then
        return 0, -1
    end

    local equippos1, equippos2 = Item.GetEquipposByStdmode(stdmode)
    if (equippos1 == -1) and (equippos2 == -1) then
        return 0, -1
    end
  
    local equipitem1 = linkbodyitem(actor, equippos1)
    local flag1 = DoCompareTwoEquipItem(actor, bagitem, equipitem1)
    if (flag1 == 1) or (equippos2 == -1) then
        return flag1, equippos1
    end  

    local flag2 = 0
    local equipitem2 = linkbodyitem(actor, equippos2)
    flag2 = DoCompareTwoEquipItem(actor, bagitem, equipitem2)
    return flag2, equippos2
end

--[[
--检查idx是否是物品
function Item.isItem(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return not ConstCfg.stdmodewheremap[stdmode]
end

--检查idx是否是装备
function Item.isEquip(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    if stdmode == 41 then return end
    return ConstCfg.stdmodewheremap[stdmode]
end

--获取where通过idx
function Item.getWheresByIdx(idx)
    local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)
    return ConstCfg.stdmodewheremap[stdmode]
end

--获取idx通过where
function Item.getIdxByWhere(actor, where)
    local equipobj = linkbodyitem(actor, where)
    if equipobj == "0" then return end
    return getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
end

--获取物品名字通过idx
function Item.getNameByIdx(idx)
    if idx == ConstCfg.money.bdjade then
        return "玉币"
    end
    return getstditeminfo(idx, ConstCfg.stditeminfo.name)
end

]]--

return Item