EquipPosStrengthManager = {}

--functionid
local EQUIPPOS_STRENGTH_BUTTONFUNC_ID_1 = 1           --切换强化的装备位
local EQUIPPOS_STRENGTH_BUTTONFUNC_ID_2 = 2           --强化一次
local EQUIPPOS_STRENGTH_BUTTONFUNC_ID_3 = 3           --强化十次

--是否为有效的强化装备位
function EquipPosStrengthManager.IsValidEquipPosForStrength(pos, postype)
    if pos == nil then
        return false
    end

    if postype == nil then
        for _, value in pairs(CommonDefine.BASE_EQUIPMENT_POS) do
            if value == pos then
                return true
            end
        end
        if (pos >= CommonDefine.EQUIPPOS_SSH_1) and (pos <= CommonDefine.EQUIPPOS_SSH_12) then
            return true
        end
    elseif postype == 1 then
        for _, value in pairs(CommonDefine.BASE_EQUIPMENT_POS) do
            if value == pos then
                return true
            end
        end        
    elseif postype == 2 then
        if (pos >= CommonDefine.EQUIPPOS_SSH_1) and (pos <= CommonDefine.EQUIPPOS_SSH_12) then
            return true
        end
    end
    return false
end

function EquipPosStrengthManager.GetStrengthCfgKey(job, pos, level)
    return job * 100000 + pos * 1000 + level
end

--更新指定装备位的装备设置强化等级及属性
function EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, pos)
	if (actor == nil) or (pos == nil) then
		return
	end		
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    if infoStr == '' then
		return        
    end
	if not EquipPosStrengthManager.IsValidEquipPosForStrength(pos) then
		return
	end
	local equipitem = linkbodyitem(actor, pos)
	if BF_IsNullObj(equipitem) then
		return
	end
	local infoTab = json2tbl(infoStr)
	if (infoTab == nil) or table.isempty(infoTab) then
		return
	end

	local sid = ''..pos
	local curPosLevel = 0
    if infoTab[sid] ~= nil then
        curPosLevel = infoTab[sid]
    end
    if curPosLevel <= 0 then
        return
    end

    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, pos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        return
    end	

	--增加自定义的强化属性
	local sGroupShowName = '['..CommonDefine.EQUIPPOS_NAME[pos]..'槽位强化]: +'..curPosLevel	
	BF_SetCustomEquipABGroup(actor, equipitem, cfgEquipPosStrength[cfgCurrKey].addprop_tab, CommonDefine.ITEM_CUSTOMEAB_GROUP_0, sGroupShowName, 252)

    refreshitem(actor, equipitem)
    recalcabilitys(actor)
end

