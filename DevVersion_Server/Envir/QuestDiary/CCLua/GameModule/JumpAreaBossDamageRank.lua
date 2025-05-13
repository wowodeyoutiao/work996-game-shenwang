JumpAreaBossDamageRank = {}

JumpAreaBossDamageRank.CurrRankData = {}

local DAMAGE_LOW_MAX = 10000

local ACTIVITY_BASE_CONFIG = {
    bossmap = 'kuafuboss',
    bossmonid = 7101,
    validweekday = {'1', '3'},    
    starttime = {hour=20, min=30},
    endtime = {hour=20, min=45},
    enterintervalseconds = 120,        
    --enterintervalseconds = 10,        
    mapstayseconds = 90,
    giverewarddelaymin = 10,        --活动结束后，延迟几分钟发奖励
    showreward = {{name='元宝', num=100}, {name='元宝', num=101}, {name='元宝', num=102}, {name='元宝', num=103}},
    rankrewardlist = {
        --单独一列奖励不要超过7个
        {rankhigh=1, ranklow=1, showrank='1', rewardlist={{name='元宝', num=100}, {name='金币', num=10000},{name='元宝', num=100}, {name='金币', num=10000}}},
        {rankhigh=2, ranklow=2, showrank='2', rewardlist={{name='元宝', num=101}, {name='金币', num=10000},{name='元宝', num=100}, {name='金币', num=10000}}},
        {rankhigh=3, ranklow=3, showrank='3', rewardlist={{name='元宝', num=102}, {name='金币', num=10000},{name='元宝', num=100}, {name='金币', num=10000}}},
        {rankhigh=4, ranklow=10, showrank='4-10', rewardlist={{name='元宝', num=103}, {name='金币', num=10000},{name='元宝', num=100}, {name='金币', num=10000}}},
        {rankhigh=11, ranklow=50, showrank='11-50', rewardlist={{name='元宝', num=104}, {name='金币', num=10000},{name='元宝', num=100}, {name='金币', num=10000}}},
    },
}

