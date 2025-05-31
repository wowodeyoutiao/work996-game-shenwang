BaoZhuBossManager = {}

--functionid
local BAOZHUBOSS_BUTTONFUNC_ID_1 = 1    --宝珠boss地图中的功能按键-退出地图
local BAOZHUBOSS_BUTTONFUNC_ID_2 = 2    --宝珠boss地图中的功能按键-行会求助
local BAOZHUBOSS_BUTTONFUNC_ID_3 = 3    --宝珠boss地图中的功能按键-复活并退出地图
local BAOZHUBOSS_BUTTONFUNC_ID_4 = 4    --宝珠boss地图中的功能按键-原地复活

local NPCPANEL_BUTTONFUNC_ID_1 = 1      --参与挑战

--判断是否为宝珠BOSS地图
function BaoZhuBossManager.IsBossMap(mapidstr)
    for _, value in pairs(cfgBaoZhuBossInfo) do
        --这里放置配置mapid的时候，是数字的情况
        local idstr = value.mapid..''        
        if idstr == mapidstr then
            return true
        end
    end
    return false
end

local function InitMapUI(actor)
    if not Player.IsPCClient(actor) then
        addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8, '<Button|text=离开地图|x=260|y=36|color='..CSS.NPC_WHITE..'|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@baozhuboss_button#sid='..
            BAOZHUBOSS_BUTTONFUNC_ID_1..'>')
        addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_35, '<Button|text=行会求助|x=260|y=86|color='..CSS.NPC_WHITE..'|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@baozhuboss_button#sid='..
            BAOZHUBOSS_BUTTONFUNC_ID_2..'>')
        --[[
        local msg = '<Img|x=0|y=100|bg=1|move=1|reset=0|img=public/bg_npc_05.png>'
        say(actor, msg)
        ]]--
    end
end

local function ClearMapUI(actor)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_35)
end

local function SendSuccessDialogue(actor, rewarditems)
    local msg = '<Text|id=1|x=150|y=25|size=20|color='..CSS.NPC_LIGHTGREEN..'|text=获得奖励>'..
        '<Text|id=2|x=45|y=55|size=16|color='..CSS.NPC_WHITE..'|text=副本首领被击杀，恭喜您获得：>'
    local currX = 45
    local currY = 55 + 40
    local currid = 2
    local idstr = '0,1,2'
    local currcount = 0
    local linecount = 4
    for seq, value in ipairs(rewarditems) do
        local itemidx = getstditeminfo(value.name, CommonDefine.STDITEMINFO_IDX)
        currcount = currcount + 1                
        currid = currid + 1
        if idstr ~= '' then
            idstr = idstr..','
        end
        idstr = idstr..currid
        msg = msg..'<ItemShow|id='..currid..'|x='..currX..'|y='..currY..'|itemid='..itemidx..'|itemcount='..value.num..'|bgtype=1|showtips=1>'
        currX = currX + 75
        if (currcount >= linecount) and (seq < #rewarditems) then
            currcount = 0
            currX = 45
            currY = currY + 75
        end
    end
    currY = currY + 80
    currid = currid + 1
    idstr = idstr..','..currid
    msg = msg..'<Button|id='..currid..'|x=160|y='..currY..'|pimg=public/btn_bbgm_01.png|nimg=public/btn_bbgm_02.png|color='..CSS.NPC_WHITE..'|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_1..'>'
    currY = currY + 30
    currid = currid + 1
    idstr = idstr..','..currid
    msg = msg..'<COUNTDOWN|id='..currid..'|x=180|y='..currY..'|time=15|count=1|size=16|color='..CSS.NPC_RED..'|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_1..'>'
    currY = currY + 40
    msg = msg..'<Img|children={'..idstr..'}|a=1|x=800|y=200|width=400|height='..currY..'|scale9t=10|scale9b=10|reset=1|move=1|img=public/1900000605.png|bg=1>'..
        '<Layout|id=0|width=400|height='..currY..'>'
    BF_ShowSpecialUI(actor, msg)
end

local function SendFailDialogue(actor)
    local msg = '<Img|children={0,1,2,3,4}|a=1|x=800|y=200|reset=1|move=1|img=public/1900000605.png|bg=1>'..
        '<Layout|id=0|width=400|height=176>'..
        '<Text|id=1|x=150|y=25|size=20|color='..CSS.NPC_DARKRED..'|text=抢夺失败>'..
        '<Text|id=2|x=35|y=60|size=16|color='..CSS.NPC_WHITE..'|text=很遗憾，您未能获得灵玉奖励，请再接再厉吧！>'..        
        '<Button|id=3|x=150|y=100|pimg=public/btn_bbgm_01.png|nimg=public/btn_bbgm_02.png|color='..CSS.NPC_WHITE..'|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_1..'>'..
        '<COUNTDOWN|id=4|x=170|y=140|time=15|count=1|size=16|color='..CSS.NPC_RED..'|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_1..'>';
    BF_ShowSpecialUI(actor, msg)
end

function BaoZhuBossManager.DoMapButton(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)
    if funcid == BAOZHUBOSS_BUTTONFUNC_ID_1 then
        --返回安全区
        Player.GoHome(actor)
    elseif funcid == BAOZHUBOSS_BUTTONFUNC_ID_2 then
        --行会求助
        local mapidstr = Player.GetMapIDStr(actor)
        for _, value in pairs(cfgBaoZhuBossInfo) do
            local idstr = value.mapid..''        
            if idstr == mapidstr then
                Player.SendGuildMsg(actor, '行会成员['..Player.GetName(actor)..']在灵玉副本['..value.showname..']中进行挑战，速来助他一臂之力！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
                break
            end
        end        
    elseif funcid == BAOZHUBOSS_BUTTONFUNC_ID_3 then
        --复活并返回安全区
        if Player.IsDead(actor) then
            realive(actor)                       
        end        
        Player.GoHome(actor)
    elseif funcid == BAOZHUBOSS_BUTTONFUNC_ID_4 then
        --原地复活        
        if not Player.IsDead(actor) then
            return
        end

        local relivetimes = getplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES) + 1
        local needitems = Player.GetCommonLocalReliveNeedItems(relivetimes)
        if not Player.CheckItemsEnough(actor, needitems, '复活') then
            return
        end
        --扣除消耗
        Player.TakeItems(actor, needitems, '宝珠BOSS地图复活')        
        setplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES, relivetimes + 1)        
        realive(actor)        
    end
