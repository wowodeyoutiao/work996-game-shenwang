JumpAreaRandomFighting = {}

JumpAreaRandomFighting.CurrRankData = {}

local ACTIVITY_BASE_CONFIG = {
    bossmap = 'kuafurandfighting',
    monscorelist = {
        {monid=7102, score=10},
        {monid=7103, score=50},
        {monid=7104, score=100},
    },
    validweekday = {'2', '4'},
    starttime = {hour=20, min=30},
    endtime = {hour=21, min=0},
    enterintervalseconds = 10,        
    giverewarddelaymin = 10,        --活动结束后，延迟几分钟发奖励
    showreward = {{name='跨服积分', num=10000}, {name='6级筛子', num=50}, {name='绑定元宝', num=5000}},
    rankrewardlist = {
        --单独一列奖励不要超过7个
        {rankhigh=1, ranklow=1, showrank='1', rewardlist={{name='跨服积分', num=10000}, {name='6级筛子', num=50},{name='绑定元宝', num=5000}}},
        {rankhigh=2, ranklow=2, showrank='2', rewardlist={{name='跨服积分', num=7000}, {name='6级筛子', num=30},{name='绑定元宝', num=3000}}},
        {rankhigh=3, ranklow=3, showrank='3', rewardlist={{name='跨服积分', num=5000}, {name='6级筛子', num=20},{name='绑定元宝', num=2000}}},
        {rankhigh=4, ranklow=4, showrank='4', rewardlist={{name='跨服积分', num=3000}, {name='6级筛子', num=10},{name='绑定元宝', num=1000}}},
        {rankhigh=5, ranklow=5, showrank='5', rewardlist={{name='跨服积分', num=1000}, {name='6级筛子', num=5},{name='绑定元宝', num=500}}},
        {rankhigh=6, ranklow=10, showrank='6-10', rewardlist={{name='跨服积分', num=800}, {name='6级筛子', num=4},{name='绑定元宝', num=400}}},
        {rankhigh=11, ranklow=20, showrank='11-20', rewardlist={{name='跨服积分', num=700}, {name='6级筛子', num=3},{name='绑定元宝', num=300}}},
        {rankhigh=21, ranklow=40, showrank='21-40', rewardlist={{name='跨服积分', num=600}, {name='6级筛子', num=2},{name='绑定元宝', num=200}}},
        {rankhigh=41, ranklow=50, showrank='41-50', rewardlist={{name='跨服积分', num=500}, {name='6级筛子', num=1},{name='绑定元宝', num=100}}},
    },
}

