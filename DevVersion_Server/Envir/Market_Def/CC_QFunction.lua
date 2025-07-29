require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()

----------------------------------------------------------------系统触发回调函数start--------------------------------------------------------------------------

-- 玩家小退触发
function playreconnection(actor)    
    --触发玩家退出游戏的事件监听
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEGAME, actor)   
end

-- 玩家大退与关闭客户端触发
function playoffline(actor)
    --触发玩家退出游戏的事件监听
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEGAME, actor) 
end

--进入跨服触发
function kflogin(actor)
    --折叠任务栏
    openhyperlink(actor, 110, 2)
    --隐藏上面topicon
    TopIcon.HideUI(actor)
    --隐藏开宝箱界面
    OpenSuperBoxManager.HideUI(actor)

    local lastday = getsysvar(CommonDefine.VAR_I_LAST_KFLOGIN_DAY)
    local currday = BF_GetDay(os.time())
    if currday ~= lastday then
        JumpAreaManager.OnDayChange()    
        setsysvar(CommonDefine.VAR_I_LAST_KFLOGIN_DAY, currday)        
    end
end

--离开跨服触发
function kuafuend(actor)
    --打开任务栏
    openhyperlink(actor, 110, 1)
    --显示上面的topicon
    TopIcon.InitUI(actor)
    --更新开宝箱界面
    --OpenSuperBoxManager.ShowBaseInvisiblePanel(actor)
    --OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--跨周
local function cc_resetweek(actor)
    --清理周变量
    setplaydef(actor, CommonDefine.VAR_U_LOGINDAYS_IN_WEEK, 0)

    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_RESETWEEK, actor) 
end

--跨天触发
function resetday(actor)
    local currweek = BF_GetWeek(os.time())
    local lastweek = getplaydef(actor, CommonDefine.VAR_U_LAST_RECORD_WEEK)
    if lastweek ~= currweek then
        setplaydef(actor, CommonDefine.VAR_U_LAST_RECORD_WEEK, currweek)
        cc_resetweek(actor)      
    end

    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, actor) 
end

--充值触发
--function recharge(actor, gold, productid, moneyid, isreal, ordertime, rechargeamount, giftamount, refundamount)
function recharge(actor)
    RechargeManager.DoRecharge(actor)
end

--接收客户端消息触发
function handlerequest(actor, strmsgID, strparam1, strparam2, strparam3, str)
--[[
    release_print('handlerequest')
    release_print('msgid:'..msgID..' type:'..type(msgID))
    release_print('param1:'..param1..' type:'..type(param1)..'param2:'..param2..' type:'..type(param2)..'param3:'..param3..' type:'..type(param3))
    release_print('str:'..str..' type:'..type(str))
]]--
    local msgID = 0
    local param1 = 0
    local param2 = 0
    local param3 = 0
    if BF_IsNumberStr(strmsgID) and BF_IsNumberStr(strparam1) and BF_IsNumberStr(strparam2) and BF_IsNumberStr(strparam3) then
        msgID = tonumber(strmsgID)
        param1 = tonumber(strparam1)
        param2 = tonumber(strparam2)
        param3 = tonumber(strparam3)
    end

    ClientMsgProcess.DoProcess(actor, msgID, param1, param2, param3, str)
end

-- 人物属性改变时触发
function sendability(actor)
    --延迟展现战力变化，防止短时间触发多次
    --delaygoto(actor, 100, "update_power_callback", 0)
end

-- 玩家升级触发
function playlevelup(actor) 
    --触发经验泡点状态更新
    Player.UpdateAutoAddExp(actor)
    
    SkillUpgrade.CheckAutoLearnSkill(actor)
    TaskManager.OnLevelChange(actor)    
    --延迟展现战力变化，防止短时间触发多次
    --delaygoto(actor, 100, "update_power_callback", 0)    
end

-- 穿戴装备触发
--function takeonex(actor, equipitem, pos, itemname, makeindex)
function takeonex(actor, spos, smakeindex)
    if (actor == nil) or not BF_IsNumberStr(smakeindex) or not BF_IsNumberStr(spos) then
        return
    end    
    local pos = tonumber(spos)

    --根据装备位的强化等级 更新当前穿戴装备强化属性
    EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, pos)    
    --根据装备位的星级 更新当前穿戴装备星级及属性 注意：强化在升星前
    EquipPosStarManager.UpdateEquipStarLvInPos(actor, pos)
    --检测装备天赋带来的装备槽位外显变化
    EquipInitGift.UpdateEquipposInitGiftIcon(actor, pos)
    --开宝箱时候的穿戴触发
    OpenSuperBoxManager.OnTakeOnEquipItem(actor, smakeindex)
    --检测加速状态
    Player.CheckSpeedUpStatus(actor)