end

--进地图的回调
function BaoZhuBossManager.OnEnterMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (not BaoZhuBossManager.IsBossMap(mapidstr)) then
        return
    end
    InitMapUI(actor)
    local attackmode = getattackmode(actor)
    setplaydef(actor, CommonDefine.VAR_N_LAST_ATTACK_MODE, attackmode)
    setattackmode(actor, CommonDefine.ATTACK_MODE_GUILD, 36000)    
    setplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES, 0)
end

--离开地图的回调
function BaoZhuBossManager.OnLeaveMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (not BaoZhuBossManager.IsBossMap(mapidstr)) then
        return
    end    
    ClearMapUI(actor)    
    setattackmode(actor, -1, 0)        
    local attackmode = getplaydef(actor, CommonDefine.VAR_N_LAST_ATTACK_MODE)
    changeattackmode(actor, attackmode)
end

--玩家死亡回调
function BaoZhuBossManager.OnPlayerDie(actor, killername)
    if BF_IsNullObj(actor) then
        return
    end
    local mapid = Player.GetMapIDStr(actor)
    if not BaoZhuBossManager.IsBossMap(mapid) then
        return
    end
    if killername == nil then
        killername = ''
    end

    local relivetimes = getplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES)
    local needitems = Player.GetCommonLocalReliveNeedItems(relivetimes+1)
    local needitemstr = BF_GetItemTableDescStr(nil, needitems)
    local msg = '<Img|children={0,1,2,3,4,5,6}|a=1|x=737|y=201|reset=1|move=1|img=private/revive/bg_swfh_1.png|bg=1>'..
        '<Layout|id=0|width=348|height=200>'..
        '<Text|id=1|x=110|y=15|size=18|color='..CSS.NPC_WHITE..'|text=死亡复活>'..
        '<Text|id=2|x=77|y=45|size=16|color='..CSS.NPC_WHITE..'|text=你被 '..killername..' 杀死了！>'..        
        '<Button|id=3|x=45|y=75|pimg=public/1900000652.png|nimg=public/1900000653.png|color='..CSS.NPC_WHITE..'|size=17|text=立即返回|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_3..'>'..
        '<Button|id=4|x=170|y=75|pimg=public/1900000652.png|nimg=public/1900000653.png|color='..CSS.NPC_WHITE..'|size=17|text=原地复活|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_4..'>'..
        '<COUNTDOWN|id=5|x=70|y=110|time=30|count=1|size=16|color='..CSS.NPC_RED..'|link=@baozhuboss_button#sid='..BAOZHUBOSS_BUTTONFUNC_ID_3..'>'..
        '<Text|id=6|x=170|y=110|size=16|color='..CSS.NPC_WHITE..'|text='..needitemstr..'>'  
    Player.ShowReliveDialogue(actor, msg)
