SkillUpgrade = {}

--functionid
local NPCPANEL_BUTTONFUNC_ID_1 = 1      --切换技能升级和技能强化
local NPCPANEL_BUTTONFUNC_ID_2 = 2      --切换技能id
local NPCPANEL_BUTTONFUNC_ID_3 = 3      --进行一次技能升级
local NPCPANEL_BUTTONFUNC_ID_4 = 4      --进行一次技能强化

local UPGRADE_TYPE_LEVEL = 0            --升级
local UPGRADE_TYPE_UPLEVEL = 1          --升阶

--升级自动学习的技能
local UPGRADE_LEVEL_AUTO_LEARN_SKILL = {
	[CommonDefine.JOB_Z] = {
        --[[
        {magicid=1, minlevel = 5},
		{magicid=3, minlevel = 1},
        {magicid=13, minlevel = 4},
        {magicid=5, minlevel = 8},
		{magicid=7, minlevel = 2},
        {magicid=12, minlevel = 3},
        {magicid=6, minlevel = 7},
        {magicid=9, minlevel = 17},
        {magicid=25, minlevel = 12},
        {magicid=10, minlevel = 19},
        {magicid=26, minlevel = 20},
        {magicid=11, minlevel = 10},
        {magicid=56, minlevel = 30},
        {magicid=22, minlevel = 15},
        {magicid=50, minlevel = 53},
        {magicid=66, minlevel = 42},
        {magicid=23, minlevel = 27},        
        {magicid=57, minlevel = 22},
        {magicid=82, minlevel = 60},
        {magicid=24, minlevel = 25},
        {magicid=38, minlevel = 37},
        {magicid=81, minlevel = 65},
        {magicid=51, minlevel = 32},
        {magicid=52, minlevel = 45},
        {magicid=33, minlevel = 24},
        {magicid=44, minlevel = 39},
        {magicid=85, minlevel = 50},
        {magicid=45, minlevel = 40},
        {magicid=58, minlevel = 35},
        {magicid=86, minlevel = 55},
        ]]--

        {magicid=3, minlevel = 1},
        {magicid=7, minlevel = 2},
        {magicid=12, minlevel = 3},
        {magicid=25, minlevel = 12},
        {magicid=26, minlevel = 20},
        {magicid=56, minlevel = 30},
        {magicid=66, minlevel = 42},
        {magicid=82, minlevel = 60},
        {magicid=81, minlevel = 65},
        {magicid=86, minlevel = 55},
	},

	[CommonDefine.JOB_F] = {
		{magicid=1, minlevel = 1},
	},
	[CommonDefine.JOB_D] = {
		{magicid=13, minlevel = 1},
	},
}


--玩家根据当前等级，自动学习技能
function SkillUpgrade.CheckAutoLearnSkill(actor)
	local job = Player.GetJob(actor)
	local level = Player.GetLevel(actor)
	local magiclist = UPGRADE_LEVEL_AUTO_LEARN_SKILL[job]
	if magiclist then
		for _, magic in ipairs(magiclist) do
			if level >= magic.minlevel then
				if getskillinfo(actor, magic.magicid, 1) == nil then                  
					addskill(actor, magic.magicid, 0)
				end	
			end
		end
	end
end

function SkillUpgrade.GetCfgKey(skillid, skilllv)
    return skillid * 100 + skilllv
end

--是否为可升级的技能
function SkillUpgrade.IsValidUpgradeSkill(actor, skillid)
    if BF_IsNullObj(actor) or (skillid == nil) or (skillid == 0) then
        return false
    end
	local skilllv = getskilllevel(actor, skillid)
	if skilllv < 0 then
		return false
	end

	local infokey = SkillUpgrade.GetCfgKey(skillid, skilllv)
	local skillInfo = cfgSkillUpgrade[infokey]
	if skillInfo == nil then
		return false
	end
	
	return true
end