function JumpAreaRandomFighting.GMResetCfg(actor)
    local now = os.date("*t")
    local currhour = tonumber(now.hour)
    local currmin = tonumber(now.min)
    ACTIVITY_BASE_CONFIG.validweekday = {'1', '2', '3', '4', '5', '6', '0', '7'}
    ACTIVITY_BASE_CONFIG.starttime.hour = currhour
    ACTIVITY_BASE_CONFIG.starttime.min = currmin
    ACTIVITY_BASE_CONFIG.endtime.hour = currhour
    ACTIVITY_BASE_CONFIG.endtime.min = math.min(59, currmin+5)
    ACTIVITY_BASE_CONFIG.giverewarddelaymin = 3
    local tempstr = tbl2json(ACTIVITY_BASE_CONFIG)
    setsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA, tempstr)
    setsysvar(CommonDefine.VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS, 0) 
    Player.SendSelfMsg(actor, '跨服大乱斗设置成当前开启，5分钟后结束，结束3分钟后发奖（本服）！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--显示规则面板
function JumpAreaRandomFighting.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=跨服大乱斗规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
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

function JumpAreaRandomFighting.GetShowInfo(actor)
    local sPanelStr = ''
    local tempX = 20
    local tempY = 20
    sPanelStr = sPanelStr..'<Text|id=101|text=时间设定：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
    tempY = tempY + 35
    sPanelStr = sPanelStr..'<Text|id=102|text=玩法说明：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'
    tempY = tempY + 140
    sPanelStr = sPanelStr..'<Text|id=103|text=奖励内容：|size=22|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_YELLOW..'>'        
    tempX = 130
    tempY = 25
    sPanelStr = sPanelStr..'<Text|id=104|text=每周二和周四晚上8点30~9点为开放挑战时间|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30
    sPanelStr = sPanelStr..'<Text|id=105|text=开放时间地图内，玩家可以进入副本战斗。副本内随机|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30
    sPanelStr = sPanelStr..'<Text|id=106|text=多种不同品质的怪物，击杀怪物后获得抗魔值，抗魔值|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30    
    sPanelStr = sPanelStr..'<Text|id=107|text=越高，最终获得奖励最大。在战场内击杀其它玩家后，|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30        
    sPanelStr = sPanelStr..'<Text|id=108|text=可获得其1/10抗魔值！|size=18|x='..tempX..'|y='..tempY..'|color='..CSS.NPC_WHITE..'>'
    tempY = tempY + 30

    local itemshowidstr = ''
    local itemshowid = 110
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA)
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
    sPanelStr = sPanelStr..'<Layout|id=15|children={50,51,52,53,54,101,102,103,104,105,106,107,108,'..itemshowidstr..',60}|x=200.0|y=65.0|width=580|height=420>'
    sPanelStr = sPanelStr..'<Button|id=50|x=220|y=360|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=进    入|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_7..'>'
    sPanelStr = sPanelStr..'<Button|id=51|x=20|y=270|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=实时榜单|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_10..'>'..
        '<Button|id=52|x=450|y=270|pimg=private/cc_jumparea/4.png|nimg=private/cc_jumparea/4.png|color='..CSS.NPC_WHITE..
        '|size=18|text=奖励预览|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_8..'>'

    local showflag = getplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2) 
    if showflag == 1 then
        --实时排名
        sPanelStr = sPanelStr..'<Img|id=60|children={61,62,63,64,65}|x=50.0|y=30.0|img=private/cc_common/rule_panel.png|reset=1|esc=1|loadDelay=0|move=0|show=0>'..
        '<Layout|id=61|x=530.0|y=1.0|width=80|height=80|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_9..'>'..
        '<Button|id=62|x=530.0|y=2.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_9..'>'

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
                '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text=排名>'..
                '<Text|id='..nTextID2..'|x=200|y=10|color=255|size=20|text=角色名>'..
                '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=20|text=抗魔值>'
        end
        
        local tabDataRank = {}
        local strDataRank = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA)
        if strDataRank~=nil and strDataRank~='' then
            tabDataRank = json2tbl(strDataRank)
            if tabDataRank ~= nil then
                nStartID = nStartID + 10        
                for seq, value in ipairs(tabDataRank) do        
                    local nLayoutID = nStartID + seq * 10 + 1
                    if strItems ~= '' then
                        strItems = strItems..','
                    end
                    strItems = strItems..nLayoutID
            
                    local nTextID1 = nStartID + seq * 10 + 2
                    local nTextID2 = nStartID + seq * 10 + 3
                    local nTextID3 = nStartID + seq * 10 + 4
                    local strTextIDs = nTextID1..','..nTextID2..','..nTextID3
                    sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=50>'..
                        '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text='..seq..'>'..
                        '<Text|id='..nTextID2..'|x=150|y=10|color=255|size=20|text='..value.showname..'>'..
                        '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=20|text='..value.currscore..'>'
                end
            end
        end
        
        local currscore = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE)     
        local strShowScoreInfo = '当前抗魔值:'..currscore

        sPanelStr = sPanelStr..'<ListView|id=63|children={'..strItems..'}|x=20.0|y=40|width=480|height=250|margin=0|direction=1>'..
            '<Text|id=64|x=180|y=300|color='..CSS.NPC_LIGHTGREEN..'|size=18|text='..strShowScoreInfo..'>'..
            '<Text|id=65|x=180|y=320|color=255|size=16|text=(结束10分钟后邮件发送奖励)>'    
    elseif showflag == 2 then
        --预览奖励
        sPanelStr = sPanelStr..'<Img|id=60|children={61,62,63}|x=50.0|y=30.0|img=private/cc_common/rule_panel.png|reset=1|esc=1|loadDelay=0|move=0|show=0>'..
        '<Layout|id=61|x=530.0|y=1.0|width=80|height=80|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_9..'>'..
        '<Button|id=62|x=530.0|y=2.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_9..'>'
        
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
                '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text=排名>'..
                '<Text|id='..nTextID2..'|x=300|y=10|color=255|size=20|text=奖励列表>'
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
function JumpAreaRandomFighting.EnterBossMap(actor)
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    local currtime = os.time()
    local currhour = BF_GetHour(currtime)
    local currmin = BF_GetMinute(currtime)

    local weekday = os.date("%w")
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

