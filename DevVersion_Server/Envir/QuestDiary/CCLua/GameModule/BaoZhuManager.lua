BaoZhuManager = {}

local RecycleSettingPanelCfg = {
    {id=1, tip='白色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_WHITE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_1, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_1},
    {id=2, tip='绿色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GREEN, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_2, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_2},
    {id=3, tip='蓝色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_BLUE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_3, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_3},
    {id=4, tip='紫色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PURPLE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_4, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_4},
    {id=5, tip='粉色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PINK, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_5, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_5},
    {id=6, tip='橙色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GOLD, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_6, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_6},
}

local BAOZHU_ITEM_STDMODE = {100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111}

local function GetRecycleCfg(id)
    for _, value in ipairs(RecycleSettingPanelCfg) do
        if value.id == id then
            return value
        end
    end
    return nil
end

--是否为有效的强化装备位
function BaoZhuManager.IsValidRecycleID(id)
    if id == nil then
        return false
    end
    for _, value in ipairs(RecycleSettingPanelCfg) do
        if value.id == id then
            return true
        end
    end    
    return false
end

--快速穿戴灵玉
function BaoZhuManager.QuickTakeOn(actor)
    local takeonobjids = {}
	local item_num = getbaseinfo(actor, CommonDefine.INFO_HUMBAGITEMNUM)
    local baozhuStdmodeStart = BAOZHU_ITEM_STDMODE[1]
    local baozhuStdmodeEnd = BAOZHU_ITEM_STDMODE[#BAOZHU_ITEM_STDMODE]
   	for i=0, item_num-1 do
		local itemobj = getiteminfobyindex(actor, i)
		if not BF_IsNullObj(itemobj) then 
			local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
            local uniqueid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
            local cfgItemInfo = cfg_item[itemidx];
            if cfgItemInfo and (cfgItemInfo.StdMode>=baozhuStdmodeStart) and (cfgItemInfo.StdMode<=baozhuStdmodeEnd) then
                local equippos = (cfgItemInfo.StdMode - baozhuStdmodeStart) + CommonDefine.EQUIPPOS_SSH_1
                local equipobj = linkbodyitem(actor, equippos) 
                if BF_IsNullObj(equipobj) then
                    local rec = {pos=equippos, objid=uniqueid}
                    takeonobjids[#takeonobjids+1] = rec
                end
            end	
		end
   	end
 
    for _, value in ipairs(takeonobjids) do
        takeonitem(actor, value.pos, value.objid) 
    end       
end

--快速脱下灵玉
function BaoZhuManager.QuickTakeOff(actor)
    for i = CommonDefine.EQUIPPOS_SSH_1, CommonDefine.EQUIPPOS_SSH_12, 1 do
        local itemobj = linkbodyitem(actor, i)
        if not BF_IsNullObj(itemobj) then
            takeoffitem(actor, i)    
        end        
    end        
end

--返回回收宝珠的复选框和信息
function BaoZhuManager.GetRecycleCheckBoxInfo(actor, nStartX, nStartY)
    local msg = ''
    local srcStartY = nStartY
    for _, cfginfo in ipairs(RecycleSettingPanelCfg) do
        local flag = getflagstatus(actor, cfginfo.flagvar)
        local color = CSS.GetQualityColor(cfginfo.qualitylv)
        msg = msg..'<CheckBox|x='..nStartX..'|y='..nStartY..'|id='..cfginfo.id..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..
            cfginfo.tempvar..'|default='..flag..'|delay=0|count=1|link=@set_recycle_quality,'..cfginfo.id..'>'..
            '<Text|text=自动回收'..cfginfo.tip..'|x='..(nStartX+30)..'|y='..(nStartY+5)..'|color='..color..'>'            
        nStartY = nStartY + 25
    end    
    local keepflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
    msg = msg..'<CheckBox|x='..(nStartX+230)..'|y='..(srcStartY+50)..'|id=10|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..CommonDefine.VAR_N_NPC_CHECKBOX_10..
        '|default='..keepflag..'|delay=0|count=1|link=@set_keep_better>'..
        '<Text|text=保留比当前穿戴灵玉更好的|x='..(nStartX+260)..'|y='..(srcStartY+55)..'|color='..CSS.NPC_WHITE..'>'  
    return msg
end

--设置玩家回收宝珠的品质
function BaoZhuManager.SetRecycleQuality(actor, recycleid)
    if BF_IsNullObj(actor) or (recycleid==nil) then
        return
    end
    local cfg = GetRecycleCfg(recycleid)
    if cfg == nil then
        return
    end

    local tempvar = getplaydef(actor, cfg.tempvar)
    if (tempvar==1) or (tempvar==0) then
        setflagstatus(actor, cfg.flagvar, tempvar)
    end
end

--玩家获得道具时触发，自动回收宝珠
function BaoZhuManager.DoAutoRecycleBaoZhu(actor, itemobj)
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then 
        return
    end
    local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
    local cfgItem = cfg_item[itemidx]
    if cfgItem == nil then
        return
    end
    if (cfgItem.StdMode >= BAOZHU_ITEM_STDMODE[1]) and (cfgItem.StdMode <= BAOZHU_ITEM_STDMODE[#BAOZHU_ITEM_STDMODE]) then
        for _, recycleCfg in ipairs(RecycleSettingPanelCfg) do
            if recycleCfg.qualitylv == cfgItem.QualityLv then                
                local flag = getflagstatus(actor, recycleCfg.flagvar)                         
                if flag == 1 then                 
                    --选中自动回收当前品质宝珠
                    local keepbetterflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
                    if keepbetterflag == 1 then                                        
                        --选中保留比穿戴更好的宝珠
                        local equippos = (cfgItem.StdMode - BAOZHU_ITEM_STDMODE[1]) + CommonDefine.EQUIPPOS_SSH_1
                        local equipobj = linkbodyitem(actor, equippos) 
                        if BF_IsNullObj(equipobj) then
                            break
                        end
                        local currequipidx = getiteminfo(actor, equipobj, CommonDefine.ITEMINFO_ITEMIDX)
                        local cfgCurrEquip = cfg_item[currequipidx]
                        if (cfgCurrEquip == nil) or (cfgCurrEquip.QualityLv < cfgItem.QualityLv) then
                            break
                        end                       
                    end
                    --自动回收珠子，并返回1000金币，后面再完成其它回收相关配置
                    local makeindex = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
                    local itemcount = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
                    itemcount = math.max(1, itemcount)
                    delitembymakeindex(actor, makeindex, itemcount, 'autorecycle')
                    giveitem(actor, '金币', 1000 * itemcount)
                end
                break     
            end
        end
    end
end

--玩家登录时触发
function BaoZhuManager.OnPlayerEnterGame(actor)	
	--开启生肖宝盒的功能  这个后面可以调整到升级或其它地方触发
	setsndaitembox(actor, 1)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, BaoZhuManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_BAOZHU)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, BaoZhuManager.DoAutoRecycleBaoZhu, CommonDefine.FUNC_ID_BAOZHU)


--是否有快捷提示
function BaoZhuManager.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, false) then
        return false
    end

    --这里的功能还需要进一步处理！！！！！

    return false
end

return BaoZhuManager