end

-- 脱下装备触发
--function takeoffex(actor, equipitem, pos, itemname, makeindex)
function takeoffex(actor, spos, smakeindex)
 
end

-- 脱下装备进背包前触发
function takeoffexchange(actor, spos, smakeindex)
    if (actor == nil) or not BF_IsNumberStr(smakeindex) or not BF_IsNumberStr(spos) then
        return
    end
    local pos = tonumber(spos)
    local makeindex = tonumber(smakeindex)
    local equipitem = getitembymakeindex(actor, makeindex)
    if BF_IsNullObj(equipitem) then
        return
    end

    local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
    --屏蔽掉换装提示    
    nothintitem(actor, 2, itemid)
    --清空脱掉装备的强化属性
    EquipPosStrengthManager.ClearEquipStrengthLv(actor, equipitem, pos)    
    --清空脱掉装备的星级属性
    EquipPosStarManager.ClearEquipStarLv(actor, equipitem, pos)    
    --检测装备天赋带来的装备槽位外显变化
    EquipInitGift.UpdateEquipposInitGiftIcon(actor, pos)
    --检测加速状态
    Player.CheckSpeedUpStatus(actor)
end

--玩家死亡 装备掉落前触发
function checkdropuseitems(actor, pos, itemidx)
    --清空脱掉装备的强化属性
    EquipPosStrengthManager.ClearEquipStrengthLvInPos(actor, pos)
    --清空脱掉装备的星级属性
    EquipPosStarManager.ClearEquipStarLvInPos(actor, pos)
    --检测装备天赋带来的装备槽位外显变化
    EquipInitGift.UpdateEquipposInitGiftIcon(actor, pos)    
    --检测加速状态
    Player.CheckSpeedUpStatus(actor)

    --暂时不改变掉落逻辑
    return true
end

--穿戴前触发 针对魂石的处理
--function takeonbefore12(actor, itemobj)
function takeonbefore12(actor, makeindx)
    if not BF_IsNullObj(actor) and (makeindx ~= nil) then
        local itemobj = getitembymakeindex(actor, makeindx)
        if not BF_IsNullObj(makeindx) then
            local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
            local stdmode = getstditeminfo(itemidx, CommonDefine.STDITEMINFO_STDMODE)
            if stdmode == CommonDefine.ITEM_STDMODE_SOULSTONE then
                Player.SendSelfMsg(actor, '请在魂石系统中穿戴！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)

                setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_SOUL_STONE)
                setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
                setplaydef(actor, CommonDefine.VAR_N_CHOOSE_ITEM_MAKEIDX, 0)        --清空选择的道具
                setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 1)        --设置数据页面编号为1                    
                SoulStoneManager.ShowBasePanel(actor)
                return false
            end            
        end
    end
    return false
end

-- 点击NPC  暂时未接入回调触发
function clicknpc(actor, npcid)    
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_CLICK_NPC, actor, npcid)
end

-- 点击任务
function clicknewtask(actor, taskidstr)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_CLICK_TASK, actor, taskidstr)
end

--道具进背包 这里是异步的
function addbag(actor, makeindex)
    local itemobj = getitembymakeindex(actor, makeindex)
    --if (not BF_IsNullObj(itemobj)) and (not Player.CheckEquipIsOnBody(actor, itemobj)) then
    if not BF_IsNullObj(itemobj) then
        --触发玩家道具进背包的事件监听
        GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, actor, itemobj, makeindex)    
    end
end

--进入地图触发
function entermap(actor, mapid)
    if Player.IsCurrMapHaveLeaveButton(actor) then     
        local buttonstr = '<Button|text=离开地图|x=260|y=36|color='..CSS.NPC_WHITE..'|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@base_leavemap_button>'
        addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8, buttonstr)
    end
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, actor, mapid)
end

--离开地图触发
function leavemap(actor, mapid)
    if Player.IsCurrMapHaveLeaveButton(actor) then
        delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
    end
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, actor, mapid)
end

