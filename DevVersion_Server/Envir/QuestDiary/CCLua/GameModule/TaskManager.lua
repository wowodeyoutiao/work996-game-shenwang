TaskManager = {}

TaskManager.ListenerMonNameList = {}

function TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    local id = 0
    local status = CommonDefine.TASK_STATUS_NONE
    local config = TaskLineConfig[tasklineid]
    if BF_IsNullObj(actor) or (config == nil) then
        return id, status
    end

    id = getplaydef(actor, config.taskIDVar)
    status = getplaydef(actor, config.taskStatusVar)
    return id, status
end

--添加任务
function TaskManager.AddNewTask(actor, tasklineid, newtaskid)
    local id, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    if id > 0 then
        return false
    end

    local config = TaskLineConfig[tasklineid]
    if config then
        local taskid = config.firstTaskID
        if newtaskid and newtaskid > 0 then
            taskid = newtaskid
        end
        local singletask = config.taskDataList[taskid]
        if singletask then 
            newpicktask(actor, taskid)         
            setplaydef(actor, config.taskIDVar, taskid)
            setplaydef(actor, config.taskStatusVar, CommonDefine.TASK_STATUS_ADD)
            setplaydef(actor, config.taskCounterVar, '')
            setplaydef(actor, config.taskSingleCounterVar, 0)
            if tasklineid == CommonDefine.TASK_LINE_ID_MAIN then
                tasktopshow(actor, newtaskid)
            end
            if singletask.autoaccept and (singletask.autoaccept == 1) then                
                TaskManager.AcceptTask(actor, tasklineid)
            end
        end
    end

    return true
end

--接受任务
function TaskManager.AcceptTask(actor, tasklineid)
    local id, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    if id == 0 then
        return false
    end
    if status ~= CommonDefine.TASK_STATUS_ADD then
        return false
    end

    local config = TaskLineConfig[tasklineid]
    if config then
        local taskid = id
        local singletask = config.taskDataList[taskid]
        if singletask then 
            if singletask.tasktype == CommonDefine.TASK_TYPE_FREEVIP then
                local currlv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_LEVEL then
                local currlv = Player.GetLevel(actor)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_POWERSCORE then
                local currlv = Player.GetPlayerPower(actor)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_OPENBOXNUM then
                local currlv = getplaydef(actor, config.taskSingleCounterVar)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_EQUIPPOS_STRENGTH then
                local currlv = EquipPosStrengthManager.GetAllCommonEquipPosMaxLevel(actor)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_SKILL_UPGRADE then
                local currlv = SkillUpgrade.GetAllSkillsMaxLevel(actor)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_SUPERBOX_UPGRADE then
                local currlv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
                newchangetask(actor, taskid, currlv..'')
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_TITLE_UPGRADE then
                local currlv = getplaydef(actor, CommonDefine.VAR_U_OLD_TITLE_LEVEL)
                newchangetask(actor, taskid, '')                
            else
                newchangetask(actor, taskid, '0', '0', '0')                
            end            
            setplaydef(actor, config.taskStatusVar, CommonDefine.TASK_STATUS_ACCEPT) 
            setplaydef(actor, config.taskCounterVar, '')
            setplaydef(actor, config.taskSingleCounterVar, 0)

            --接任务的时候判断任务是否已完成
            if singletask.tasktype == CommonDefine.TASK_TYPE_FREEVIP then
                local currviplv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
                if currviplv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_LEVEL then
                local currlv = Player.GetLevel(actor)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_POWERSCORE then
                local currlv = Player.GetPlayerPower(actor)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_EQUIPPOS_STRENGTH then
                local currlv = EquipPosStrengthManager.GetAllCommonEquipPosMaxLevel(actor)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_SKILL_UPGRADE then
                local currlv = SkillUpgrade.GetAllSkillsMaxLevel(actor)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end      
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_SUPERBOX_UPGRADE then
                local currlv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            elseif singletask.tasktype == CommonDefine.TASK_TYPE_TITLE_UPGRADE then
                local currlv = getplaydef(actor, CommonDefine.VAR_U_OLD_TITLE_LEVEL)
                if currlv >= singletask.tasktargparam then
                    TaskManager.FinishTask(actor, tasklineid)
                end
            end

            --刷怪任务 直接飞目标地
            if singletask.tasktype == CommonDefine.TASK_TYPE_KILLMON then
                if singletask.targpos then                
                    mapmove(actor, singletask.targpos.mapid, singletask.targpos.x, singletask.targpos.y, 4)
                    startautoattack(actor)
                end      
            end
        end
    end

    close(actor)
    return true