--更新指定装备位的装备星级及属性
function EquipPosStrengthManager.UpdateEquipStarLvInPos(actor, pos)
	if (actor == nil) or (pos == nil) then
		return
	end		
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    if infoStr == '' then
		return        
    end
	if not EquipPosStrengthManager.IsValidEquipPosForUpgradeStar(pos) then
		return
	end
	local equipitem = linkbodyitem(actor, pos)
	if equipitem == '0' then
		return
	end
	local infoTab = json2tbl(infoStr)
	if (infoTab == nil) or table.isempty(infoTab) then
		return
	end

	local sid = ''..pos
	local curPosLevel = 0
    if infoTab[sid] ~= nil then
        curPosLevel = infoTab[sid]
    end
    if curPosLevel <= 0 then
        return
    end

    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetUpgradeStarCfgKey(bJob, pos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        return
    end

	--增加自定义的星级和扩展属性
    local sGroupShowName = '['..CommonDefine.EQUIPPOS_NAME[pos]..'槽位星级]: +'..curPosLevel	
	BF_SetCustomEquipABGroup(actor, equipitem, cfgEquipPosStrength[cfgCurrKey].addprop_tab, CommonDefine.ITEM_CUSTOMEAB_GROUP_1, sGroupShowName, 253)
    setitemaddvalue(actor, equipitem, 2, 3, curPosLevel);
    
    --计算星级的加成属性对于对应装备位上装备【基础属性+强化属性】的百分比强化的实际加成属性点
    local strAddAbility = GetEquipPosStarAddAbilityStr(actor, pos, equipitem, cfgCurrKey)
    if strAddAbility ~= '' then
        local sGroupName = CommonDefine.EQUIPPOS_ADDAB_GROUP_NAME[pos]
        if (sGroupName ~= nil) and (sGroupName ~= '') then
            addattlist(actor, sGroupName,"=",strAddAbility)
        end                
    end

    refreshitem(actor, equipitem)
    recalcabilitys(actor)	
end

--返回玩家指定装备位对应的强化配置key
function EquipPosStrengthManager.GetPlayerCfgKey(actor, pos)
	if (actor == nil) or (pos == nil) then
		return -1
	end		
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    if infoStr == '' then
		return -1     
    end
	if not EquipPosStrengthManager.IsValidEquipPosForStrength(pos) then
		return -1
	end
	local infoTab = json2tbl(infoStr)
	if (infoTab == nil) or table.isempty(infoTab) then
		return -1
	end

	local sid = ''..pos
	local curPosLevel = 0
    if infoTab[sid] ~= nil then
        curPosLevel = infoTab[sid]
    end
    if curPosLevel <= 0 then
        return -1
    end

    local bJob = Player.GetJob(actor)
    return EquipPosStrengthManager.GetStrengthCfgKey(bJob, pos, curPosLevel)
end

--清空指定装备位上装备的强化等级及属性
function EquipPosStrengthManager.ClearEquipStrengthLvInPos(actor, equippos)
	if (actor == nil) or (equippos == nil) then
		return
	end

	local equipitem = linkbodyitem(actor, equippos)
	EquipPosStrengthManager.ClearEquipStrengthLv(actor, equipitem, equippos)
end

--清空指定装备的强化等级及属性
function EquipPosStrengthManager.ClearEquipStrengthLv(actor, equipitem, equippos)
	if (actor == nil) or (equipitem == nil) or (equipitem == '0') then
		return
	end

	--清除自定义的强化属性
	clearitemcustomabil(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_0)

	refreshitem(actor, equipitem)
	recalcabilitys(actor)
end

--返回全身装备位的最小强化等级，普通装备位
function EquipPosStrengthManager.GetAllCommonEquipPosMinLevel(actor)
	local minlv = 0
	if BF_IsNullObj(actor) then
		return 0
	end

    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    if infoStr == '' then
		return 0     
    end
	local infoTab = json2tbl(infoStr)
	if (infoTab == nil) or table.isempty(infoTab) then
		return 0
	end

	local minlv = 999
    for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
		local sid = ''..CommonDefine.BASE_EQUIPMENT_POS[i]
		local curPosLevel = 0
		if infoTab[sid] ~= nil then
			curPosLevel = infoTab[sid]
		end	
        if curPosLevel < minlv then
            minlv = curPosLevel
        end
    end
	if minlv == 999 then
		minlv = 0
	end
	return minlv
end


--显示规则面板
function EquipPosStrengthManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel#funcid='..CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel#funcid='..CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=装备强化规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、强化的属性会绑定在对应装备槽位上，穿戴装备后生效|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=2、放心更换装备，装备的更换不会影响已有的强化属性效果|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=3、强化的最高等级不能超过当前角色等级|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function GetSingleEquipPosShowInfo(actor, equippos)
    local sPanelStr = ''
    if (not BF_IsNullObj(actor)) then   
        local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)

        local infoTab = {}
        if infoStr ~= '' then
            infoTab = json2tbl(infoStr)
        end
        local sid = equippos..''
        if infoTab[sid] == nil then
            infoTab[sid] = 0
            infoStr = tbl2json(infoTab)
            setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
        end
        local curPosLevel = infoTab[sid]
        if curPosLevel < 0 then
            return sPanelStr
        end
        local nextPosLevel = curPosLevel + 1
        local bCurrIsMaxLv = false       
        local bJob = Player.GetJob(actor)
        local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
        if cfgEquipPosStrength[cfgCurrKey] == nil then
            release_print("GetSingleEquipPosShowInfo no config key:"..cfgCurrKey)
            return sPanelStr
        end
        local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
        if cfgEquipPosStrength[cfgNextKey] == nil then
            bCurrIsMaxLv = true
        end        
        
        sPanelStr = sPanelStr..'<Layout|id=15|children={101,102,120,140,160,500}|x=200.0|y=65.0|width=580|height=420>'..
            '<Img|id=101|x=-4.0|y=200.0|height=5|img=private/cc_common/pic_line_1.png>'..
            '<Img|id=102|x=-4.0|y=300.0|height=5|img=private/cc_common/pic_line_1.png>'

        --当前强化等级
        local startid = 120
        local idstr = startid..','..(startid+1)..','..(startid+2)..','..(startid+3)
        local tempLeftX = 40
        local tempLeftY = 20
        sPanelStr = sPanelStr..'<Text|id='..(startid+1)..'|text=当前等级：|size=20|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'..
                               '<Text|id='..(startid+2)..'|text='..curPosLevel..'级|size=20|x='..(tempLeftX+100)..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        tempLeftY = tempLeftY + 40
        sPanelStr = sPanelStr..'<Text|id='..(startid+3)..'|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'|size=18|text=属性加成：>'
        local currPropDescTable = cfgEquipPosStrength[cfgCurrKey].addprop_desctab
        for seq, descItem in ipairs(currPropDescTable) do
            local textid = startid + 10 + seq
            idstr = idstr..','..textid
            tempLeftY = tempLeftY + 30
            sPanelStr = sPanelStr..'<Text|id='..textid..'|text='..descItem.desc..'|size=18|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        end
        sPanelStr = sPanelStr..'<Layout|id='..startid..'|children={'..idstr..'}|x=30.0|y=0|width=240|height=180>'                    

        --下一强化等级
        startid = 140
        idstr =  startid..','..(startid+1)..','..(startid+2)..','..(startid+3)
        local tempRightX = 40
        local tempRightY = 20
        if bCurrIsMaxLv then
            sPanelStr = sPanelStr..'<Text|id='..(startid+1)..'|text=已达到等级上限|size=20|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
            tempRightY = tempRightY + 30
        else
            sPanelStr = sPanelStr..'<Text|id='..(startid+1)..'|text=下一等级：|size=20|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'..
                                   '<Text|id='..(startid+2)..'|text='..nextPosLevel..'级|size=20|x='..(tempRightX+100)..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            tempRightY = tempRightY + 40
            sPanelStr = sPanelStr..'<Text|id='..(startid+3)..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'|size=18|text=属性加成：>'         
            local nextPropDescTable =  cfgEquipPosStrength[cfgNextKey].addprop_desctab
            for seq, descItem in ipairs(nextPropDescTable) do
                local textid = startid + 10 + seq
                idstr = idstr..','..textid
                tempRightY = tempRightY + 30
                sPanelStr = sPanelStr..'<Text|id='..textid..'|size=18|text='..descItem.desc..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            end
        end
        sPanelStr = sPanelStr..'<Layout|id='..startid..'|children={'..idstr..'}|x=330.0|y=0|width=240|height=180>'       

        --消耗
        local tempX = 150
        local tempY = 30
        local currPlayerLv = Player.GetLevel(actor)
        sPanelStr = sPanelStr..'<Layout|id=160|children={161,162}|x=0|y=200.0|width=580|height=110>'
        if not bCurrIsMaxLv then            
            sPanelStr = sPanelStr..'<Text|id=161|text=等级限制：角色达到'..cfgEquipPosStrength[cfgCurrKey].needlv..'级/'..currPlayerLv..'级|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
            tempY = tempY + 30
            local sConsumeInfo = BF_GetItemTableDescStr(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab)
            sPanelStr = sPanelStr..'<Text|id=162|text=强化消耗：'..sConsumeInfo..'|size=20|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
        end

        --强化按钮
        idstr = '501,502'
        if bCurrIsMaxLv then
            sPanelStr = sPanelStr..'<Text|id=501|text=已达到最高强化等级！|x=200|y=30|color='..CSS.NPC_LIGHTGREEN..'>'
        else
            sPanelStr = sPanelStr..'<Button|id=501|x=120|y=10|text=强化一次|size=18|color='..CSS.NPC_WHITE..'|mimg=private/cc_equip_strength/3.png|nimg=private/cc_equip_strength/3.png|link=@function_button#funcid='..
                CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'#sid='..EQUIPPOS_STRENGTH_BUTTONFUNC_ID_2..'>'
            sPanelStr = sPanelStr..'<Button|id=502|x=350|y=10|text=强化十次|size=18|color='..CSS.NPC_WHITE..'|mimg=private/cc_equip_strength/3.png|nimg=private/cc_equip_strength/3.png|link=@function_button#funcid='..
                CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'#sid='..EQUIPPOS_STRENGTH_BUTTONFUNC_ID_3..'>'
        end
        sPanelStr = sPanelStr..'<Layout|id=500|children={'..idstr..'}|x=0|y=310.0|width=580|height=110>'
    end
    return sPanelStr
