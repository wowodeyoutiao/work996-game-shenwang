EquipPosStarManager = {}

--functionid
local EQUIPPOS_STAR_BUTTONFUNC_ID_1 = 1           --切换升星的装备位
local EQUIPPOS_STAR_BUTTONFUNC_ID_2 = 2           --升星一次
local EQUIPPOS_STAR_BUTTONFUNC_ID_3 = 3           --自动升星
local EQUIPPOS_STAR_BUTTONFUNC_ID_4 = 4           --停止升星
--local EQUIPPOS_STAR_BUTTONFUNC_ID_5 = 5           --设置自动升星的目标星级
local EQUIPPOS_STAR_BUTTONFUNC_ID_6 = 6           --设置自动升星的目标星级 menu

local MAX_STAR_NUM = 15                           --最大升星数  

local SHOW_BAG_ITEMS = {'升星石', '金币'}

EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN = 4                --自动升星的最小目标
EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX = MAX_STAR_NUM     --自动升星的最大目标


local SELECT_AUTO_STAR_LIST = {
    {showstr='4星', targstar=4},
    {showstr='5星', targstar=5},
    {showstr='6星', targstar=6},
    {showstr='7星', targstar=7},
    {showstr='8星', targstar=8},
    {showstr='9星', targstar=9},
    {showstr='10星', targstar=10},
    {showstr='11星', targstar=11},
    {showstr='12星', targstar=12},
    {showstr='13星', targstar=13},
    {showstr='14星', targstar=14},
    {showstr='15星', targstar=15},    
}


--是否为有效的升星装备位
function EquipPosStarManager.IsValidEquipPosForUpgradeStar(pos)
    if pos == nil then
        return false
    end
	for _, value in pairs(CommonDefine.BASE_EQUIPMENT_POS) do
		if value == pos then
			return true
		end
	end    
    return false
end

function EquipPosStarManager.GetUpgradeStarCfgKey(job, pos, level)
    return job * 100000 + pos * 1000 + level
end

--返回槽位星级的加成属性字符串,  '#job#id#value|#job#id#value'
local function GetEquipPosStarAddAbilityStr(actor, pos, equipitem, cfgStarCurrKey)
    local strAddAbility = ''
    if (actor==nil) or (pos==nil) or (equipitem==nil) then
        return strAddAbility
    end
    --取装备的基础属性    
    local baseABTab = {}
    local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
    for i = CommonDefine.ABILITYID_MIN_DC, CommonDefine.ABILITYID_MAX_MAC, 1 do
        local abvalue = getstditematt(itemid, i)
        if abvalue > 0 then
            local skey = ''..i
            baseABTab[skey] = {id=i, value=abvalue}
        end
    end

    --取装备位的强化属性
    local finalABTab = {}
    local currStrengthKey = EquipPosStrengthManager.GetPlayerCfgKey(actor, pos)
    if currStrengthKey >= 0 then    
        if (cfgEquipPosStrength[currStrengthKey] ~= nil) and (cfgEquipPosStrength[currStrengthKey].addprop_tab ~= nil) then
            finalABTab = BF_MergeAbilityTables(baseABTab, cfgEquipPosStrength[currStrengthKey].addprop_tab)
        end
    end
    
    for _, abinfo in pairs(cfgEquipPosUpgradeStar[cfgStarCurrKey].addprop_tab) do
        local addPercentPairTab = CommonDefine.ADD_PERCENT_ABILITY_PAIR[abinfo.id]
        if (addPercentPairTab ~= nil) and (not table.isempty(addPercentPairTab)) then
            for _, baseABInfo in pairs(finalABTab) do
                for i = 1, #addPercentPairTab, 1 do
                    if addPercentPairTab[i] == baseABInfo.id then
                        local addvalue = math.floor(baseABInfo.value * abinfo.value / 100)                 
                        if addvalue > 0 then
                            if strAddAbility ~= '' then
                                strAddAbility = strAddAbility..'|'
                            end
                            strAddAbility = strAddAbility..'#3#'..baseABInfo.id..'#'..addvalue
                        end                        
                    end
                end
            end
        end          
    end    

    return strAddAbility