end

--完成任务
function TaskManager.FinishTask(actor, tasklineid)
    local id, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    if id == 0 then
        return false
    end
    if status ~= CommonDefine.TASK_STATUS_ACCEPT then
        return false
    end

    local config = TaskLineConfig[tasklineid]
    if config then
        local taskid = id
        local singletask = config.taskDataList[taskid]
        if singletask then 
            newcompletetask(actor, taskid)
            setplaydef(actor, config.taskStatusVar, CommonDefine.TASK_STATUS_FINISH)            
            if singletask.autosubmit and (singletask.autosubmit==1) then
                TaskManager.EndTask(actor, tasklineid)
            end
        end
    end

    return true
end

--领奖并结束任务
function TaskManager.EndTask(actor, tasklineid)
    local id, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    if id == 0 then
        return false
    end
    if status ~= CommonDefine.TASK_STATUS_FINISH then
        return false
    end

    local config = TaskLineConfig[tasklineid]
    if config then    
        local taskid = id
        local singletask = config.taskDataList[taskid]
        if singletask then             
            if singletask.reward_tab then
                local finalrewardtab = Player.FilterTable(actor, singletask.reward_tab)                
                Player.GiveItemsToBagOrMail(actor, finalrewardtab, '任务奖励：'..taskid)
            end
            if singletask.openbox_num and (singletask.openbox_num > 0) then
                OpenSuperBoxManager.AddNewBoxNum(actor, singletask.openbox_num)
            end

            if singletask.nextid and singletask.nextid > 0 then
                newdeletetask(actor, taskid)
                setplaydef(actor, config.taskIDVar, 0)
                TaskManager.AddNewTask(actor, tasklineid, singletask.nextid)
                --TaskManager.OnPlayerClickTask(actor, singletask.nextid)
            else
                newdeletetask(actor, taskid)
                setplaydef(actor, config.taskStatusVar, CommonDefine.TASK_STATUS_END)
                close(actor)
            end
        end
    end

    return true
end

--删除任务
function TaskManager.DeleteTask(actor, tasklineid)
    local id, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid)
    if id == 0 then
        return false
    end

    local config = TaskLineConfig[tasklineid]
    if config then
        newdeletetask(actor, id)
        setplaydef(actor, config.taskIDVar, 0)
        setplaydef(actor, config.taskStatusVar, CommonDefine.TASK_STATUS_NONE)
    end

    return true   
end

