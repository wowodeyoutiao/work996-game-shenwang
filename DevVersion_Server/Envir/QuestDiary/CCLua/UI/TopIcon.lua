TopIcon = {}

local ICON_GATHER = '1'                         --收缩面板
local ICON_EXTEND = '2'                         --展开面板
local ICON_SUPERBOX = '3'                       --月光宝盒
local ICON_GMMODE = '4'                         --管理模式
local ICON_FIRSTRECHARGE = '5'                  --首充
local ICON_NEWPLAYER_RECHARGEACTIVITY = '6'     --新人充值返利
local ICON_OPENSERVERACTIVITY = '7'             --开服活动
local ICON_EXTENDGIFT = '8'                     --进阶礼包
local ICON_FREEVIP = '9'                        --免费VIP
local ICON_JUMPAREA = '10'                      --跨服玩法
local ICON_EVERYDAY_TASK = '11'                 --每日必做
local ICON_BAIPIAO_GIFT = '12'                  --白嫖礼包
local ICON_EXTEND_STORAGE_MAKESURE = '13'       --仓库扩容，确认
local ICON_SHOW_QUICK_TIP_PANEL = '14'          --打开有红点功能对应的快捷提示框
local ICON_QUICK_TIP_GOTO = '15'                --对应红点功能提示的快捷前往
local ICON_HIDE_QUICK_TIP_PANEL = '16'          --关闭有红点功能对应的快捷提示框

local ICON_GATHER_POP_ABILITY = '20'            --收缩快捷属性面板
local ICON_EXTEND_POP_ABILITY = '21'            --展开快捷属性面板


local MAINICON_ID_1 = 'mainicon_1'              --进阶礼包 iconid
local MAINICON_ID_2 = 'mainicon_2'              --开服活动 iconid
local MAINICON_ID_3 = 'mainicon_3'              --新人充值返利 iconid
local MAINICON_ID_4 = 'mainicon_4'              --首充 iconid
local MAINICON_ID_5 = 'mainicon_5'              --每日必做 iconid
local MAINICON_ID_6 = 'mainicon_6'              --免费VIP iconid
local MAINICON_ID_7 = 'mainicon_7'              --跨服玩法 iconid
local MAINICON_ID_8 = 'mainicon_8'              --白嫖礼包 iconid
local MAINICON_ID_9 = 'mainicon_9'              --月光宝盒 iconid


function TopIcon.InitUI(actor)
    --主界面入口icon
    TopIcon.InnerExtendPanel(actor)
    TopIcon.InnerExtendPanel2(actor)

    setontimer(actor, CommonDefine.TIMER_ID_CHECK_TOPICON_REDPOINT, 10, 0, 0)
    setontimer(actor, CommonDefine.TIMER_ID_CHECK_QUICK_GOTO_TIP, 30, 0, 0)

    TopIcon.CheckRedPoint(actor)
    TopIcon.CheckQuickInfoTip(actor)
end

function TopIcon.HideUI(actor)
    delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33)
    delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34) 
end

function TopIcon.OpenPanel(actor, sid, sparam)
    if (actor == nil) or (sid == nil) then
        return
    end
    
    local nparam = 0 
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    if sid == ICON_GATHER then
        TopIcon.InnerGatherPanel(actor)
    elseif sid == ICON_EXTEND then
        TopIcon.InnerExtendPanel(actor)
    elseif sid == ICON_GMMODE then
        TopIcon.InnerGMModePanel(actor)        
    elseif sid == ICON_FIRSTRECHARGE then
        --首充
        FirstRecharge.OpenPanel(actor)
    elseif sid == ICON_NEWPLAYER_RECHARGEACTIVITY then
        --新人充值返利活动
        ActivityNewPlayerRecharge.OpenPanel(actor)
    elseif sid == ICON_OPENSERVERACTIVITY then
        --开服活动
        ActivityOpenServer.OpenPanel(actor)
    elseif sid == ICON_EXTENDGIFT then
        --进阶礼包
        ActivityExtendGift.OpenPanel(actor)
    elseif sid == ICON_EVERYDAY_TASK then
        --每日必做
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EVERYDAY_TASK, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_EVERYDAY_TASK)        
        EverydayTask.OpenPanel(actor)
    elseif sid == ICON_FREEVIP then
        --免费VIP
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_FREEVIP, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_FREEVIP)
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        FreeVIPManager.ShowBasePanel(actor)
    elseif sid == ICON_JUMPAREA then
        --跨服活动
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_JUMPAREA_BASE)        
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        JumpAreaManager.ShowBasePanel(actor)
    elseif sid == ICON_BAIPIAO_GIFT then
        --白嫖礼包        
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAIPIAO_GIFT, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_BAIPIAO_GIFT)
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1, 0)
        BaiPiaoGift.ShowBasePanel(actor)
    elseif sid == ICON_SUPERBOX then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_SUPERBOX, true) then
            return
        end    
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SHOW_SUPERBOX_UI_FLAG, 1)        
        OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    elseif sid == ICON_EXTEND_STORAGE_MAKESURE then
        --扩容仓库 确定
        TopIcon.DoExtendStorage(actor)
    elseif sid == ICON_SHOW_QUICK_TIP_PANEL then
        --打开有红点功能对应的快捷提示框
        TopIcon.ShowQuickInfoTipPanel(actor)
    elseif sid == ICON_HIDE_QUICK_TIP_PANEL then
        TopIcon.HideQuickInfoTipPanel(actor)
    elseif sid == ICON_QUICK_TIP_GOTO then
        --对应红点功能提示的快捷前往
        TopIcon.DoQuickInfoTipGoTo(actor, nparam)       
    elseif sid == ICON_GATHER_POP_ABILITY then
        TopIcon.InnerGatherPanel2(actor)
    elseif sid == ICON_EXTEND_POP_ABILITY then
        TopIcon.InnerExtendPanel2(actor)        
    end