end

local function IsPosCanUpgradeOnce(actor, equippos, infoTab)
    local sid = ''..equippos    
    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return false
    end

    local nextPosLevel = curPosLevel + 1
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        return false
    end
    local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosStrength[cfgNextKey] == nil then        
        return false
    end

    --条件判断
    local currPlayerLv = Player.GetLevel(actor)
    if currPlayerLv < cfgEquipPosStrength[cfgCurrKey].needlv then
        return false
    end
    if not Player.CheckItemsEnough(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '') then
        return false
    end

    return true
end

--显示初始面板
function EquipPosStrengthManager.ShowBasePanel(actor)
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    local posTab = {}
    local bChanged = false
    for pos, posname in pairs(CommonDefine.EQUIPPOS_NAME) do
        if EquipPosStrengthManager.IsValidEquipPosForStrength(pos, 1) then
            local sid = pos..''
            if infoTab[sid] == nil then
                infoTab[sid] = 0
                bChanged = true
            end
            local tab = {pos=pos, name=posname, level=infoTab[sid]}
            posTab[#posTab + 1] = tab                                                
        end   
    end

    if bChanged == true then
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    end

    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16}|x=20.0|y=16.0|reset=1|img=private/cc_equip_strength/8.png|show=0|esc=1|move=0|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@cc_exit_specialui>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@cc_exit_specialui>'..
        '<Text|id=13|x=72.0|y=70.0|size=18|color=151|text=选择槽位>'..
        '<Button|id=16|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel#funcid='..CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'>'

    local idstr1 = ''
    for seq, _ in ipairs(posTab) do
        if idstr1 ~= '' then
            idstr1 = idstr1..','
        end
        idstr1 = idstr1..(30+seq)
    end
    strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..idstr1..'}|x=65.0|y=110.0|width=130|height=350|margin=0|direction=1>'
    local choosepos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)   

    for seq, value in ipairs(posTab) do
        local baseid = 30 + seq
        local textid1 = baseid * 10 + 1
        local textid2 = baseid * 10 + 2
        if choosepos == -1 then          
            choosepos = value.pos         
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, choosepos)
        end
        if choosepos == value.pos then
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..textid1..','..textid2..'}x=-6.0|y=0.0|img=private/cc_equip_strength/5.png|link=@function_button#funcid='..
                CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'#sid='..EQUIPPOS_STRENGTH_BUTTONFUNC_ID_1..'#param1='..value.pos..'>'
            strPanelInfo = strPanelInfo..'<Text|id='..textid1..'|x=20.0|y=5.0|size=18|color='..CSS.NPC_YELLOW..'|text='..value.name..'槽位>'
                ..'<Text|id='..textid2..'|x=50.0|y=25.0|size=18|color='..CSS.NPC_YELLOW..'|text='..value.level..'级>'
            --对应当前选中的装备槽位
            strPanelInfo = strPanelInfo..GetSingleEquipPosShowInfo(actor, value.pos)                
        else
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..textid1..','..textid2..'}x=-6.0|y=0.0|img=private/cc_equip_strength/6.png|link=@function_button#funcid='..
                CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH..'#sid='..EQUIPPOS_STRENGTH_BUTTONFUNC_ID_1..'#param1='..value.pos..'>'                
            strPanelInfo = strPanelInfo..'<Text|id='..textid1..'|x=20.0|y=5.0|size=18|color='..CSS.NPC_WHITE..'|text='..value.name..'槽位>'
                ..'<Text|id='..textid2..'|x=50.0|y=25.0|size=18|color='..CSS.NPC_WHITE..'|text='..value.level..'级>'
        end        
        if IsPosCanUpgradeOnce(actor, value.pos, infoTab) then
            Player.AddRedPoint(actor, 0, baseid, 10, 10)
        else
            Player.DelRedPoint(actor, 0, baseid)
        end
    end
    BF_ShowSpecialUI(actor, strPanelInfo)        