local function ShowTaskDialogue(actor, singletask, taskstatus)
    if BF_IsNullObj(actor) or singletask==nil then
        return;
    end

    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y

    local msg = '<Text|text=任务信息:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    local taskdesclist = {}
    if singletask.acceptdialogue then
        taskdesclist = string.split(singletask.acceptdialogue, '|')
        if taskdesclist == false then
            taskdesclist = {}
        end
    end    
    for _, showstr in ipairs(taskdesclist) do
        msg = msg..'<Text|text='..showstr..'|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
        tempCurrY = tempCurrY + 30
    end
    tempCurrY = tempCurrY + 20        
    
    if taskstatus == CommonDefine.TASK_STATUS_ADD then        
        msg = msg..'<Text|text=任务目标:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
        local tasktargstr = ''
        if singletask.tasktype == CommonDefine.TASK_TYPE_KILLMON then
            if singletask.tasktarg_tab then
                for _, targ in ipairs(singletask.tasktarg_tab) do
                    if tasktargstr ~= '' then
                        tasktargstr = tasktargstr..';   '
                    end
                    tasktargstr = tasktargstr..targ.monname..'X'..targ.num;
                end
            end
        end
        msg = msg..'<Text|text='..tasktargstr..'|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    end
    tempCurrY = tempCurrY + 50

    msg = msg..'<Text|text=任务奖励:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    if singletask.reward_tab then
        local finalrewardtab = Player.FilterTable(actor, singletask.reward_tab)  
        for _, reward in ipairs(finalrewardtab) do  
            local itemidx = getstditeminfo(reward.name, CommonDefine.STDITEMINFO_IDX)
            msg = msg..'<ItemShow|x='..(tempCurrX+100)..'|y='..tempCurrY..'|width=70|height=70|itemid='..itemidx..'|itemcount='..reward.num..'|bgtype=1|showtips=1>'
            tempCurrX = tempCurrX + 70
        end
    end  

    tempCurrX = CSS.NPC_LEFT_START_X + 380
    tempCurrY = CSS.NPC_TOP_START_Y + 200
    if taskstatus == CommonDefine.TASK_STATUS_ADD then
        msg = msg..'<Button|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=20|text=接受任务|link=@global_accept_task>'
    elseif taskstatus == CommonDefine.TASK_STATUS_FINISH then
        msg = msg..'<Button|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=20|text=提交任务|link=@global_submit_task>'
    end
    BF_NPCSayExt(actor,msg)
end

