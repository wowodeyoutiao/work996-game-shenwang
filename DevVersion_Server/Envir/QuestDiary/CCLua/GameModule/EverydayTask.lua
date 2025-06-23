EverydayTask = {}

--functionid
local EVERYDAYTASK_BUTTONFUNC_ID_1 = 1           --领取单个任务完成的奖励
local EVERYDAYTASK_BUTTONFUNC_ID_2 = 2           --单个任务的立即前往
local EVERYDAYTASK_BUTTONFUNC_ID_3 = 3           --领取任务完成数量达成的奖励

local TASK_STATUS_NOT_OPEN = 1                   --等级不足，不能开启
local TASK_STATUS_NOT_FINISH = 2                 --未完成，请前往
local TASK_STATUS_FINISHED = 3                   --已完成，待领取奖励
local TASK_STATUS_GET_REWARD = 4                 --奖励已领取

local TASK_FINAL_REWARDITEMS = 
{
    [1] = {targnum = 5, rewarditems={{name='藏宝图', num=3}}},
    [2] = {targnum = 10, rewarditems={{name='绑定元宝', num=500},{name='升星石', num=100}}},
}

--打开界面
function EverydayTask.OpenPanel(actor)
    EverydayTask.ShowActivityPanel(actor)
end

--是否显示功能入口icon
function EverydayTask.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return true
end

local function GetSingleTaskStatus(actor, taskid, countertab, rewardtab)
    if BF_IsNullObj(actor) or (taskid==nil) or (countertab==nil) or (rewardtab==nil) then
        return TASK_STATUS_NOT_OPEN, 0
    end
    local singletask = cfgEverydayTask[taskid]
    if singletask == nil then
        return TASK_STATUS_NOT_OPEN, 0
    end

    if table.indexof(rewardtab, taskid) ~= false then
        return TASK_STATUS_GET_REWARD, 0
    else
        local bIsOpen, wNeedLv = Player.IsFunctionOpen(actor, singletask.tasktype, false)
        if not bIsOpen then
            return TASK_STATUS_NOT_OPEN, wNeedLv
        end

        local currnum = 0
        local sid = taskid..''
        if countertab[sid] then
            currnum = countertab[sid]
        end
        --[[
        if currnum >= singletask.tasktargnum then
            return TASK_STATUS_FINISHED, 0
        else
            return TASK_STATUS_NOT_FINISH, 0
        end
        ]]--
        return TASK_STATUS_FINISHED, 0
    end
end