local function UpdateKMScoreShow(actor)
    if not BF_IsNullObj(actor) then
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37)
        local score = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE)
        addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37, '<Text|x=-100|y=-210|color='..CSS.NPC_LIGHTGREEN..
            '|size=20|text=当前抗魔值:'..score..'>')
    end
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

--本服的定时执行逻辑
function JumpAreaRandomFighting.OnLocalServerTimer() 
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    local weekday = os.date("%w")    
    if table.indexof(ACTIVITY_BASE_CONFIG.validweekday, weekday) == false then
        --非活动日不处理相关逻辑        
        return
    end     

    local currtime = os.time()
    local currhour = BF_GetHour(currtime)
    local currmin = BF_GetMinute(currtime)    
    local rewardstatus = getsysvar(CommonDefine.VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS)
    if (rewardstatus == 1) and ((currhour<ACTIVITY_BASE_CONFIG.starttime.hour) or (currhour==ACTIVITY_BASE_CONFIG.starttime.hour and currmin<ACTIVITY_BASE_CONFIG.starttime.min)) then
        setsysvar(CommonDefine.VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS, 0)        
    end

    --游戏结束 10分钟后发奖
    rewardstatus = getsysvar(CommonDefine.VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS)  
    if (rewardstatus == 0) and BF_IsDelayedByMinutes(ACTIVITY_BASE_CONFIG.endtime, ACTIVITY_BASE_CONFIG.giverewarddelaymin) then
        local strBossDamageRank = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA)
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
                                Player.OfflineGiveItems(value.playerid, rewarditems, '跨服大乱斗排行奖励', '恭喜你获得跨服大乱斗排行第'..seq..'名！')
                            end
                        end                        
                    end
                end
            end
            setsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA, '')
        end

        setsysvar(CommonDefine.VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS, 1) 
    end
end

--跨服的跨天处理
function JumpAreaRandomFighting.OnDayChange()
    JumpAreaRandomFighting.CurrRankData = {}
end