function global_accept_task(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local tasklineid = getplaydef(actor, CommonDefine.VAR_U_CURR_TASKLINEID)
    if tasklineid and tasklineid > 0 then
        TaskManager.AcceptTask(actor, tasklineid)            
    end    
end

function global_submit_task(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local tasklineid = getplaydef(actor, CommonDefine.VAR_U_CURR_TASKLINEID)
    if tasklineid and tasklineid > 0 then
        TaskManager.EndTask(actor, tasklineid)            
    end   
end

--玩家打开NPC对话框前先检测任务
function TaskManager.CheckNpcTask(actor)
    local currnpc = getcurrnpc(actor)
    if currnpc then
        local npcidx = getnpcindex(currnpc)
        for tasklineid, lineconfig in pairs(TaskLineConfig) do
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status ~= CommonDefine.TASK_STATUS_NONE and lineconfig then
                local singletask = lineconfig.taskDataList[taskid]
                if singletask then
                    if status == CommonDefine.TASK_STATUS_ADD then
                        if singletask.acceptnpcid == npcidx then
                            setplaydef(actor, CommonDefine.VAR_U_CURR_TASKLINEID, tasklineid)
                            ShowTaskDialogue(actor, singletask, CommonDefine.TASK_STATUS_ADD)
                            return true
                        end
                    elseif status == CommonDefine.TASK_STATUS_FINISH then
                        if singletask.submitnpcid == npcidx then
                            setplaydef(actor, CommonDefine.VAR_U_CURR_TASKLINEID, tasklineid)
                            ShowTaskDialogue(actor, singletask, CommonDefine.TASK_STATUS_FINISH)
                            return true
                        end 
                    end                                                 
                end
            end
        end        
    end
    return false
end

--判断是否在任务监听的杀怪目标中
local function IsAddListenMon(monshowname)    
    if (TaskManager.ListenerMonNameList[monshowname] == nil) or (TaskManager.ListenerMonNameList[monshowname] ~= true) then
        return false
    end
    return true
end

function TaskManager.InitAddListenMon()
    TaskManager.ListenerMonNameList = {}
    for _, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            for _, singletask in pairs(lineconfig.taskDataList) do
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_KILLMON) and
                   singletask.tasktarg_tab and (#singletask.tasktarg_tab > 0) then
                    for _, targ in ipairs(singletask.tasktarg_tab) do
                        TaskManager.ListenerMonNameList[targ.monname] = true
                    end                    
                end
            end
        end
    end
end

local function UpdateTaskProgress(actor, taskid, tasktype, counterlist, countervar)
    if BF_IsNullObj(actor) then
        return
    end
    local s1 = '0'
    local s2 = '0'
    local s3 = '0'
    if tasktype == CommonDefine.TASK_TYPE_KILLMON then
        if counterlist['1'] then
            s1 = counterlist['1']..''
        end
        if counterlist['2'] then
            s2 = counterlist['2']..''
        end
        if counterlist['3'] then
            s3 = counterlist['3']..''
        end    
    elseif tasktype == CommonDefine.TASK_TYPE_FREEVIP then
        local currlv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
        s1 = currlv..''
    elseif tasktype == CommonDefine.TASK_TYPE_LEVEL then
        local currlv = Player.GetLevel(actor)
        s1 = currlv..''
    elseif tasktype == CommonDefine.TASK_TYPE_POWERSCORE then
        local currlv = Player.GetPlayerPower(actor)
        s1 = currlv..''
    elseif tasktype == CommonDefine.TASK_TYPE_OPENBOXNUM then
        if countervar ~= nil then
            local currlv = getplaydef(actor, countervar)
            s1 = currlv..''
        end
    elseif tasktype == CommonDefine.TASK_TYPE_EQUIPPOS_STRENGTH then
        local currlv = EquipPosStrengthManager.GetAllCommonEquipPosMaxLevel(actor)
        s1 = currlv..''
    elseif tasktype == CommonDefine.TASK_TYPE_SKILL_UPGRADE then
        local currlv = SkillUpgrade.GetAllSkillsMaxLevel(actor)
        s1 = currlv..''
    elseif tasktype == CommonDefine.TASK_TYPE_SUPERBOX_UPGRADE then
        local currlv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
        s1 = currlv..''
    end    
    newchangetask(actor, taskid, s1, s2, s3) 
end

--任意地图击杀怪物触发
function TaskManager.OnKillMon(actor, mon, killtype, mapidstr)
	if BF_IsNullObj(actor) then
		return
	end	
	--不是玩家击杀的不触发
    --后面再考虑宝宝的问题！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    --后面再考虑宝宝的问题！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！

	if killtype ~= '2' then
		return
	end
    local monshowname = Player.GetName(mon)
    if not IsAddListenMon(monshowname) then
        return
    end

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_KILLMON) and
                    singletask.tasktarg_tab and (#singletask.tasktarg_tab > 0) then
                    local sTempData = getplaydef(actor, lineconfig.taskCounterVar)
                    local counterlist = {}
                    if (type(sTempData) == 'string') and (sTempData ~= '') then
                        counterlist = json2tbl(sTempData)
                    end

                    local bChanged = false
                    local bCheckFinish = false
                    for seq, targ in ipairs(singletask.tasktarg_tab) do
                        local seqstr = seq..''
                        if targ.monname == monshowname then
                            if counterlist[seqstr] == nil then
                                counterlist[seqstr] = 0
                                bChanged = true
                            end
                            if counterlist[seqstr] < targ.num then
                                counterlist[seqstr] = math.min(targ.num, counterlist[seqstr] + 1)
                                bChanged = true
                                if counterlist[seqstr] >= targ.num then
                                    bCheckFinish = true
                                end                                
                            end                                                
                        end
                    end                    

                    if bChanged then
                        sTempData = tbl2json(counterlist)
                        setplaydef(actor, lineconfig.taskCounterVar, sTempData)                         
                        local bTaskFinished = false
                        if bCheckFinish then
                            bTaskFinished = true
                            for seq, targ in ipairs(singletask.tasktarg_tab) do                                
                                local seqstr = seq..''
                                if counterlist[seqstr] == nil or counterlist[seqstr] < targ.num then
                                    bTaskFinished = false
                                    break
                                end
                            end                             
                        end       

                        if bTaskFinished then
                            TaskManager.FinishTask(actor, tasklineid)
                        else
                            UpdateTaskProgress(actor, taskid, singletask.tasktype, counterlist, lineconfig.taskSingleCounterVar)
                        end
                    end
                end            
            end
        end
    end
end

--免费VIP升级
function TaskManager.OnFreeVIPChange(actor)
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_FREEVIP) and singletask.tasktargparam then
                    local currlv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
                    if currlv >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currlv..'')
                    end
                end            
            end
        end
    end  