end

function TopIcon.InnerGatherPanel(actor)
    delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33)
    delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34)
    addbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33, '<Button|x=-220|y=14|nimg=custom/30001.png|link=@topicon_openpanel#sid='..ICON_EXTEND..'>')
end

function TopIcon.InnerExtendPanel(actor)
    local curlv = Player.GetLevel(actor)

    delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33)    
    local currIconX = -220
    local buttonstr = '<Button|x='..currIconX..'|y=14|nimg=custom/30002.png|link=@topicon_openpanel#sid='..ICON_GATHER..'>'    
    currIconX = currIconX - 80
    buttonstr = buttonstr..'<Button|x='..currIconX..'|y=10|nimg=private/cc_func_icon/5.png|link=@开启盒子>'
    currIconX = currIconX - 80
    buttonstr = buttonstr..'<Button|x='..currIconX..'|y=10|nimg=private/cc_func_icon/7.png|link=@打开账号交易>'

    if FirstRecharge.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_4..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/4.png|link=@topicon_openpanel#sid='..ICON_FIRSTRECHARGE..'>'
    end
    if ActivityOpenServer.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_2..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/1.png|link=@topicon_openpanel#sid='..ICON_OPENSERVERACTIVITY..'>'
    end
    if JumpAreaManager.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_7..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/6.png|link=@topicon_openpanel#sid='..ICON_JUMPAREA..'>'
    end
    currIconX = currIconX - 80
    buttonstr = buttonstr..'<Button|id='..MAINICON_ID_6..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/9.png|link=@topicon_openpanel#sid='..ICON_FREEVIP..'>'
    if EverydayTask.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_5..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/10.png|link=@topicon_openpanel#sid='..ICON_EVERYDAY_TASK..'>'        
    end
    currIconX = currIconX - 80
    buttonstr = buttonstr..'<Button|id='..MAINICON_ID_9..'|x='..currIconX..'|y=10|nimg=private/cc_func_icon/12.png|link=@topicon_openpanel#sid='..ICON_SUPERBOX..'>'
    addbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33, buttonstr)

    if curlv >= 40 then
        delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34)
        buttonstr = ''
        currIconX = -300
        buttonstr = buttonstr..'<Button|x='..currIconX..'|y=80|nimg=private/cc_func_icon/8.png|link=@元宝充值>'
        if ActivityExtendGift.CanShowIcon(actor) then
            currIconX = currIconX - 80
            buttonstr = buttonstr..'<Button|id='..MAINICON_ID_1..'|x='..currIconX..'|y=80|nimg=private/cc_func_icon/2.png|link=@topicon_openpanel#sid='..ICON_EXTENDGIFT..'>'        
        end        
        if ActivityNewPlayerRecharge.CanShowIcon(actor) then        
            currIconX = currIconX - 80
            buttonstr = buttonstr..'<Button|id='..MAINICON_ID_3..'|x='..currIconX..'|y=80|nimg=private/cc_func_icon/3.png|link=@topicon_openpanel#sid='..ICON_NEWPLAYER_RECHARGEACTIVITY..'>'
        end 
        if BaiPiaoGift.CanShowIcon(actor) then
            currIconX = currIconX - 80
            buttonstr = buttonstr..'<Button|id='..MAINICON_ID_8..'|x='..currIconX..'|y=80|nimg=private/cc_func_icon/11.png|link=@topicon_openpanel#sid='..ICON_BAIPIAO_GIFT..'>'        
        end        
        addbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34, buttonstr)
    end
