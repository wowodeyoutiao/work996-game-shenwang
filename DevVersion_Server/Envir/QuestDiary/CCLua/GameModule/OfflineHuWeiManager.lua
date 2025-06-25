OfflineHuWeiManager = {}


local NPCPANEL_BUTTONFUNC_ID_1 = 1      --升级
local NPCPANEL_BUTTONFUNC_ID_2 = 2      --领取离线奖励

local ZCD_NPC_NAME_LIST = {'武卫', '御卫', '虎卫', '禁卫', '宿卫'}
local ZCD_NPC_LIST = {
    {
        hwtype=1, npcname=ZCD_NPC_NAME_LIST[1], levelvar=CommonDefine.VAR_U_ZCDHW_LEVEL1, abilitygroup=CommonDefine.ABIL_GROUP_HUWEI1, 
        showbagitems={'武卫精魄','金币'}, imgx=226, imgy=40, imgwidth=120, imgheight=180,
    },
    {
        hwtype=2, npcname=ZCD_NPC_NAME_LIST[2], levelvar=CommonDefine.VAR_U_ZCDHW_LEVEL2, abilitygroup=CommonDefine.ABIL_GROUP_HUWEI2, 
        showbagitems={'御卫精魄','金币'}, imgx=220, imgy=40, imgwidth=180, imgheight=180,
    },
    {
        hwtype=3, npcname=ZCD_NPC_NAME_LIST[3], levelvar=CommonDefine.VAR_U_ZCDHW_LEVEL3, abilitygroup=CommonDefine.ABIL_GROUP_HUWEI3,
        showbagitems={'虎卫精魄','金币'}, imgx=210, imgy=40, imgwidth=150, imgheight=180,
    },
    {
        hwtype=4, npcname=ZCD_NPC_NAME_LIST[4], levelvar=CommonDefine.VAR_U_ZCDHW_LEVEL4, abilitygroup=CommonDefine.ABIL_GROUP_HUWEI4, 
        showbagitems={'禁卫精魄','金币'}, imgx=190, imgy=36, imgwidth=175, imgheight=190,
    },
    {
        hwtype=5, npcname=ZCD_NPC_NAME_LIST[5], levelvar=CommonDefine.VAR_U_ZCDHW_LEVEL5, abilitygroup=CommonDefine.ABIL_GROUP_HUWEI5, 
        showbagitems={'宿卫精魄','金币'}, imgx=230, imgy=30, imgwidth=145, imgheight=200,
    },
}

local function GetHuWeiNpcCfg(huweitype)
    for _, value in ipairs(ZCD_NPC_LIST) do
        if value.hwtype == huweitype then
            return value
        end
    end
    return nil
end

local function GetOfflineHuWeiCfgKey(hwtype, hwlevel)
    return hwtype * 1000 + hwlevel
end

local function GetOfflineRewardInfoTab(actor)
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_OFFLINE_REWARD_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    return infoTab
end

function OfflineHuWeiManager.OnResetDay(actor)
    local infoTab = GetOfflineRewardInfoTab(actor)
    local bChanged = false
    for _, value in ipairs(ZCD_NPC_LIST) do
        local hwtype = value.hwtype
        local hwlevel = getplaydef(actor, value.levelvar)
        if hwlevel > 0 then
            local cfgKey = GetOfflineHuWeiCfgKey(hwtype, hwlevel)
            if cfgOfflineHuWei[cfgKey] and (cfgOfflineHuWei[cfgKey].offlineitemname~='') and (cfgOfflineHuWei[cfgKey].offlineitemnum>0) then
                local sHWType = ''..hwtype
                if infoTab[sHWType] ~= nil then
                    infoTab[sHWType].daytotalnum = 0
                    bChanged = true
                end                
            end
        end
    end
    if bChanged then
        local infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_OFFLINE_REWARD_INFO, infoStr)
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, OfflineHuWeiManager.OnResetDay, CommonDefine.FUNC_ID_OFFLINE)



---------------------------通用npc对话----------------------------------------

