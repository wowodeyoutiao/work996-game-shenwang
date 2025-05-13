JumpAreaManager = {}

JumpAreaManager.BUTTONFUNC_ID_1 = 1                  --切换跨服活动页签
JumpAreaManager.BUTTONFUNC_ID_2 = 2                  --进入跨服BOSS
JumpAreaManager.BUTTONFUNC_ID_3 = 3                  --显示跨服BOSS实时榜单
JumpAreaManager.BUTTONFUNC_ID_4 = 4                  --显示跨服BOSS奖励预览
JumpAreaManager.BUTTONFUNC_ID_5 = 5                  --显示跨服BOSS基础
JumpAreaManager.BUTTONFUNC_ID_6 = 6                  --兑换当前指定的跨服商店道具

JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1 = '1'       --addbutton对应的特殊按钮1 返回本服

JumpAreaManager.ACTIVITY_TYPE_SINGLEPK = 1           --跨服个人战
JumpAreaManager.ACTIVITY_TYPE_MULTIPK = 2            --跨服大乱斗
JumpAreaManager.ACTIVITY_TYPE_BOSS = 3               --跨服BOSS
JumpAreaManager.ACTIVITY_TYPE_DUOBAO = 4             --跨服夺宝战
JumpAreaManager.ACTIVITY_TYPE_SHOP = 5               --跨服商店

local JUMPAREA_ACTIVITY_CFG = {
    {id=JumpAreaManager.ACTIVITY_TYPE_SINGLEPK, name='跨服个人战', funcid=CommonDefine.FUNC_ID_JUMPAREA_1},
    {id=JumpAreaManager.ACTIVITY_TYPE_MULTIPK, name='跨服大乱斗', funcid=CommonDefine.FUNC_ID_JUMPAREA_2},
    {id=JumpAreaManager.ACTIVITY_TYPE_BOSS, name='跨服BOSS', funcid=CommonDefine.FUNC_ID_JUMPAREA_3},
    {id=JumpAreaManager.ACTIVITY_TYPE_DUOBAO, name='跨服夺宝战', funcid=CommonDefine.FUNC_ID_JUMPAREA_4},
    {id=JumpAreaManager.ACTIVITY_TYPE_SHOP, name='跨服商店', funcid=CommonDefine.FUNC_ID_JUMPAREA_5},
}

--跨服活动初始化
function JumpAreaManager.OnInit()
    --release_print('JumpAreaManager.OnInit')
    local isKuafuSever = checkkuafuserver()
    if isKuafuSever == false then
        if not hastimerex(CommonDefine.G_TIMER_ID_CHECK_JUMPAREA_BOSS) then 
            setontimerex(CommonDefine.G_TIMER_ID_CHECK_JUMPAREA_BOSS, 30)               
        end
    else

    end
end

function JumpAreaManager.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end
    local level = Player.GetLevel(actor)
    if level >= 40 then
        return true
    end
    return false
end

--显示规则面板
function JumpAreaManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if chooseid == JumpAreaManager.ACTIVITY_TYPE_SINGLEPK then   

    elseif chooseid == JumpAreaManager.ACTIVITY_TYPE_MULTIPK then        

    elseif chooseid == JumpAreaManager.ACTIVITY_TYPE_BOSS then
        strPanelInfo = strPanelInfo..JumpAreaBossDamageRank.ShowRulePanel(actor)
    elseif chooseid == JumpAreaManager.ACTIVITY_TYPE_DUOBAO then

    elseif chooseid == JumpAreaManager.ACTIVITY_TYPE_SHOP then
        strPanelInfo = strPanelInfo..JumpAreaScoreShop.ShowRulePanel(actor)
    end

    BF_ShowSpecialUI(actor, strPanelInfo) 
end

local function GetJumpAreaActivityShowInfo(actor, id)
    local sPanelStr = ''
    if not BF_IsNullObj(actor) then
        if id == JumpAreaManager.ACTIVITY_TYPE_BOSS then
            sPanelStr = sPanelStr..JumpAreaBossDamageRank.GetShowInfo(actor)
        elseif id == JumpAreaManager.ACTIVITY_TYPE_SHOP then
            sPanelStr = sPanelStr..JumpAreaScoreShop.GetShowInfo(actor)
        end
    end
    return sPanelStr
end

--显示初始面板
function JumpAreaManager.ShowBasePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15}|x=20.0|y=16.0|reset=1|img=private/cc_jumparea/14.png|show=0|esc=1|move=0|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
        '<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

    local idstr1 = ''    
    local choosepos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)   
    for seq, value in ipairs(JUMPAREA_ACTIVITY_CFG) do
        local baseid = 20 + seq
        local textid = baseid * 10 + 1
        if choosepos == -1 then          
            choosepos = value.id         
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, choosepos)
        end
        if choosepos == value.id then
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..textid..'}x=-6.0|y=0.0|img=private/cc_jumparea/1.png|link=@function_button,'..
                JumpAreaManager.BUTTONFUNC_ID_1..','..value.id..'>'
            strPanelInfo = strPanelInfo..'<Text|id='..textid..'|x=10.0|y=10.0|size=20|color='..CSS.NPC_YELLOW..'|text='..value.name..'>'
            --对应当前选中的活动项目
            strPanelInfo = strPanelInfo..GetJumpAreaActivityShowInfo(actor, value.id)
        else
            strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..textid..'}x=-6.0|y=0.0|img=private/cc_jumparea/2.png|link=@function_button,'..
                JumpAreaManager.BUTTONFUNC_ID_1..','..value.id..'>'
            strPanelInfo = strPanelInfo..'<Text|id='..textid..'|x=10.0|y=10.0|size=20|color='..CSS.NPC_WHITE..'|text='..value.name..'>'
        end
        if idstr1 ~= '' then
            idstr1 = idstr1..','
        end
        idstr1 = idstr1..baseid
    end
    strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..idstr1..'}|x=65.0|y=70.0|width=130|height=350|margin=0|direction=1>'

    BF_ShowSpecialUI(actor, strPanelInfo)        
end

--处理say的button回调
function JumpAreaManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local id = 0
    if BF_IsNumberStr(sparam) then
        id = tonumber(sparam)
    end

    if funcid == JumpAreaManager.BUTTONFUNC_ID_1 then
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, id)
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2, 0)
        JumpAreaManager.ShowBasePanel(actor)
    elseif funcid == JumpAreaManager.BUTTONFUNC_ID_2 then
        JumpAreaBossDamageRank.EnterBossMap(actor)
    elseif funcid == JumpAreaManager.BUTTONFUNC_ID_3 then
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2, 1)
        JumpAreaManager.ShowBasePanel(actor)
    elseif funcid == JumpAreaManager.BUTTONFUNC_ID_4 then
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2, 2)
        JumpAreaManager.ShowBasePanel(actor)
    elseif funcid == JumpAreaManager.BUTTONFUNC_ID_5 then
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM2, 0)
        JumpAreaManager.ShowBasePanel(actor)
    elseif funcid == JumpAreaManager.BUTTONFUNC_ID_6 then
        JumpAreaScoreShop.ExchangeShopItem(actor, id)
    end
end

--处理addbutton的button回调
function JumpAreaManager.DoJumpAreaButton(actor, sid)
    if (actor == nil) or (sid == nil) then
        return
    end
    
    local playerid = Player.GetPlayerID(actor)
    if sid == JumpAreaManager.JUMPAREA_BUTTONFUNC_ID_1 then
        kfbackcall(CommonDefine.KFBCMSG_GOBACK_MZMAP, playerid, '', '') 
    end
end

return JumpAreaManager