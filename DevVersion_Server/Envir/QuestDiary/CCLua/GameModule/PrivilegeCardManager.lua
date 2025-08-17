--特权卡
PrivilegeCardManager = {}

--functionid
local PRIVILEGECARD_BUTTONFUNC_ID_1 = 1    --显示特权卡基础界面
local PRIVILEGECARD_BUTTONFUNC_ID_2 = 2    --购买特权卡

local PRIVILEGE_LEVEL_1 = 1;                     --周卡
local PRIVILEGE_LEVEL_2 = 2;                  	 --月卡
local PRIVILEGE_LEVEL_3 = 3;                     --季卡

--特区卡配置
local PRIVILEGE_CARD_CONFIG = {
    [PRIVILEGE_LEVEL_1] = {
        ShowName = '周卡',
        NeedItems = {{name='元宝', num=1000}},
        ValidDays = 7,
        Desc = '1、购买后每日可领100元宝\\2、月光宝盒每日开启上限增加\\100次（与VIP增加次数叠加生效）\\3、对怪增伤提升：5%',
        BuyDayVar = CommonDefine.VAR_U_PRIVILEGE_CARD_1_BUY_DAY,
        DayGiveItems = {{name='元宝', num=100}},
        SuperBoxMaxDayOpenAddNum = 100,
        MonAddDamageRate = 5,
        HumAddDamageRate = 0,
    },
    [PRIVILEGE_LEVEL_2] = {
        ShowName = '月卡',
        NeedItems = {{name='元宝', num=5000}},
        ValidDays = 30,
        Desc = '1、购买后每日可领150元宝\\2、月光宝盒每日开启上限增加\\200次（与VIP增加次数叠加生效）\\3、对怪增伤提升：10%\\4、对人增伤提升：10%',
        BuyDayVar = CommonDefine.VAR_U_PRIVILEGE_CARD_2_BUY_DAY,
        DayGiveItems = {{name='元宝', num=150}},
        SuperBoxMaxDayOpenAddNum = 200,
        MonAddDamageRate = 10,
        HumAddDamageRate = 10,
    },
    [PRIVILEGE_LEVEL_3] = {
        ShowName = '季卡',
        NeedItems = {{name='元宝', num=20000}},
        ValidDays = 90,
        Desc = '1、购买后每日可领200元宝\\2、月光宝盒每日开启上限增加\\400次（与VIP增加次数叠加生效）\\3、对怪增伤提升：20%\\4、对人增伤提升：20%',
        BuyDayVar = CommonDefine.VAR_U_PRIVILEGE_CARD_3_BUY_DAY,
        DayGiveItems = {{name='元宝', num=200}},
        SuperBoxMaxDayOpenAddNum = 400,
        MonAddDamageRate = 20,
        HumAddDamageRate = 20,
    },
}

--是否显示功能入口icon
function PrivilegeCardManager.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return true
end

local function GetCardLeftValidDays(actor, cardlevel)
    if BF_IsNullObj(actor) then
        return 0
    end
    local cfgPrivilege = PRIVILEGE_CARD_CONFIG[cardlevel]
    if cfgPrivilege == nil then
        return 0
    end

    local LastBuyDay = getplaydef(actor, cfgPrivilege.BuyDayVar)
    if LastBuyDay == 0 then
        return 0
    end
    local currday = BF_GetDay(os.time())
    if math.abs(currday - LastBuyDay) > cfgPrivilege.ValidDays then
        return 0
    end
    return cfgPrivilege.ValidDays - math.abs(currday - LastBuyDay)
end

local function GetCurrMaxPrivilegeLevel(actor)
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_3) > 0 then
        return PRIVILEGE_LEVEL_3
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_2) > 0 then
        return PRIVILEGE_LEVEL_2
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_1) > 0 then
        return PRIVILEGE_LEVEL_1
    end
    return 0
end

function PrivilegeCardManager.GetSuperBoxDayOpenAddNum(actor)
    if BF_IsNullObj(actor) then
        return 0
    end
    local nMaxLevel = GetCurrMaxPrivilegeLevel(actor)
    if (nMaxLevel >= PRIVILEGE_LEVEL_1) and (nMaxLevel <= PRIVILEGE_LEVEL_3) then
        return PRIVILEGE_CARD_CONFIG[nMaxLevel].SuperBoxMaxDayOpenAddNum
    end
    return 0
end

function PrivilegeCardManager.GetAttackDamageAddRate(actor, target)
    if BF_IsNullObj(actor) then
        return 0
    end

    local nMaxLevel = GetCurrMaxPrivilegeLevel(actor)
    if (nMaxLevel >= PRIVILEGE_LEVEL_1) and (nMaxLevel <= PRIVILEGE_LEVEL_3) then
        local bTargIsPlayer = false
        if not BF_IsNullObj(target) then
            if Player.IsPlayer(target) then
                bTargIsPlayer = true
            end
        end

        if bTargIsPlayer then
            return PRIVILEGE_CARD_CONFIG[nMaxLevel].HumAddDamageRate
        else
            return PRIVILEGE_CARD_CONFIG[nMaxLevel].MonAddDamageRate
        end
    end
    return 0    
end

function PrivilegeCardManager.GetMonAddDamageRate(actor)
    if BF_IsNullObj(actor) then
        return 0
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_3) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_3].MonAddDamageRate
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_2) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_2].MonAddDamageRate
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_1) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_1].MonAddDamageRate
    end    
    return 0
end

function PrivilegeCardManager.GetHumAddDamageRate(actor)
    if BF_IsNullObj(actor) then
        return 0
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_3) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_3].HumAddDamageRate
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_2) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_2].HumAddDamageRate
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_1) > 0 then
        return PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_1].HumAddDamageRate
    end    
    return 0
end

