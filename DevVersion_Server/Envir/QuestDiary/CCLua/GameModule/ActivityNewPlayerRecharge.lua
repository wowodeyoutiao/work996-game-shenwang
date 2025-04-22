ActivityNewPlayerRecharge = {}

--functionid
local NEWPLAYERRECHARGE_BUTTONFUNC_ID_1 = 1    --显示单充返利信息
local NEWPLAYERRECHARGE_BUTTONFUNC_ID_2 = 2    --显示累充返利信息
local NEWPLAYERRECHARGE_BUTTONFUNC_ID_3 = 3    --前往充值
local NEWPLAYERRECHARGE_BUTTONFUNC_ID_4 = 4    --领取对应的单充奖励
local NEWPLAYERRECHARGE_BUTTONFUNC_ID_5 = 5    --领取对应的累充奖励


local MAX_ACTIVITY_LOGIN_DAY = 999               --活动的最大天数
local ACTIVITY_TYPE_SINGLE_RECHARGE = 1        --活动类型 单充
local ACTIVITY_TYPE_TOTAL_RECHARGE = 2         --活动类型 累充

--返回当前的进入游戏天数
function ActivityNewPlayerRecharge.GetLoginDay(actor)
    local currLoginDay = 0
    local firstLoginDay = getplaydef(actor, CommonDefine.VAR_U_FIRST_LOGIN_DAY)
    if firstLoginDay > 0 then
        local currday = BF_GetDay(os.time())
        if currday >= firstLoginDay then
            currLoginDay = currday - firstLoginDay + 1
        end
    end
    return currLoginDay
end

--打开界面
function ActivityNewPlayerRecharge.OpenPanel(actor)
    --打开界面后，默认显示的应该是什么，后面再优化
    ActivityNewPlayerRecharge.ShowActivityPanel(actor, ACTIVITY_TYPE_SINGLE_RECHARGE)
end

--是否显示功能入口icon
function ActivityNewPlayerRecharge.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    local currLoginDay = ActivityNewPlayerRecharge.GetLoginDay(actor)
    if currLoginDay > MAX_ACTIVITY_LOGIN_DAY then
        --还要判断是否已经有奖励未领取？？？？
        --还要判断是否已经有奖励未领取？？？？
        --还要判断是否已经有奖励未领取？？？？
        return false
    end
    return true
end

