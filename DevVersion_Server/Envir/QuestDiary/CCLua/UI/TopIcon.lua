TopIcon = {}

local ICON_GATHER = '1'                         --收缩面板
local ICON_EXTEND = '2'                         --展开面板

local ICON_GMMODE = '4'                         --管理模式
local ICON_FIRSTRECHARGE = '5'                  --首充
local ICON_NEWPLAYER_RECHARGEACTIVITY = '6'     --新人充值返利
local ICON_OPENSERVERACTIVITY = '7'             --开服活动
local ICON_EXTENDGIFT = '8'                     --进阶礼包
local ICON_FREEVIP = '9'                        --免费VIP

local ICON_EVERYDAY_TASK = '11'                 --每日必做

local ICON_EXTEND_STORAGE_MAKESURE = '13'       --仓库扩容，确认
local ICON_SHOW_QUICK_TIP_PANEL = '14'          --打开有红点功能对应的快捷提示框
local ICON_QUICK_TIP_GOTO = '15'                --对应红点功能提示的快捷前往
local ICON_HIDE_QUICK_TIP_PANEL = '16'          --关闭有红点功能对应的快捷提示框




local MAINICON_ID_1 = 'mainicon_1'              --进阶礼包 iconid
local MAINICON_ID_2 = 'mainicon_2'              --开服活动 iconid
local MAINICON_ID_3 = 'mainicon_3'              --新人充值返利 iconid
local MAINICON_ID_4 = 'mainicon_4'              --首充 iconid
local MAINICON_ID_5 = 'mainicon_5'              --每日必做 iconid
local MAINICON_ID_6 = 'mainicon_6'              --免费VIP iconid


function TopIcon.InitUI(actor)
    --主界面入口icon
    TopIcon.InnerExtendPanel(actor)

    setontimer(actor, CommonDefine.TIMER_ID_CHECK_TOPICON_REDPOINT, 10, 0, 0)
    setontimer(actor, CommonDefine.TIMER_ID_CHECK_QUICK_GOTO_TIP, 30, 0, 0)
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
        EverydayTask.OpenPanel(actor)
    elseif sid == ICON_FREEVIP then
        --免费VIP
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_FREEVIP, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_FREEVIP)
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        FreeVIPManager.ShowBasePanel(actor)
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
    currIconX = currIconX - 70
    buttonstr = buttonstr..'<Layout|children=65001|x='..currIconX..'|y=10|width=55|height=55|link=@开启盒子>'..
        '<Effect|id=65001|x=20|y=57|effectid=5109|effecttype=0|scale=0.8>'        
    currIconX = currIconX - 90
    buttonstr = buttonstr..'<Button|x='..currIconX..'|y=10|nimg=custom/a00003.png|width=70|height=70|link=@打开账号交易>'

    if FirstRecharge.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_4..'|x='..currIconX..'|y=10|width=70|height=70|nimg=private/cc_func_icon/4.png|link=@topicon_openpanel#sid='..ICON_FIRSTRECHARGE..'>'
    end
    if ActivityOpenServer.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_2..'|x='..currIconX..'|y=10|width=70|height=70|nimg=private/cc_func_icon/1.png|link=@topicon_openpanel#sid='..ICON_OPENSERVERACTIVITY..'>'
    end
    currIconX = currIconX - 80
    buttonstr = buttonstr..'<Button|id='..MAINICON_ID_6..'|x='..currIconX..'|y=10|width=70|height=70|text=免费VIP|color=255|nimg=custom/a00016.png|link=@topicon_openpanel#sid='..ICON_FREEVIP..'>'