--规则说明
function PrivilegeCardManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'    

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=特权卡规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、周卡、月卡、季卡每种购买后在持续时间内无法再次购买|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、三种卡可同时购买，购买后道具奖励可以叠加领取，特权|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=内容则相同种类取最高值，不同种类同时生效|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=3、特权卡每日奖励将会通过邮件附件发放，注意查收|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)    
end

--基础面板
function PrivilegeCardManager.ShowBasePanel(actor)        
    local strPanelInfo = '<Img|id=10|children={11,12,13,21,22,23,31,32,33}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|height=448|esc=1|bg=1|img=private/cc_privilege_card/1.png|loadDelay=0|reset=1|show=0|move=0>'..
        '<Layout|id=11|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

    local cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_1]
    strPanelInfo = strPanelInfo..'<RText|id=31|x=80|y=240|size=15|text='..cfgPrivilege.Desc..'>'
    local leftValidDays = GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_1)
    if leftValidDays > 0 then
        strPanelInfo = strPanelInfo..'<Button|id=21|x=130|y=370|text=剩余'..leftValidDays..'天|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png>'
    else
        strPanelInfo = strPanelInfo..'<Button|id=21|x=130|y=370|text=购买周卡|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..
        PRIVILEGECARD_BUTTONFUNC_ID_2..','..PRIVILEGE_LEVEL_1..'>'
    end

    cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_2]
    strPanelInfo = strPanelInfo..'<RText|id=32|x=320|y=240|size=15|text='..cfgPrivilege.Desc..'>'
    leftValidDays = GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_2)
    if leftValidDays > 0 then
        strPanelInfo = strPanelInfo..'<Button|id=22|x=370|y=370|text=剩余'..leftValidDays..'天|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png>'
    else
        strPanelInfo = strPanelInfo..'<Button|id=22|x=370|y=370|text=购买月卡|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..
        PRIVILEGECARD_BUTTONFUNC_ID_2..','..PRIVILEGE_LEVEL_2..'>'
    end    

    cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_3]
    strPanelInfo = strPanelInfo..'<RText|id=33|x=570|y=240|size=15|text='..cfgPrivilege.Desc..'>'    
    leftValidDays = GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_3)
    if leftValidDays > 0 then
        strPanelInfo = strPanelInfo..'<Button|id=23|x=620|y=370|text=剩余'..leftValidDays..'天|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png>'
    else
        strPanelInfo = strPanelInfo..'<Button|id=23|x=620|y=370|text=购买季卡|size=18|color='..CSS.NPC_LIGHTGREEN..
        '|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_up.png|nimg=private/cc_common/button_up.png|link=@function_button,'..
        PRIVILEGECARD_BUTTONFUNC_ID_2..','..PRIVILEGE_LEVEL_3..'>'
    end
    
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function PrivilegeCardManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

    local funcid = tonumber(sid)
    local nparam = 0
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    if funcid == PRIVILEGECARD_BUTTONFUNC_ID_1 then
        PrivilegeCardManager.ShowBasePanel(actor)
    elseif funcid == PRIVILEGECARD_BUTTONFUNC_ID_2 then
        PrivilegeCardManager.BuyCard(actor, nparam)
    end
end

--购买特权卡
function PrivilegeCardManager.BuyCard(actor, cardlevel)
    if BF_IsNullObj(actor) then
        return
    end
    if (cardlevel < PRIVILEGE_LEVEL_1) or (cardlevel > PRIVILEGE_LEVEL_3) then
        return
    end
    local cfgPrivilege = PRIVILEGE_CARD_CONFIG[cardlevel]
    if cfgPrivilege == nil then
        return
    end

    local leftValidDays = GetCardLeftValidDays(actor, cardlevel)
    if leftValidDays > 0 then
        Player.SendSelfMsg(actor, cfgPrivilege.ShowName..'还剩余'..leftValidDays..'天，相同特权卡不可叠加购买！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgPrivilege.NeedItems, '购买特权卡：'..cardlevel) then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, cfgPrivilege.NeedItems, '购买特权卡：'..cardlevel)

    setplaydef(actor, cfgPrivilege.BuyDayVar, BF_GetDay(os.time()))
    Player.GiveItemsByMail(actor, cfgPrivilege.DayGiveItems, '特权卡奖励', '购买'..cfgPrivilege.ShowName..'，发放每日奖励！')   
    Player.SendSelfMsg(actor, '成功购买'..cfgPrivilege.ShowName..',有效期'..cfgPrivilege.ValidDays..'天！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
    PrivilegeCardManager.ShowBasePanel(actor)
end

--玩家跨天回调
function PrivilegeCardManager.OnResetDay(actor)    
    if BF_IsNullObj(actor) then
        return
    end    
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_3) > 0 then
        local cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_3]
        Player.GiveItemsByMail(actor, cfgPrivilege.DayGiveItems, '特权卡奖励', '购买'..cfgPrivilege.ShowName..'，发放每日奖励！')   
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_2) > 0 then
        local cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_2]
        Player.GiveItemsByMail(actor, cfgPrivilege.DayGiveItems, '特权卡奖励', '购买'..cfgPrivilege.ShowName..'，发放每日奖励！')   
    end
    if GetCardLeftValidDays(actor, PRIVILEGE_LEVEL_1) > 0 then
        local cfgPrivilege = PRIVILEGE_CARD_CONFIG[PRIVILEGE_LEVEL_1]
        Player.GiveItemsByMail(actor, cfgPrivilege.DayGiveItems, '特权卡奖励', '购买'..cfgPrivilege.ShowName..'，发放每日奖励！')   
    end 
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, PrivilegeCardManager.OnResetDay, CommonDefine.FUNC_ID_PRIVILEGE_CARD)

return PrivilegeCardManager