function ActivityNewPlayerRecharge.ShowActivityPanel(actor, activitytype)
    if BF_IsNullObj(actor) then
        return
    end

    local strPanelInfo = '<Img|id=300|children={10,20,30,40,50,60}|x=100.0|y=61.0|move=0|show=0|bg=1|esc=1|reset=1|img=private/cc_newplayer_recharge/1.png>'..
        '<Layout|id=10|x=693.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=20|x=696.0|y=13.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'
             
    local singlerecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_SINGLE)
    local totalrecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_TOTAL)        
    if activitytype == ACTIVITY_TYPE_SINGLE_RECHARGE then
        strPanelInfo = strPanelInfo..'<Button|id=30|x=76.0|y=119.0|size=18|mimg=private/cc_newplayer_recharge/2.png|nimg=private/cc_newplayer_recharge/2.png|color=255|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_1..'>'..
            '<Button|id=40|x=197.0|y=119.0|size=18|mimg=private/cc_newplayer_recharge/5.png|nimg=private/cc_newplayer_recharge/5.png|color=255|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_2..'>'..
            '<Text|id=60|x=320.0|y=125.0|color=255|size=18|text=当前最大单笔充值'..singlerecharge ..'元>'
    else
        strPanelInfo = strPanelInfo..'<Button|id=30|x=76.0|y=119.0|size=18|mimg=private/cc_newplayer_recharge/3.png|nimg=private/cc_newplayer_recharge/3.png|color=255|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_1..'>'..
            '<Button|id=40|x=197.0|y=119.0|size=18|mimg=private/cc_newplayer_recharge/4.png|nimg=private/cc_newplayer_recharge/4.png|color=255|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_2..'>'..
            '<Text|id=60|x=320.0|y=125.0|color=255|size=18|text=当前最大累计充值'..totalrecharge ..'元>'
    end

    -- 提取所有键
    local keys = {}
    for key in pairs(cfgActivityNewPlayerRecharge) do
        table.insert(keys, key)
    end
    -- 对键进行排序
    table.sort(keys) 

    local nStartID = 500
    local idstr = ''
    local i = 1
    for _, key in ipairs(keys) do
        local value = cfgActivityNewPlayerRecharge[key]   
        if value.checktype == activitytype then            
            if idstr ~= '' then
                idstr = idstr..','
            end
            idstr = idstr..(nStartID + i*10)   
            i = i + 1
        end
    end
    strPanelInfo = strPanelInfo..'<ListView|id=50|children={'..idstr..'}|x=58.0|y=163.0|width=600|height=250|direction=1|margin=0>'   

    local datastr1 = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA)    
    local datastr2 = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA)
    local singletab1 = {}
    if datastr1 ~= '' then
        singletab1 = json2tbl(datastr1)
    end
    local singletab2 = {}
    if datastr2 ~= '' then
        singletab2 = json2tbl(datastr2)
    end

    local PAGE_BUTTON_REDPOINT_FLAG = {false, false}
    i = 1    
    for _, key in ipairs(keys) do
        local value = cfgActivityNewPlayerRecharge[key]
        if value.checktype == activitytype then
            local baseid = nStartID + i*10
            local idstr1 = (baseid+1)..','..(baseid+2)
            for seq1, _ in ipairs(value.rewards_tab) do
                if idstr1 ~= '' then
                    idstr1 = idstr1..','
                end
                idstr1 = idstr1..(baseid + 2 + seq1)
            end
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..idstr1..'}|x=100.0|y=61.0|show=0|img=private/cc_newplayer_recharge/20.png>'        
            if activitytype == ACTIVITY_TYPE_SINGLE_RECHARGE then
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=单笔充值'..value.checknum ..'元>'
                if singlerecharge >= value.checknum then
                    if table.indexof(singletab1, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_newplayer_recharge/7.png|nimg=private/cc_newplayer_recharge/7.png|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_4..','..value.id..'>'                    
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else      
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_newplayer_recharge/8.png>'
                    end
                else
                    strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_newplayer_recharge/6.png|nimg=private/cc_newplayer_recharge/6.png|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_3..'>'
                end
            else
                strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x=480.0|y=10.0|color=255|size=15|text=累计充值'..value.checknum ..'元>'
                if totalrecharge >= value.checknum then
                    if table.indexof(singletab2, value.id) == false then
                        strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_newplayer_recharge/7.png|nimg=private/cc_newplayer_recharge/7.png|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_5..','..value.id..'>'
                        Player.AddRedPoint(actor, 0, (baseid+2), 10, 10)
                        PAGE_BUTTON_REDPOINT_FLAG[activitytype] = true
                    else
                        strPanelInfo = strPanelInfo..'<Img|id='..(baseid+2)..'|x=480.0|y=35.0|show=0|img=private/cc_newplayer_recharge/8.png>'                    
                    end
                else
                    strPanelInfo = strPanelInfo..'<Button|id='..(baseid+2)..'|x=480.0|y=35.0|mimg=private/cc_newplayer_recharge/6.png|nimg=private/cc_newplayer_recharge/6.png|link=@newplayer_recharge_button,'..NEWPLAYERRECHARGE_BUTTONFUNC_ID_3..'>'
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
                if value.checktype == ACTIVITY_TYPE_SINGLE_RECHARGE then
                    if singlerecharge >= value.checknum then
                        if table.indexof(singletab1, value.id) == false then
                            PAGE_BUTTON_REDPOINT_FLAG[value.checktype] = true
                        end
                    end
                else
                    if totalrecharge >= value.checknum then
                        if table.indexof(singletab2, value.id) == false then
                            PAGE_BUTTON_REDPOINT_FLAG[value.checktype] = true      
                        end
                    end            
                end                 
            end         
        end
    end

    for ctype = 1, #PAGE_BUTTON_REDPOINT_FLAG, 1 do        
        if PAGE_BUTTON_REDPOINT_FLAG[ctype] == true then
            if ctype == ACTIVITY_TYPE_SINGLE_RECHARGE then
                Player.AddRedPoint(actor, 0, 30, 10, 10)
            elseif ctype == ACTIVITY_TYPE_TOTAL_RECHARGE then
                Player.AddRedPoint(actor, 0, 40, 10, 10)
            end
        end
    end
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function ActivityNewPlayerRecharge.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)
    if funcid == NEWPLAYERRECHARGE_BUTTONFUNC_ID_1 then
        ActivityNewPlayerRecharge.ShowActivityPanel(actor, ACTIVITY_TYPE_SINGLE_RECHARGE)
    elseif funcid == NEWPLAYERRECHARGE_BUTTONFUNC_ID_2 then
        ActivityNewPlayerRecharge.ShowActivityPanel(actor, ACTIVITY_TYPE_TOTAL_RECHARGE)
    elseif funcid == NEWPLAYERRECHARGE_BUTTONFUNC_ID_3 then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_RECHARGE)
    elseif funcid == NEWPLAYERRECHARGE_BUTTONFUNC_ID_4 then
        if not BF_IsNumberStr(sparam) then
            return
        end
        local id = tonumber(sparam)
        ActivityNewPlayerRecharge.GetRechargeReward(actor, ACTIVITY_TYPE_SINGLE_RECHARGE, id)
    elseif funcid == NEWPLAYERRECHARGE_BUTTONFUNC_ID_5 then
        if not BF_IsNumberStr(sparam) then
            return
        end
        local id = tonumber(sparam)
        ActivityNewPlayerRecharge.GetRechargeReward(actor, ACTIVITY_TYPE_TOTAL_RECHARGE, id)
    end