--是否为可进阶的技能
function SkillUpgrade.IsValidAdvanceUpgradeSkill(actor, skillid)
    if BF_IsNullObj(actor) or (skillid == nil) or (skillid == 0) then
        return false
    end
	local skilllv = getskilllevelup(actor, skillid)
	if skilllv < 0 then
		return false
	end

	local infokey = SkillUpgrade.GetCfgKey(skillid, skilllv)
	local skillInfo = cfgSkillAdvanceUpgrade[infokey]
	if skillInfo == nil then
		return false
	end
	return true
end




--------------------------------------------------------主面板相关--------------------------------------------------------------------
function SkillUpgrade.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=技能升级规则说明：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、只有输出类的技能才能进行升级操作。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=2、技能升级消耗书页道具，每次升级均会有角色等级的限制。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=3、技能升级所提升的是释放技能时额外附带的百分比对应攻|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=击力的伤害。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=技能进阶规则说明：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'		
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=27|text=1、只有可以升级的技能才能进行进阶操作，且需要对应的技能|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'			
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=28|text=升到指定等级。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'		
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=29|text=2、技能进阶需要消耗技能秘籍道具。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'	
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=30|text=3、技能进阶提升的为对应技能最终的输出威力的百分比加成。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'	

    BF_ShowSpecialUI(actor, strPanelInfo)    
end