function OfflineHuWeiManager.ShowRulePanel(actor)    
    local sparam = ''
    local huweitype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
    if cfgHuWeiNpc ~= nil then
        sparam = huweitype..''
    end
    
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel,'..sparam..'>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel,'..sparam..'>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=紫宸殿规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、紫宸殿有5个护卫可供升级。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=2、不同的护卫升级之后除了带来属性提升之外，还会给|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=角色带来不同道具的离线奖励。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=3、护卫的升级条件除了受到角色的等级限制之外，还受|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=到其他护卫的等级限制。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function IsFitUpgradeCondition(actor, conditionstr)
    if (conditionstr == nil) or (conditionstr == '') then
        return false, ''
    end
    local strConditionTab = string.split(conditionstr, '|')
    if strConditionTab == false then
        return false, ''
    end
    
    for _, value in ipairs(strConditionTab) do
        if value ~= '' then
            local strParamList = string.split(value, '#')
            if (strParamList ~= false) and (#strParamList >= 2) then
                local conditionid = tonumber(strParamList[1])
                local conditionvalue = tonumber(strParamList[2])
                if conditionid == 0 then
                    if Player.GetLevel(actor) < conditionvalue then
                        return false, '玩家等级'
                    end
                else
                    local cfgNpc = GetHuWeiNpcCfg(conditionid)
                    if cfgNpc ~= nil then
                        local huweilevel = getplaydef(actor, cfgNpc.levelvar)    
                        if huweilevel < conditionvalue then
                            return false, ZCD_NPC_NAME_LIST[cfgNpc.hwtype]..'等级'
                        end
                    end                    
                end
            end
        end
    end   

    return true
end

local function GetConditionDescStr(actor, conditionstr)
    local descstr = ''
    if (conditionstr == nil) or (conditionstr == '') then
        return descstr
    end
    local strConditionTab = string.split(conditionstr, '|')
    if strConditionTab == false then
        return descstr
    end

    for _, value in ipairs(strConditionTab) do
        if value ~= '' then
            local strParamList = string.split(value, '#')
            if (strParamList ~= false) and (#strParamList >= 2) then
                local tempconstr = ''
                local conditionid = tonumber(strParamList[1])
                local conditionvalue = tonumber(strParamList[2])
                if conditionid == 0 then
                    local currlv = Player.GetLevel(actor)
                    --tempconstr = '角色'..conditionvalue..'级/'..currlv..'级'
                    tempconstr = '角色'..conditionvalue..'级'
                else
                    local cfgNpc = GetHuWeiNpcCfg(conditionid)
                    if cfgNpc ~= nil then
                        local huweilevel = getplaydef(actor, cfgNpc.levelvar)  
                        --tempconstr = ZCD_NPC_NAME_LIST[conditionid]..conditionvalue..'级/'..huweilevel..'级'
                        tempconstr = ZCD_NPC_NAME_LIST[conditionid]..conditionvalue..'级'
                    end                    
                end
                if descstr ~= '' then
                    descstr = descstr..'; '
                end
                descstr = descstr..tempconstr
            end
        end
    end                
    return descstr    
end

function OfflineHuWeiManager.ShowBasePanel(actor, sparam)
    local huweitype = ZCD_NPC_LIST[1].hwtype
    if BF_IsNumberStr(sparam) then
        huweitype = tonumber(sparam)        
    end

    local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
    if cfgHuWeiNpc == nil then
        return
    end
    setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, huweitype)

    local currlv = getplaydef(actor, cfgHuWeiNpc.levelvar)
    local currKey = GetOfflineHuWeiCfgKey(huweitype, currlv)
    local nextlv = currlv + 1
    local nextKey = GetOfflineHuWeiCfgKey(huweitype, nextlv)
    local bCurrIsMaxLv = false
    local cfgCurrLv = cfgOfflineHuWei[currKey]
    if cfgCurrLv == nil then
        release_print("OfflineHuWei no config hwtype:"..huweitype.." level:"..currlv)
        return
    end
    local cfgNextLv = cfgOfflineHuWei[nextKey]
    if cfgNextLv == nil then
        bCurrIsMaxLv = true
    end        

    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16,17,18,19,100}|x=150.0|y=50.0|height=448|show=0|move=0|reset=1|bg=1|img=private/cc_offline/1.png|esc=1|loadDelay=0>'..
        '<Layout|id=11|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..        
        --'<Text|id=13|x=190.0|y=18.0|size=20|color=161|text='..cfgHuWeiNpc.npcname..'>'..
        '<Button|id=18|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

    strPanelInfo = strPanelInfo..Item.GetBagItemsShowInfo(actor, cfgHuWeiNpc.showbagitems, 19)
        
    --左侧列表
    local idstr1 = ''
    for i = 1, #ZCD_NPC_LIST, 1 do
        local ctype = ZCD_NPC_LIST[i].hwtype
        local showname = ZCD_NPC_LIST[i].npcname
        local baseid = 100 + i*5
        local imgid1 = baseid + 1
        local textid1 = baseid + 2
        local imgid2 = baseid + 3
        idstr1 = idstr1..','..baseid
        strPanelInfo = strPanelInfo..'<Layout|id='..baseid..'|children={'..imgid1..','..imgid2..','..textid1..'}|x=0|y=0|width=120|height=106>'..
            '<Img|id='..imgid1..'|x=10.0|y=0.0|img=private/cc_offline/headicon_'..ctype..'.png|link=@show_base_panel,'..ctype..'>'..
            '<Text|id='..textid1..'|x=90|y=80|size=16|color='..CSS.NPC_WHITE..'|text='..showname..'>'
        if i == huweitype then
            strPanelInfo = strPanelInfo..'<Img|id='..imgid2..'|x=10.0|y=0.0|img=private/cc_offline/3.png>'
        end
    end 
    
    strPanelInfo = strPanelInfo..'<ListView|id=100|children={'..idstr1..'}|x=65.0|y=56.0|width=120|height=370|margin=0|direction=1>'
    
    --当前等级属性
    local tempLeftX = 68
    local tempLeftY = 30
    local idstr = '21,22,23'
    strPanelInfo = strPanelInfo..'<Text|id=21|text=当前等级：|size=16|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'..
                           '<Text|id=22|text='..currlv..'|size=16|x='..(tempLeftX+80)..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'
    tempLeftY = tempLeftY + 30
    local currPropDescTable = cfgCurrLv.addprop_desctab
    if #currPropDescTable == 0 then
        strPanelInfo = strPanelInfo..'<Text|id=23|text=无|size=16|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        tempLeftY = tempLeftY + 25
    else
        local currid = 30
        for _, descItem in ipairs(currPropDescTable) do
            currid = currid + 1
            idstr = idstr..','..currid
            strPanelInfo = strPanelInfo..'<Text|id='..currid..'|text='..descItem.desc..'|size=16|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
            tempLeftY = tempLeftY + 25
        end
        if cfgCurrLv.offlineitemname and cfgCurrLv.offlineitemnum then
            currid = currid + 1
            idstr = idstr..','..currid
            strPanelInfo = strPanelInfo..'<Text|id='..currid..'|text=离线收益:'..cfgCurrLv.offlineitemname..'+'..cfgCurrLv.offlineitemnum..'/分钟'..
                '|size=16|x='..(tempLeftX-40)..'|y='..tempLeftY..'|color='..CSS.NPC_LIGHTGREEN..'>'            
        end
        tempLeftY = tempLeftY + 25
    end
    strPanelInfo = strPanelInfo..'<Img|id=91|children={'..idstr..'}|x=20.0|y=60.0|img=private/cc_offline/5.png>'

    --下一等级属性
    local tempRightX = 68
    local tempRightY = 30
    idstr = '24,25,26'
    if bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=24|text=已达到最高等级|size=16|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        tempRightY = tempRightY + 30
    else
        strPanelInfo = strPanelInfo..'<Text|id=25|text=下一等级：|size=16|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'..
                               '<Text|id=26|text='..nextlv..'|size=16|x='..(tempRightX+80)..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        tempRightY = tempRightY + 30
        local nextPropDescTable = cfgNextLv.addprop_desctab
        local currid = 40
        for _, descItem in ipairs(nextPropDescTable) do
            currid = currid + 1
            idstr = idstr..','..currid
            strPanelInfo = strPanelInfo..'<Text|id='..currid..'|text='..descItem.desc..'|size=16|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            tempRightY = tempRightY + 25
        end
        currid = currid + 1
        idstr = idstr..','..currid        
        strPanelInfo = strPanelInfo..'<Text|id='..currid..'|text=离线收益:'..cfgNextLv.offlineitemname..'+'..cfgNextLv.offlineitemnum..'/分钟'..
            '|size=16|x='..(tempRightX-40)..'|y='..tempRightY..'|color='..CSS.NPC_LIGHTGREEN..'>'        
        tempRightY = tempRightY + 25
    end       
    strPanelInfo = strPanelInfo..'<Img|id=92|children={'..idstr..'}|x=360.0|y=60.0|img=private/cc_offline/5.png>'
    strPanelInfo = strPanelInfo..'<Img|id=93|children={94}|x=172.0|y=0.0|img=private/cc_offline/4.png>'..
        '<Text|id=94|text='..cfgHuWeiNpc.npcname..'|size=20|x=100|y=8|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Img|id=95|x='..ZCD_NPC_LIST[huweitype].imgx..'|y='..ZCD_NPC_LIST[huweitype].imgy..
        '|width='..ZCD_NPC_LIST[huweitype].imgwidth..'|height='..ZCD_NPC_LIST[huweitype].imgheight..'|img=private/cc_offline/body_'..huweitype..'.png>'
    strPanelInfo = strPanelInfo..'<Layout|id=15|children={91,92,93,95}|x=200.0|y=56.0|width=580|height=240>'    


    idstr = '51,52,53'
    local tempCurrX = 20
    local tempCurrY = 0
    local itemidstr = ''
    if bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=51|text=已达到最高等级|size=18|x='..(tempCurrX+20)..'|y='..(tempCurrY+40)..'|color='..CSS.NPC_YELLOW..'>'
    else
        local sConditionDesc = GetConditionDescStr(actor, cfgCurrLv.condition)
        strPanelInfo = strPanelInfo..'<Text|id=51|text=升级条件:  '..sConditionDesc..'|size=16|x='..(tempCurrX+20)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        tempCurrY = tempCurrY + 30
        strPanelInfo = strPanelInfo..'<Text|id=52|text=升级消耗:|size=16|x='..(tempCurrX+20)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

        local sTempStr = ''
        sTempStr, itemidstr = Item.GetNeedItemsGridShowInfo(actor, cfgCurrLv.needitems_tab, tempCurrX + 18, tempCurrY + 8, 180, 0.8)
        if sTempStr ~= '' then
            strPanelInfo = strPanelInfo..sTempStr
        end

        tempCurrY = tempCurrY + 50
        strPanelInfo = strPanelInfo..'<Button|id=53|x='..(tempCurrX+60)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..
            '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|size=18|text=升    级|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_1..','..huweitype..'>'
    end
    strPanelInfo = strPanelInfo..'<Layout|id=17|children={'..idstr..','..itemidstr..'}|x=200.0|y=300.0|width=350|height=120>'


    idstr = '61,62,63,64,65,'
    local offlineitemdesc = ''
    if cfgCurrLv.offlineitemname and (cfgCurrLv.offlineitemname ~= '') then    
        local infoTab = GetOfflineRewardInfoTab(actor)
        local sHWType = ''..huweitype
        if infoTab[sHWType] then    
            local dayleftnum = cfgCurrLv.offlinemaxnum - infoTab[sHWType].daytotalnum
            local passseconds = math.max(0, os.time() - infoTab[sHWType].starttime)
            local currnum = cfgCurrLv.offlineitemnum * math.floor(passseconds / 60)
            currnum = math.min(dayleftnum, currnum)    
            offlineitemdesc = 'X'..currnum..'/'..dayleftnum           
        end
    end

    tempCurrX = 30
    tempCurrY = 0
    if offlineitemdesc ~= '' then
        local itemidx = getstditeminfo(cfgCurrLv.offlineitemname, CommonDefine.STDITEMINFO_IDX)
        local imgpath = Item.GetItemImgPath(itemidx)        
        strPanelInfo = strPanelInfo..'<Text|id=61|text=离线收益:|size=16|x='..(tempCurrX+10)..'|y='..(tempCurrY+30)..'|color='..CSS.NPC_WHITE..'>'

        strPanelInfo = strPanelInfo..'<Img|id=62|x='..(tempCurrX+90)..'|y='..(tempCurrY+30)..'|width=24|height=24|img='..imgpath..'>'
        strPanelInfo = strPanelInfo..'<Text|id=63|text='..offlineitemdesc..' |size=16|x='..(tempCurrX+120)..'|y='..(tempCurrY+30)..'|color='..CSS.NPC_WHITE..'>'

        --strPanelInfo = strPanelInfo..'<Text|id=64|text=(收益达到上限后不再累计)|size=16|x='..tempCurrX..'|y='..(tempCurrY+80)..'|color='..CSS.NPC_LIGHTGREEN..'>'       
        strPanelInfo = strPanelInfo..'<Button|id=65|x='..(tempCurrX+40)..'|y='..(tempCurrY+80)..'|color='..CSS.NPC_WHITE..
            '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|size=18|text=收    取|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_2..','..huweitype..'>'
    else
        strPanelInfo = strPanelInfo..'<Text|id=61|text=升级后领取离线收益|size=16|x='..(tempCurrX+10)..'|y='..(tempCurrY+50)..'|color='..CSS.NPC_LIGHTGREEN..'>'
    end
    strPanelInfo = strPanelInfo..'<Layout|id=16|children={'..idstr..'}|x=550.0|y=300.0|width=240|height=120>'

    
    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function DoUpgrade(actor, huweitype)
    local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
    if cfgHuWeiNpc == nil then
        return
    end
    local currlv = getplaydef(actor, cfgHuWeiNpc.levelvar)
    local currKey = GetOfflineHuWeiCfgKey(huweitype, currlv)
    local nextlv = currlv + 1
    local nextKey = GetOfflineHuWeiCfgKey(huweitype, nextlv)
    local cfgCurrLv = cfgOfflineHuWei[currKey]
    if cfgCurrLv == nil then
        return
    end
    local cfgNextLv = cfgOfflineHuWei[nextKey]
    if cfgNextLv == nil then
        Player.SendSelfMsg(actor, cfgHuWeiNpc.npcname..'已达到等级上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    local bConditionFlag, sTip = IsFitUpgradeCondition(actor, cfgCurrLv.condition)
    if not bConditionFlag then
        Player.SendSelfMsg(actor, '升级所需的'..sTip..'不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --升级消耗
    if not Player.CheckItemsEnough(actor, cfgCurrLv.needitems_tab, '护卫升级') then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, cfgCurrLv.needitems_tab, '护卫升级')

    --每日必做计数      
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_OFFLINE, 1)      

    setplaydef(actor, cfgHuWeiNpc.levelvar, nextlv)
    addattlist(actor, cfgHuWeiNpc.abilitygroup, "=", cfgGuanZhi[nextlv].addprop_abstr)
    recalcabilitys(actor)  
    
    if (nextlv==3) or (nextlv==6) or (nextlv==9) or (nextlv==10) then
        sendmovemsg(actor, 1, 251, 0, 270, 1, '玩家 '..Player.GetName(actor)..' 将'..cfgHuWeiNpc.npcname..'提升至'..nextlv..'级，海量资源坐享其成！')
    end

    --升1级开启记录
    if nextlv == 1 then
        local infoTab = GetOfflineRewardInfoTab(actor)

        for _, value in ipairs(ZCD_NPC_LIST) do
            if value.hwtype == huweitype then
                local hwtype = value.hwtype
                local hwlevel = getplaydef(actor, value.levelvar)
                if hwlevel > 0 then
                    local cfgKey = GetOfflineHuWeiCfgKey(hwtype, hwlevel)
                    if cfgOfflineHuWei[cfgKey] and (cfgOfflineHuWei[cfgKey].offlineitemname~='') and (cfgOfflineHuWei[cfgKey].offlineitemnum>0) then
                        local sHWType = ''..hwtype
                        if infoTab[sHWType] == nil then
                            infoTab[sHWType] = {hwtype=hwtype, daytotalnum=0, starttime=os.time()}                
                        end
                    end
                end
                break
            end
        end

        local infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_OFFLINE_REWARD_INFO, infoStr)
    end