--人物死亡触发
function playdie(actor, killername)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG, 0)    

    if killername == nil then
        killername = ''
    end

    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_DIE, actor, killername)    

    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG) == 0 then
        local msg = '<Img|children={0,1,2,3,4}|a=1|x=120|y=-450|reset=1|move=1|img=private/revive/bg_swfh_1.png|bg=1>'..
        '<Layout|id=0|width=348|height=200>'..
        '<Text|id=1|x=110|y=15|size=18|color='..CSS.NPC_WHITE..'|text=死亡复活>'..
        '<Text|id=2|x=85|y=55|size=16|color='..CSS.NPC_WHITE..'|text=你被 '..killername..' 杀死了！>'..        
        '<Button|id=3|x=110|y=90|pimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_down1.png|color='..CSS.NPC_WHITE..'|size=17|text=回城复活|link=@common_relive_button>'..
        '<COUNTDOWN|id=4|x=200|y=92|time=30|count=1|size=16|color='..CSS.NPC_RED..'|link=@common_relive_button>'
        Player.ShowReliveDialogue(actor, msg)
    end
end

--怪物被击杀触发  mapinfo对应地图要配置onkillmon才可以哦
function onkillmob(hitter, mapidstr, monuserid)
    local mon = getmonbyuserid(mapidstr, monuserid)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_MON_KILLED, hitter, mon)    
end

--击杀玩家触发
--function killplay(killer, deather)
function killplay(killer, deathername)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_KILL_PLAYER, killer, deathername)
end

--任意地图击杀怪物触发
function killmon(actor, monobjidstr, killtype, mapidstr)
    local mon = getmonbyuserid(mapidstr, monobjidstr)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_KILL_MON, actor, mon, killtype, mapidstr)    
end

--称号改变
function ontitleupgrade(actor)
    TaskManager.OnTitleUpgrade(actor)
end

----------------------------------------改名相关-----------------------------------------