end

--更新指定装备位的装备星级及属性
function EquipPosStarManager.UpdateEquipStarLvInPos(actor, pos)
	if (actor == nil) or (pos == nil) then
		return
	end		
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    if infoStr == '' then
		return        
    end
	if not EquipPosStarManager.IsValidEquipPosForUpgradeStar(pos) then
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
    local cfgCurrKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, pos, curPosLevel)
    if cfgEquipPosUpgradeStar[cfgCurrKey] == nil then
        return
    end

	--增加自定义的星级和扩展属性
    local sGroupShowName = '['..CommonDefine.EQUIPPOS_NAME[pos]..'槽位星级]: +'..curPosLevel	
	BF_SetCustomEquipABGroup(actor, equipitem, cfgEquipPosUpgradeStar[cfgCurrKey].addprop_tab, CommonDefine.ITEM_CUSTOMEAB_GROUP_1, sGroupShowName, 253)
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

--清空指定装备位上装备的星级及属性
function EquipPosStarManager.ClearEquipStarLvInPos(actor, equippos)
	if (actor == nil) or (equippos == nil) then
		return
	end
	local equipitem = linkbodyitem(actor, equippos)
    EquipPosStarManager.ClearEquipStarLv(actor, equipitem, equippos)
end

--清空指定装备位上装备的星级及属性
function EquipPosStarManager.ClearEquipStarLv(actor, equipitem, equippos)
	if (actor == nil) or (equipitem == nil) or (equipitem == '0') or (equippos == nil) then
		return
	end

	--清除自定义的星级和扩展属性
	clearitemcustomabil(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_1)
    setitemaddvalue(actor, equipitem, 2, 3, 0);
    --清楚加成到人物身上的属性组
    local sGroupName = CommonDefine.EQUIPPOS_ADDAB_GROUP_NAME[equippos]
    if (sGroupName ~= nil) and (sGroupName ~= '') then
        delattlist(actor, sGroupName)
    end

    refreshitem(actor, equipitem)
    recalcabilitys(actor)    
end

--返回玩家指定装备位对应的升星配置key
function EquipPosStarManager.GetPlayerCfgKey(actor, pos)
	if (actor == nil) or (pos == nil) then
		return -1
	end		
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    if infoStr == '' then
		return -1     
    end
	if not EquipPosStarManager.IsValidEquipPosForUpgradeStar(pos) then
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
    return EquipPosStarManager.GetUpgradeStarCfgKey(bJob, pos, curPosLevel)
end

--玩家登录时触发
function EquipPosStarManager.OnPlayerEnterGame(actor)
    for pos, groupname in pairs(CommonDefine.EQUIPPOS_ADDAB_GROUP_NAME) do
        local equipitem = linkbodyitem(actor, pos)
        if equipitem ~= '0'then
            local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX) 
            local cfgCurrKey = EquipPosStarManager.GetPlayerCfgKey(actor, pos)
            if cfgCurrKey ~= -1 then
                local strAddAbility = GetEquipPosStarAddAbilityStr(actor, pos, equipitem, cfgCurrKey)
                if strAddAbility ~= '' then
                    addattlist(actor, groupname, "=", strAddAbility)
                end                 
            end          
        end
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, EquipPosStarManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_EQUIPPOS_STAR)