--跨服服务器更新实时的排行榜数据
local function UpdateRankData(actor, score)
    if BF_IsNullObj(actor) then
        return
    end

    local bFind = false
    local currplayerid = Player.GetPlayerIDStr(actor)
    local rec = {playerid = currplayerid, currscore = score, showname = Player.GetName(actor)}
    for _, value in ipairs(JumpAreaRandomFighting.CurrRankData) do
        if value.playerid ==  currplayerid then
            value.currscore = score
            bFind = true
            break
        end
    end
    if bFind == false then        
        JumpAreaRandomFighting.CurrRankData[#JumpAreaRandomFighting.CurrRankData+1] = rec
    end

    table.sort(JumpAreaRandomFighting.CurrRankData, function(a, b)
        return a.currscore > b.currscore
    end)

    local sInfo = tbl2json(rec)
    kfbackcall(CommonDefine.KFBCMSG_UPDATE_JUMPAREA_RANDFIGHTING_RANK, '0', sInfo, '')
end

--本地服务器更新收到的单条信息
function JumpAreaRandomFighting.LocalServerUpdateInfo(sUpdateInfoStr)
    if sUpdateInfoStr == '' then
        return
    end
    local updateRec = json2tbl(sUpdateInfoStr)
    if not BF_IsTable(updateRec) then
        return
    end
    local strRank = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA)
    local tabRank = {}
    if strRank~=nil and strRank~='' then
        tabRank = json2tbl(strRank)
    end  
    if not BF_IsTable(tabRank) then
        return
    end
    
    local bFind = false
    local currplayerid = updateRec.playerid
    for _, value in ipairs(tabRank) do
        if value.playerid == currplayerid then
            value.currscore = updateRec.currscore
            bFind = true
            break
        end
    end
    if bFind == false then
        local rec = {playerid = updateRec.playerid, currscore = updateRec.currscore, showname = updateRec.showname}
        tabRank[#tabRank+1] = rec
    end
    table.sort(tabRank, function(a, b)
        return a.currscore > b.currscore
    end)

    local sDataStr = tbl2json(tabRank)
    setsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA, sDataStr)
end

local function InitMapUI(actor)
    local sJsonStr = getsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA)
    if sJsonStr~=nil and sJsonStr~='' then
        ACTIVITY_BASE_CONFIG = json2tbl(sJsonStr)
    end

    local now = os.date("*t")
    local nEndTotal = ACTIVITY_BASE_CONFIG.endtime.hour * 60 + ACTIVITY_BASE_CONFIG.endtime.min
    local nCurrentTotal = now.hour * 60 + now.min
    local nStaySeconds = math.max(0, nEndTotal-nCurrentTotal) * 60
    if nStaySeconds == 0 then
        nStaySeconds = 5
    end

    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8, '<Button|text=离开地图|x=850|y=36|color='..CSS.NPC_WHITE..
        '|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@jumparea_button#sid='..JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1..'>')
    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_9, '<COUNTDOWN|x=870|y=76|time='..nStaySeconds..
        '|count=1|size=16|color='..CSS.NPC_LIGHTGREEN..'|link=@jumparea_button#sid='..JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1..'>')        
    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_35, '<Button|text=实时排名|x=850|y=116|color='..CSS.NPC_WHITE..
        '|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@jumparea_button#sid='..JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_2..'>')        
    UpdateKMScoreShow(actor)
end

function JumpAreaRandomFighting.ShowCurrRankData(actor)
    --实时排名
    local sPanelStr = '<Img|id=60|children={61,62,63,64,65}|x=150.0|y=60.0|img=private/cc_common/rule_panel.png|reset=1|esc=1|loadDelay=0|move=0|show=0>'..
    '<Layout|id=61|x=530.0|y=1.0|width=80|height=80|link=@cc_exit_specialui>'..
    '<Button|id=62|x=530.0|y=2.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@cc_exit_specialui>'

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
            '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text=排名>'..
            '<Text|id='..nTextID2..'|x=200|y=10|color=255|size=20|text=角色名>'..
            '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=20|text=抗魔值>'
    end
    
    local tabDataRank = JumpAreaRandomFighting.CurrRankData
    if tabDataRank ~= nil then
        nStartID = nStartID + 10        
        for seq, value in ipairs(tabDataRank) do        
            local nLayoutID = nStartID + seq * 10 + 1
            if strItems ~= '' then
                strItems = strItems..','
            end
            strItems = strItems..nLayoutID
    
            local nTextID1 = nStartID + seq * 10 + 2
            local nTextID2 = nStartID + seq * 10 + 3
            local nTextID3 = nStartID + seq * 10 + 4
            local strTextIDs = nTextID1..','..nTextID2..','..nTextID3
            sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=480|height=50>'..
                '<Text|id='..nTextID1..'|x=50|y=10|color=255|size=20|text='..seq..'>'..
                '<Text|id='..nTextID2..'|x=150|y=10|color=255|size=20|text='..value.showname..'>'..
                '<Text|id='..nTextID3..'|x=380|y=10|color=255|size=20|text='..value.currscore..'>'
        end
    end
    
    local currscore = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE)     
    local strShowScoreInfo = '当前抗魔值:'..currscore

    sPanelStr = sPanelStr..'<ListView|id=63|children={'..strItems..'}|x=20.0|y=40|width=480|height=250|margin=0|direction=1>'..
        '<Text|id=64|x=180|y=300|color='..CSS.NPC_LIGHTGREEN..'|size=18|text='..strShowScoreInfo..'>'..
        '<Text|id=65|x=180|y=320|color=255|size=16|text=(结束10分钟后邮件发送奖励)>'

    BF_ShowSpecialUI(actor, sPanelStr, 1)
