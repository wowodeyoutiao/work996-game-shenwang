ActivityOpenServer = {}

--functionid
local OPENSERVER_BUTTONFUNC_ID_1 = 1           --领取每日活跃奖励
local OPENSERVER_BUTTONFUNC_ID_2 = 2           --领取每周活跃奖励
local OPENSERVER_BUTTONFUNC_ID_3 = 3           --领取等级目标奖励
local OPENSERVER_BUTTONFUNC_ID_4 = 4           --前往升级的引导
local OPENSERVER_BUTTONFUNC_ID_5 = 5           --领取战力目标奖励
local OPENSERVER_BUTTONFUNC_ID_6 = 6           --前往升级的引导
local OPENSERVER_BUTTONFUNC_ID_7 = 7           --显示每日活跃
local OPENSERVER_BUTTONFUNC_ID_8 = 8           --显示每周活跃
local OPENSERVER_BUTTONFUNC_ID_9 = 9           --显示等级目标
local OPENSERVER_BUTTONFUNC_ID_10 = 10         --显示战力目标

local ACTIVITY_TYPE_DAILY_ACTIVY = 1           --活动类型 每日活跃
local ACTIVITY_TYPE_WEEKLY_ACTIVY = 2          --活动类型 每周活跃
local ACTIVITY_TYPE_LEVEL_TARGET = 3           --活动类型 等级达标
local ACTIVITY_TYPE_POWER_TARGET = 4           --活动类型 战力达标

local ACTIVITY_TYPE_BUTTON_PIC = {
    [1] = {pic1='private/cc_openserver/1.png', pic2='private/cc_openserver/4.png', pic3='private/cc_openserver/6.png', pic4='private/cc_openserver/8.png'},
    [2] = {pic1='private/cc_openserver/2.png', pic2='private/cc_openserver/3.png', pic3='private/cc_openserver/6.png', pic4='private/cc_openserver/8.png'},
    [3] = {pic1='private/cc_openserver/2.png', pic2='private/cc_openserver/4.png', pic3='private/cc_openserver/5.png', pic4='private/cc_openserver/8.png'},
    [4] = {pic1='private/cc_openserver/2.png', pic2='private/cc_openserver/4.png', pic3='private/cc_openserver/6.png', pic4='private/cc_openserver/7.png'},
}

--打开界面
function ActivityOpenServer.OpenPanel(actor)
    --打开界面后，默认显示的应该是什么，后面再优化
    ActivityOpenServer.ShowActivityPanel(actor, ACTIVITY_TYPE_DAILY_ACTIVY)
end

--是否显示功能入口icon
function ActivityOpenServer.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return true
end

local function GetPlayerRewardData(actor, activitytype)
    local varidstr = ''
    if activitytype == ACTIVITY_TYPE_DAILY_ACTIVY then
        varidstr = CommonDefine.VAR_T_OPENSERVER_REWARDDATA1
    elseif activitytype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
        varidstr = CommonDefine.VAR_T_OPENSERVER_REWARDDATA2
    elseif activitytype == ACTIVITY_TYPE_LEVEL_TARGET then
        varidstr = CommonDefine.VAR_T_OPENSERVER_REWARDDATA3
    elseif activitytype == ACTIVITY_TYPE_POWER_TARGET then
        varidstr = CommonDefine.VAR_T_OPENSERVER_REWARDDATA4        
    end
    local datastr = getplaydef(actor, varidstr)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end
    return rewardtab
end