--显示规则面板
function EquipPosStarManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=槽位升星规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、升星的属性会绑定在装备槽位上，穿戴装备后属性生效|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=2、放心更换装备，装备的更换不会影响已有的升星属性效果|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=3、升星具有成功率，失败将会掉星；使用升星符可提升几率|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function GetSingleEquipPosShowInfo(actor, equippos)
    local sPanelStr = ''
    if (not BF_IsNullObj(actor)) then   
        local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)

        local infoTab = {}
        if infoStr ~= '' then
            infoTab = json2tbl(infoStr)
        end
        local sid = equippos..''
        if infoTab[sid] == nil then
            infoTab[sid] = 0
            infoStr = tbl2json(infoTab)
            setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
        end
        local curPosLevel = infoTab[sid]
        if curPosLevel < 0 then
            return sPanelStr
        end
        local nextPosLevel = curPosLevel + 1
        local bCurrIsMaxLv = false       
        local bJob = Player.GetJob(actor)
        local cfgCurrKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, curPosLevel)
        if cfgEquipPosUpgradeStar[cfgCurrKey] == nil then
            release_print("GetSingleEquipPosShowInfo no config key:"..cfgCurrKey)
            return sPanelStr
        end
        local cfgNextKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, nextPosLevel)
        if cfgEquipPosUpgradeStar[cfgNextKey] == nil then
            bCurrIsMaxLv = true
        end   
        
        local equipname = ''
        local equipcolor = CSS.QUALITY_WHITE
        local equipobj = linkbodyitem(actor, equippos)
        if not BF_IsNullObj(equipobj) then
            equipname = getiteminfo(actor, equipobj, CommonDefine.ITEMINFO_SRCNAME) 
            equipcolor = Item.GetItemQualityColor(actor, equipobj)
        end        
        
        sPanelStr = sPanelStr..'<Layout|id=15|children={101,110,160,500}|x=280.0|y=60.0|width=510|height=430>'

        local starid = 900
        local staridstr = ''
        local starx = 10
        local stary = 110
        for i = 1, MAX_STAR_NUM, 1 do
            starid = starid + 1
            staridstr = staridstr..','..starid
            starx = starx + 30
            if curPosLevel >= i then
                sPanelStr = sPanelStr..'<Img|id='..starid..'|x='..starx..'|y='..stary..'|img=private/cc_equip_star/star_1.png>'
            else
                sPanelStr = sPanelStr..'<Img|id='..starid..'|x='..starx..'|y='..stary..'|img=private/cc_equip_star/star_2.png>'
            end
        end

        sPanelStr = sPanelStr..'<Layout|id=101|children={102,104'..staridstr..'}|x=0.0|y=0.0|width=510|height=150>'..
            '<Img|id=102|children={103}|x=228.0|y=20.0|img=private/cc_common/itemframe_1.png>'..
            '<EquipShow|id=103|x=-2.0|y=-4.0|showtips=1|effectshow=0|reload=1|index='..equippos..'>'..
            '<Text|id=104|x=210.0|y=90.0|size=16|color='..equipcolor..'|text='..equipname..'>'

        --sPanelStr = sPanelStr..'<Layout|id=110|children={120,140}|x=0|y=150|width=510|height=120|color=244>'                
        sPanelStr = sPanelStr..'<Layout|id=110|children={119,120,140}|x=0|y=150|width=510|height=120>'..
            '<Img|id=119|x=210.0|y=36.0|img=private/cc_equip_star/1.png>'
        --当前星级
        local startid = 120
        
        local tempLeftX = 20
        local tempLeftY = 20
        local idstr = ''
        local currPropDescTable = cfgEquipPosUpgradeStar[cfgCurrKey].addprop_desctab
        for seq, descItem in ipairs(currPropDescTable) do
            local textid = startid + 10 + seq
            idstr = idstr..','..textid
            tempLeftY = tempLeftY + 30
            sPanelStr = sPanelStr..'<Text|id='..textid..'|text='..descItem.desc..'|size=16|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        end
        sPanelStr = sPanelStr..'<Img|id='..startid..'|children={'..idstr..'}|x=30|y=0|img=private/cc_equip_star/panel_1.png>'

        --下一星级
        startid = 140
        local tempRightX = 20
        local tempRightY = 20
        if bCurrIsMaxLv then
            idstr = idstr..','..(startid+1)
            tempRightY = tempRightY + 30
            sPanelStr = sPanelStr..'<Text|id='..(startid+1)..'|text=已达到星级上限|size=16|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        else            
            local nextPropDescTable =  cfgEquipPosUpgradeStar[cfgNextKey].addprop_desctab
            for seq, descItem in ipairs(nextPropDescTable) do
                local textid = startid + 10 + seq
                idstr = idstr..','..textid
                tempRightY = tempRightY + 30
                sPanelStr = sPanelStr..'<Text|id='..textid..'|size=16|text='..descItem.desc..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            end
        end
        sPanelStr = sPanelStr..'<Img|id='..startid..'|children={'..idstr..'}|x=300|y=0|img=private/cc_equip_star/panel_2.png>'

        --消耗
        local tempX = 120
        local tempY = 10        
        local itemidstr = ''
        if not bCurrIsMaxLv then            
            sPanelStr = sPanelStr..'<Text|id=161|text=成功概率：'..cfgEquipPosUpgradeStar[cfgCurrKey].successrate ..'%|size=16|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
            tempY = tempY + 30
            sPanelStr = sPanelStr..'<Text|id=162|text=升星消耗：|x='..tempX..'|y='..tempY..'|size=16|color='..CSS.NPC_YELLOW..'>'
            local sTempStr = ''
            sTempStr, itemidstr = Item.GetNeedItemsGridShowInfo(actor, cfgEquipPosUpgradeStar[cfgCurrKey].needitems_tab, tempX+10, tempY+20, 180)
            if sTempStr ~= '' then
                sPanelStr = sPanelStr..sTempStr
            end

            local strItemList1 = ''
            for _, value in ipairs(SELECT_AUTO_STAR_LIST) do
                if strItemList1 ~= '' then
                    strItemList1 = strItemList1..'#'
                end
                strItemList1 = strItemList1..value.showstr
            end
        
            local currSelectStr1 = SELECT_AUTO_STAR_LIST[1].showstr
            local chooseseq = getplaydef(actor, CommonDefine.VAR_U_EQUIPPOS_AUTO_STAR_CONDITION)
            if (chooseseq >= 1) and (chooseseq <= #SELECT_AUTO_STAR_LIST) then
                currSelectStr1 = SELECT_AUTO_STAR_LIST[chooseseq].showstr
            end

            sPanelStr = sPanelStr..'<MenuItem|id=503|x=430.0|y='..tempY..'|width=60|height=30|itemname='..strItemList1..'|select='..currSelectStr1..'|fontsize=16|itemhei=16|menuid='..CommonDefine.VAR_S_SELECT_MENUITEM_3..
                '|selectcolor=254|fontcolor=250|direction=0|link=@function_button,'..EQUIPPOS_STAR_BUTTONFUNC_ID_6..'>'                
        end
        sPanelStr = sPanelStr..'<Layout|id=160|children={161,162,503,'..itemidstr..'}|x=0|y=270.0|width=510|height=110>'

        --升星按钮
        idstr = '501,502'
        if bCurrIsMaxLv then
            sPanelStr = sPanelStr..'<Text|id=501|text=已升至满星状态！|x=200|y=10|color='..CSS.NPC_LIGHTGREEN..'>'
        else
            local tempCurrY = 10
            sPanelStr = sPanelStr..'<Button|id=501|x=110|y='..tempCurrY..'|text=升星一次|size=18|color='..CSS.NPC_WHITE..'|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..            
                EQUIPPOS_STAR_BUTTONFUNC_ID_2..'>'
            if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG) == 0 then
                sPanelStr = sPanelStr..'<Button|id=502|x=302|y='..tempCurrY..'|text=自动升星|size=18|color='..CSS.NPC_WHITE..'|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..
                    EQUIPPOS_STAR_BUTTONFUNC_ID_3..'>'
            else
                sPanelStr = sPanelStr..'<Button|id=502|x=302|y='..tempCurrY..'|text=停止升星|size=18|color='..CSS.NPC_WHITE..'|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..
                    EQUIPPOS_STAR_BUTTONFUNC_ID_4..'>'
            end      
        end
        sPanelStr = sPanelStr..'<Layout|id=500|children={'..idstr..'}|x=0|y=380.0|width=510|height=52>'

    end
    return sPanelStr