function JumpAreaBossDamageRank.GMResetCfg(actor)
    ACTIVITY_BASE_CONFIG.validweekday = {'1', '2', '3', '4', '5', '6', '0', '7'}
    local now = os.date("*t")
    local currhour = tonumber(now.hour)
    local currmin = tonumber(now.min)
    ACTIVITY_BASE_CONFIG.starttime.hour = currhour
    ACTIVITY_BASE_CONFIG.starttime.min = currmin
    ACTIVITY_BASE_CONFIG.endtime.hour = currhour
    ACTIVITY_BASE_CONFIG.endtime.min = math.min(59, currmin+5)
    ACTIVITY_BASE_CONFIG.enterintervalseconds = 20
    ACTIVITY_BASE_CONFIG.giverewarddelaymin = 3
    local tempstr = tbl2json(ACTIVITY_BASE_CONFIG)
    setsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA, tempstr)
    Player.SendSelfMsg(actor, '跨服boss设置成当前开启，5分钟后结束，进入间隔20秒，结束3分钟后发奖（本服）！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--显示规则面板
function JumpAreaBossDamageRank.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=跨服BOSS规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=3、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=4、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
 
    return strPanelInfo
end

function JumpAreaBossDamageRank.GetShowInfo(actor)
    local sPanelStr = ''
    local tempX = 20
    local tempY = 20
    sPanelStr = sPanelStr..'<Text|id=101|text=时间设定：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
    tempY = tempY + 35
    sPanelStr = sPanelStr..'<Text|id=102|text=玩法说明：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
    tempY = tempY + 70
    sPanelStr = sPanelStr..'<Text|id=103|text=奖励内容：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'        
    tempX = 130
    tempY = 25
    sPanelStr = sPanelStr..'<Text|id=104|text=每周一和周三晚上8点30~8点45为开放挑战时间|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30
    sPanelStr = sPanelStr..'<Text|id=105|text=开放时间地图内会刷新BOSS，每次进入可攻击90秒，|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30
    sPanelStr = sPanelStr..'<Text|id=106|text=间隔2分钟可再次进入，按照对BOSS造成伤害进行排行！|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30

    local itemshowidstr = ''
    local itemshowid = 110
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    for idx, reward in ipairs(ACTIVITY_BASE_CONFIG.showreward) do  
        local itemidx = getstditeminfo(reward.name, CommonDefine.STDITEMINFO_IDX)        
        sPanelStr = sPanelStr..'<ItemShow|id='..(itemshowid+idx)..'|x='..tempX..'|y='..tempY..'|width=70|height=70|itemid='..itemidx..'|itemcount='..reward.num..'|bgtype=1|showtips=1>'        
        tempX = tempX + 70
        if itemshowidstr ~= '' then
            itemshowidstr = itemshowidstr..','
        end
        itemshowidstr = itemshowidstr..(itemshowid+idx)
    end
    sPanelStr = sPanelStr..'<Layout|id=15|children={50,51,52,53,54,101,102,103,104,105,106,'..itemshowidstr..',60}|x=200.0|y=65.0|width=580|height=420>'
    sPanelStr = sPanelStr..'<Button|id=50|x=220|y=360|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=进    入|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_2..'>'

    sPanelStr = sPanelStr..'<Button|id=51|x=20|y=270|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=实时榜单|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_3..'>'..
        '<Button|id=52|x=450|y=270|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=奖励预览|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_4..'>'

    local currtime = os.time()
    local lastentertime = getplaydef(actor, CommonDefine.VAR_J_DAY_JUMPAREA_BOSS_LAST_ENTERTIME)
    local passtime = math.abs(currtime - lastentertime)
    if passtime < ACTIVITY_BASE_CONFIG.enterintervalseconds then
        local leftseconds = ACTIVITY_BASE_CONFIG.enterintervalseconds - passtime
        sPanelStr = sPanelStr..'<COUNTDOWN|id=53|x=220|y=330|time='..leftseconds..'|count=1|size=16|color='..CSS.NPC_LIGHTGREEN..'|link=@function_button,'..
        JumpAreaManager.BUTTONFUNC_ID_1..','..JumpAreaManager.ACTIVITY_TYPE_BOSS..'>'..
        '<Text|id=54|text=后可进入|size=16|x=270|y=330|color='..CSS.NPC_WHITE..'>'
    end

    local showflag = getplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2) 
    if showflag == 1 then
        --实时排名
        sPanelStr = sPanelStr..'<Img|id=60|children={61,62,63,64,65}|x=50.0|y=30.0|img=private/cc_common/rule_panel.png|reset=1|esc=1|loadDelay=0|move=0|show=0>'..
        '<Layout|id=61|x=530.0|y=1.0|width=80|height=80|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_5..'>'..
        '<Button|id=62|x=530.0|y=2.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_5..'>'

        local strItems = ''
        local nStartID = 300
        if true then
            local nLayoutID = nStartID
            if strItems ~= '' then
                strItems = strItems..','
            end
            strItems = strItems..nLayoutID
            local nTextID1 = nStartID + 1
            local nTextID2 = nStartID + 2
            local nTextID3 = nStartID + 3
            local strTextIDs = nTextID1..','..nTextID2..','..nTextID3
            sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=40>'..
                '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=16|text=排名>'..
                '<Text|id='..nTextID2..'|x=200|y=10|color=255|size=16|text=角色名>'..
                '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=16|text=伤害总量>'
        end
        
        local tabBossDamageRank = {}
        local strBossDamageRank = getsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_RANK_DATA)
        if strBossDamageRank~=nil and strBossDamageRank~='' then
            tabBossDamageRank = json2tbl(strBossDamageRank)
            if tabBossDamageRank ~= nil then
                nStartID = nStartID + 10        
                for seq, value in ipairs(tabBossDamageRank) do        
                    local nLayoutID = nStartID + seq * 10 + 1
                    if strItems ~= '' then
                        strItems = strItems..','
                    end
                    strItems = strItems..nLayoutID
            
                    local nTextID1 = nStartID + seq * 10 + 2
                    local nTextID2 = nStartID + seq * 10 + 3
                    local nTextID3 = nStartID + seq * 10 + 4
                    local strTextIDs = nTextID1..','..nTextID2..','..nTextID3
                    sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=50|color='..(30+seq)..'>'..
                        '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text='..seq..'>'..
                        '<Text|id='..nTextID2..'|x=150|y=10|color=255|size=20|text='..value.showname..'>'..
                        '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=20|text='..value.currscore..'万>'
                end                 
            end           
        end
        
        local damagehigh = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH)     
        local strShowScoreInfo = '当前伤害总量:'..damagehigh..'万'

        sPanelStr = sPanelStr..'<ListView|id=63|children={'..strItems..'}|x=20.0|y=40|width=480|height=250|margin=0|direction=1>'..
            '<Text|id=64|x=180|y=300|color='..CSS.NPC_LIGHTGREEN..'|size=18|text='..strShowScoreInfo..'>'..
            '<Text|id=65|x=180|y=320|color=255|size=16|text=(结束10分钟后邮件发送奖励)>'
        
    elseif showflag == 2 then
        --预览奖励
        sPanelStr = sPanelStr..'<Img|id=60|children={61,62,63}|x=50.0|y=30.0|img=private/cc_common/rule_panel.png|reset=1|esc=1|loadDelay=0|move=0|show=0>'..
        '<Layout|id=61|x=530.0|y=1.0|width=80|height=80|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_5..'>'..
        '<Button|id=62|x=530.0|y=2.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_5..'>'
        
        local strItems = ''
        local nStartID = 300
        if true then
            local nLayoutID = nStartID
            if strItems ~= '' then
                strItems = strItems..','
            end
            strItems = strItems..nLayoutID
            local nTextID1 = nStartID + 1
            local nTextID2 = nStartID + 2
            local strTextIDs = nTextID1..','..nTextID2
            sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=40>'..
                '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=16|text=排名>'..
                '<Text|id='..nTextID2..'|x=300|y=10|color=255|size=16|text=奖励列表>'
        end

        nStartID = nStartID + 10
        for seq, value in ipairs(ACTIVITY_BASE_CONFIG.rankrewardlist) do
            local nLayoutID = nStartID + seq * 10 + 1
            if strItems ~= '' then
                strItems = strItems..','
            end
            strItems = strItems..nLayoutID
    
            local nTextID1 = nStartID + seq * 10 + 2
            local strTextIDs = nTextID1..''
            local itemx = 100
            local itemy = 0
            for seq1, reward in ipairs(value.rewardlist) do
                local showid = nStartID + seq*10 + 2 + seq1
                strTextIDs = strTextIDs..','..showid                
                local itemidx = getstditeminfo(reward.name, CommonDefine.STDITEMINFO_IDX)
                itemx = 100 + 70 * seq1
                sPanelStr = sPanelStr..'<ItemShow|id='..showid..'|x='..itemx..'|y='..itemy..'|width=70|height=70|itemid='..itemidx..'|itemcount='..reward.num..'|bgtype=1|showtips=1>'        
            end
            sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=70>'..
                '<Text|id='..nTextID1..'|x=50|y=20|color=255|size=20|text='..value.showrank..'>'
        end
        
        sPanelStr = sPanelStr..'<ListView|id=63|children={'..strItems..'}|x=20.0|y=40|width=480|height=300|margin=0|direction=1>'    
    end

    return sPanelStr