end

--玩家升级
function TaskManager.OnLevelChange(actor) 
	if BF_IsNullObj(actor) then
		return
	end	

    local currlv = Player.GetLevel(actor) 
    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_LEVEL) and singletask.tasktargparam then                                
                    currlv = Player.GetLevel(actor) 
                    if currlv >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currlv..'')
                    end
                end            
            end
        end
    end

    if currlv >= 20 then
        local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, CommonDefine.TASK_LINE_ID_BRANCH) 
        if status == CommonDefine.TASK_STATUS_NONE then
            TaskManager.AddNewTask(actor, CommonDefine.TASK_LINE_ID_BRANCH, 0)
            --接任务的时候触发一下检测免费VIP的逻辑
            TaskManager.OnFreeVIPChange(actor)
        end
    end
end

--玩家战力变化
function TaskManager.OnPowerScoreChange(actor) 
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_POWERSCORE) and singletask.tasktargparam then
                    local currnum = Player.GetPlayerPower(actor)               
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currnum..'')
                    end
                end            
            end
        end
    end  
end

--玩家开箱增加
function TaskManager.OnAddOpenBoxNum(actor, addnum) 
	if BF_IsNullObj(actor) or (addnum <= 0) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_OPENBOXNUM) and singletask.tasktargparam then
                    local currnum = getplaydef(actor, lineconfig.taskSingleCounterVar) + addnum
                    setplaydef(actor, lineconfig.taskSingleCounterVar, currnum)
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currnum..'')
                    end
                end
            end
        end
    end
end

--玩家装备槽位强化
function TaskManager.OnEquipStrength(actor) 
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_EQUIPPOS_STRENGTH) and singletask.tasktargparam then
                    local currnum = EquipPosStrengthManager.GetAllCommonEquipPosMaxLevel(actor)               
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currnum..'')
                    end
                end            
            end
        end
    end  
end

--玩家开宝箱升级
function TaskManager.OnSuperBoxUpgrade(actor) 
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_SUPERBOX_UPGRADE) and singletask.tasktargparam then
                    local currnum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currnum..'')
                    end
                end            
            end
        end
    end  
end

--玩家技能升级
function TaskManager.OnSkillUpgrade(actor) 
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_SKILL_UPGRADE) and singletask.tasktargparam then
                    local currnum = getplaydef(actor, CommonDefine.VAR_U_OLD_TITLE_LEVEL)
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, '')
                    end
                end            
            end
        end
    end  
end

--玩家称号升级
function TaskManager.OnTitleUpgrade(actor)
	if BF_IsNullObj(actor) then
		return
	end	

    for tasklineid, lineconfig in pairs(TaskLineConfig) do
        if lineconfig and lineconfig.taskDataList then
            local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
            if taskid > 0 and status == CommonDefine.TASK_STATUS_ACCEPT then
                local singletask = lineconfig.taskDataList[taskid]                
                if singletask and (singletask.tasktype == CommonDefine.TASK_TYPE_TITLE_UPGRADE) and singletask.tasktargparam then
                    local currnum = SkillUpgrade.GetAllSkillsMaxLevel(actor)
                    if currnum >= singletask.tasktargparam then
                        TaskManager.FinishTask(actor, tasklineid)
                    else
                        newchangetask(actor, taskid, currnum..'')
                    end
                end            
            end
        end
    end   
end