end

--领取奖励
function ActivityNewPlayerRecharge.GetRechargeReward(actor, activitytype, id)
    if BF_IsNullObj(actor) then
        return
    end
    local currnum = 0
    local rewarddata = {}    
    if activitytype == ACTIVITY_TYPE_SINGLE_RECHARGE then
        currnum = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_SINGLE)        
        local datastr = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA)        
        if datastr ~= '' then
            rewarddata = json2tbl(datastr)
        end
    else
        currnum = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_TOTAL)
        local datastr = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA)        
        if datastr ~= '' then
            rewarddata = json2tbl(datastr)
        end
    end
    for _, value in pairs(cfgActivityNewPlayerRecharge) do
        if (value.checktype == activitytype) and  (value.id == id) then       
            if currnum >= value.checknum then
                if table.indexof(rewarddata, id) == false then
                    rewarddata[#rewarddata+1] = id
                    Player.GiveItemsToBagOrMail(actor, value.rewards_tab, '新人充值返利')
                    local datastr = tbl2json(rewarddata)
                    if activitytype == ACTIVITY_TYPE_SINGLE_RECHARGE then
                        setplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA, datastr)
                    else
                        setplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA, datastr)
                    end
                    ActivityNewPlayerRecharge.ShowActivityPanel(actor, activitytype)
                end
            end
            break            
        end
    end
end

--触发充值
function ActivityNewPlayerRecharge.DoRecharge(actor, gold, productid, isreal)
    if gold > 0 then
        --超过新手活动时间的充值无效
        local currLoginDay = ActivityNewPlayerRecharge.GetLoginDay(actor)
        if currLoginDay > MAX_ACTIVITY_LOGIN_DAY then
            return
        end
        
        local singlerecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_SINGLE)
        local totalrecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_TOTAL)
        if gold > singlerecharge then
            setplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_SINGLE, gold)            
        end
        setplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_TOTAL, totalrecharge + gold)
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_DO_RECHARGE, ActivityNewPlayerRecharge.DoRecharge, CommonDefine.FUNC_ID_NEWPLAYER_RECHARGE)

function ActivityNewPlayerRecharge.IsTopIconHaveRedPoint(actor)
    local datastr1 = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA)    
    local datastr2 = getplaydef(actor, CommonDefine.VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA)
    local singletab1 = {}
    if datastr1 ~= '' then
        singletab1 = json2tbl(datastr1)
    end
    local singletab2 = {}
    if datastr2 ~= '' then
        singletab2 = json2tbl(datastr2)
    end

    local singlerecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_SINGLE)
    local totalrecharge = getplaydef(actor, CommonDefine.VAR_U_NEWPLAYER_RECHARGE_TOTAL)       

    for _, value in pairs(cfgActivityNewPlayerRecharge) do
        if value.checktype == ACTIVITY_TYPE_SINGLE_RECHARGE then
            if singlerecharge >= value.checknum then
                if table.indexof(singletab1, value.id) == false then
                    return true
                end
            end
        else
            if totalrecharge >= value.checknum then
                if table.indexof(singletab2, value.id) == false then
                    return true            
                end
            end            
        end
    end

    return false
end

return ActivityNewPlayerRecharge