end

function TopIcon.InnerGatherPanel2(actor)
    delbutton(actor, 105, CommonDefine.ADD_BUTTON_ID_41)
    addbutton(actor, 105, CommonDefine.ADD_BUTTON_ID_41, '<Button|x=10|y=-40|nimg=private/cc_popshow/3.png|link=@topicon_openpanel#sid='..ICON_EXTEND_POP_ABILITY..'>')
end

function TopIcon.InnerExtendPanel2(actor)
    delbutton(actor, 105, CommonDefine.ADD_BUTTON_ID_41)
    local nGiftValue1 = getplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_1)
    local nGiftValue2 = getplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_2)
    local nGiftValue3 = getplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_3)
    local nGiftValue4 = getplaydef(actor, CommonDefine.VAR_N_GIFT_ABILITY_4)
    local nQieGePoint = Player.GetQieGePoint(actor)
    local sPanelStr = '<Layout|id=5500|children={5507,5501,5502,5503,5504,5505,5506}|x=70|y=-40|width=150|height=120|color='..CSS.NPC_GRAY..'>'..
        '<Img|id=5507|x=0|y=0|img=private/cc_popshow/1.png>'..
        '<Button|id=5501|x=-60|y=0|nimg=private/cc_popshow/2.png|link=@topicon_openpanel#sid='..ICON_GATHER_POP_ABILITY..'>'..
        '<Text|id=5502|x=110|y=2|color='..CSS.NPC_LIGHTGREEN..'|size=16|text='..nGiftValue1..'%>'..
        '<Text|id=5503|x=110|y=28|color='..CSS.NPC_LIGHTGREEN..'|size=16|text='..nGiftValue2..'%>'..
        '<Text|id=5504|x=110|y=52|color='..CSS.NPC_LIGHTGREEN..'|size=16|text='..nGiftValue3..'%>'..
        '<Text|id=5505|x=110|y=76|color='..CSS.NPC_LIGHTGREEN..'|size=16|text='..nGiftValue4..'%>'..
        '<Text|id=5506|x=110|y=100|color='..CSS.NPC_LIGHTGREEN..'|size=16|text='..nQieGePoint..'>'
    addbutton(actor, 105, CommonDefine.ADD_BUTTON_ID_41, sPanelStr)
end

function TopIcon.CheckRedPoint(actor)
    if ActivityExtendGift.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_1, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_1)    
    end

    if ActivityOpenServer.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_2, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_2)    
    end

    if ActivityNewPlayerRecharge.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_3, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_3)    
    end

    if FirstRecharge.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_4, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_4)
    end

    if EverydayTask.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_5, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_5)
    end

    if BaiPiaoGift.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_8, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_8)
    end

    if FreeVIPManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_6, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_6)
    end

    if OpenSuperBoxManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 102, MAINICON_ID_9, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_9)
    end


    if EquipPosStrengthManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_POSSTRENGTH, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_POSSTRENGTH)
    end

    if EquipPosStarManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_POSSTAR, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_POSSTAR)
    end   
    
    if GuanZhiManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_GUANZHI, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_GUANZHI)  
    end

    if OfflineHuWeiManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_HUWEI, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_HUWEI)
    end

    if SkillUpgrade.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_SKILL, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_SKILL)
    end

    if SoulStoneManager.IsTopIconHaveRedPoint(actor) then
        Player.AddRedPoint(actor, 109, NewMainUIBase.UI_ICON_SOULSTONE, 10, 10)    
    else
        Player.DelRedPoint(actor, 109, NewMainUIBase.UI_ICON_SOULSTONE)
    end
end

function TopIcon.HideQuickInfoTipPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_31)
end