end

--显示初始面板
function EquipPosStarManager.ShowBasePanel(actor)
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end

    local posTab = {}
    local bChanged = false
    for pos, posname in pairs(CommonDefine.EQUIPPOS_NAME) do
        if EquipPosStarManager.IsValidEquipPosForUpgradeStar(pos) then
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
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
    end

    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16,17}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|reset=1|img=private/cc_equip_star/8.png|show=0|esc=1|move=0|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
        '<Button|id=16|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

    strPanelInfo = strPanelInfo..Item.GetBagItemsShowInfo(actor, SHOW_BAG_ITEMS, 17)        

    local idstr1 = ''
    for seq, _ in ipairs(posTab) do
        if idstr1 ~= '' then
            idstr1 = idstr1..','
        end
        idstr1 = idstr1..(30+seq)
    end    

    local defaultseq = 1
    local choosepos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)   
    for seq, value in ipairs(posTab) do
        local baseid = 30 + seq
        local textid1 = baseid * 10 + 1
        local textid2 = baseid * 10 + 2
        local equipshowid = baseid * 10 + 3        
        local picid2 = baseid * 10 + 4
        local picid3 = baseid * 10 + 5
        local tempidstr = textid1..','..textid2..','..equipshowid..','..picid2..','..picid3
        if choosepos == -1 then          
            choosepos = value.pos         
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, choosepos)
        end
        local equipname = ''
        local equipcolor = CSS.QUALITY_WHITE
        local equipobj = linkbodyitem(actor, value.pos)
        if not BF_IsNullObj(equipobj) then
            equipname = getiteminfo(actor, equipobj, CommonDefine.ITEMINFO_SRCNAME) 
            equipcolor = Item.GetItemQualityColor(actor, equipobj)
        end

        local strPosIconImg = 'private/cc_common/pos_icon_'..value.pos..'.png'
        
        strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..tempidstr..'}|x=-6.0|y=0.0|img=private/cc_common/listviewitem_1.png|link=@function_button,'..
            EQUIPPOS_STAR_BUTTONFUNC_ID_1..','..value.pos..'>'
        strPanelInfo = strPanelInfo..'<Text|id='..textid1..'|x=85.0|y=14.0|size=18|color='..equipcolor..'|text='..equipname..'>'
            ..'<Text|id='..textid2..'|x=85.0|y=44.0|size=18|color='..CSS.NPC_WHITE..'|text='..value.level..'星>'
        strPanelInfo = strPanelInfo..'<EquipShow|id='..equipshowid..'|x=6.0|y=6.0|showtips=0|effectshow=0|reload=1|index='..value.pos..'>'..
            '<Img|id='..picid3..'|x=8|y=12|img='..strPosIconImg..'>'

        if choosepos == value.pos then
            --对应当前选中的装备槽位
            strPanelInfo = strPanelInfo..'<Img|id='..picid2..'|x=0|y=0|img=private/cc_common/listviewitem_2.png>'
            strPanelInfo = strPanelInfo..GetSingleEquipPosShowInfo(actor, value.pos)                
            defaultseq = seq
        end
    end
    strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..idstr1..'}|x=65.0|y=56.0|width=210|height=440|margin=0|reload=1|default='..defaultseq..'|direction=1>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