local function GetSingleShowInfo(actor, targSkillID)    
    local choosetype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_OPER_TYPE)
    local magicCfgInfo = cfg_magic[targSkillID]
    if magicCfgInfo == nil then
        return
    end    
    local skillCommonLv = getskilllevel(actor, targSkillID)
    local skillLv = skillCommonLv
    if choosetype == UPGRADE_TYPE_UPLEVEL then
        skillLv = getskilllevelup(actor, targSkillID)
    end
    if (skillCommonLv < 0) or (skillLv < 0) then
        return
    end
    local cfgKey = SkillUpgrade.GetCfgKey(targSkillID, skillLv)
    local upgradeInfo = nil 
    if choosetype == UPGRADE_TYPE_LEVEL then
        upgradeInfo = cfgSkillUpgrade[cfgKey]    
        if upgradeInfo == nil then
            Player.SendSelfMsg(actor, '缺少对应的技能升级配置！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end    
    else
        upgradeInfo = cfgSkillAdvanceUpgrade[cfgKey]    
        if upgradeInfo == nil then
            Player.SendSelfMsg(actor, '缺少对应的技能进阶配置！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end        
    end    

    local skillNextLv = skillLv + 1
    local cfgNextKey = SkillUpgrade.GetCfgKey(targSkillID, skillNextLv)
    local upgradeNextInfo = cfgSkillUpgrade[cfgNextKey]  
    if choosetype == UPGRADE_TYPE_UPLEVEL then
        upgradeNextInfo = cfgSkillAdvanceUpgrade[cfgNextKey]
    end

    local sPanelStr = '<Text|id=17|text='..magicCfgInfo.MagName..'|x=440|y=56|size=25|color='..CSS.NPC_ORANGE..'>'
    local idstr = '31,32,33,34,35,36,37,38,39'
    local tempCurrX = 40
    local tempCurrY = 10    
    local sLvName = '等级'
    if choosetype == UPGRADE_TYPE_UPLEVEL then
        sLvName = '等阶'
    end
    sPanelStr = sPanelStr..'<Text|id=31|text=当前'..sLvName..'：'..skillLv..'|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 50    
    local effectdesc = ''
    if upgradeInfo.effectdesc then
        effectdesc = upgradeInfo.effectdesc
    end
    sPanelStr = sPanelStr..'<Text|id=32|text=效果：'..effectdesc..'|size=16|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'

    tempCurrX = 350
    tempCurrY = 10
    if upgradeNextInfo ~= nil then
        sPanelStr = sPanelStr..'<Text|id=33|text=下一'..sLvName..'：'..skillNextLv..'|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        tempCurrY = tempCurrY + 50
        local effectdesc = ''
        if upgradeNextInfo.effectdesc then
            effectdesc = upgradeNextInfo.effectdesc
        end
        sPanelStr = sPanelStr..'<Text|id=34|text=效果：'..effectdesc..'|size=16|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    end

    tempCurrX = 0
    tempCurrY = 150
    sPanelStr = sPanelStr..'<Img|id=35|x='..tempCurrX..'|y='..tempCurrY..'|move=0|img=private/cc_skill/5.png>'
    tempCurrX = 40
    tempCurrY = tempCurrY + 10
    local currPlayerLv = Player.GetLevel(actor)
    if upgradeNextInfo ~= nil then
        if choosetype == UPGRADE_TYPE_LEVEL then
            sPanelStr = sPanelStr..'<Text|id=36|text=角色等级限制：达到'..upgradeInfo.needlv..'级/'..currPlayerLv..'级|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        else
            sPanelStr = sPanelStr..'<Text|id=36|text=技能等级限制：达到'..upgradeInfo.needlv..'级/'..skillCommonLv..'级|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        end        
    end
    tempCurrY = tempCurrY + 30
    local itemidstr = ''
    if upgradeNextInfo ~= nil then
        --local sConsumeInfo = BF_GetItemTableDescStr(actor, upgradeInfo.needitems_tab)
        if choosetype == UPGRADE_TYPE_LEVEL then
            --sPanelStr = sPanelStr..'<Text|id=37|text=升级消耗：'..sConsumeInfo..'|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
            sPanelStr = sPanelStr..'<Text|id=37|text=升级消耗：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        else
            --sPanelStr = sPanelStr..'<Text|id=37|text=进阶消耗：'..sConsumeInfo..'|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
            sPanelStr = sPanelStr..'<Text|id=37|text=进阶消耗：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        end        
        local sTempStr = ''
        sTempStr, itemidstr = Item.GetNeedItemsShowInfo(actor, upgradeInfo.needitems_tab, tempCurrX, tempCurrY, 170, 180, CSS.NPC_WHITE)
        if sTempStr ~= '' then
            sPanelStr = sPanelStr..sTempStr
        end        
    end    
    tempCurrX = 0
    tempCurrY = tempCurrY + 30   
    sPanelStr = sPanelStr..'<Img|id=38|x='..tempCurrX..'|y='..tempCurrY..'|move=0|img=private/cc_skill/5.png>'
    tempCurrY = tempCurrY + 50

    --升级按钮
    if upgradeNextInfo ~= nil then
        if choosetype == UPGRADE_TYPE_LEVEL then
            sPanelStr = sPanelStr..'<Button|id=39|x='..(tempCurrX+240)..'|y='..tempCurrY..'|text=升    级|size=18|color=255|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@function_button,'..
                NPCPANEL_BUTTONFUNC_ID_3..','..targSkillID..'>'
        else
            sPanelStr = sPanelStr..'<Button|id=39|x='..(tempCurrX+240)..'|y='..tempCurrY..'|text=进    阶|size=18|color=255|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@function_button,'..
                NPCPANEL_BUTTONFUNC_ID_4..','..targSkillID..'>'
        end
    else
        sPanelStr = sPanelStr..'<Text|id=39|text=已达到最高技能'..sLvName..'！|x='..(tempCurrX+240)..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    end

    sPanelStr = sPanelStr..'<Layout|id=13|children={'..idstr..','..itemidstr..'}|x=200.0|y=100.0|width=580|height=320>'

    return sPanelStr
end

local function IsSkillCanUpgradeOnce(actor, targSkillID, upgradetype)
    if upgradetype == UPGRADE_TYPE_LEVEL then
        local magicCfgInfo = cfg_magic[targSkillID]
        if magicCfgInfo == nil then
            return false
        end    
        local skillLv = getskilllevel(actor, targSkillID)
        if skillLv < 0 then
            return false
        end
        local cfgKey = SkillUpgrade.GetCfgKey(targSkillID, skillLv)
        local upgradeInfo = cfgSkillUpgrade[cfgKey]    
        if upgradeInfo == nil then
            return false
        end
        local skillNextLv = skillLv + 1
        local cfgNextKey = SkillUpgrade.GetCfgKey(targSkillID, skillNextLv)
        local upgradeNextInfo = cfgSkillUpgrade[cfgNextKey]
        if upgradeNextInfo == nil then
            return false
        end
    
        --条件判断
        local currPlayerLv = Player.GetLevel(actor)
        if currPlayerLv < upgradeInfo.needlv then
            return false
        end
        if not Player.CheckItemsEnough(actor, upgradeInfo.needitems_tab, '') then
            return false
        end

        return true
    else
        local magicCfgInfo = cfg_magic[targSkillID]
        if magicCfgInfo == nil then
            return false
        end    
        local skillCommonLv = getskilllevel(actor, targSkillID)
        local skillLv = getskilllevelup(actor, targSkillID)
        if (skillLv < 0) or (skillCommonLv < 0) then
            return false
        end
        local cfgKey = SkillUpgrade.GetCfgKey(targSkillID, skillLv)
        local upgradeInfo = cfgSkillAdvanceUpgrade[cfgKey]    
        if upgradeInfo == nil then
            return false
        end
        local skillNextLv = skillLv + 1
        local cfgNextKey = SkillUpgrade.GetCfgKey(targSkillID, skillNextLv)
        local upgradeNextInfo = cfgSkillAdvanceUpgrade[cfgNextKey]
        if upgradeNextInfo == nil then
            return false
        end
    
        --条件判断
        if skillCommonLv < upgradeInfo.needlv then
            return false
        end
        if not Player.CheckItemsEnough(actor, upgradeInfo.needitems_tab, '') then
            return false
        end
    
        if magicCfgInfo.AdvanceLevelVarID and (type(magicCfgInfo.AdvanceLevelVarID) == "number") then
            local id = magicCfgInfo.AdvanceLevelVarID
            if (id < 51) or (id > 80) then
                return false
            end    
        end
    
        return true
    end
end

function SkillUpgrade.ShowBasePanel(actor)    
    local strPanelInfo = '<Img|id=10|children={11,12,14,13,15,16,17,18}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|height=448|esc=1|move=0|reset=1|img=private/cc_skill/6.png|show=0|loadDelay=0|bg=1>'..
        '<Layout|id=11|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Button|id=18|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'..
        '<Text|id=21|x=9.0|y=9.0|color=161|size=20|text=升>'..
        '<Text|id=22|x=9.0|y=45.0|color=161|size=20|text=级>'..
        '<Text|id=23|x=9.0|y=9.0|color=161|size=20|text=进>'..
        '<Text|id=24|x=9.0|y=45.0|color=161|size=20|text=阶>'

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    local choosetype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_OPER_TYPE)
    if choosetype == UPGRADE_TYPE_LEVEL then
        strPanelInfo = strPanelInfo..'<Button|id=15|children={21,22}|x=16.0|y=114.0|size=18|color=255|mimg=private/cc_skill/1.png|nimg=private/cc_skill/1.png|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_1..',0>'..
            '<Button|id=16|children={23,24}|x=16.0|y=212.0|size=18|color=255|mimg=private/cc_skill/2.png|nimg=private/cc_skill/2.png|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_1..',1>'
    else
        strPanelInfo = strPanelInfo..'<Button|id=15|children={21,22}|x=16.0|y=114.0|size=18|color=255|mimg=private/cc_skill/2.png|nimg=private/cc_skill/2.png|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_1..',0>'..
            '<Button|id=16|children={23,24}|x=16.0|y=212.0|size=18|color=255|mimg=private/cc_skill/1.png|nimg=private/cc_skill/1.png|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_1..',1>'
    end

    local listitemidstr = ''
    local skill_list = getallskills(actor)
    local seq = 0
    for _, skillID in ipairs(skill_list or {}) do
        if SkillUpgrade.IsValidUpgradeSkill(actor, skillID) then     
            local magicInfo = cfg_magic[skillID]            
            if magicInfo ~= nil then
                seq = seq + 1
                local picid = 40 + seq * 3
                local textid1 = 40 + seq * 3 + 1
                local textid2 = 40 + seq * 3 + 2
                if chooseid == -1 then          
                    chooseid = skillID
                    setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
                end
        
                local tabpic = 'private/cc_skill/3.png'
                if chooseid == skillID then
                    tabpic = 'private/cc_skill/4.png'
                end

                if choosetype == UPGRADE_TYPE_LEVEL then
                    local nSkillLv = getskilllevel(actor, skillID)                    
                    strPanelInfo = strPanelInfo..'<Img|id='..picid..'|children={'..textid1..','..textid2..'}x=0.0|y=0.0|img='..tabpic..'|link=@function_button,'..
                        NPCPANEL_BUTTONFUNC_ID_2..','..skillID..'>'..
                        '<Text|id='..textid1..'|x=6.0|y=12.0|size=18|color='..CSS.NPC_YELLOW..'|text='..magicInfo.MagName..'>'..
                        '<Text|id='..textid2..'|x=80.0|y=14.0|size=15|color='..CSS.NPC_LIGHTGREEN..'|text=('..nSkillLv..'级)>'
                else
                    local nSkillUpLv = getskilllevelup(actor, skillID)
                    strPanelInfo = strPanelInfo..'<Img|id='..picid..'|children={'..textid1..','..textid2..'}x=0.0|y=0.0|img='..tabpic..'|link=@function_button,'..
                        NPCPANEL_BUTTONFUNC_ID_2..','..skillID..'>'..
                        '<Text|id='..textid1..'|x=6.0|y=12.0|size=18|color='..CSS.NPC_YELLOW..'|text='..magicInfo.MagName..'>'..
                        '<Text|id='..textid2..'|x=80.0|y=14.0|size=15|color='..CSS.NPC_LIGHTGREEN..'|text=('..nSkillUpLv..'阶)>'
                end

                --对应当前选中的页签
                if chooseid == skillID then
                    strPanelInfo = strPanelInfo..GetSingleShowInfo(actor, chooseid)
                end
        
                if listitemidstr ~= '' then
                    listitemidstr = listitemidstr..','
                end
                listitemidstr = listitemidstr..picid

                if IsSkillCanUpgradeOnce(actor, skillID, choosetype) then
                    Player.AddRedPoint(actor, 0, picid, 10, 10)
                else
                    Player.DelRedPoint(actor, 0, picid)
                end
            end
        end
    end    
    strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..listitemidstr..'}|x=64.0|y=60.0|width=130|height=360|margin=0|direction=1>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end


--技能升级一次
local function DoSkillUpgradeOnce(actor, targSkillID)
    local magicCfgInfo = cfg_magic[targSkillID]
    if magicCfgInfo == nil then
        return
    end    
    local skillLv = getskilllevel(actor, targSkillID)
    if skillLv < 0 then
        return
    end
    local cfgKey = SkillUpgrade.GetCfgKey(targSkillID, skillLv)
    local upgradeInfo = cfgSkillUpgrade[cfgKey]    
    if upgradeInfo == nil then
        return
    end
    local skillNextLv = skillLv + 1
    local cfgNextKey = SkillUpgrade.GetCfgKey(targSkillID, skillNextLv)
    local upgradeNextInfo = cfgSkillUpgrade[cfgNextKey]
    if upgradeNextInfo == nil then
        return
    end

    --条件判断
    local currPlayerLv = Player.GetLevel(actor)
    if currPlayerLv < upgradeInfo.needlv then
        Player.SendSelfMsg(actor, '技能升级所需角色等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    if not Player.CheckItemsEnough(actor, upgradeInfo.needitems_tab, '技能升级') then
        return
    end

    --扣除消耗
    Player.TakeItems(actor, upgradeInfo.needitems_tab, '技能升级')

    --升级
    setskillinfo(actor, targSkillID, 1, skillNextLv)
    Player.SendSelfMsg(actor, '技能【'..magicCfgInfo.MagName..'】已成功升到'..skillNextLv..'级！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)    

    --任务触发
    TaskManager.OnSkillUpgrade(actor)
end

--技能进阶一次
local function DoSkillAdvanceUpgradeOnce(actor, targSkillID)
    local magicCfgInfo = cfg_magic[targSkillID]
    if magicCfgInfo == nil then
        return
    end    
    local skillCommonLv = getskilllevel(actor, targSkillID)
    local skillLv = getskilllevelup(actor, targSkillID)
    if (skillLv < 0) or (skillCommonLv < 0) then
        return
    end
    local cfgKey = SkillUpgrade.GetCfgKey(targSkillID, skillLv)
    local upgradeInfo = cfgSkillAdvanceUpgrade[cfgKey]    
    if upgradeInfo == nil then
        return
    end
    local skillNextLv = skillLv + 1
    local cfgNextKey = SkillUpgrade.GetCfgKey(targSkillID, skillNextLv)
    local upgradeNextInfo = cfgSkillAdvanceUpgrade[cfgNextKey]
    if upgradeNextInfo == nil then
        return
    end

    --条件判断
    if skillCommonLv < upgradeInfo.needlv then
        Player.SendSelfMsg(actor, '技能进阶所需技能等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    if not Player.CheckItemsEnough(actor, upgradeInfo.needitems_tab, '技能进阶') then
        return
    end

    if magicCfgInfo.AdvanceLevelVarID and (type(magicCfgInfo.AdvanceLevelVarID) == "number") then
        local id = magicCfgInfo.AdvanceLevelVarID
        if (id < 151) or (id > 180) then
            BF_ExceptionOut('do_skill_advance_upgrade_once: AdvanceLevelVarID error:'..id)
            Player.SendSelfMsg(actor, '技能进阶失败 111', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        else
            setplaydef(actor, 'U'..id, skillNextLv)
        end    
    end

    --扣除消耗
    Player.TakeItems(actor, upgradeInfo.needitems_tab, '技能进阶')

    --进阶
    setskillinfo(actor, targSkillID, 2, skillNextLv)
    
    Player.SendSelfMsg(actor, '技能【'..magicCfgInfo.MagName..'】已成功进到'..skillNextLv..'阶！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)    
end

--处理button回调
function SkillUpgrade.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    
    local funcid = tonumber(sid)
    local nparam = 0
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    if funcid == NPCPANEL_BUTTONFUNC_ID_1 then
        setplaydef(actor, CommonDefine.VAR_N_CHOOSE_OPER_TYPE, nparam)
    elseif funcid == NPCPANEL_BUTTONFUNC_ID_2 then
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, nparam)        
    elseif funcid == NPCPANEL_BUTTONFUNC_ID_3 then
        DoSkillUpgradeOnce(actor, nparam)
    elseif funcid == NPCPANEL_BUTTONFUNC_ID_4 then
        DoSkillAdvanceUpgradeOnce(actor, nparam)
    end
    SkillUpgrade.ShowBasePanel(actor)
end

--返回技能的最大等级，普通等级
function SkillUpgrade.GetAllSkillsMaxLevel(actor)
	local maxlv = 0
	if BF_IsNullObj(actor) then
		return 0
	end

    local skill_list = getallskills(actor)
    for _, skillID in ipairs(skill_list or {}) do
        local skilllv = getskilllevel(actor, skillID)
        if skilllv >= maxlv then
            maxlv = skilllv
        end
    end    
	return maxlv
end

function SkillUpgrade.IsTopIconHaveRedPoint(actor)    
    local skill_list = getallskills(actor)
    local choosetype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_OPER_TYPE)
    local seq = 0
    for _, skillID in ipairs(skill_list or {}) do
        if SkillUpgrade.IsValidUpgradeSkill(actor, skillID) then     
            local magicInfo = cfg_magic[skillID]            
            if magicInfo ~= nil then
                seq = seq + 1
                if IsSkillCanUpgradeOnce(actor, skillID, choosetype) then
                    return true
                end
            end
        end
    end
    return false
end

return SkillUpgrade