local function GetPlayerCurrValue(actor, activitytype)
    local currvalue = 0
    local tipstr = ''
    if activitytype == ACTIVITY_TYPE_DAILY_ACTIVY then
        local dayonlinetime = getplaydef(actor, CommonDefine.VAR_J_DAY_ONLINE_TIME)        
        local currtime = os.time()
        local lastlogintime = getplaydef(actor, CommonDefine.VAR_U_LAST_LOGIN_TIME)
        local curronlinetime = math.abs(currtime - lastlogintime)
        dayonlinetime = dayonlinetime + curronlinetime
        currvalue = math.floor(dayonlinetime / 60)
        tipstr = '今日在线:'..currvalue..'分钟'
    elseif activitytype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
        currvalue = getplaydef(actor, CommonDefine.VAR_U_LOGINDAYS_IN_WEEK)
        tipstr = '本周登录:'..currvalue..'天'
    elseif activitytype == ACTIVITY_TYPE_LEVEL_TARGET then
        currvalue = Player.GetLevel(actor)
        tipstr = '当前等级:'..currvalue..'级'
    elseif activitytype == ACTIVITY_TYPE_POWER_TARGET then
        currvalue = Player.GetPlayerPower(actor)
        tipstr = '当前战力:'..BF_NumToShowStr(currvalue)
    end 
    return currvalue, tipstr
end