--玩家登录时触发
function TaskManager.OnPlayerEnterGame(actor)
    for tasklineid, lineconfig in pairs(TaskLineConfig) do      
        local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
        if taskid > 0 and status ~= CommonDefine.TASK_STATUS_NONE and lineconfig then
            local singletask = lineconfig.taskDataList[taskid]
            if singletask then
                if status == CommonDefine.TASK_STATUS_ADD then                    
                    newpicktask(actor, taskid)
                elseif status == CommonDefine.TASK_STATUS_ACCEPT then              
                    local sTempData = getplaydef(actor, lineconfig.taskCounterVar)
                    local counterlist = {}
                    if (type(sTempData) == 'string') and (sTempData ~= '') then
                        counterlist = json2tbl(sTempData)
                    end                    
                    UpdateTaskProgress(actor, taskid, singletask.tasktype, counterlist, lineconfig.taskSingleCounterVar)
                elseif status == CommonDefine.TASK_STATUS_FINISH then
                    newcompletetask(actor, taskid)   
                end                  
            end          
            if tasklineid == CommonDefine.TASK_LINE_ID_MAIN then
                tasktopshow(actor, taskid)
            end            
        end        
    end
end

--玩家点击任务
function TaskManager.OnPlayerClickTask(actor, clicktaskidstr)
    if BF_IsNullObj(actor) or (not BF_IsNumberStr(clicktaskidstr)) then
        return
    end

    local clicktaskid = tonumber(clicktaskidstr)
    for tasklineid, lineconfig in pairs(TaskLineConfig) do      
        local taskid, status = TaskManager.GetCurrTaskLineInfo(actor, tasklineid) 
        if taskid == clicktaskid then
            if taskid > 0 and lineconfig then    
                local singletask = lineconfig.taskDataList[taskid]
                if singletask then               
                    if status == CommonDefine.TASK_STATUS_ADD then
                        if singletask.acceptnpcid then
                            opennpcshowex(actor, singletask.acceptnpcid, 3, 3)
                        end
                    elseif status == CommonDefine.TASK_STATUS_ACCEPT then
                        if singletask.tasktype == CommonDefine.TASK_TYPE_FREEVIP then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_FREEVIP)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_LEVEL then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_UPGRADE_LEVEL)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_POWERSCORE then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_INCREASE_POWER)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_OPENBOXNUM then
                            --触发开一次宝箱
                            --OpenSuperBoxManager.DoOpenBoxOnce(actor, false, nil)
                            --快捷引导开箱
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_AUTO_OPENBOX)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_EQUIPPOS_STRENGTH then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_EQUIP_STRENGTH)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_SKILL_UPGRADE then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_SKILL_UPGRADE)
                        elseif singletask.tasktype == CommonDefine.TASK_TYPE_SUPERBOX_UPGRADE then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_SUPERBOX_UPGRADE)
                        elseif singletask.taskstype == CommonDefine.TASK_TYPE_TITLE_UPGRADE then
                            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_TITLE_UPGRADE)
                        else
                            if singletask.targpos then                
                                if BF_GetDistanceFromMapPoint(actor, singletask.targpos.mapid, singletask.targpos.x, singletask.targpos.y) < 5 then
                                    startautoattack(actor)
                                else
                                    mapmove(actor, singletask.targpos.mapid, singletask.targpos.x, singletask.targpos.y, 3)
                                    startautoattack(actor)
                                end
                            end
                        end
                    elseif status == CommonDefine.TASK_STATUS_FINISH then
                        if singletask.submitnpcid and (singletask.submitnpcid > 0) then
                            opennpcshowex(actor, singletask.submitnpcid, 3, 3)
                        elseif singletask.autosubmit == 0 then                      
                            TaskManager.EndTask(actor, tasklineid)
                        end
                    end
                end
            end
            break
        end
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, TaskManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_GAMETASK)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_CLICK_TASK, TaskManager.OnPlayerClickTask, CommonDefine.FUNC_ID_GAMETASK)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_KILL_MON, TaskManager.OnKillMon, CommonDefine.FUNC_ID_GAMETASK)

return TaskManager