end

local function DoGetOfflineReward(actor, huweitype)
    if getbagblank(actor) < 1 then
        Player.SendSelfMsg(actor, '请整理出至少1个背包空格！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
    if cfgHuWeiNpc == nil then
        return
    end
    local currlv = getplaydef(actor, cfgHuWeiNpc.levelvar)
    local currKey = GetOfflineHuWeiCfgKey(huweitype, currlv)
    local cfgCurrLv = cfgOfflineHuWei[currKey]
    if cfgCurrLv == nil then
        return
    end
    if (cfgCurrLv.offlineitemname == '') or (cfgCurrLv.offlineitemnum <= 0) then
        return
    end

    local infoTab = GetOfflineRewardInfoTab(actor)
    local sHWType = ''..huweitype
    if infoTab[sHWType] == nil then
        return
    end

    local difftime = os.time() - infoTab[sHWType].starttime

    if math.abs(os.time() - infoTab[sHWType].starttime) < CommonDefine.OFFLINE_FETCH_MIN_INTERVAL then
        Player.SendSelfMsg(actor, '领取奖励需间隔3分钟！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local dayleftnum = cfgCurrLv.offlinemaxnum - infoTab[sHWType].daytotalnum
    local passseconds = math.max(0, os.time() - infoTab[sHWType].starttime)
    local currnum = cfgCurrLv.offlineitemnum * math.floor(passseconds / 60)
    currnum = math.min(dayleftnum, currnum)    

    if currnum <= 0 then
        Player.SendSelfMsg(actor, '当前无可领取奖励！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return        
    end

    giveitem(actor, cfgCurrLv.offlineitemname, currnum)
    infoTab[sHWType].daytotalnum = infoTab[sHWType].daytotalnum + currnum
    infoTab[sHWType].starttime = os.time()
    local infoStr = tbl2json(infoTab)
    setplaydef(actor, CommonDefine.VAR_T_OFFLINE_REWARD_INFO, infoStr)
    Player.SendSelfMsg(actor, '领取离线奖励！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--处理button回调
function OfflineHuWeiManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    
    local funcid = tonumber(sid)
    local nparam = 0
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    if funcid == NPCPANEL_BUTTONFUNC_ID_1 then
        DoUpgrade(actor, nparam)
        OfflineHuWeiManager.ShowBasePanel(actor, nparam)
    elseif funcid == NPCPANEL_BUTTONFUNC_ID_2 then
        DoGetOfflineReward(actor, nparam)
        OfflineHuWeiManager.ShowBasePanel(actor, nparam)
    end    
end

--是否有快捷提示--升级
function OfflineHuWeiManager.IsHaveQuickTipUpgrade(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_OFFLINE, false) then
        return false
    end

    for _, value in ipairs(ZCD_NPC_LIST) do
        local huweitype = value.hwtype
        local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
        if cfgHuWeiNpc then
            local currlv = getplaydef(actor, cfgHuWeiNpc.levelvar)
            local currKey = GetOfflineHuWeiCfgKey(huweitype, currlv)
            local nextlv = currlv + 1
            local nextKey = GetOfflineHuWeiCfgKey(huweitype, nextlv)
            local cfgCurrLv = cfgOfflineHuWei[currKey]
            local cfgNextLv = cfgOfflineHuWei[nextKey]
            if cfgCurrLv and cfgNextLv then
                --条件判断 以及 升级消耗
                local bConditionFlag = IsFitUpgradeCondition(actor, cfgCurrLv.condition)
                if bConditionFlag and Player.CheckItemsEnough(actor, cfgCurrLv.needitems_tab, '') then
                    return true
                end
            end
        end
    end
    return false
end

--是否有快捷提示--每日奖励
function OfflineHuWeiManager.IsHaveQuickTipReward(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_OFFLINE, false) then
        return false
    end

    for _, value in ipairs(ZCD_NPC_LIST) do
        local huweitype = value.hwtype
        local cfgHuWeiNpc = GetHuWeiNpcCfg(huweitype)
        if cfgHuWeiNpc then
            local currlv = getplaydef(actor, cfgHuWeiNpc.levelvar)
            local currKey = GetOfflineHuWeiCfgKey(huweitype, currlv)
            local cfgCurrLv = cfgOfflineHuWei[currKey]
            if cfgCurrLv and cfgCurrLv.offlineitemname and cfgCurrLv.offlineitemnum and (cfgCurrLv.offlineitemname ~= '') and (cfgCurrLv.offlineitemnum > 0) then
                local infoTab = GetOfflineRewardInfoTab(actor)
                local sHWType = ''..huweitype
                if infoTab[sHWType] ~= nil then
                    local dayleftnum = cfgCurrLv.offlinemaxnum - infoTab[sHWType].daytotalnum
                    local passseconds = math.max(0, os.time() - infoTab[sHWType].starttime)
                    local currnum = cfgCurrLv.offlineitemnum * math.floor(passseconds / 60)
                    currnum = math.min(dayleftnum, currnum)            
                    if currnum > 0 then
                        return true
                    end
                end             
            end
        end
    end
    
    return false
end

function OfflineHuWeiManager.IsTopIconHaveRedPoint(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_OFFLINE, false) then
        return false
    end

    if OfflineHuWeiManager.IsHaveQuickTipUpgrade(actor) == true then
        return true
    end

    if OfflineHuWeiManager.IsHaveQuickTipReward(actor) == true then
        return true
    end

    return false
end

return OfflineHuWeiManager