end

--进入BOSS地图
function JumpAreaBossDamageRank.EnterBossMap(actor)
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    local currtime = os.time()
    local currhour = BF_GetHour(currtime)
    local currmin = BF_GetMinute(currtime)

    local weekday = os.date("%w")
    release_print('weekday:'..weekday..' type:'..type(weekday))
    if not table.indexof(ACTIVITY_BASE_CONFIG.validweekday, weekday) then
        Player.SendSelfMsg(actor, '不在活动日，无法进入！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    if (currhour<ACTIVITY_BASE_CONFIG.starttime.hour) or (currhour==ACTIVITY_BASE_CONFIG.starttime.hour and currmin<ACTIVITY_BASE_CONFIG.starttime.min) or
       (currhour>ACTIVITY_BASE_CONFIG.endtime.hour) or (currhour==ACTIVITY_BASE_CONFIG.endtime.hour and currmin>ACTIVITY_BASE_CONFIG.endtime.min) then
        Player.SendSelfMsg(actor, '不在活动时间段内，无法进入！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return      
    end

    local lastentertime = getplaydef(actor, CommonDefine.VAR_J_DAY_JUMPAREA_BOSS_LAST_ENTERTIME)
    if math.abs(currtime - lastentertime) < ACTIVITY_BASE_CONFIG.enterintervalseconds then
        Player.SendSelfMsg(actor, '还在间隔CD中，等待进入！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    setplaydef(actor, CommonDefine.VAR_J_DAY_JUMPAREA_BOSS_LAST_ENTERTIME, currtime)
    map(actor, ACTIVITY_BASE_CONFIG.bossmap)
end

local function GetRewardByRank(rank)
    local rewarditems = nil
    for _, value in ipairs(ACTIVITY_BASE_CONFIG.rankrewardlist) do
        if (rank >= value.rankhigh) and (rank <= value.ranklow) then
            rewarditems = value.rewardlist
            break
        end
    end
    return rewarditems
end

--本服的执行逻辑
function JumpAreaBossDamageRank.OnLocalServerTimer() 
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    local weekday = os.date("%w")    
release_print('OnLocalServerTimer weekday:'..weekday..' type:'..type(weekday))    
local str = tbl2json(ACTIVITY_BASE_CONFIG.validweekday)
release_print('valid:'..str)

    if table.indexof(ACTIVITY_BASE_CONFIG.validweekday, weekday) == false then
        --非活动日不处理相关逻辑        
        return
    end

local s1 = tbl2json(ACTIVITY_BASE_CONFIG)    
release_print('s1:'..s1)        

    local currtime = os.time()
    local currhour = BF_GetHour(currtime)
    local currmin = BF_GetMinute(currtime)    
    local rewardstatus = getsysvar(CommonDefine.VAR_G_JUMPAREA_DAMAGERANK_REWARD_STATUS)
    if (rewardstatus == 1) and ((currhour<ACTIVITY_BASE_CONFIG.starttime.hour) or (currhour==ACTIVITY_BASE_CONFIG.starttime.hour and currmin<ACTIVITY_BASE_CONFIG.starttime.min)) then
        setsysvar(CommonDefine.VAR_G_JUMPAREA_DAMAGERANK_REWARD_STATUS, 0)        
    end

    --游戏结束 10分钟后发奖
    rewardstatus = getsysvar(CommonDefine.VAR_G_JUMPAREA_DAMAGERANK_REWARD_STATUS)  
release_print('rewardstatus:'..rewardstatus)
    if (rewardstatus == 0) and BF_IsDelayedByMinutes(ACTIVITY_BASE_CONFIG.endtime, ACTIVITY_BASE_CONFIG.giverewarddelaymin) then
        local strBossDamageRank = getsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_RANK_DATA)
        if strBossDamageRank~=nil and strBossDamageRank~='' then
            local localserverid = grobalinfo(11)
            local prename = 'k'..localserverid
            local tabBossDamageRank = json2tbl(strBossDamageRank)
            if tabBossDamageRank ~= nil then
                for seq, value in ipairs(tabBossDamageRank) do
                    local showname = value.showname
                    local strParamList = string.split(showname, '_')
                    if strParamList ~= false then
                        if prename == strParamList[1] then
                            local rewarditems = GetRewardByRank(seq)
                            if rewarditems ~= nil then
                                Player.OfflineGiveItems(value.playerid, rewarditems, '跨服BOSS伤害排行奖励', '恭喜你获得跨服BOSS伤害排行第'..seq..'名！')
                            end
                        end                        
                    end
                end
            end
            setsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_RANK_DATA, '')
        end

        setsysvar(CommonDefine.VAR_G_JUMPAREA_DAMAGERANK_REWARD_STATUS, 1) 
    end
end

--跨服服务器更新实时的排行榜数据
local function UpdateRankData(actor, score)
    if BF_IsNullObj(actor) then
        return
    end

    local bFind = false
    local currplayerid = Player.GetPlayerID(actor)
    for _, value in ipairs(JumpAreaBossDamageRank.CurrRankData) do
        if value.playerid ==  currplayerid then
            value.currscore = score
            bFind = true
            break
        end
    end
    if bFind == false then
        local rec = {playerid = Player.GetPlayerID(actor), currscore = score, showname = Player.GetName(actor)}
        JumpAreaBossDamageRank.CurrRankData[#JumpAreaBossDamageRank.CurrRankData+1] = rec
    end

    table.sort(JumpAreaBossDamageRank.CurrRankData, function(a, b)
        return a.score > b.score
    end)

    local sRankData = tbl2json(JumpAreaBossDamageRank.CurrRankData)
    kfbackcall(CommonDefine.KFBCMSG_UPDATE_JUMPAREA_DAMAGE_RANK, '0', sRankData, '')
end

--玩家攻击时触发 
function JumpAreaBossDamageRank.DoAttackDamage(actor, target, damage)
    if BF_IsNullObj(actor) or BF_IsNullObj(target) then
        return damage
    end

    local monid = Player.GetMonIdx(target)
    if monid == ACTIVITY_BASE_CONFIG.bossmonid then       
        local mapidstr = Player.GetMapIDStr(actor)
        if mapidstr == ACTIVITY_BASE_CONFIG.bossmap then
            --记录玩家的伤害累计数据
            local damagehigh = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH)
            local damagelow = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_LOW)           
            damagelow = damagelow + damage                        
            local bCheckRank = false
            if damagelow >= DAMAGE_LOW_MAX then
                local addpoint = math.floor(damagelow / DAMAGE_LOW_MAX)
                damagehigh = damagehigh + addpoint
                damagelow = damagelow % DAMAGE_LOW_MAX
                bCheckRank = true

                delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37)
                local damagehigh = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH)
                addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37, '<Text|x=-100|y=-210|color='..CSS.NPC_LIGHTGREEN..
                    '|size=20|text=当前伤害总量:'..damagehigh..'万>')
            end        
            setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH, damagehigh)
            setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_LOW, damagelow)
            --检测排行榜数据更新
            if bCheckRank == true then
                UpdateRankData(actor, damagehigh)
            end
        end
    end

    return damage