--[[
    if EverydayTask.CanShowIcon(actor) then
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|id='..MAINICON_ID_5..'|x='..currIconX..'|y=35|nimg=private/cc_func_icon/5.png|link=@topicon_openpanel#sid='..ICON_EVERYDAY_TASK..'>'        
    end
]]--
    addbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_33, buttonstr)

    if curlv >= 40 then
        delbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34)
        buttonstr = ''
        currIconX = -280
        buttonstr = buttonstr..'<Button|x='..currIconX..'|y=75|nimg=custom/a00002.png|width=70|height=70|link=@元宝充值>'
        currIconX = currIconX - 80
        buttonstr = buttonstr..'<Button|x='..currIconX..'|y=75|nimg=custom/a00016.png|width=70|height=70|link=@唯一会员>'
        if ActivityExtendGift.CanShowIcon(actor) then
            currIconX = currIconX - 80
            buttonstr = buttonstr..'<Button|id='..MAINICON_ID_1..'|x='..currIconX..'|y=75|width=70|height=70|nimg=private/cc_func_icon/2.png|link=@topicon_openpanel#sid='..ICON_EXTENDGIFT..'>'        
        end        
        if ActivityNewPlayerRecharge.CanShowIcon(actor) then        
            currIconX = currIconX - 80
            buttonstr = buttonstr..'<Button|id='..MAINICON_ID_3..'|x='..currIconX..'|y=75|width=70|height=70|nimg=private/cc_func_icon/3.png|link=@topicon_openpanel#sid='..ICON_NEWPLAYER_RECHARGEACTIVITY..'>'
        end            
        addbutton(actor, 102, CommonDefine.ADD_BUTTON_ID_34, buttonstr)
    end
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
--[[
    if EverydayTask.IsTopIconHaveRedPoint(actor) then    
        Player.AddRedPoint(actor, 102, MAINICON_ID_5, 10, 10)    
    else
        Player.DelRedPoint(actor, 102, MAINICON_ID_5)    
    end
]]--    
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
    if BaoZhuManager.IsHaveQuickTip(actor) then
        infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_BAOZHU, name='灵玉提升'}
    end
    -- if YunBiaoManager.IsHaveQuickTip(actor) then
    --     infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_YUNBIAO, name='运镖'}
    -- end
    -- if SingleBossManager.IsHaveQuickTip(actor) then
    --     infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_SINGLEBOSS, name='个人首领'}
    -- end
    -- if BaoZhuBossManager.IsHaveQuickTip(actor) then
    --     infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_KILL_BAOZHUBOSS, name='灵玉副本'}
    -- end
    -- if RandomBossManager.IsHaveQuickTip(actor) then
    --     infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_KILL_RANDOMBOSS, name='战力首领'}
    -- end
    -- if MoFangZhenManager.IsHaveQuickTip(actor) then
    --     infolist[#infolist+1] = {id=CommonDefine.QUICK_GOTO_KILL_RANDOMBOSS, name='战力首领'}
    -- end
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

    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32)
    if EquipPosStrengthManager.IsHaveQuickTip(actor) or 
        SoulStoneManager.IsHaveQuickTip(actor) or 
        BaoZhuManager.IsHaveQuickTip(actor) or
        -- YunBiaoManager.IsHaveQuickTip(actor) or
        -- SingleBossManager.IsHaveQuickTip(actor) or
        -- BaoZhuBossManager.IsHaveQuickTip(actor) or
        -- RandomBossManager.IsHaveQuickTip(actor) or
        -- MoFangZhenManager.IsHaveQuickTip(actor) or
        GuanZhiManager.IsHaveQuickTip(actor) or
        FreeVIPManager.IsHaveQuickTip(actor) or
        OfflineHuWeiManager.IsHaveQuickTipUpgrade(actor) or
        OfflineHuWeiManager.IsHaveQuickTipReward(actor) then

        local buttonstr = '<Button|x=210|y=-240|nimg=private/cc_quicktip/1.png|link=@topicon_openpanel#sid='..ICON_SHOW_QUICK_TIP_PANEL..'>'
        addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32, buttonstr)    
    end
end


GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, TopIcon.InnerExtendPanel, CommonDefine.FUNC_ID_TOPICON)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, TopIcon.InitUI, CommonDefine.FUNC_ID_TOPICON)

return TopIcon