--装备位 升星一次
local function EquipPosUpgradeStarOnce(actor)
    if BF_IsNullObj(actor) then
        return
    end    
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STAR, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStarManager.IsValidEquipPosForUpgradeStar(equippos) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end

    local nextPosLevel = curPosLevel + 1
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosUpgradeStar[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosUpgradeStar[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前升星已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgEquipPosUpgradeStar[cfgCurrKey].needitems_tab, '升星') then
        return
    end

    --扣除消耗
    Player.TakeItems(actor, cfgEquipPosUpgradeStar[cfgCurrKey].needitems_tab, '装备升星')
    
    if cfgEquipPosUpgradeStar[cfgCurrKey].successrate >= math.random(1, 100) then
        --升星成功
        Player.SendSelfMsg(actor, '升星成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)

        infoTab[sid] = nextPosLevel;
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)

        --更新当前装备位的星级状态
        EquipPosStarManager.UpdateEquipStarLvInPos(actor, equippos)

        --触发装备位升星
        --[[
        -----------------------------------------------------todo
        FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_UPGRADE_EQUIPSTAR, 'max', nextPosLevel)        
        ]]--
    else
        --升星失败
        Player.SendSelfMsg(actor, '升星失败！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        
        if (curPosLevel <= 0) or (cfgEquipPosUpgradeStar[cfgCurrKey].faildeclv <= 0) then
            return
        end

        infoTab[sid] = math.max(0, curPosLevel - cfgEquipPosUpgradeStar[cfgCurrKey].faildeclv);
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
        
        --更新当前对应的装备状态
        EquipPosStarManager.UpdateEquipStarLvInPos(actor, equippos)        
    end 
    
    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_EQUIPPOS_STAR, 1)          