function ActivityOpenServer.ShowActivityPanel(actor, activitytype)
    if BF_IsNullObj(actor) then
        return
    end

    local strPanelInfo = '<Img|id=300|children={11,12,13,14,15,16,17,18,19,50}|x=100.0|y=61.0|move=0|show=0|bg=1|esc=1|reset=1|img=private/cc_openserver/12.png>'..
        '<Layout|id=11|x=693.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=696.0|y=13.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'
 
    local buttonlist = ACTIVITY_TYPE_BUTTON_PIC[activitytype]
    strPanelInfo = strPanelInfo..'<Button|id=13|x=70.0|y=120.0|size=18|mimg='..buttonlist.pic1..'|nimg='..buttonlist.pic1..'|color=255|link=@openserver_button,'..OPENSERVER_BUTTONFUNC_ID_7..'>'..
        '<Button|id=14|x=170.0|y=120.0|size=18|mimg='..buttonlist.pic2..'|nimg='..buttonlist.pic2..'|color=255|link=@openserver_button,'..OPENSERVER_BUTTONFUNC_ID_8..'>'..
        '<Button|id=15|x=270.0|y=120.0|size=18|mimg='..buttonlist.pic3..'|nimg='..buttonlist.pic3..'|color=255|link=@openserver_button,'..OPENSERVER_BUTTONFUNC_ID_9..'>'..
        '<Button|id=16|x=370.0|y=120.0|size=18|mimg='..buttonlist.pic4..'|nimg='..buttonlist.pic4..'|color=255|link=@openserver_button,'..OPENSERVER_BUTTONFUNC_ID_10..'>'        

    local currvalue, tipstr = GetPlayerCurrValue(actor, activitytype)
    strPanelInfo = strPanelInfo..'<Text|id=17|x=500.0|y=130.0|color=255|size=18|text='..tipstr..'>'

    if activitytype == ACTIVITY_TYPE_DAILY_ACTIVY then
        strPanelInfo = strPanelInfo..'<Text|id=18|x=70.0|y=50.0|color=215|size=20|outline=1|text=活动时间：永久>'
        strPanelInfo = strPanelInfo..'<Text|id=19|x=70.0|y=80.0|color=215|size=20|outline=1|text=活动规则：每日累计在线时间达到对应档位即可领奖！>'
    elseif activitytype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
        strPanelInfo = strPanelInfo..'<Text|id=18|x=70.0|y=50.0|color=215|size=20|outline=1|text=活动时间：永久>'
        strPanelInfo = strPanelInfo..'<Text|id=19|x=70.0|y=80.0|color=215|size=20|outline=1|text=活动规则：每周登录次数达到对应档位即可领奖！>'
    elseif activitytype == ACTIVITY_TYPE_LEVEL_TARGET then
        strPanelInfo = strPanelInfo..'<Text|id=18|x=70.0|y=50.0|color=215|size=20|outline=1|text=活动时间：永久>'
        strPanelInfo = strPanelInfo..'<Text|id=19|x=70.0|y=80.0|color=215|size=20|outline=1|text=活动规则：角色等级达到对应档位即可领奖！>'
    elseif activitytype == ACTIVITY_TYPE_POWER_TARGET then
        strPanelInfo = strPanelInfo..'<Text|id=18|x=70.0|y=50.0|color=215|size=20|outline=1|text=活动时间：永久>'
        strPanelInfo = strPanelInfo..'<Text|id=19|x=70.0|y=80.0|color=215|size=20|outline=1|text=活动规则：角色战力达到对应档位即可领奖！>'
    end

    -- 提取所有键
    local keys = {}
    for key in pairs(cfgActivityOpenServer) do
        table.insert(keys, key)
    end
    -- 对键进行排序
    table.sort(keys) 

    local nStartID = 500
    local idstr = ''
    local i = 1
    for _, key in ipairs(keys) do
        local value = cfgActivityOpenServer[key]   
        if value.checktype == activitytype then            
            if idstr ~= '' then
                idstr = idstr..','
            end
            idstr = idstr..(nStartID + i*10)   
            i = i + 1
        end
    end
    strPanelInfo = strPanelInfo..'<ListView|id=50|children={'..idstr..'}|x=58.0|y=163.0|width=600|height=250|direction=1|margin=0>'     

    i = 1
    local currvaluelist = {}
    local rewardtablist = {}
    for i = 1, ACTIVITY_TYPE_POWER_TARGET, 1 do
        currvaluelist[#currvaluelist + 1] = GetPlayerCurrValue(actor, i)
        rewardtablist[#rewardtablist+1] = GetPlayerRewardData(actor, i)
    end
    local PAGE_BUTTON_REDPOINT_FLAG = {false, false,false,false}
    local rewardtab = GetPlayerRewardData(actor, activitytype)    
    for _, key in ipairs(keys) do
        local value = cfgActivityOpenServer[key]
        if value.checktype == activitytype then
            local baseid = nStartID + i*10
            local idstr1 = (baseid+1)..','..(baseid+2)
            for seq1, _ in ipairs(value.rewards_tab) do
                if idstr1 ~= '' then
                    idstr1 = idstr1..','
                end
                idstr1 = idstr1..(baseid + 2 + seq1)
            end
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..idstr1..'}|x=100.0|y=61.0|show=0|img=private/cc_openserver/20.png>'
            
            if activitytype == ACTIVITY_TYPE_DAILY_ACTIVY then
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=每天在线'..value.checknum..'分钟>'
                if currvalue >= value.checknum then
                    if table.indexof(rewardtab, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_openserver/11.png|nimg=private/cc_openserver/11.png|link=@openserver_button,'..
                            OPENSERVER_BUTTONFUNC_ID_1..','..value.id..'>'   
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/10.png>'
                    end
                else
                    strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/9.png>'
                end
            elseif activitytype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=本周登录'..value.checknum..'天>'
                if currvalue >= value.checknum then
                    if table.indexof(rewardtab, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_openserver/11.png|nimg=private/cc_openserver/11.png|link=@openserver_button,'..
                            OPENSERVER_BUTTONFUNC_ID_2..','..value.id..'>'   
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/10.png>'
                    end
                else
                    strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/9.png>'
                end
            elseif activitytype == ACTIVITY_TYPE_LEVEL_TARGET then          
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=角色'..value.checknum..'级可领>'
                if currvalue >= value.checknum then
                    if table.indexof(rewardtab, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_openserver/11.png|nimg=private/cc_openserver/11.png|link=@openserver_button,'..
                            OPENSERVER_BUTTONFUNC_ID_3..','..value.id..'>'                    
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/10.png>'
                    end
                else
                    strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|color=255|size=15|text=前往升级|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@openserver_button,'..
                        OPENSERVER_BUTTONFUNC_ID_4..','..value.id..'>'
                end
            elseif activitytype == ACTIVITY_TYPE_POWER_TARGET then
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=战力'..BF_NumToShowStr(value.checknum)..'可领>'
                if currvalue >= value.checknum then
                    if table.indexof(rewardtab, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_openserver/11.png|nimg=private/cc_openserver/11.png|link=@openserver_button,'..
                            OPENSERVER_BUTTONFUNC_ID_5..','..value.id..'>'                    
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else      
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_openserver/10.png>'
                    end
                else
                    strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|color=255|size=15|text=前往提升|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@openserver_button,'..
                        OPENSERVER_BUTTONFUNC_ID_6..','..value.id..'>'                    
                end
            end
    
            for seq1, singleitem in ipairs(value.rewards_tab) do
                local itemidx = getstditeminfo(singleitem.name, CommonDefine.STDITEMINFO_IDX)
                local currx = 20 + 80 * (seq1-1)
                strPanelInfo = strPanelInfo..'<ItemShow|id='..(baseid+2+seq1)..'|x='..currx..'|y=10|itemid='..itemidx..'|itemcount='..singleitem.num..'|bgtype=1|showtips=1>'
            end
            i = i + 1
        else
            if PAGE_BUTTON_REDPOINT_FLAG[value.checktype] == false then
                if currvaluelist[value.checktype] >= value.checknum then
                    if table.indexof(rewardtablist[value.checktype], value.id) == false then
                        PAGE_BUTTON_REDPOINT_FLAG[value.checktype] = true
                    end
                end                
            end
        end
    end  

    for ctype = 1, #PAGE_BUTTON_REDPOINT_FLAG, 1 do        
        if PAGE_BUTTON_REDPOINT_FLAG[ctype] == true then
            if ctype == ACTIVITY_TYPE_DAILY_ACTIVY then
                Player.AddRedPoint(actor, 0, 13, 10, 10)
            elseif ctype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
                Player.AddRedPoint(actor, 0, 14, 10, 10)
            elseif ctype == ACTIVITY_TYPE_LEVEL_TARGET then
                Player.AddRedPoint(actor, 0, 15, 10, 10)
            elseif ctype == ACTIVITY_TYPE_POWER_TARGET then
                Player.AddRedPoint(actor, 0, 16, 10, 10)                
            end
        end
    end    
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function ActivityOpenServer.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local id = 0
    if BF_IsNumberStr(sparam) then
        id = tonumber(sparam)
    end

    if funcid == OPENSERVER_BUTTONFUNC_ID_1 then
        if id ~= 0 then
            ActivityOpenServer.GetRechargeReward(actor, ACTIVITY_TYPE_DAILY_ACTIVY, id)        
        end
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_2 then
        if id ~= 0 then
            ActivityOpenServer.GetRechargeReward(actor, ACTIVITY_TYPE_WEEKLY_ACTIVY, id)        
        end     
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_3 then
        if id ~= 0 then
            ActivityOpenServer.GetRechargeReward(actor, ACTIVITY_TYPE_LEVEL_TARGET, id)        
        end  
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_4 then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_UPGRADE_LEVEL)        
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_5 then
        if id ~= 0 then
            ActivityOpenServer.GetRechargeReward(actor, ACTIVITY_TYPE_POWER_TARGET, id)        
        end       
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_6 then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_INCREASE_POWER)
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_7 then
        ActivityOpenServer.ShowActivityPanel(actor, ACTIVITY_TYPE_DAILY_ACTIVY)
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_8 then
        ActivityOpenServer.ShowActivityPanel(actor, ACTIVITY_TYPE_WEEKLY_ACTIVY)
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_9 then
        ActivityOpenServer.ShowActivityPanel(actor, ACTIVITY_TYPE_LEVEL_TARGET)
    elseif funcid == OPENSERVER_BUTTONFUNC_ID_10 then                        
        ActivityOpenServer.ShowActivityPanel(actor, ACTIVITY_TYPE_POWER_TARGET)
    end  
end

--领取奖励
function ActivityOpenServer.GetRechargeReward(actor, activitytype, id)
    if BF_IsNullObj(actor) then
        return
    end

    local rewardtab = GetPlayerRewardData(actor, activitytype)
    local currvalue = GetPlayerCurrValue(actor, activitytype)
    for _, value in pairs(cfgActivityOpenServer) do
        if value.id == id then       
            if currvalue >= value.checknum then
                if table.indexof(rewardtab, id) == false then
                    rewardtab[#rewardtab+1] = id
                    Player.GiveItemsToBagOrMail(actor, value.rewards_tab, '开服活动：'..id)
                    local datastr = tbl2json(rewardtab)
                    if activitytype == ACTIVITY_TYPE_DAILY_ACTIVY then
                        setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA1, datastr)
                    elseif activitytype == ACTIVITY_TYPE_WEEKLY_ACTIVY then
                        setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA2, datastr)
                    elseif activitytype == ACTIVITY_TYPE_LEVEL_TARGET then
                        setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA3, datastr)
                    elseif activitytype == ACTIVITY_TYPE_POWER_TARGET then
                        setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA4, datastr)
                    end
                    ActivityOpenServer.ShowActivityPanel(actor, activitytype)
                end
            end
            break            
        end
    end
end

--玩家登录时触发
function ActivityOpenServer.OnPlayerEnterGame(actor)	
	local currtime = os.time()
    setplaydef(actor, CommonDefine.VAR_U_LAST_LOGIN_TIME, currtime)
end

--玩家离线时触发
function ActivityOpenServer.OnPlayerLeaveGame(actor)
	local currtime = os.time()
    local lastlogintime = getplaydef(actor, CommonDefine.VAR_U_LAST_LOGIN_TIME)
    local onlinetime = math.abs(currtime - lastlogintime)
    if onlinetime > 0 then
        local dayonlinetime = getplaydef(actor, CommonDefine.VAR_J_DAY_ONLINE_TIME) + onlinetime
        setplaydef(actor, CommonDefine.VAR_J_DAY_ONLINE_TIME, dayonlinetime)
    end
end

--玩家跨天回调
function ActivityOpenServer.OnResetDay(actor)    
    local logindays = getplaydef(actor, CommonDefine.VAR_U_LOGINDAYS_IN_WEEK) + 1
    setplaydef(actor, CommonDefine.VAR_U_LOGINDAYS_IN_WEEK, logindays)

    local currtime = os.time()
    setplaydef(actor, CommonDefine.VAR_U_LAST_LOGIN_TIME, currtime)    

    --清理每日奖励的领取状态
    setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA1, '')