end

local function ClearMapUI(actor)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_9)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_35)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37)
end

--玩家跨天回调
function JumpAreaRandomFighting.OnResetDay(actor)    
    setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE, 0)
end

--进地图的回调
function JumpAreaRandomFighting.OnEnterMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (mapidstr ~= ACTIVITY_BASE_CONFIG.bossmap) then
        return
    end
    InitMapUI(actor)
end

--离开地图的回调
function JumpAreaRandomFighting.OnLeaveMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (mapidstr ~= ACTIVITY_BASE_CONFIG.bossmap) then
        return
    end    
    ClearMapUI(actor)    
end

--玩家死亡回调
function JumpAreaRandomFighting.OnPlayerDie(actor, killername)
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

    local killer = getplayerbyname(killername)
    if Player.IsPlayer(killer) then
        local currscore = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE)
        local chgscore = math.floor(currscore * 0.1)
        if chgscore > 0 then
            local killerscore = getplaydef(killer, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE)
            setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE, currscore - chgscore)
            setplaydef(killer, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE, killerscore + chgscore)
            UpdateKMScoreShow(actor)
            UpdateRankData(actor, currscore - chgscore)
            UpdateKMScoreShow(killer)
            UpdateRankData(actor, killerscore + chgscore)
        end
    end

    --死亡后原地图复活 随机
    realive(actor)
    Player.FullHPMP(actor)
    map(actor, ACTIVITY_BASE_CONFIG.bossmap)
    Player.SendSelfMsg(actor, '你被'..killername..'击杀，已复活请再接再厉！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--击杀怪物触发
function JumpAreaRandomFighting.OnKillMon(actor, mon, killtype, mapidstr)
    if BF_IsNullObj(actor) or BF_IsNullObj(mon) then
        return
    end
    if mapidstr ~= ACTIVITY_BASE_CONFIG.bossmap then
        return
    end
    if not checkkuafu(actor) then
        return
    end
    if killtype ~= '2' then
        return
    end

    local monid = Player.GetMonIdx(mon) 
    for _, value in ipairs(ACTIVITY_BASE_CONFIG.monscorelist) do
        if value.monid == monid then
            local currscore = getplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE) + value.score            
            setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_FIGHTING_KMVALUE, currscore)           
            UpdateKMScoreShow(actor)
            UpdateRankData(actor, currscore)
            break
        end
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, JumpAreaRandomFighting.OnResetDay, CommonDefine.FUNC_ID_JUMPAREA_2)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, JumpAreaRandomFighting.OnEnterMap, CommonDefine.FUNC_ID_JUMPAREA_2)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, JumpAreaRandomFighting.OnLeaveMap, CommonDefine.FUNC_ID_JUMPAREA_2)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_DIE, JumpAreaRandomFighting.OnPlayerDie, CommonDefine.FUNC_ID_JUMPAREA_2)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_KILL_MON, JumpAreaRandomFighting.OnKillMon, CommonDefine.FUNC_ID_JUMPAREA_2)


return JumpAreaRandomFighting