local function FillRedPointFunctionInfoList(actor, infolist)    
    if EquipPosStrengthManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_EQUIP_STRENGTH, name='槽位强化'}
    end
    if SoulStoneManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_SOULSTONE, name='魂石镶嵌'}
    end
    --if BaoZhuManager.IsHaveQuickTip(actor) then
    if BaoZhuManagerNew.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_BAOZHU, name='灵玉提升'}
    end
    if YunBiaoManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_YUNBIAO, name='运镖'}
    end
    if SingleBossManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_SINGLEBOSS, name='个人首领'}
    end
    if BaoZhuBossManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_KILL_BAOZHUBOSS, name='灵玉副本'}
    end
    if RandomBossManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_KILL_RANDOMBOSS, name='战力首领'}
    end
    if GuanZhiManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_GUANZHI, name='提升官职'}
    end
    if FreeVIPManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_FREEVIP, name='VIP奖励'}
    end
    if OfflineHuWeiManager.IsHaveQuickTipUpgrade(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_ZCD, name='护卫升级'}
    end
    if OfflineHuWeiManager.IsHaveQuickTipReward(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_ZCD, name='离线奖励'}
    end
    if OpenSuperBoxManager.IsHaveQuickTipReward(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_BAG_USEDICE, name='获得箱子'}
    end
end

function TopIcon.ShowQuickInfoTipPanel(actor)
    local funcinfolist = {}
    FillRedPointFunctionInfoList(actor, funcinfolist)

    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_31)
    local idstr1 = ''
    local strPanelInfo = '<Img|id=5100|children={5101,5102,5110}|x=160|y=-430|img=private/cc_quicktip/2.png>'..
        '<Layout|id=5101|x=130|y=0|width=80|height=80|link=@topicon_openpanel#sid='..ICON_HIDE_QUICK_TIP_PANEL..'>'..
        '<Button|id=5102|x=130|y=0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@topicon_openpanel#sid='..ICON_HIDE_QUICK_TIP_PANEL..'>'
    for seq, value in ipairs(funcinfolist) do
        local currid = 5110 + seq
        if idstr1 ~= '' then
            idstr1 = idstr1..','
        end
        idstr1 = idstr1..currid       
        strPanelInfo = strPanelInfo..'<Button|id='..currid..'|text='..value.name..'|size=18|x=4|y=0|nimg=private/cc_quicktip/3.png|mimg=private/cc_quicktip/3.png|link=@topicon_openpanel#sid='..
            ICON_QUICK_TIP_GOTO..'#sparam='..value.id..'>'    
    end
    strPanelInfo = strPanelInfo..'<ListView|id=5110|children={'..idstr1..'}|x=4.0|y=4.0|width=120|height=180|margin=0|direction=1>'        
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_31, strPanelInfo)
end

function TopIcon.DoQuickInfoTipGoTo(actor, gotoid) 
    if BF_IsNullObj(actor) or (gotoid == nil) then
        return
    end
    Player.QuickGoTo(actor, gotoid)
    TopIcon.HideQuickInfoTipPanel(actor)
end

function TopIcon.CheckQuickInfoTip(actor)
    if Player.GetLevel(actor) < CommonDefine.SHOW_QUICK_TIP_MIN_LEVEL then
        return
    end

    local bCurrShowFlag = 0    
    if EquipPosStrengthManager.IsHaveQuickTip(actor) or 
        SoulStoneManager.IsHaveQuickTip(actor) or 
        --BaoZhuManager.IsHaveQuickTip(actor) or
        BaoZhuManagerNew.IsHaveQuickTip(actor) or
        YunBiaoManager.IsHaveQuickTip(actor) or
        SingleBossManager.IsHaveQuickTip(actor) or
        BaoZhuBossManager.IsHaveQuickTip(actor) or
        RandomBossManager.IsHaveQuickTip(actor) or
        GuanZhiManager.IsHaveQuickTip(actor) or
        FreeVIPManager.IsHaveQuickTip(actor) or
        OfflineHuWeiManager.IsHaveQuickTipUpgrade(actor) or
        OfflineHuWeiManager.IsHaveQuickTipReward(actor) or
        OpenSuperBoxManager.IsHaveQuickTipReward(actor) then
        bCurrShowFlag = 1        
    end

    if bCurrShowFlag ~= getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SHOW_QUICKTIP_FLAG) then
        if bCurrShowFlag == 1 then
            delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32)
            local buttonstr = '<Button|x=180|y=-240|nimg=private/cc_quicktip/1.png|link=@topicon_openpanel#sid='..ICON_SHOW_QUICK_TIP_PANEL..'>'
            addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32, buttonstr)    
        else
            delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32)
        end
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SHOW_QUICKTIP_FLAG, bCurrShowFlag)        
    end
end


GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, TopIcon.InnerExtendPanel, CommonDefine.FUNC_ID_TOPICON)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, TopIcon.InitUI, CommonDefine.FUNC_ID_TOPICON)

return TopIcon