end

--玩家跨周回调
function ActivityOpenServer.OnResetWeek(actor)    
    --清理每周奖励的领取状态
    setplaydef(actor, CommonDefine.VAR_T_OPENSERVER_REWARDDATA2, '')
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, ActivityOpenServer.OnPlayerEnterGame, CommonDefine.FUNC_ID_OPEN_SERVER)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_LEAVEGAME, ActivityOpenServer.OnPlayerLeaveGame, CommonDefine.FUNC_ID_OPEN_SERVER)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, ActivityOpenServer.OnResetDay, CommonDefine.FUNC_ID_OPEN_SERVER)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETWEEK, ActivityOpenServer.OnResetWeek, CommonDefine.FUNC_ID_OPEN_SERVER)


function ActivityOpenServer.IsTopIconHaveRedPoint(actor)
    local currvaluelist = {}
    local rewardtablist = {}
    for i = 1, ACTIVITY_TYPE_POWER_TARGET, 1 do
        currvaluelist[#currvaluelist + 1] = GetPlayerCurrValue(actor, i)
        rewardtablist[#rewardtablist+1] = GetPlayerRewardData(actor, i)
    end

    for _, value in pairs(cfgActivityOpenServer) do
        if currvaluelist[value.checktype] >= value.checknum then
            if table.indexof(rewardtablist[value.checktype], value.id) == false then
                return true
            end
        end
    end

    return false
end

return ActivityOpenServer