end


--怪物被击杀回调
function BaoZhuBossManager.OnMonKilled(hitter, mon)
    if BF_IsNullObj(mon) then
        return
    end
    local mapid = Player.GetMapIDStr(mon)
    if not BaoZhuBossManager.IsBossMap(mapid) then
        return
    end

    local idx = Player.GetMonIdx(mon)
    local cfgBossInfo = nil
    for _, value in pairs(cfgBaoZhuBossInfo) do
        if value.monidx == idx then
            cfgBossInfo = value
            break
        end
    end
    if cfgBossInfo == nil then
        return
    end

    local hitterguildname = ''
    if not BF_IsNullObj(hitter) then
        hitterguildname = Player.GetGuildName(hitter)
    end

    --触发击杀宝珠BOSS
	FreeVIPManager.TriggerChgTaskCounter(hitter, FreeVIPManager.TASK_TYPE_BAOZHUBOSS_KILLTIMES, '+', 1)

    local players = getplaycount(mapid, 1, 1)
    for _, player in ipairs(type(players) == "table" and players or {}) do
        local guildname = Player.GetGuildName(player)
        if guildname == hitterguildname then
            --胜利结算 增加次数
            local entertimes = getplaydef(player, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES) + 1
            setplaydef(player, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES, entertimes)
            local rewarditems = BF_GetRandomRewardItems(cfgBossInfo.rewarditems_tab)
            if not table.isempty(rewarditems) then
                Player.GiveItemsToBagOrMail(player, rewarditems, '珠玉副本奖励')
                SendSuccessDialogue(player, rewarditems)

                --每日必做计数        
                --EverydayTask.AddTaskCounter(player, CommonDefine.FUNC_ID_BAOZHU_BOSS, 1)  
            end            
        else
            --失败不结算 不加次数
            SendFailDialogue(player)
        end
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, BaoZhuBossManager.OnEnterMap, CommonDefine.FUNC_ID_BAOZHU_BOSS)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, BaoZhuBossManager.OnLeaveMap, CommonDefine.FUNC_ID_BAOZHU_BOSS)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_DIE, BaoZhuBossManager.OnPlayerDie, CommonDefine.FUNC_ID_BAOZHU_BOSS)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_MON_KILLED, BaoZhuBossManager.OnMonKilled, CommonDefine.FUNC_ID_BAOZHU_BOSS)



--------------------------------------------------------主面板相关--------------------------------------------------------------------
function BaoZhuBossManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=灵珠首领副本规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、灵珠首领副本每天有获得挑战奖励的次数上限，获得|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=奖励的次数达到上限之后将无法再次进入挑战。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、灵珠首领副本内为行会战斗模式，可以通过快捷按钮|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=邀请行会内的其他玩家来帮助自己战斗。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=3、灵珠首领副本内死亡可以通过消耗金币进行原地复活，|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=但复活次数越高消耗也相应的越高。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=28|text=4、灵珠首领如果被成功击败，则归属者以及副本内的同行|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=29|text=会成员均会获得结算奖励。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