--正在查询玩家名称
function queryinghumname(actor)
    Player.SendSelfMsg(actor, '正在查询请稍后。。。', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--名称被过滤
function humnamefilter(actor)
    Player.SendSelfMsg(actor, '名称被过滤。。。', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--长度不符合要求
function namelengthfail(actor)
    Player.SendSelfMsg(actor, '长度不符合要求', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--名称已经存在
function humnameexists(actor)
    Player.SendSelfMsg(actor, '名称已经存在', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--正在执行改名操作
function changeinghumname(actor)
    Player.SendSelfMsg(actor, '正在修改请稍后。。。', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--改名成功
function changehumnameok(actor)
    local str = parsetext("你的名字修改成功，旧名称：<$USERNAME> 新名称：<$USERNEWNAME>！", actor)
    Player.SendSelfMsg(actor, str, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--改名失败
function changehumnamefail(actor)
    Player.SendSelfMsg(actor, '修改名称失败', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--------------------------------------------镖车功能相关----------------------
--镖车到达目标点
function carpathend(actor)    
    YunBiaoManager.OnArriveTargetPos(actor)
end

--击杀镖车
function cardie(actor, carmonname, monobjidstr)
    YunBiaoManager.OnPlayerKillCar(actor, carmonname, monobjidstr)
end

--玩家丢失镖车触发
--[[
function losercar(actor, biaoche)
    YunBiaoManager.LostBiaoChe(actor, biaoche)
end
]]--
--------------------------------------------伤害计算相关----------------------
--人物攻击前触发
--[[
function attackdamage(actor, target, hitter, magicid, damage, model)  
    --BF_DebugOut('damage:'..damage)    
    
    local bTargIsPlayer = false
    if not BF_IsNullObj(target) then
        bTargIsPlayer = Player.IsPlayer(target)
    end

    if bTargIsPlayer then
        local selfLevel = getplaydef(actor, CommonDefine.VAR_U_GUANZHI_LEVEL) 
        local targLevel = getplaydef(target, CommonDefine.VAR_U_GUANZHI_LEVEL) 
        if selfLevel > targLevel then
            damage = math.floor(damage * 1.1)
        end
    end
    return damage
end
]]--

function attackdamage(actor, damagevalue)
    if BF_IsNullObj(actor) then
        return
    end
    local currtarg = Player.GetCurrTargetObj(actor)
    if currtarg == nil then
        return
    end

    --对怪切割
    local monid = Player.GetMonIdx(currtarg)
    if monid > 0 then
        local nQieGePoint = Player.GetQieGePoint(actor)
        if nQieGePoint > 0 then
            humanhp(currtarg, '-', nQieGePoint, CommonDefine.HP_EFFECT_ID_QIEGE, 0, actor, 1, 1) 
        end
    end

    damagevalue = GuanZhiManager.DoAttackDamage(actor, currtarg, damagevalue)
    damagevalue = JumpAreaBossDamageRank.DoAttackDamage(actor, currtarg, damagevalue) 
    callscriptex(actor, "ChangeDamageValue", 0, "=", damagevalue)
end



----------------------------------------------------------------系统触发回调函数end--------------------------------------------------------------------------


----------------------------------------------------------------按钮回调函数start--------------------------------------------------------------------------

function mainuibase_openpanel(actor, sid)
    MainUIBase.OpenPanel(actor, sid)
end

function baozhuboss_button(actor, sid)
    BaoZhuBossManager.DoMapButton(actor, sid)
end

function mofangzhen_button(actor, sid)
    MoFangZhenManager.DoMapButton(actor, sid)
end

function zcdmap_button(actor, sid)
    OfflineHuWeiManager.DoMapButton(actor, sid)
end

function firstrecharge_button(actor, sid)
    FirstRecharge.DoOperButton(actor, sid)
end

function newplayer_recharge_button(actor, sid, sparam)
    ActivityNewPlayerRecharge.DoOperButton(actor, sid, sparam)
end

function openserver_button(actor, sid, sparam)
    ActivityOpenServer.DoOperButton(actor, sid, sparam)
end

function extendgift_button(actor, sid, sparam)
    ActivityExtendGift.DoOperButton(actor, sid, sparam)
end

function recyclemanager_button(actor, sid)
    RecycleManager.DoOperButton(actor, sid)
end

function set_recycle_option(actor, sid)
    RecycleManager.SetRecycleOption(actor, sid)
end

function common_relive_button(actor)
    realive(actor)
    Player.GoHome(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_38)
end

function randomboss_button(actor, sid)
    RandomBossManager.DoMapButton(actor, sid)
end

function publicboss_button(actor, sid)
    PublicBossManager.DoMapButton(actor, sid)
end

function singleboss_button(actor, sid)
    SingleBossManager.DoMapButton(actor, sid)
end

function treasuremap_button(actor, sid)
    TreasureMap.DoOperButton(actor, sid)
end

function opensuperboxmanager_button(actor, sid, sparam)
    OpenSuperBoxManager.DoOperButton(actor, sid, sparam)
end

function gmhelper_openpanel(actor)
    GMHelper.OpenPanel(actor)
end

function gmhelper_button(actor, sid)
    GMHelper.DoGmOper(actor, sid)
end

function newrecycle_openpanel(actor)
    RecycleManager.ShowRecycleEnterUI(actor)
end

function newmainuibase_openpanel(actor, sid)
    NewMainUIBase.OpenPanel(actor, sid)
end

function topicon_openpanel(actor, sid, sparam)
    TopIcon.OpenPanel(actor, sid, sparam)
end

function changename_button(actor, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sparam) then
        return
    end
    local id = tonumber(sparam)
    if id == 1 then    
        local needitems = {{name='角色改名卡', num=1}}
        if not Player.CheckItemsEnough(actor, needitems, '角色改名') then
            return
        end    
        local sNewName = parsetext("<$NPCINPUT(1)>", actor)   
        local nNameLen = string.len(sNewName)
        if (nNameLen < 2) or (nNameLen > 14) then
            Player.SendSelfMsg(actor, '当前名字长度态度', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
            return
        end

        if changehumname(actor, sNewName) == 0 then
            Player.TakeItems(actor, needitems, '角色改名')        
        end
    else
        close(actor)
    end
end

function base_leavemap_button(actor) 
    if BF_IsNullObj(actor) then
        return
    end
    Player.GoMZHome(actor)
end

function jumparea_button(actor, sid)
    JumpAreaManager.DoJumpAreaButton(actor, sid)
end

function baipiao_refresh(actor)
    BaiPiaoGift.ShowBasePanel(actor)
end

-------------------------------------------------------新逻辑还是从原来的NPC脚本走--------------------------------------------
--灵玉功能相关
function baozhu_button_function(actor, sid, sparam)
    --BaoZhuManager.DoOperButton(actor, sid, sparam)
end

--规则说明面板
function show_rule_panel(actor)    
    local currfuncid = getplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID)
    if currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH then
        EquipPosStrengthManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STAR then
        EquipPosStarManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_SOUL_STONE then
        SoulStoneManager.ShowRulePanel(actor)      
    elseif currfuncid == CommonDefine.FUNC_ID_GUANZHI then
        GuanZhiManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_SKILLUPGRADE then
        SkillUpgrade.ShowRulePanel(actor)   
    elseif currfuncid == CommonDefine.FUNC_ID_COMPOSE then
        ItemComposeManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_OFFLINE then
        OfflineHuWeiManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_FREEVIP then
        FreeVIPManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_JUMPAREA_BASE then
        JumpAreaManager.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_BAOZHU then
        BaoZhuManagerNew.ShowRulePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_BAIPIAO_GIFT then
        BaiPiaoGift.ShowRulePanel(actor)
    end
end

--显示基础面板
function show_base_panel(actor, sparam)
    local currfuncid = getplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID)
    if currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH then
        EquipPosStrengthManager.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STAR then
        EquipPosStarManager.ShowBasePanel(actor)        
    elseif currfuncid == CommonDefine.FUNC_ID_SOUL_STONE then
        SoulStoneManager.ShowBasePanel(actor)         
    elseif currfuncid == CommonDefine.FUNC_ID_GUANZHI then
        GuanZhiManager.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_SKILLUPGRADE then
        SkillUpgrade.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_COMPOSE then
        ItemComposeManager.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_OFFLINE then
        OfflineHuWeiManager.ShowBasePanel(actor, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_FREEVIP then
        FreeVIPManager.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_JUMPAREA_BASE then
        JumpAreaManager.ShowBasePanel(actor)
    elseif currfuncid == CommonDefine.FUNC_ID_BAIPIAO_GIFT then
        BaiPiaoGift.ShowBasePanel(actor)
    end    
end

--对应的功能操作
function function_button(actor, sid, sparam)   
    local currfuncid = getplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID)    
    if currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH then
        EquipPosStrengthManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_EQUIPPOS_STAR then
        EquipPosStarManager.DoOperButton(actor, sid, sparam)        
    elseif currfuncid == CommonDefine.FUNC_ID_SOUL_STONE then
        SoulStoneManager.DoOperButton(actor, sid, sparam)   
    elseif currfuncid == CommonDefine.FUNC_ID_GUANZHI then
        GuanZhiManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_SKILLUPGRADE then
        SkillUpgrade.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_COMPOSE then
        ItemComposeManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_OFFLINE then
        OfflineHuWeiManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_FREEVIP then
        FreeVIPManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_JUMPAREA_BASE then
        JumpAreaManager.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_BAOZHU then
        BaoZhuManagerNew.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_EVERYDAY_TASK then
        EverydayTask.DoOperButton(actor, sid, sparam)
    elseif currfuncid == CommonDefine.FUNC_ID_BAIPIAO_GIFT then
        BaiPiaoGift.DoOperButton(actor, sid, sparam)
    end
end

----------------------------------------------------------------按钮回调函数end--------------------------------------------------------------------------


----------------------------------------------------------------玩家延迟回调start------------------------------------------------------------------------
function treasuremap_dig_callback(actor)
    --藏宝图 挖宝回调
    TreasureMap.DigCallBack(actor)
end

local function InnerUpdatePowerShow(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_6)
    local currpower = Player.GetPlayerPower(actor)
    local str = '<Effect|x=-550|y=-40|effectid=15001|effecttype=0|scale=0.8>'..
        '<TextAtlas|x=-460|y=-20|img=public/zhnli_num.png|schar=0|iheight=20|iwidth=13|text='..currpower..'>'
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_6, str)    
end

function update_power_callback(actor)
    --更新玩家的战力变化
    local currpower = Player.GetPlayerPower(actor);
    local lastpower = getplaydef(actor, CommonDefine.VAR_N_LAST_PLAYERPOWER)
    if lastpower ~= currpower then
        local diffpower = currpower - lastpower
        setplaydef(actor, CommonDefine.VAR_N_LAST_PLAYERPOWER, currpower)
        setplayvar(actor, "HUMAN", '战斗力', currpower, 1)
        --Player.SendSelfMsg(actor, '当前战力:'..currpower, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        InnerUpdatePowerShow(actor)    
        if (diffpower > 0) and (lastpower > 0) then
            local showstr = '+'..diffpower
            local strPanelInfo = '<Img|id=5000|children={5001}|x=-550|y=-100|img=private/cc_mainui/zhanli_tip.png>'..
                '<Text|id=5001|text='..showstr..'|x=100|y=28|color='..CSS.NPC_LIGHTGREEN..'|size=25>'
            addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_7, strPanelInfo)
            delaygoto(actor, 3000, "hide_power_callback", 0)
        end
        --触发战力任务
        TaskManager.OnPowerScoreChange(actor)
        --更新玩家的风雨雷电的临时属性记录
        EquipInitGift.UpdateEquipGiftAbilityInfo(actor)
        TopIcon.InnerExtendPanel2(actor)
    end
end

function hide_power_callback(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_7)
end

--txt里回调的
function equippos_star_auto_upgrade_callback(actor)
    EquipPosStarManager.EquipPosAutoUpgradeStar(actor)
    EquipPosStarManager.ShowBasePanel(actor)
end

function weapon_auto_addluck_callback(actor)
    WeaponAddLuckManager.AutoAddLuck(actor)
    WeaponAddLuckManager.ShowBasePanel(actor)
end

--lua直接回调
function equippos_star_auto_upgrade(actor)
    EquipPosStarManager.EquipPosAutoUpgradeStar(actor)
    EquipPosStarManager.ShowBasePanel(actor)    
end

function superbox_delay_checkrecycle(actor)
    OpenSuperBoxManager.DelayCheckRecycle(actor)
end

function superbox_auto_open(actor)
    OpenSuperBoxManager.AutoOpenSuperBox(actor)
end

function superbox_delay_openboxonce(actor)
    OpenSuperBoxManager.DoOpenBoxOnce(actor, false, nil)
end

----------------------------------------------------------------玩家延迟回调end--------------------------------------------------------------------------


----------------------------------------------------------------系统延迟回调start------------------------------------------------------------------------
function g_delay_RandomBossManager_ClearFightingMap(sysobj, mapidstr)
    RandomBossManager.ClearFightingMap(mapidstr)
end

function g_delay_SingleBossManager_ClearFightingMap(sysobj, mapidstr)
    SingleBossManager.ClearFightingMap(mapidstr)
end
----------------------------------------------------------------系统延迟回调end---------------------------------------------------------------------------

----------------------------------------------------------------跨服相关回调start--------------------------------------------------------------------
function kfsyscall101(sysobj)
    local str = parsetext('<$PARAM1>', sysobj)
    JumpAreaBossDamageRank.LocalServerUpdateInfo(str)
end

function kfsyscall102(actor)
    Player.GoMZHome(actor)
end

function kfsyscall103(sysobj)
    local str = parsetext('<$PARAM1>', sysobj)
    JumpAreaRandomFighting.LocalServerUpdateInfo(str)
end

----------------------------------------------------------------跨服相关回调end--------------------------------------------------------------------

----------------------------------------------------------------使用道具回调start------------------------------------------------------------------------

--[[
function stdmodefunc0(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--随机传送石
function stdmodefunc10(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--比奇传送石
function stdmodefunc11(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--盟重回城石
function stdmodefunc12(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用藏宝图
function stdmodefunc201(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用可拆解兑换的道具
function stdmodefunc202(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用槽位直升星石
function stdmodefunc203(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用改名卡
function stdmodefunc204(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用魔方阵凭证
function stdmodefunc205(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--使用筛子
function stdmodefunc206(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end
]]--


function stdmodefunc0(actor, smakeindex)  
    return ItemUseManager.DoUse(actor, smakeindex)
end

--盟重回城石
function stdmodefunc12(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用藏宝图
function stdmodefunc201(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用可拆解兑换的道具
function stdmodefunc202(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用槽位直升星石
function stdmodefunc203(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用改名卡
function stdmodefunc204(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用魔方阵凭证
function stdmodefunc205(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end

--使用筛子
function stdmodefunc206(actor, smakeindex)
    return ItemUseManager.DoUse(actor, smakeindex)
end