end

--装备位 强化一次
local function EquipPosStrengthUpgradeOnce(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStrengthManager.IsValidEquipPosForStrength(equippos) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end

    local nextPosLevel = curPosLevel + 1
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosStrength[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前强化等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    local currPlayerLv = Player.GetLevel(actor)
    if currPlayerLv < cfgEquipPosStrength[cfgCurrKey].needlv then
        Player.SendSelfMsg(actor, '强化所需角色等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    if not Player.CheckItemsEnough(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '强化') then
        return
    end

    --扣除消耗
    Player.TakeItems(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '装备强化')
    --升级
    infoTab[sid] = nextPosLevel;
    infoStr = tbl2json(infoTab)
    setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    Player.SendSelfMsg(actor, '强化成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)

    --更新当前装备位的强化状态
    EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, equippos)  
    
    --更新当前装备位的升星加成属性
    EquipPosStarManager.UpdateEquipStarLvInPos(actor, equippos)

    --[[
    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, 1)      
    ]]--
end

--装备位 升级十次
local function EquipPosStrengthUpgradeTenTimes(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStrengthManager.IsValidEquipPosForStrength(equippos) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end

    local bLevelChanged = false
    for i = 1, 10, 1 do
        local nextPosLevel = curPosLevel + 1
        local bJob = Player.GetJob(actor)        
        local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
        if cfgEquipPosStrength[cfgCurrKey] == nil then
            break
        end           
        local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)        
        if cfgEquipPosStrength[cfgNextKey] == nil then
            Player.SendSelfMsg(actor, '当前强化等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            break
        end     
        --条件判断
        local currPlayerLv = Player.GetLevel(actor)
        if currPlayerLv < cfgEquipPosStrength[cfgCurrKey].needlv then
            Player.SendSelfMsg(actor, '强化所需角色等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            break
        end
        if not Player.CheckItemsEnough(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '强化') then
            break
        end
    
        --扣除消耗
        Player.TakeItems(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '装备强化')        
        --升级
        infoTab[sid] = nextPosLevel
        curPosLevel = nextPosLevel
        bLevelChanged = true
    end

    if bLevelChanged then
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
        Player.SendSelfMsg(actor, '强化成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    
        --更新当前装备位的强化状态
        EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, equippos)  

        --更新当前装备位的升星加成属性
        EquipPosStarManager.UpdateEquipStarLvInPos(actor, equippos)  


        --[[
        --------------------------------------------------------------------
        -----------------------------------------------------------------------
        -----------------------------------------------------------------------todo        
        --每日必做计数        
        EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, 10)              
        ]]--
    end
end

--处理button回调
function EquipPosStrengthManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local param = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if BF_IsNumberStr(sparam) then
        param = tonumber(sparam)
    end

    if funcid == EQUIPPOS_STRENGTH_BUTTONFUNC_ID_1 then
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID,  param)
    elseif funcid == EQUIPPOS_STRENGTH_BUTTONFUNC_ID_2 then
        EquipPosStrengthUpgradeOnce(actor)
    elseif funcid == EQUIPPOS_STRENGTH_BUTTONFUNC_ID_3 then
        EquipPosStrengthUpgradeTenTimes(actor)
    end
    EquipPosStrengthManager.ShowBasePanel(actor)
end

--是否有快捷提示
function EquipPosStrengthManager.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, false) then
        return false
    end

    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    for pos, _ in pairs(CommonDefine.EQUIPPOS_NAME) do
        if EquipPosStrengthManager.IsValidEquipPosForStrength(pos, 1) then
            local sid = pos..''
            if infoTab[sid] ~= nil then
                if IsPosCanUpgradeOnce(actor, pos, infoTab) then
                    return true
                end
            end
        end   
    end

    return false
end

return EquipPosStrengthManager