end

local function EquipPosStopAutoUpgradeStar(actor)
    for i = EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX, 1 do
        local checkvar = CommonDefine.CHECK_BOX_VAR[i - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
        setplaydef(actor, checkvar, 0)        
    end
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG, 0)
end

--装备位 自动升星
function EquipPosStarManager.EquipPosAutoUpgradeStar(actor, startflag)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STAR, false) then
        return
    end
    if startflag==nil or startflag==false then
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG) == 0 then
            Player.SendSelfMsg(actor, '停止自动升星！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStarManager.IsValidEquipPosForUpgradeStar(equippos) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end

    local nextPosLevel = curPosLevel + 1
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosUpgradeStar[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = EquipPosStarManager.GetUpgradeStarCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosUpgradeStar[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前升星已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        EquipPosStarManager.ShowBasePanel(actor)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgEquipPosUpgradeStar[cfgCurrKey].needitems_tab, '升星') then
        return
    end

    local targPosLevel = 0
    local chooseseq = getplaydef(actor, CommonDefine.VAR_U_EQUIPPOS_AUTO_STAR_CONDITION)
    if (chooseseq >= 1) and (chooseseq <= #SELECT_AUTO_STAR_LIST) then
        targPosLevel = SELECT_AUTO_STAR_LIST[chooseseq].targstar
    end

    -- local targPosLevel = 0
    -- for i = EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX, 1 do
    --     local checkvar = CommonDefine.CHECK_BOX_VAR[i - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
    --     if getplaydef(actor, checkvar) == 1 then
    --         targPosLevel = i
    --         break
    --     end
    -- end

    if curPosLevel >= targPosLevel then
        if startflag and startflag==true then
            if targPosLevel == 0 then
                Player.SendSelfMsg(actor, '未选择的目标星级，系统默认选择了下一级，请再确认！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            else
                Player.SendSelfMsg(actor, '选择的目标星级小于当前星级，系统默认选择了下一级，请再确认！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)            
            end
            if targPosLevel < EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX then
                targPosLevel = math.max(curPosLevel + 1, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN)
                -- local checkvar = CommonDefine.CHECK_BOX_VAR[targPosLevel - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
                -- setplaydef(actor, checkvar, 1)
                setplaydef(actor, CommonDefine.VAR_U_EQUIPPOS_AUTO_STAR_CONDITION, chooseseq+1)
            end
        else
            Player.SendSelfMsg(actor, '当前已达到目标星级！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            EquipPosStopAutoUpgradeStar(actor)
            EquipPosStarManager.ShowBasePanel(actor)
        end        
    else
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG, 1)         
        EquipPosUpgradeStarOnce(actor)
        delaygoto(actor, 1000, 'equippos_star_auto_upgrade', 0)
    end
end

--设置自动升星的目标
--[[
local function SetAutoUpgradeTargStar(actor, varseq)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(varseq) then
        return
    end
    local seq = tonumber(varseq)
    if (seq < EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN) or (seq > EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStarManager.IsValidEquipPosForUpgradeStar(equippos) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end
    if curPosLevel >= seq then
        for i = EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX, 1 do            
            local checkvar = CommonDefine.CHECK_BOX_VAR[i - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
            setplaydef(actor, checkvar, 0)            
        end
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG, 0)

        Player.SendSelfMsg(actor, '目标星级低于当前星级！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    for i = EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX, 1 do
        if i ~= seq then
            local checkvar = CommonDefine.CHECK_BOX_VAR[i - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
            setplaydef(actor, checkvar, 0)            
        end
    end
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG, 0) 
end
]]--

--设置自动升星的目标
local function SetAutoUpgradeTargStarEx(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local sparam = ''
    if BF_IsLocalTestServer() then
        sparam = getconst(actor, '$STR('..CommonDefine.VAR_S_SELECT_MENUITEM_3..')')
    else
        sparam = getconst(actor, '<$NPCPARAMS(4,'..CommonDefine.VAR_S_SELECT_MENUITEM_3..')>')
    end  
    for seq, value in ipairs(SELECT_AUTO_STAR_LIST) do
        if value.showstr == sparam then
            setplaydef(actor, CommonDefine.VAR_U_EQUIPPOS_AUTO_STAR_CONDITION, seq)            
            break
        end
    end       
end

--找到随机一个低于指定星级的装备位，将其升星到指定星级
function EquipPosStarManager.RandomUpgradePosToTargStarNum(actor, targstarnum)
    if BF_IsNullObj(actor) or (targstarnum==nil) then
        return false
    end
    if (targstarnum < 1) or (targstarnum > EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX) then
        return false
    end

    local infoTab = {}
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO)
    if infoStr ~= '' then
		infoTab = json2tbl(infoStr)
    end
	if infoTab == nil then
		return false
	end
    local poslist = {}
	for _, value in pairs(CommonDefine.BASE_EQUIPMENT_POS) do
        local sid = value..''
        if infoTab[sid] == nil then
            infoTab[sid] = 0
        end
        if infoTab[sid] < targstarnum then
            poslist[#poslist+1] = value
        end
	end

    if table.isempty(poslist) then
        return false
    end
    local rand = math.random(1, #poslist)
    local currpos = poslist[rand]
    local sid = currpos..''
    infoTab[sid] = targstarnum
    infoStr = tbl2json(infoTab)
    setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, infoStr)
    EquipPosStarManager.UpdateEquipStarLvInPos(actor, poslist[rand])
    --[[
    -----------------------------------------------------todo    
    FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_UPGRADE_EQUIPSTAR, 'max', targstarnum) 
    ]]--
    Player.SendSelfMsg(actor, CommonDefine.EQUIPPOS_NAME[currpos]..'槽位星级升至'..targstarnum, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    return true
end

--处理button回调
function EquipPosStarManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local param = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if BF_IsNumberStr(sparam) then
        param = tonumber(sparam)
    end

    if funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_1 then
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID,  param)
        EquipPosStopAutoUpgradeStar(actor)
    elseif funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_2 then
        EquipPosUpgradeStarOnce(actor)
    elseif funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_3 then
        EquipPosStarManager.EquipPosAutoUpgradeStar(actor, true)
    elseif funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_4 then
        EquipPosStopAutoUpgradeStar(actor)
--[[
    elseif funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_5 then
        SetAutoUpgradeTargStar(actor, param)
]]--
    elseif funcid == EQUIPPOS_STAR_BUTTONFUNC_ID_6 then
        SetAutoUpgradeTargStarEx(actor)
    end
    EquipPosStarManager.ShowBasePanel(actor)
end

function EquipPosStarManager.IsTopIconHaveRedPoint(actor)

    ------------------------    
    ------------------------
    ------------------------
    return false
end

return EquipPosStarManager