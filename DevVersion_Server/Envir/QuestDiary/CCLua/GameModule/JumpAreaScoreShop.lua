JumpAreaScoreShop = {}

--显示规则面板
function JumpAreaScoreShop.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=跨服商店规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
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

function JumpAreaScoreShop.GetShowInfo(actor)
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

 

    return sPanelStr
end

--玩家跨天回调
function JumpAreaScoreShop.OnResetDay(actor)    
    
end


GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, JumpAreaScoreShop.OnResetDay, CommonDefine.FUNC_ID_JUMPAREA_5)

return JumpAreaScoreShop