function EverydayTask.ShowActivityPanel(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local strPanelInfo = '<Img|id=20|children={21,22,23,25,26,27,28,29,30,31,32}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|show=0|bg=1|reset=1|move=0|esc=1|loadDelay=1|img=private/cc_everyday_task/9.png>'..
        '<Layout|id=21|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=22|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Img|id=23|children={24}|ax=0|x=82|y=88.0|img=private/cc_everyday_task/12.png>'..        
        '<Img|id=25|ax=0|x=660|y=60|img=private/cc_everyday_task/10.png>'        

    local datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA)
    local countertab = {}
    if datastr ~= '' then
        countertab = json2tbl(datastr)
    end  
    datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end    

    local nCurrFinishedTaskNum = #rewardtab
    local nTotalTaskNum = #cfgEverydayTask
    local nTargTaskNum1 = TASK_FINAL_REWARDITEMS[1].targnum
    local itemid1 = getstditeminfo(TASK_FINAL_REWARDITEMS[1].rewarditems[1].name, CommonDefine.STDITEMINFO_IDX)
    local itemcount1 = TASK_FINAL_REWARDITEMS[1].rewarditems[1].num
    local nTargTaskNum2 = TASK_FINAL_REWARDITEMS[2].targnum
    local itemid2 = getstditeminfo(TASK_FINAL_REWARDITEMS[2].rewarditems[1].name, CommonDefine.STDITEMINFO_IDX)
    local itemcount2 = TASK_FINAL_REWARDITEMS[2].rewarditems[1].num    
    local progresswidth = math.floor(400 * nCurrFinishedTaskNum / TASK_FINAL_REWARDITEMS[#TASK_FINAL_REWARDITEMS].targnum)
    strPanelInfo = strPanelInfo..'<Text|id=26|x=510.0|y=70.0|size=18|color=255|text=当前：'..nCurrFinishedTaskNum..'/'..nTotalTaskNum..'>'..        
        '<Text|id=27|ax=0|x=90|y=80.0|size=18|color=255|text=完成'..nTargTaskNum1..'个可领取>'..        
        '<Text|id=28|ax=0|x=288.0|y=80.0|size=18|color=255|text=完成'..nTargTaskNum2..'个可领取>'..
        '<ItemShow|id=29|x=220.0|y=60.0|width=70|height=70|itemid='..itemid1..'|itemcount='..itemcount1..'|bgtype=1>'..
        '<ItemShow|id=30|x=420.0|y=60.0|width=70|height=70|itemid='..itemid2..'|itemcount='..itemcount2..'|bgtype=1>'..
        '<Img|id=24|ax=0|x=2|y=36|width='..progresswidth..'|img=private/cc_everyday_task/11.png>'

    local nFinalRewardIdx = getplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX)
    if nFinalRewardIdx == 0 then
        if nCurrFinishedTaskNum >= nTargTaskNum1 then
            strPanelInfo = strPanelInfo..'<Button|id=31|x=510.0|y=110.0|text=领取奖励|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..EVERYDAYTASK_BUTTONFUNC_ID_3..'>'
            Player.AddRedPoint(actor, 0, 31, 10, 10)
        else
            strPanelInfo = strPanelInfo..'<Text|id=31|ax=0|x=510|y=110.0|size=18|color='..CSS.NPC_YELLOW..'|text=无可领取奖励>'
        end
    elseif nFinalRewardIdx == 1 then
        if nCurrFinishedTaskNum >= nTargTaskNum2 then
            strPanelInfo = strPanelInfo..'<Button|id=31|x=510.0|y=110.0|text=领取奖励|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..EVERYDAYTASK_BUTTONFUNC_ID_3..'>'
            Player.AddRedPoint(actor, 0, 31, 10, 10)
        else
            strPanelInfo = strPanelInfo..'<Text|id=31|ax=0|x=510|y=110.0|size=18|color='..CSS.NPC_YELLOW..'|text=无可领取奖励>'
        end
    elseif nFinalRewardIdx >= 2 then
        strPanelInfo = strPanelInfo..'<Text|id=31|ax=0|x=510|y=110.0|size=18|color='..CSS.NPC_LIGHTGREEN..'|text=奖励已领完>'
    end            

    -- 提取所有键
    local keys = {}
    for key in pairs(cfgEverydayTask) do
        table.insert(keys, key)
    end
    -- 对键进行排序
    table.sort(keys)   
    
    local nStartID = 500
    local idstr = ''
    for seq, _ in ipairs(keys) do
        if idstr ~= '' then
            idstr = idstr..','
        end
        idstr = idstr..(nStartID + seq*20)   
    end    
    strPanelInfo = strPanelInfo..'<ListView|id=32|children={'..idstr..'}|x=60.0|y=160.0|width=760|height=340|direction=1|margin=0>'
    
    for seq, key in ipairs(keys) do
        local value = cfgEverydayTask[key]
        local baseid = nStartID + seq*20
        local idstr1 = (baseid+1)..','..(baseid+2)..','..(baseid+3)..','..(baseid+4)..','..(baseid+5)
        local nCount = 5
        for seq1, _ in ipairs(value.finishrewards_tab) do
            if idstr1 ~= '' then
                idstr1 = idstr1..','
            end
            idstr1 = idstr1..(baseid + nCount + seq1)
        end
        local tempseq = seq % 4 + 1
        strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..idstr1..'}|x=100.0|y=61.0|show=0|img=private/cc_everyday_task/lan_'..tempseq..'.png>'

        local innerx = 100
        local taskcurrnum = 0
        local sid = key..''
        if countertab[sid] then
            taskcurrnum = countertab[sid]
        end
        taskcurrnum = math.min(value.tasktargnum, taskcurrnum)
        strPanelInfo = strPanelInfo..'<Text|id='..(baseid+1)..'|x='..(innerx + 20)..'|y=8.0|color='..CSS.NPC_YELLOW..'|size=20|text='..value.tasktitle..'>'..
            '<Text|id='..(baseid+2)..'|x='..(innerx + 20)..'|y=50.0|color='..CSS.NPC_WHITE..'|size=15|text='..value.taskdesc..'>'..
            '<Text|id='..(baseid+3)..'|x='..(innerx + 150)..'|y=12.0|color='..CSS.NPC_WHITE..'|size=15|text=进度：'..taskcurrnum..'/'..value.tasktargnum..'>'
        
        local status, param = GetSingleTaskStatus(actor, value.id, countertab, rewardtab)
        if status == TASK_STATUS_NOT_OPEN then
            strPanelInfo = strPanelInfo..'<Text|id='..(baseid+4)..'|x='..(innerx + 500)..'|y=30.0|color='..CSS.NPC_GRAY..'|size=20|text='..param..'级开启>'
        elseif status == TASK_STATUS_NOT_FINISH then
            strPanelInfo = strPanelInfo..'<Button|id='..(baseid+4)..'|x='..(innerx + 510)..'|y=25.0|text=前往|pimg=private/cc_common/button_down1.png|mimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_up1.png|link=@function_button,'..
                EVERYDAYTASK_BUTTONFUNC_ID_2..','..value.id..'>'
        elseif status == TASK_STATUS_FINISHED then
            strPanelInfo = strPanelInfo..'<Button|id='..(baseid+4)..'|x='..(innerx + 510)..'|y=25.0|text=领取|pimg=private/cc_common/button_down1.png|mimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_up1.png|link=@function_button,'..
                EVERYDAYTASK_BUTTONFUNC_ID_1..','..value.id..'>'
            Player.AddRedPoint(actor, 0, (baseid+4), 10, 10)
        elseif status == TASK_STATUS_GET_REWARD then
            strPanelInfo = strPanelInfo..'<Text|id='..(baseid+4)..'|x='..(innerx + 510)..'|y=30.0|color='..CSS.NPC_LIGHTGREEN..'|size=20|text=已领取>'
        end
        
        for seq1, singleitem in ipairs(value.finishrewards_tab) do
            local itemidx = getstditeminfo(singleitem.name, CommonDefine.STDITEMINFO_IDX)
            local currx = innerx + 400 - 70 * (seq1-1)
            strPanelInfo = strPanelInfo..'<ItemShow|id='..(baseid+nCount+seq1)..'|x='..currx..'|y=5|width=15|height=15|itemid='..itemidx..'|itemcount='..singleitem.num..'|bgtype=1|showtips=1>'
        end
    end    

    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function EverydayTask.DoOperButton(actor, sid, sparam) 
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)
    local taskid = 0
    if BF_IsNumberStr(sparam) then
        taskid = tonumber(sparam)
    end
    if funcid == EVERYDAYTASK_BUTTONFUNC_ID_1 then
        local taskinfo = cfgEverydayTask[taskid]
        if taskinfo then         
            local datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA)
            local countertab = {}
            if datastr ~= '' then
                countertab = json2tbl(datastr)
            end  
            datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA)
            local rewardtab = {}
            if datastr ~= '' then
                rewardtab = json2tbl(datastr)
            end             
            local status, _ = GetSingleTaskStatus(actor, taskid, countertab, rewardtab)
            if status ~= TASK_STATUS_FINISHED then
                Player.SendSelfMsg(actor, '无奖励可领取', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
                EverydayTask.ShowActivityPanel(actor)
                return
            end

            Player.GiveItemsToBagOrMail(actor, taskinfo.finishrewards_tab, '每日必做单任务:'..taskid)
            rewardtab[#rewardtab+1] = taskid
            datastr = tbl2json(rewardtab)
            setplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA, datastr)
            EverydayTask.ShowActivityPanel(actor)
        end        
    elseif funcid == EVERYDAYTASK_BUTTONFUNC_ID_2 then
        local taskinfo = cfgEverydayTask[taskid]
        if taskinfo then
           Player.QuickGoTo(actor, taskinfo.gotoid) 
        end
    elseif funcid == EVERYDAYTASK_BUTTONFUNC_ID_3 then
        local nFinalRewardIdx = getplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX)
        local nTargTaskNum1 = TASK_FINAL_REWARDITEMS[1].targnum
        local nTargTaskNum2 = TASK_FINAL_REWARDITEMS[2].targnum
        local datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA)
        local rewardtab = {}
        if datastr ~= '' then
            rewardtab = json2tbl(datastr)
        end          

        if nFinalRewardIdx == 0 then
            if #rewardtab >= nTargTaskNum1 then
                Player.GiveItemsToBagOrMail(actor, TASK_FINAL_REWARDITEMS[1].rewarditems, '每日必做累计奖励1')
                setplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX, 1)
            end
            if #rewardtab >= nTargTaskNum2 then
                Player.GiveItemsToBagOrMail(actor, TASK_FINAL_REWARDITEMS[2].rewarditems, '每日必做累计奖励2')
                setplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX, 2)
            end            
        elseif nFinalRewardIdx == 1 then
            if #rewardtab >= nTargTaskNum2 then
                Player.GiveItemsToBagOrMail(actor, TASK_FINAL_REWARDITEMS[2].rewarditems, '每日必做累计奖励2')
                setplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX, 2)
            end
        elseif nFinalRewardIdx >= 2 then
            Player.SendSelfMsg(actor, '奖励已领过', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        end
        EverydayTask.ShowActivityPanel(actor)
    end
end

--触发任务计数增加
function EverydayTask.AddTaskCounter(actor, tasktype, addnum)
    local datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA)
    local countertab = {}
    if datastr ~= '' then
        countertab = json2tbl(datastr)
    end      
    for _, value in pairs(cfgEverydayTask) do
        if value.tasktype == tasktype then
            local sid = value.id..''
            if countertab[sid] == nil then
                countertab[sid] = 0
            end
            countertab[sid] = countertab[sid] + addnum
        end
    end
    datastr = tbl2json(countertab)
    setplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA, datastr)
end

function EverydayTask.IsTopIconHaveRedPoint(actor)
    local datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA)
    local countertab = {}
    if datastr ~= '' then
        countertab = json2tbl(datastr)
    end      

    datastr = getplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end   
    
    local nCurrFinishedTaskNum = #rewardtab
    local nTargTaskNum1 = TASK_FINAL_REWARDITEMS[1].targnum
    local nTargTaskNum2 = TASK_FINAL_REWARDITEMS[2].targnum

    local nFinalRewardIdx = getplaydef(actor, CommonDefine.VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX)
    if nFinalRewardIdx == 0 then
        if nCurrFinishedTaskNum >= nTargTaskNum1 then
            return true
        end
    elseif nFinalRewardIdx == 1 then
        if nCurrFinishedTaskNum >= nTargTaskNum2 then
            return true
        end
    end

    for _, value in pairs(cfgEverydayTask) do
        local status = GetSingleTaskStatus(actor, value.id, countertab, rewardtab)
        if status == TASK_STATUS_FINISHED then
            return true    
        end        
    end    

    return false
end

return EverydayTask