end

local function InitMapUI(actor)
    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8, '<Button|text=离开地图|x=850|y=36|color='..CSS.NPC_WHITE..
        '|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@jumparea_button#sid='..JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1..'>')
    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_9, '<COUNTDOWN|x=870|y=76|time='..ACTIVITY_BASE_CONFIG.mapstayseconds..
        '|count=1|size=16|color='..CSS.NPC_LIGHTGREEN..'|link=@jumparea_button#sid='..JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1..'>')        

    local damagehigh = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH)
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37, '<Text|x=-100|y=-210|color='..CSS.NPC_LIGHTGREEN..
        '|size=20|text=当前伤害总量:'..damagehigh..'万>')
end

local function ClearMapUI(actor)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_9)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37)
end

--玩家跨天回调
function JumpAreaBossDamageRank.OnResetDay(actor)    
    setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH, 0)
    setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_LOW, 0)
end

--进地图的回调
function JumpAreaBossDamageRank.OnEnterMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (mapidstr ~= ACTIVITY_BASE_CONFIG.bossmap) then
        return
    end
    InitMapUI(actor)
end

--离开地图的回调
function JumpAreaBossDamageRank.OnLeaveMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (mapidstr ~= ACTIVITY_BASE_CONFIG.bossmap) then
        return
    end    
    ClearMapUI(actor)    
end

--玩家死亡回调
function JumpAreaBossDamageRank.OnPlayerDie(actor, killername)
    if BF_IsNullObj(actor) then
        return
    end
    local mapid = Player.GetMapIDStr(actor)
    if mapid ~= ACTIVITY_BASE_CONFIG.bossmap then
        return
    end
    if not checkkuafu(actor) then
        return
    end

    --死亡返回原服盟重主城
    Player.GoMZHome(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, JumpAreaBossDamageRank.OnResetDay, CommonDefine.FUNC_ID_JUMPAREA_3)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, JumpAreaBossDamageRank.OnEnterMap, CommonDefine.FUNC_ID_JUMPAREA_3)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, JumpAreaBossDamageRank.OnLeaveMap, CommonDefine.FUNC_ID_JUMPAREA_3)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_DIE, JumpAreaBossDamageRank.OnPlayerDie, CommonDefine.FUNC_ID_JUMPAREA_3)

return JumpAreaBossDamageRank