function BaoZhuBossManager.ShowBasePanel(actor)    
    local leftentertimes = math.max(0, CommonDefine.DAY_BAOZHUBOSS_GETREWARD_MAXTIMES - getplaydef(actor, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES))
    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15}|x=205.0|y=31.0|height=448|bg=1|reset=1|img=private/cc_bosslist_ex/5.png|loadDelay=0|show=0|move=0|esc=1>'..
		'<Layout|id=11|x=693.0|y=14.0|width=80|height=80|link=@exit>'..
		'<Button|id=12|x=696.0|y=15.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..		
		'<Text|id=13|x=278.0|y=399.0|color=151|size=20|text=今日可挑战:'..leftentertimes..'/'..CommonDefine.DAY_BAOZHUBOSS_GETREWARD_MAXTIMES..'>'..
        '<Button|id=15|x=550.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

	local itemidstr = ''
	local currpower = Player.GetPlayerPower(actor)
	if #cfgBaoZhuBossInfo == 0 then
		strPanelInfo = strPanelInfo..'<Text|id=14|text=当前没有可以挑战的首领|size=25|x=240|y=200|color='..CSS.NPC_WHITE..'>'
	else
		local baseid = 400
		for seq, bossinfo in ipairs(cfgBaoZhuBossInfo) do
			local picid = baseid + seq * 20			
			if itemidstr ~= '' then
				itemidstr = itemidstr..','
			end
			itemidstr = itemidstr..picid
			local childstr = (picid+1)..','..(picid+2)..','..(picid+3)..','..(picid+4)
            for seq1, value1 in ipairs(bossinfo.showrewards_tab) do
                local itemidx = getstditeminfo(value1.name, CommonDefine.STDITEMINFO_IDX)
                local tempx1 = 40 + seq1 * 70
                local itemid = picid + 10 + seq1
                childstr = childstr..','..itemid
                strPanelInfo = strPanelInfo..'<ItemShow|id='..itemid..'|ay=1|x='..tempx1..'|y=42|width=50|height=50|itemid='..itemidx..'|itemcount='..value1.num..'|bgtype=1|showtips=1>'
            end
			strPanelInfo = strPanelInfo..'<Img|id='..picid..'|children={'..childstr..'}|x=0.0|y=0.0|height=110|reset=1|img=private/cc_bosslist_ex/2.png>'..
				'<Text|id='..(picid+1)..'|text='..bossinfo.showname..'|size=18|x=10|y=10|color='..CSS.NPC_YELLOW..'>'..
                --'<Text|id='..(picid+2)..'|text=奖励介绍:可获得各等级的直升宝石和稀有材料!|size=18|x=10|y=50|color='..CSS.NPC_WHITE..'>'
                '<Text|id='..(picid+2)..'|text=奖励介绍:|size=18|x=10|y=50|color='..CSS.NPC_WHITE..'>'

            if currpower < bossinfo.needscore then
                strPanelInfo = strPanelInfo..'<Text|id='..(picid+3)..'|text=需角色战力|size=18|x=480|y=20|color='..CSS.NPC_RED..'>'..                
                    '<Text|id='..(picid+4)..'|text='..BF_NumToShowStr(bossinfo.needscore)..'/'..BF_NumToShowStr(currpower)..'|size=15|x=480|y=60|color='..CSS.NPC_WHITE..'>'
            else
                local _, leftseconds = BF_GetMapBossInfo(bossinfo.mapid, bossinfo.monidx)
                if leftseconds > 0 then
                    strPanelInfo = strPanelInfo..'<Text|id='..(picid+3)..'|text=死亡复活|size=18|x=480|y=20|color='..CSS.NPC_RED..'>'..
                        '<COUNTDOWN|id='..(picid+4)..'|x=500|y=60|time='..leftseconds..'|count=1|size=18|color='..
                        CSS.NPC_LIGHTGREEN..'|link=@show_base_panel>'
                else
                    strPanelInfo = strPanelInfo..'<Button|id='..(picid+3)..'|x=480|y=40|mimg=private/cc_bosslist_ex/4.png|nimg=private/cc_bosslist_ex/4.png|size=18|color='..
					    CSS.NPC_WHITE..'|text=前往挑战|link=@function_button,'..NPCPANEL_BUTTONFUNC_ID_1..','..bossinfo.id..'>'
                end
            end
		end
		strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..itemidstr..'}|x=60.0|y=50.0|width=600|height=330|direction=1|margin=0>'
	end
		
    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function GotoBossMap(actor, id)
    local currentertimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES)
    if currentertimes >= CommonDefine.DAY_BAOZHUBOSS_GETREWARD_MAXTIMES then
        Player.SendSelfMsg(actor, '今日可挑战次数已用完！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    if (id < 1) or (id > #cfgBaoZhuBossInfo) then
        return
    end
    local bossinfo = cfgBaoZhuBossInfo[id]
    if bossinfo == nil then
        return
    end
    if Player.GetPlayerPower(actor) < bossinfo.needscore then
        Player.SendSelfMsg(actor, '挑战需要的战力不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --判断boss是否死亡？？？？
    map(actor, bossinfo.mapid)
end

--处理button回调
function BaoZhuBossManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    
    local funcid = tonumber(sid)
    local nparam = 0
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    if funcid == NPCPANEL_BUTTONFUNC_ID_1 then
		GotoBossMap(actor, nparam)
    end
end


--是否有快捷提示
function BaoZhuBossManager.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU_BOSS, false) then
        return false
    end

    local currentertimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES)
    if currentertimes >= CommonDefine.DAY_BAOZHUBOSS_GETREWARD_MAXTIMES then
        return false
    end

    if #cfgBaoZhuBossInfo == 0 then
		return false
	else
        local currpower = Player.GetPlayerPower(actor)
		for _, bossinfo in ipairs(cfgBaoZhuBossInfo) do		
            if currpower >= bossinfo.needscore then
                local _, leftseconds = BF_GetMapBossInfo(bossinfo.mapid, bossinfo.monidx)
                if leftseconds <= 0 then
                    return true
                end
            end
		end
	end

    return false
end

return BaoZhuBossManager