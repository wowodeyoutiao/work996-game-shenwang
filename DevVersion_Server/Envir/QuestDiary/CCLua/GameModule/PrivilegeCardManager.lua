--特权卡
PrivilegeCardManager = {}

--functionid
local PRIVILEGECARD_BUTTONFUNC_ID_1 = 1    --显示特权卡基础界面
local PRIVILEGECARD_BUTTONFUNC_ID_2 = 2    --购买特权卡

local PRIVILEGE_LEVEL_1 = 1;                     --周卡
local PRIVILEGE_LEVEL_2 = 2;                  	 --月卡
local PRIVILEGE_LEVEL_3 = 3;                     --季卡

--是否显示功能入口icon
function PrivilegeCardManager.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return false
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
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、白嫖礼包分为多种类别的礼包，每一类礼包分为多个档次。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、每一类礼包只能选择一个档次进行种草，种草期结束后即|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=可免费领取礼包。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=3、每一类礼包均可以通过元宝直接购买，且随着购买次数的|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=增加，礼包折扣力度也会增加。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    

    BF_ShowSpecialUI(actor, strPanelInfo)    
end

--基础面板
function PrivilegeCardManager.ShowBasePanel(actor)        
    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16,17,18,19}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|height=448|esc=1|bg=1|img=private/cc_baipiao/8.png|loadDelay=0|reset=1|show=0|move=0>'..
        '<Layout|id=11|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'..
        '<Img|id=16|x=160|y=90|width=300|height=22|img=private/cc_baipiao/1.png>'..
        '<Img|id=17|x=460|y=90|width=320|height=22|img=private/cc_baipiao/2.png>'
    
 
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

    end
end

--购买特权卡
function PrivilegeCardManager.BuyCard(actor, cardlevel)

end

return PrivilegeCardManager