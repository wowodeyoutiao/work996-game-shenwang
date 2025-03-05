require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()

----------------------------------------------------------------ϵͳ�����ص�����start--------------------------------------------------------------------------

-- ���С�˴���
function playreconnection(actor)
    --��������˳���Ϸ���¼�����
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEGAME, actor) 
end

-- ��Ҵ�����رտͻ��˴���
function playoffline(actor)
    --��������˳���Ϸ���¼�����
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEGAME, actor) 
end

--����
local function cc_resetweek(actor)
    --�����ܱ���
    setplaydef(actor, CommonDefine.VAR_U_LOGINDAYS_IN_WEEK, 0)

    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_RESETWEEK, actor) 
end

--���촥��
function resetday(actor)
    local currweek = BF_GetWeek(os.time())
    local lastweek = getplaydef(actor, CommonDefine.VAR_U_LAST_RECORD_WEEK)
    if lastweek ~= currweek then
        setplaydef(actor, CommonDefine.VAR_U_LAST_RECORD_WEEK, currweek)
        cc_resetweek(actor)      
    end

    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, actor) 
end

--��ֵ����
function recharge(actor, gold, productid, moneyid, isreal, ordertime, rechargeamount, giftamount, refundamount)
    RechargeManager.DoRecharge(actor, gold, productid, moneyid, isreal, ordertime, rechargeamount, giftamount, refundamount)
end

--���տͻ�����Ϣ����
--[[
--��ʱ�����Ϳͻ��˵Ķ�����Ϣ����
function handlerequest(actor, msgID, param1, param2, param3, str)
    ClientMsgProcess.DoProcess(actor, msgID, param1, param2, param3, str)
end
]]--

-- �������Ըı�ʱ����
function sendability(actor)
    --�ӳ�չ��ս���仯����ֹ��ʱ�䴥�����
    delaygoto(actor, 100, "update_power_callback", 0)
end

-- �����������
function playlevelup(actor) 
    SkillUpgrade.CheckAutoLearnSkill(actor)
    --�ӳ�չ��ս���仯����ֹ��ʱ�䴥�����
    delaygoto(actor, 100, "update_power_callback", 0)    
end

-- ����װ������
function takeonex(actor, equipitem, pos, itemname, makeindex)
    if (actor == nil) or (equipitem == nil) or (pos == nil) then
        return
    end
    --����װ��λ��ǿ���ȼ� ���µ�ǰ����װ��ǿ������
    EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, pos)    
    --����װ��λ���Ǽ� ���µ�ǰ����װ���Ǽ������� ע�⣺ǿ��������ǰ
    EquipPosStarManager.UpdateEquipStarLvInPos(actor, pos)
    --������״̬
    Player.CheckSpeedUpStatus(actor)
end

-- ����װ������
function takeoffex(actor, equipitem, pos, itemname, makeindex)
    if (actor == nil) or (equipitem == nil) or (pos == nil) then
        return
    end
    --����ѵ�װ����ǿ������
    EquipPosStrengthManager.ClearEquipStrengthLv(actor, equipitem, pos)    
    --����ѵ�װ�����Ǽ�����
    EquipPosStarManager.ClearEquipStarLv(actor, equipitem, pos)    
    --������״̬
    Player.CheckSpeedUpStatus(actor)    
end

--������� װ������ǰ����
function checkdropuseitems(actor, pos, itemidx)
    --����ѵ�װ����ǿ������
    EquipPosStrengthManager.ClearEquipStrengthLvInPos(actor, pos)
    --����ѵ�װ�����Ǽ�����
    EquipPosStarManager.ClearEquipStarLvInPos(actor, pos)
    --������״̬
    Player.CheckSpeedUpStatus(actor)

    --��ʱ���ı�����߼�
    return true
end

--����ǰ���� ��Ի�ʯ�Ĵ���
function takeonbefore12(actor, itemobj)
    if not BF_IsNullObj(actor) and not BF_IsNullObj(itemobj) then
        local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
        local stdmode = getstditeminfo(itemidx, CommonDefine.STDITEMINFO_STDMODE)
        if stdmode == CommonDefine.ITEM_STDMODE_SOULSTONE then
            Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_SOULSTONE)
            Player.SendSelfMsg(actor, '���ڻ�ʯ��ʦ�����л�ʯ������', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return false
        end
    end
    return true
end

-- ���NPC
function clicknpc(actor, npcid)    
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_CLICK_NPC, actor, npcid)
end

-- �������
function clicknewtask(actor, taskid)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_CLICK_TASK, actor, taskid)
end

--���߽����� �������첽��
function addbag(actor, itemobj)
    --������ҵ��߽��������¼�����
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, actor, itemobj)
end

--�����ͼ����
function entermap(actor, mapid, x, y)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, actor, mapid, x, y)
end

--�뿪��ͼ����
function leavemap(actor, mapid, x, y)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, actor, mapid, x, y)
end

--������������
function playdie(actor, killer)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG, 0)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_DIE, actor, killer)
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG) == 0 then
        local killername = ''
        if not BF_IsNullObj(killer) then
            killername = Player.GetName(killer)
        end
        local msg = '<Img|children={0,1,2,3}|a=1|x=737|y=201|reset=1|move=1|img=private/revive/bg_swfh_1.png|bg=1>'..
        '<Layout|id=0|width=348|height=200>'..
        '<Text|id=1|x=110|y=15|size=18|color='..CSS.NPC_WHITE..'|text=��������>'..
        '<Text|id=2|x=85|y=55|size=16|color='..CSS.NPC_WHITE..'|text=�㱻 '..killername..' ɱ���ˣ�>'..        
        '<Button|id=3|x=110|y=90|pimg=public/1900000652.png|nimg=public/1900000653.png|color='..CSS.NPC_WHITE..'|size=17|text=�سǸ���|link=@common_relive_button>'
        Player.ShowReliveDialogue(actor, msg)
    end
end

--���ﱻ��ɱ����  mapinfo��Ӧ��ͼҪ����onkillmon�ſ���Ŷ
function onkillmob(hitter, mon)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_MON_KILLED, hitter, mon)    
end

--��ɱ��Ҵ���
function killplay(killer, deather)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_KILL_PLAYER, killer, deather)
end

--�����ͼ��ɱ���ﴥ��
function killmon(actor, mon, killtype, monobjidstr, monname, mapidstr)
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_KILL_MON, actor, mon, killtype, monobjidstr, monname, mapidstr)    
end


----------------------------------------�������-----------------------------------------

--���ڲ�ѯ�������
function queryinghumname(actor)
    Player.SendSelfMsg(actor, '���ڲ�ѯ���Ժ󡣡���', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--���Ʊ�����
function humnamefilter(actor)
    Player.SendSelfMsg(actor, '���Ʊ����ˡ�����', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--���Ȳ�����Ҫ��
function namelengthfail(actor)
    Player.SendSelfMsg(actor, '���Ȳ�����Ҫ��', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--�����Ѿ�����
function humnameexists(actor)
    Player.SendSelfMsg(actor, '�����Ѿ�����', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--����ִ�и�������
function changeinghumname(actor)
    Player.SendSelfMsg(actor, '�����޸����Ժ󡣡���', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--�����ɹ�
function changehumnameok(actor)
    local str = parsetext("��������޸ĳɹ��������ƣ�<$USERNAME> �����ƣ�<$USERNEWNAME>��", actor)
    Player.SendSelfMsg(actor, str, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--����ʧ��
function changehumnamefail(actor)
    Player.SendSelfMsg(actor, '�޸�����ʧ��', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
end

--------------------------------------------�ڳ��������----------------------
--�ڳ�����Ŀ���
function carpathend(actor)    
    YunBiaoManager.OnArriveTargetPos(actor)
end

--��Ҷ�ʧ�ڳ�����
function losercar(actor, biaoche)
    YunBiaoManager.LostBiaoChe(actor, biaoche)
end
--------------------------------------------�˺��������----------------------
--���﹥��ǰ����
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

----------------------------------------------------------------ϵͳ�����ص�����end--------------------------------------------------------------------------


----------------------------------------------------------------��ť�ص�����start--------------------------------------------------------------------------

function mainuibase_openpanel(actor, sid)
    MainUIBase.OpenPanel(actor, sid)
end

function topicon_openpanel(actor, sid, sparam)
    TopIcon.OpenPanel(actor, sid, sparam)
end

function topicon_dogmoper(actor, sid)
    TopIcon.DoGmOper(actor, sid)
end

function baozhuboss_button(actor, sid)
    BaoZhuBossManager.DoMapButton(actor, sid)
end

function mofangzhen_button(actor, sid)
    MoFangZhenManager.DoMapButton(actor, sid)
end

function randomboss_button(actor, sid)
    RandomBossManager.DoMapButton(actor, sid)
end

function zcdmap_button(actor, sid)
    OfflineHuWeiManager.DoMapButton(actor, sid)
end

function common_relive_button(actor)
    realive(actor)
    Player.GoHome(actor)
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

function publicboss_button(actor, sid)
    PublicBossManager.DoMapButton(actor, sid)
end

function singleboss_button(actor, sid)
    SingleBossManager.DoMapButton(actor, sid)
end

function everyday_task_button(actor, sid, sparam)
    EverydayTask.DoOperButton(actor, sid, sparam)
end

function treasuremap_button(actor, sid)
    TreasureMap.DoOperButton(actor, sid)
end

function opensuperboxmanager_button(actor, sid)
    OpenSuperBoxManager.DoOperButton(actor, sid)
end

function changename_button(actor, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sparam) then
        return
    end
    local id = tonumber(sparam)
    if id == 1 then    
        local needitems = {{name='��ɫ������', num=1}}
        if not Player.CheckItemsEnough(actor, needitems, '��ɫ����') then
            return
        end    
        local sNewName = parsetext("<$NPCINPUT(1)>", actor)   
        local nNameLen = string.len(sNewName)
        if (nNameLen < 2) or (nNameLen > 14) then
            Player.SendSelfMsg(actor, '��ǰ���ֳ���̬��', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end

        if changehumname(actor, sNewName) == 0 then
            Player.TakeItems(actor, needitems, '��ɫ����')        
        end
    else
        close(actor)
    end
end

----------------------------------------------------------------��ť�ص�����end--------------------------------------------------------------------------


----------------------------------------------------------------����ӳٻص�start------------------------------------------------------------------------
function treasuremap_dig_callback(actor)
    --�ر�ͼ �ڱ��ص�
    TreasureMap.DigCallBack(actor)
end

local function InnerUpdatePowerShow(actor)
    delbutton(actor, 101, 999)
    local currpower = Player.GetPlayerPower(actor)
    local str = '<Img|id=5010|children={5011}|x=272|y=30|img=private/cc_mainui/zhanli.png>'..
        '<Text|id=5011|text='..currpower..'|x=100|y=16|color='..CSS.NPC_WHITE..'|size=25>'
    addbutton(actor, 101, 999, str)
end

function update_power_callback(actor)
    --������ҵ�ս���仯
    local currpower = Player.GetPlayerPower(actor);
    local lastpower = getplaydef(actor, CommonDefine.VAR_N_LAST_PLAYERPOWER)
    if lastpower ~= currpower then
        local diffpower = currpower - lastpower
        setplaydef(actor, CommonDefine.VAR_N_LAST_PLAYERPOWER, currpower)
        Player.SendSelfMsg(actor, '��ǰս��:'..currpower, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        InnerUpdatePowerShow(actor)    
        if (diffpower > 0) and (lastpower > 0) then
            local showstr = '+'..diffpower
            local strPanelInfo = '<Img|id=5000|children={5001}|x=220|y=-240|img=private/cc_mainui/zhanli_tip.png>'..
                '<Text|id=5001|text='..showstr..'|x=100|y=28|color='..CSS.NPC_LIGHTGREEN..'|size=25>'
            addbutton(actor, 108, 998, strPanelInfo)
            delaygoto(actor, 3000, "hide_power_callback", 0)
        end
    end    
end

function hide_power_callback(actor)
    delbutton(actor, 108, 998)
end
----------------------------------------------------------------����ӳٻص�end--------------------------------------------------------------------------


----------------------------------------------------------------ϵͳ�ӳٻص�start------------------------------------------------------------------------
function g_delay_RandomBossManager_ClearFightingMap(sysobj, mapidstr)
    RandomBossManager.ClearFightingMap(mapidstr)
end

function g_delay_SingleBossManager_ClearFightingMap(sysobj, mapidstr)
    SingleBossManager.ClearFightingMap(mapidstr)
end
----------------------------------------------------------------ϵͳ�ӳٻص�end---------------------------------------------------------------------------



----------------------------------------------------------------ʹ�õ��߻ص�start------------------------------------------------------------------------

function stdmodefunc0(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--�������ʯ
function stdmodefunc10(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--���洫��ʯ
function stdmodefunc11(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--���ػس�ʯ
function stdmodefunc12(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--ʹ�òر�ͼ
function stdmodefunc201(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--ʹ�ÿɲ��һ��ĵ���
function stdmodefunc202(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--ʹ�ò�λֱ����ʯ
function stdmodefunc203(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--ʹ�ø�����
function stdmodefunc204(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end

--ʹ��ħ����ƾ֤
function stdmodefunc205(actor, itemobj)
    return ItemUseManager.DoUse(actor, itemobj)
end


----------------------------------------------------------------ʹ�õ��߻ص�end--------------------------------------------------------------------------


--[[
[@PlayOffLine]
#IF
CheckRangeHumCount 3 330 330 20 < 120
#ACT
MOVR N50 323 339
MOVR N51 323 339
mapmove 3 <$STR(N50)> <$STR(N51)>
OFFLINEPLAY 72000 100
BREAK

[@OpenSndaItemBox]
#if
CHECKRENEWLEVEL > 0
#ACT
SetSndaItemBox 1 2 8888 4 5 6 7 8 6666 9 10
SENDMSG 6 �ѿ���
break
#elseact
SendMsg 7 ��ת���ȼ�����1ת���޷�ʹ�ã�
break

[@OnKillMob]
;RANDOM 300
;#act
;MOV U10 <$x>
;MOV U11 <$Y>
;MOV T10 <$MAP>
;mapmove ��֤3530054 28 28
;SENDMSG 6 {������ʾ��:|251:0:0}{���������ѻ���֤ϵͳ��|222:0}{��վ�ڹ�Ȧ�ڵ��NPC!��֤�ɹ�������ԭ�����|222:0}
;SENDMSG 6 {������ʾ��:|251:0:0}{���������ѻ���֤ϵͳ��|222:0}{��վ�ڹ�Ȧ�ڵ��NPC!��֤�ɹ�������ԭ�����|222:0}
;SENDMSG 6 {������ʾ��:|251:0:0}{���������ѻ���֤ϵͳ��|222:0}{��վ�ڹ�Ȧ�ڵ��NPC!��֤�ɹ�������ԭ�����|222:0}
;SENDMSG 6 {������ʾ��:|251:0:0}{���������ѻ���֤ϵͳ��|222:0}{��վ�ڹ�Ȧ�ڵ��NPC!��֤�ɹ�������ԭ�����|222:0}


[@KillPlay]
#IF
CHECKLEVELEX > 0
#act
CALCVAR HUMAN KP + 1
SAVEVAR HUMAN KP
;-----------------------------------------------------------------------------------------------------------------
[@PlayLevelUp]
#IF
CHECKLEVELEX = 50
#ACT
GIVE ��ݹ��� 1
GIVE һ������ 1
GIVE ����ֿ� 1
GIVE ���ػس�ʯ 1
GIVE �������ʯ 1
break
;-----------------------------------------------------------------------------------------------------------------
[@PlayDie]
#IF
CHECKITEMW ��Ҳ���� 1
#ACT
TakeEx 9
take ��Ҳ���� 46
ThrowItem <$MAP> <$X> <$Y> 1 ��Ҳ���� 1|60 1 1

#IF
check [059] 1
CHECKCURRTARGETRACE = 0
#ACT
<$CURRRTARGETNAME>.GAMEGOLD + 100000
SET [059] 0
SETICON 1 -1
SendCenterMsg 250 0 ս������<$CURRRTARGETNAME>���ɵ���ӵ�С������·�����[<$USERNAME>]���100000Ԫ���������� 1 3
SendCenterMsg 250 0 ս������<$CURRRTARGETNAME>���ɵ���ӵ�С������·�����[<$USERNAME>]���100000Ԫ���������� 1 3
SendCenterMsg 250 0 ս������<$CURRRTARGETNAME>���ɵ���ӵ�С������·�����[<$USERNAME>]���100000Ԫ���������� 1 3




#IF
KILLBYHUM
#ACT
CALCVAR HUMAN PD + 1
SAVEVAR HUMAN PD
SendCenterMsg 250 0 ս������<$CURRRTARGETNAME>����%m�����䣬�ɵ���<$USERNAME>���ֵ��ǰ�æ���120���ȣ� 1 3
#CALL [\��Ϸ��½\���ϵͳ.txt] @��ŷ���


#ELSEACT
SENDMSG 1 ��ʾ:���<$CURRRTARGETNAME>����:%m(%x:%y)�����<$USERNAME>�ɵ��ˣ�
BREAK




;-----------------------------------------------------------------------------------------------------------------
[@StdModeFunc17]
#IF
#ACT
give ��ש 2
BREAK

[@StdModeFunc16]
#IF
#ACT
give ���� 5
BREAK

[@StdModeFunc15]
#IF
checkgold 49000001
#ACT
give ���� 1
messagebox ��ʾ��������Я���Ľ�Ǯ̫����.�޷����жһ�.
BREAK
#ELSEACT
give ��� 998000
SENDMSG 7 ��ϲ��������100W���.
BREAK

[@STDMODEFUNC9]
#IF
gender woman
#ACT
HAIRSTYLE 1
SENDMSG 7 �����Ѿ����!
BREAK
#IF
gender man
#ACT
HAIRSTYLE 1
SENDMSG 7 �����Ѿ����!
BREAK

[@STDMODEFUNC10]
#IF
gender woman
#ACT
HAIRSTYLE 0
SENDMSG 7 �����Ѿ����!
BREAK
#IF
gender man
#ACT
HAIRSTYLE 0
SENDMSG 7 �����Ѿ����!
BREAK

[@STDMODEFUNC11]
#IF
#ACT
KILLMONEXPRATE 200 7200
Gmexecute showeffect 76
SENDMSG 0 ��ҡ�<$USERNAME>��ʹ��˫�����ᣬ�����2Сʱ˫��ʱ�䡣


[@STDMODEFUNC12]
#IF
#ACT
KILLMONEXPRATE 200 3600
Gmexecute showeffect 76
SENDMSG 0 ��ҡ�<$USERNAME>��ʹ��˫������(С)�������1Сʱ˫��ʱ�䡣


[@STDMODEFUNC13]
#IF
#ACT
KILLMONEXPRATE 200 10800
Gmexecute showeffect 76
SENDMSG 0 ��ҡ�<$USERNAME>��ʹ��˫������(��)�������3Сʱ˫��ʱ�䡣


[@STDMODEFUNC14]
#IF
#ACT
KILLMONEXPRATE 200 21600
Gmexecute showeffect 76
SENDMSG 0 ��ҡ�<$USERNAME>��ʹ��˫������(��)�������6Сʱ˫��ʱ�䡣


[@StdModeFunc15]
#IF
#ACT
Gmexecute showeffect 79
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc16]
#IF
#ACT
Gmexecute showeffect 80
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc17]
#IF
#ACT
Gmexecute showeffect 81
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc18]
#IF
#ACT
Gmexecute showeffect 82
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc19]
#IF
#ACT
Gmexecute showeffect 83
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc20]
#IF
#ACT
Gmexecute showeffect 84
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc21]
#IF
#ACT
Gmexecute showeffect 85
SENDMSG 0 <$USERNAME>��:%m%x:%y�����̻�������ҿ�ȥ����Ŷ��

[@StdModeFunc41]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 79
Gmexecute showeffect 80
Gmexecute showeffect 81
Delaygoto 2000 @��䵰��1
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��1]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 80
Gmexecute showeffect 81
Gmexecute showeffect 82
Delaygoto 2000 @��䵰��2
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��2]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 81
Gmexecute showeffect 82
Gmexecute showeffect 83
Delaygoto 2000 @��䵰��3
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��3]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 82
Gmexecute showeffect 83
Gmexecute showeffect 84
Delaygoto 2000 @��䵰��4
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��4]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 83
Gmexecute showeffect 84
Gmexecute showeffect 85
Delaygoto 2000 @��䵰��5
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��5]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 79
Gmexecute showeffect 84
Gmexecute showeffect 85
Delaygoto 2000 @��䵰��6
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@��䵰��6]
#IF
small M3 60
#Act
INC M3 2
Gmexecute showeffect 79
Gmexecute showeffect 80
Gmexecute showeffect 85
Delaygoto 2000 @��䵰��
SENDMSG 0 <$USERNAME>��:%m%x:%y������䵰����!��ҿ�ȥ����
#ELSEAct
MOV M3 0

[@StdModeFunc29]
#IF
#ACT
mapmove 0 326 272

[@StdModeFunc30]
#IF
#ACT
mapmove 3 330 330
SendCenterMsg 180 251 ��ʣ��%d�뿪����ͼ. 5 0 @ExitMap
[@StdModeFunc99]

[@RevMaster]
�Է������Ϊʦ�����Ƿ����մ���Ϊͽ�� \ \
��<ͬ��/@ResposeMaster>�� \
��<��ͬ��/@ResposeMasterFail>��

[@ResposeMaster]
#IF
#ACT
master responsemaster1 ok
close

[@ResposeMasterFail]
#if
#act
master responsemaster1 fail

[@EndMaster]
#if
#act
SENDMSG 0 %s����˰�ʦ��ͽ��ʽ!

[@EndMasterFail]
��ʦʧ�ܣ�\ \
��<�ر�/@exit>��

[@RevUnMaster]
�Է�������������ʦͽ��ϵ�����Ƿ��Ӧ�� \ \
��<��Ը��/@ResposeUnMaster>��
��<�˳�/@Exit>��

[@ResposeUnMaster]
#if
#act
unmaster REQUESTUNMASTER MASTER

[@PoseUnMasterEnd]
�Ǻǣ����Ѿ���ͽ������ʦͽ��ϵ�ˣ����� \ \
��<�˳�/@exit>��

[@RequestUnMasterEnd]
�Ǻǣ����Ѿ�����ʦͽ��ϵ�ˣ����� \ \
��<�˳�/@exit>��
;-----------------------------------------------------------------------------------------------------------------
[@GroupItem0]
#IF
#ACT
SENDMSG 5 ʥս��װ�������Ա�����,��������15%!

[@GroupItem1]
#IF
#ACT
SENDMSG 5 ������װ�������Ա�����:ħ������15%!

[@GroupItem2]
#IF
#ACT
SENDMSG 5 ������װ�������Ա�����!��������15%!

[@GroupItem3]
#IF
#ACT
SENDMSG 5 ������Ч:ͷ��һ��������������1%!

[@GroupItem4]
#IF
#ACT
SENDMSG 5 ������Ч:ͷ��һ��ħ����������1%!

[@GroupItem5]
#IF
#ACT
SENDMSG 5 ������Ч:ͷ��һ��������������1%!

[@GroupItem6]
#IF
#ACT
SENDMSG 5 �·�������Ч:������������3%�������ָ�����1%ħ���ָ�����1%��

[@GroupItem7]
#IF
#ACT
SENDMSG 5 �·�������Ч:������������3%�������ָ�����1%ħ���ָ�����1%��

[@GroupItem8]
#IF
#ACT
SENDMSG 5 �·�������Ч:������������3%�������ָ�����1%ħ���ָ�����1%��

[@GroupItem9]
#IF
#ACT
SENDMSG 5 �·�������Ч:������������3%�������ָ�����1%ħ���ָ�����1%��

[@GroupItem10]
#IF
#ACT
SENDMSG 5 �·�������Ч:ħ����������3�㣬HP����20%�������ָ�����1%ħ���ָ�����1%��

[@GroupItem11]
#IF
#ACT
SENDMSG 5 �·�������Ч:ħ����������3�㣬HP����20%�������ָ�����1%ħ���ָ�����1%��
;-----------------------------------------------------------------------------------------------------------------
[@PD001]
#if
EQUAL I66 1
#act
SetOnTimer 5 1
;SENDMSG 0 ���[<$USERNAME>]ռ�켤���ɶ�һ�ŵ㣬��������30��Ԫ������20����
BREAK

[@PD002]
#if
EQUAL I66 1
#act
SetOnTimer 5 1
;SENDMSG 0 ���[<$USERNAME>]ռ�켤���ɶԶ��ŵ㣬��������20��Ԫ������15����
BREAK

[@PD003]
#if
EQUAL I66 1
#act
SetOnTimer 5 1
;SENDMSG 0 ���[<$USERNAME>]ռ�켤���ɶ����ŵ㣬��������10��Ԫ������10����
BREAK
;-----------------------------------------------------------------------------------------------------------------
[@StorageOpenFail2]
#IF
#ACT
MESSAGEBOX �ֿ���޷���,����ȷ�Ϻ�������ҪԪ��1000 @�����ֿ�� @ȡ��

[@�����ֿ��]
#IF
CHECKGAMEGOLD > 999
#ACT
GAMEGOLD - 1000
;SETSTORAGEOPEN 20130801 20130802 20130803 20130804 2 20130806 20130807 20130808 1 20130810
CHANGESTORAGE 40;�����ֿ������
MESSAGEBOX �ֿ���ѽ���
#ELSEACT
MESSAGEBOX Ԫ������

;�ֿ���δ����ʱ���Ӹòֿ�ȡ��Ʒ�����Ʒ��ʧ�ܣ����Ҵ���QF�ű��ֶ�
[@StorageOpenFail3]
#IF
#ACT
MESSAGEBOX �ֿ����޷���,����ȷ�Ϻ�������ҪԪ��2000 @�����ֿ��� @ȡ��

[@�����ֿ���]
#IF
CHECKGAMEGOLD > 1999
#ACT
GAMEGOLD - 2000
;SETSTORAGEOPEN 20130801 20130802 20130803 20130804 3 20130806 20130807 20130808 1 20130810
CHANGESTORAGE 40;�����ֿ�������
MESSAGEBOX �ֿ����ѽ���
#ELSEACT
MESSAGEBOX Ԫ������
;-----------------------------------------------------------------------------------------------------------------
[@QueryingHumName]
���ڲ�ѯ���Ժ󡣡���\ \
<�ر�/@exit>\

[@QueryHumNameOK]
��ѯ�ɹ��������ƿ���ʹ��\ \
<�ر�/@exit>\

[@ChangeingHumName]
�����޸����Ժ󡣡���\ \
<�ر�/@exit>\

[@ChangeHumNameOK]
��������޸ĳɹ��������ƣ�<$USERNAME> �����ƣ�<$USERNEWNAME>��\ \
<�ر�/@exit>\

[@NameLengthFail]
���ֳ��Ȳ�������30���ַ���\ \
<�ر�/@exit>\

[@HumNameFilter]
�����ִ��ڷǷ��ַ���\ \
<�ر�/@exit>\

[@HumNameExists]
�������Ѿ����������ռ�ã���ѡ����������\ \
<�ر�/@exit>\

[@ChangeHumNameFail]
����ʧ�ܣ�\ \
<�ر�/@exit>\
;-----------------------------------------------------------------------------------------------------------------
[@StdModeFunc69]
#if
#ACT
CHANGEEXP + 100000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{1��|222:0}
BREAK
[@StdModeFunc70]
#if
#ACT
CHANGEEXP + 10000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{1000W|222:0}
BREAK
[@StdModeFunc71]
#if
#ACT
CHANGEEXP + 20000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{2000W|222:0}
BREAK
[@StdModeFunc72]
#if
#ACT
CHANGEEXP + 30000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{3000W|222:0}
BREAK
[@StdModeFunc73]
#if
#ACT
CHANGEEXP + 50000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{5000W|222:0}
BREAK
[@StdModeFunc75]
#if
#ACT
CHANGEEXP + 200000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{2�ھ���|222:0}
BREAK
[@StdModeFunc76]
#if
#ACT
CHANGEEXP + 500000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{5�ھ���|222:0}
BREAK
[@StdModeFunc77]
#if
#ACT
CHANGEEXP + 1000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{100W|222:0}
BREAK
[@StdModeFunc78]
#if
#ACT
CHANGEEXP + 2000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{200W|222:0}
BREAK
[@StdModeFunc79]
#if
#ACT
CHANGEEXP + 5000000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{500W|222:0}
BREAK

[@StdModeFunc188]
#if
#ACT
CHANGEEXP + 200000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{20W|222:0}
BREAK

[@StdModeFunc189]
#if
#ACT
CHANGEEXP + 500000
SENDMSG 6 {������ʾ��:|251:0:0}{�ɹ���þ���ֵ|255:0}{50W|222:0}
BREAK

[@StdModeFunc80]
#ACT
GAMEGOLD + 20
SENDMSG 7 ��ϲ��20Ԫ���ѵ��ʻ���.
[@StdModeFunc81]
#ACT
GAMEGOLD + 50
SENDMSG 7 ��ϲ��50Ԫ���ѵ��ʻ���.
[@StdModeFunc59]
#ACT
GAMEGOLD + 100
SENDMSG 7 ��ϲ��100Ԫ���ѵ��ʻ���.
[@StdModeFunc60]
#ACT
GAMEGOLD + 200
SENDMSG 7 ��ϲ��200Ԫ���ѵ��ʻ���.
[@StdModeFunc61]
#ACT
GAMEGOLD + 500
SENDMSG 7 ��ϲ��500Ԫ���ѵ��ʻ���.
[@StdModeFunc62]
#ACT
GAMEGOLD + 1000
SENDMSG 7 ��ϲ��1000Ԫ���ѵ��ʻ���.
[@StdModeFunc63]
#ACT
GAMEGOLD + 2000
SENDMSG 7 ��ϲ��2000Ԫ���ѵ��ʻ���.
[@StdModeFunc64]
#ACT
GAMEGOLD + 5000
SENDMSG 7 ��ϲ��5000Ԫ���ѵ��ʻ���.
[@StdModeFunc65]
#ACT
GAMEGOLD + 10000
SENDMSG 7 ��ϲ��10000Ԫ���ѵ��ʻ���.
[@StdModeFunc66]
#ACT
GAMEGOLD + 20000
SENDMSG 7 ��ϲ��20000Ԫ���ѵ��ʻ���.
[@StdModeFunc67]
#ACT
GAMEGOLD + 50000
SENDMSG 7 ��ϲ��50000Ԫ���ѵ��ʻ���.
[@StdModeFunc68]
#ACT
GAMEGOLD + 100000
SENDMSG 7 ��ϲ��100000Ԫ���ѵ��ʻ���.

[@StdModeFunc53]
#ACT
GAMEPOINT + 1
GAMEGIRD + 1
break

[@StdModeFunc54]
#ACT
GAMEPOINT + 5
GAMEGIRD + 5
break

[@StdModeFunc55]
#ACT
GAMEPOINT + 10
GAMEGIRD + 10
break

[@StdModeFunc74]
#IF
CheckHumInRange 3 633 278 5
#ACT
GIVE �ʹ������� 1
SENDMSG 7 ����ɳ�ʹ���¥��ֹʹ�ü����
BREAK


#IF
;IsOnMap 0150
HaveGuild
#ACT
MOV A91 <$GUILDNAME>
MOV A92 <$USERNAME>
Gmexecute ��ʼ���� @�л��ٻ�
SENDMSG 7 �������ѷų�����ȴ����Ԯ��
SENDMSG 7 �������ѷų�����ȴ����Ԯ��
#ELSEACT
GIVE �ʹ������� 1
SENDMSG 7 ����ֻ�����ڻʹ���ʹ�ü������ʱ�޷�ʹ�ü�����
BREAK

[@StdModeFunc82]
#IF
CHECKSKILL �һ𽣷� < 3 1
#ACT
SKILLLEVEL �һ𽣷� + 1 1
SENDMSG 6 �һ𽣷�����ǿ����1��.���3�أ�

[@StdModeFunc83]
#IF
CHECKSKILL ħ���� < 3 1
#ACT
SKILLLEVEL ħ���� + 1 1
SENDMSG 6 ħ��������ǿ����1��.���3�أ�

[@StdModeFunc84]
#IF
CHECKSKILL ����� < 3 1
#ACT
SKILLLEVEL ����� + 1 1
SENDMSG 6 ���������ǿ����1��.���3�أ�

[@StdModeFunc85]
#IF
#ACT
GAMEGIRD + 10
SENDMSG 6 �������10������
BREAK
[@StdModeFunc86]
#IF
#ACT
GAMEGIRD + 50
SENDMSG 6 �������50������
BREAK
[@StdModeFunc87]
#IF
#ACT
GAMEGIRD + 100
SENDMSG 6 �������100������
BREAK
[@StdModeFunc88]
#IF
#ACT
GAMEGIRD + 500
SENDMSG 6 �������500������
BREAK
[@StdModeFunc89]
#IF
#ACT
GAMEGIRD + 1000
SENDMSG 6 �������1000������
BREAK

[@StdModeFunc90]
#ACT
RESTBONUSPOINT
SENDMSG 7 ��������ѻ�ԭ��
break

[@StdModeFunc91]
#act
CHANGEPKPOINT = 0
SENDMSG 7 ���Ѿ������������������ú�����Ŷ��
close

[@StdModeFunc92]
#act
#CALL [\��Ϸ����\װ������.txt] @��ʼ����
GIVE һ������ 1
BREAK

[@StdModeFunc93]
#act
#CALL [\��Ϸ����\��ݹ���.txt] @������
GIVE ��ݹ��� 1
BREAK

[@StdModeFunc94]
\
\
<��������ֿ�/@storage>\
<��������ֿ�/@storage>\
<��������ֿ�/@storage>\
<��������ֿ�/@storage>\
#ACT
GIVE ����ֿ� 1
BREAK

[@StdModeFunc95]
#if
;CHECKITEMADDVALUE 1 3 < 7
CHECKITEMADDVALUE 1 5 < 7
#act
;CHANGEITEMADDVALUE 1 3 + 1
CHANGEITEMADDVALUE 1 5 + 1
SENDMSG 6 �����������+7�㣡
BREAK

[@StdModeFunc96]
#if
#act
MessageBox \ \��Ҫ��ȡ5000Ԫ��������\ \�ɹ������������˺���������1%��\ \ʧ�������������˺��������㡿 @ȷ22�� @ȡ��22


[@ȷ22��]
#if
CHECKBAGSIZE 2
CHECKGAMEGOLD > 4999
#ACT
goto @112
#elseact
GIVE ���������� 1
MESSAGEBOX ���ϵĿո񲻹�2��������û��5000Ԫ����
break


[@ȡ��22]
#if
#ACT
GIVE ���������� 1
break

[@112]
#if
random 2
#act
GAMEGOLD - 5000
SetNewItemValue 1 1 = 0
MESSAGEBOX ���ź�,ʧ��,Ԫ�������
BREAK

#if
random 1
CHECKNEWITEMVALUE 1 1 < 5
#act
GAMEGOLD - 5000
SetNewItemValue 1 1 + 1
MESSAGEBOX �ɹ���
BREAK

[@StdModeFunc97]
#if
#act
MessageBox \ \��Ҫ��ȡ5000Ԫ��������\ \�ɹ�������������������1%��\ \ʧ�������������������㡿 @ȷ11�� @ȡ��11


[@ȡ��11]
#if
#ACT
GIVE ���������� 1
break

[@ȷ11��]
#if
CHECKBAGSIZE 2
CHECKGAMEGOLD > 4999
#ACT
goto @1121
#elseact
GIVE ���������� 1
MESSAGEBOX ���ϵĿո񲻹�2��������û��5000Ԫ����
break

[@1121]
#if
random 3
CHECKNEWITEMVALUE 1 0 < 10
#act
GAMEGOLD - 5000
SetNewItemValue 1 0 + 1
MESSAGEBOX �ɹ���
BREAK

#if
random 2
CHECKNEWITEMVALUE 1 0 < 10
#act
GAMEGOLD - 5000
SetNewItemValue 1 0 + 1
MESSAGEBOX �ɹ���
BREAK

#if
random 1
#act
GAMEGOLD - 5000
SetNewItemValue 1 0 = 0
MESSAGEBOX ���ź�,ʧ��,Ԫ�������
BREAK

[@StdModeFunc98]
#if
check [60] 0
#ACT
SET [60] 1
MESSAGEBOX ��ϲ���Ϊ�����Ļ�Ա��ң��ٴ�ʹ�û�Ա���ɲ鿴��Ա���ܣ���
BREAK

#if
check [60] 1
#SAY
\
{                   ��<$SERVERNAME>��/AUTOCOLOR=209,253,254,252,215,95,252,247}\
<����������������������������������������������������������/FCOLOR=58>\
<���/FCOLOR=250><��ϴ����/@��ϴ����><���/FCOLOR=250>          <���/FCOLOR=249><װ������/@װ������><���/FCOLOR=249> \ \
<���/FCOLOR=250><ÿ�ո���/@ÿ�ո���><���/FCOLOR=250>��        <���/FCOLOR=250><תְ����/@תְ����><���/FCOLOR=250>          \ \
\��            <���/FCOLOR=250><������ɫ/@������ɫ><���/FCOLOR=250>          \ \
<��������������������������Ⱥ:�޹���������������������/FCOLOR=58>\


[@������ɫ]
\ \
��Ա�ṩ���������ɫ���ع��ܡ�\ \
<���/@254><��ɫ/FCOLOR=254>     <���/@253><��ɫ/FCOLOR=253>      <���/@252><��ɫ/FCOLOR=252>\ \
<���/@251><��ɫ/FCOLOR=251>     <���/@250><��ɫ/FCOLOR=250>      <���/@249><��ɫ/FCOLOR=249>\ \
<���/@70><��ɫ/FCOLOR=70>     <���/@31><��ɫ/FCOLOR=31>      <���/@161><��ɫ/FCOLOR=161>\ \



[@161]
#IF
#ACT
ChangeHearMsgColor 100 161

[@31]
#IF
#ACT
ChangeHearMsgColor 100 31

[@70]
#IF
#ACT
ChangeHearMsgColor 100 70


[@249]
#IF
#ACT
ChangeHearMsgColor 100 249



[@250]
#IF
#ACT
ChangeHearMsgColor 100 250


[@251]
#IF
#ACT
ChangeHearMsgColor 100 251


[@252]
#IF
#ACT
ChangeHearMsgColor 100 252



[@253]
#IF
#ACT
ChangeHearMsgColor 100 253

[@254]
#IF
#ACT
ChangeHearMsgColor 100 254




[@תְ����]
{��    ��<$SERVERNAME>��/AUTOCOLOR=209,253,254,252,215,95,252,247}            <תְ���Ի�Ա����/FCOLOR=254>\
<����������������������������������������������������������/FCOLOR=58>\
<���˧��/@toman1>                        <�����Ů/@towoman1>  \
<�ǻ�Ա2��.��Ա1��Ԫ��/FCOLOR=168> \ \

<תְսʿ/@սʿ1>              <תְ��ʦ/@��ʦ1>             <תְ��ʿ/@��ʿ1>  \
<�ǻ�Ա15��.��Ա10��Ԫ��/FCOLOR=253>\
<---------------------------------------------------------->\

<������һҳ/@main>             <���ҹر�/@exit> \
[@��ʿ1]
#if
check [60] 1
checkjob taoist
#Act
messagebox [������ʾ]�����Ѿ��ǡ���ʿ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� ��ʿ ְҵ��
break
#If
CHECKGAMEGOLD > 99999
#Act
GAMEGOLD - 100000
ChangeJob taoist
ADDSKILL ������ 3
ADDSKILL ����� 3
ADDSKILL ������ս�� 3
ADDSKILL ������ 3
ADDSKILL ʩ���� 3
ADDSKILL ����� 3
ADDSKILL ��ʥս���� 3
ADDSKILL Ⱥ�������� 3
ADDSKILL ������ʾ 3
ADDSKILL �ٻ����� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ���ʿ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ���ʿ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� ��ʿ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ100000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ100000Ԫ����
break

#If
checkjob taoist
#Act
messagebox [������ʾ]�����Ѿ��ǡ���ʿ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� ��ʿ ְҵ��
break
#If
CHECKGAMEGOLD > 149999
#Act
GAMEGOLD - 150000
ChangeJob taoist
ADDSKILL ������ 3
ADDSKILL ����� 3
ADDSKILL ������ս�� 3
ADDSKILL ������ 3
ADDSKILL ʩ���� 3
ADDSKILL ����� 3
ADDSKILL ��ʥս���� 3
ADDSKILL Ⱥ�������� 3
ADDSKILL ������ʾ 3
ADDSKILL �ٻ����� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ���ʿ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ���ʿ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� ��ʿ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ150000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ150000Ԫ����
break

[@��ʦ1]
#If
check [60] 1
checkjob wizard
#Act
messagebox [������ʾ]�����Ѿ��ǡ�ħ��ʦ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� ħ��ʦ ְҵ��
break
#If
CHECKGAMEGOLD > 99999
#Act
GAMEGOLD - 100000
ChangeJob wizard
ADDSKILL �׵��� 3
ADDSKILL ��ǽ 3
ADDSKILL ħ���� 3
ADDSKILL ������ 3
ADDSKILL ���ܻ� 3
ADDSKILL �����Ӱ 3
ADDSKILL �ջ�֮�� 3
ADDSKILL �����׹� 3
ADDSKILL �ջ�֮�� 3
ADDSKILL ˲Ϣ�ƶ� 3
ADDSKILL ʥ���� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ�ħ��ʦ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ�ħ��ʦ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� ħ��ʦ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ100000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ100000Ԫ����
break

#If
checkjob wizard
#Act
messagebox [������ʾ]�����Ѿ��ǡ�ħ��ʦ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� ħ��ʦ ְҵ��
break
#If
CHECKGAMEGOLD > 149999
#Act
GAMEGOLD - 150000
ChangeJob wizard
ADDSKILL �׵��� 3
ADDSKILL ��ǽ 3
ADDSKILL ħ���� 3
ADDSKILL ������ 3
ADDSKILL ���ܻ� 3
ADDSKILL �����Ӱ 3
ADDSKILL �ջ�֮�� 3
ADDSKILL �����׹� 3
ADDSKILL �ջ�֮�� 3
ADDSKILL ˲Ϣ�ƶ� 3
ADDSKILL ʥ���� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ�ħ��ʦ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ�ħ��ʦ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� ħ��ʦ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ150000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ150000Ԫ����
break

[@սʿ1]
#If
check [60] 1
checkjob warrior
#Act
messagebox [������ʾ]�����Ѿ��ǡ�սʿ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� սʿ ְҵ��
break
#If
CHECKGAMEGOLD > 99999
#Act
GAMEGOLD - 100000
ChangeJob Warrior
ADDSKILL �������� 3
ADDSKILL ��ɱ���� 3
ADDSKILL ��ɱ���� 3
ADDSKILL �����䵶 3
ADDSKILL Ұ����ײ 3
ADDSKILL �һ𽣷� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ�սʿ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ�սʿ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� սʿ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ100000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ100000Ԫ����
break

#If
checkjob warrior
#Act
messagebox [������ʾ]�����Ѿ��ǡ�սʿ��ְҵ��
SENDMSG 7 [������ʾ]�����Ѿ��� սʿ ְҵ��
break
#If
CHECKGAMEGOLD > 149999
#Act
GAMEGOLD - 150000
ChangeJob Warrior
ADDSKILL �������� 3
ADDSKILL ��ɱ���� 3
ADDSKILL ��ɱ���� 3
ADDSKILL �����䵶 3
ADDSKILL Ұ����ײ 3
ADDSKILL �һ𽣷� 3
DELNOJOBSKILL
messagebox ��ϲ�������Ѿ�ת�ɡ�սʿ����\��ֹ���ݳ������ѱ�ϵͳ�Զ������ߡ�
SENDMSG 7 ��ϲ�������Ѿ�ת�ɡ�սʿ����
SENDMSG 0 ��ϲ��<$USERNAME> תְ��Ϊ�˱�����һ�� սʿ��
kick
#ELSEACT
messagebox [������ʾ]����Ҫ150000Ԫ����
SENDMSG 7 [������ʾ]����Ҫ150000Ԫ����
break

[@toman1]
#IF
check [60] 1
CHECKUSEITEM 0
#ACT
messagebox [������ʾ]�������ġ��·����ѵ���
SENDMSG 7 [������ʾ]�������ġ��·����ѵ���
break
#IF
CHECKGAMEGOLD > 9999
#ACT
GAMEGOLD - 10000
CHANGEGENDER 0
SENDMSG 7 ��ϲ���������ǳ��ĳɹ������Ѿ����һλ�����ˡ�
SENDMSG 0 ��ϲ��<$USERNAME> ���Գ�Ϊ��һλ���С�
messagebox ��ϲ���������ǳ��ĳɹ������Ѿ����һλ�����ˡ�
goto @�Ա�ת��11
break
#ELSEACT
messagebox [������ʾ]��������Ҫ����10000Ԫ����
SENDMSG 7 [������ʾ]��������Ҫ����10000Ԫ����
break

#IF
CHECKUSEITEM 0
#ACT
messagebox [������ʾ]�������ġ��·����ѵ���
SENDMSG 7 [������ʾ]�������ġ��·����ѵ���
break
#IF
CHECKGAMEGOLD > 19999
#ACT
GAMEGOLD - 20000
CHANGEGENDER 0
SENDMSG 7 ��ϲ���������ǳ��ĳɹ������Ѿ����һλ�����ˡ�
SENDMSG 0 ��ϲ��<$USERNAME> ���Գ�Ϊ��һλ���С�
messagebox ��ϲ���������ǳ��ĳɹ������Ѿ����һλ�����ˡ�
goto @�Ա�ת��11
break
#ELSEACT
messagebox [������ʾ]��������Ҫ����20000Ԫ����
SENDMSG 7 [������ʾ]��������Ҫ����20000Ԫ����
break

[@towoman1]
#IF
check [60] 1
CHECKUSEITEM 0
#ACT
messagebox [������ʾ]�������ġ��·����ѵ���
SENDMSG 7 [������ʾ]�������ġ��·����ѵ���
break
#IF
CHECKGAMEGOLD > 9999
#ACT
GAMEGOLD - 10000
CHANGEGENDER 1
SENDMSG 7 ��ϲ���������ǳ��ĳɹ������Ѿ����һλŮ���ˡ�
SENDMSG 0 ��ϲ��<$USERNAME> ���Գ�Ϊ��һλ��Ů��
messagebox ��ϲ���������ǳ��ĳɹ������Ѿ����һλŮ���ˡ�
goto @�Ա�ת��11
break
#ELSEACT
messagebox [������ʾ]��������Ҫ����10000Ԫ����
SENDMSG 7 [������ʾ]��������Ҫ����10000Ԫ����
break

#IF
CHECKUSEITEM 0
#ACT
messagebox [������ʾ]�������ġ��·����ѵ���
SENDMSG 7 [������ʾ]�������ġ��·����ѵ���
break
#IF
CHECKGAMEGOLD > 19999
#ACT
GAMEGOLD - 20000
CHANGEGENDER 1
SENDMSG 7 ��ϲ���������ǳ��ĳɹ������Ѿ����һλŮ���ˡ�
SENDMSG 0 ��ϲ��<$USERNAME> ���Գ�Ϊ��һλ��Ů��
messagebox ��ϲ���������ǳ��ĳɹ������Ѿ����һλŮ���ˡ�
goto @�Ա�ת��11
break
#ELSEACT
messagebox [������ʾ]��������Ҫ����20000Ԫ����
SENDMSG 7 [������ʾ]��������Ҫ����20000Ԫ����
break






[@��Ա���]
\
<��ȡ�ƻ���ս��/@��ս��>����������<��ȡ�ƻ�Ůս��/@Ůս��>\
\
<��ȡ�ƻ��з���/@�з���>����������<��ȡ�ƻ�Ů����/@Ů����>\
\
<��ȡ�ƻ��е���/@�е���>����������<��ȡ�ƻ�Ů����/@Ů����>\

[@Ů����]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ���յ��� 2
GIVE ���յ�ָ 2
GIVE ���յ�ѫ 1
GIVE ���յ��� 1
GIVE ���յ�ѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ǿ������� 1
GIVE Ⱥ��ʩ���� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ���յ��� 2
GIVE ���յ�ָ 2
GIVE ���յ�ѫ 1
GIVE ���յ��� 1
GIVE ���յ�ѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ǿ������� 1
GIVE Ⱥ��ʩ���� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@�е���]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ���յ��� 2
GIVE ���յ�ָ 2
GIVE ���յ�ѫ 1
GIVE ���յ��� 1
GIVE ���յ�ѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ǿ������� 1
GIVE Ⱥ��ʩ���� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ���յ��� 2
GIVE ���յ�ָ 2
GIVE ���յ�ѫ 1
GIVE ���յ��� 1
GIVE ���յ�ѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ���յ��� 1
GIVE ���յ��� 1
GIVE ǿ������� 1
GIVE Ⱥ��ʩ���� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@Ů����]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 2
GIVE ����ħָ 2
GIVE ����ħѫ 1
GIVE ����ħ�� 1
GIVE ����ħѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ǿ��ħ���� 1
GIVE Ⱥ���׵��� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 2
GIVE ����ħָ 2
GIVE ����ħѫ 1
GIVE ����ħ�� 1
GIVE ����ħѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ǿ��ħ���� 1
GIVE Ⱥ���׵��� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@�з���]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 2
GIVE ����ħָ 2
GIVE ����ħѫ 1
GIVE ����ħ�� 1
GIVE ����ħѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ǿ��ħ���� 1
GIVE Ⱥ���׵��� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 2
GIVE ����ħָ 2
GIVE ����ħѫ 1
GIVE ����ħ�� 1
GIVE ����ħѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ħ�� 1
GIVE ����ħ�� 1
GIVE ǿ��ħ���� 1
GIVE Ⱥ���׵��� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@Ůս��]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ����ս�� 2
GIVE ����սָ 2
GIVE ����սѫ 1
GIVE ����ս�� 1
GIVE ����սѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ǿ���һ𽣷� 1
GIVE ���ս��� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ����ս�� 2
GIVE ����սָ 2
GIVE ����սѫ 1
GIVE ����ս�� 1
GIVE ����սѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ǿ���һ𽣷� 1
GIVE ���ս��� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@��ս��]
#if
CHECKLEVELEX > 79
check [130] 0
#act
SET [130] 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ����ս�� 2
GIVE ����սָ 2
GIVE ����սѫ 1
GIVE ����ս�� 1
GIVE ����սѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ǿ���һ𽣷� 1
GIVE ���ս��� 1
BREAK

#if
CHECKLEVELEX < 80
check [130] 0
#act
SET [130] 1
CHANGELEVEL = 80
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ����ս�� 2
GIVE ����սָ 2
GIVE ����սѫ 1
GIVE ����ս�� 1
GIVE ����սѥ 1
GIVE ���˶��� 1
GIVE ���ˡ��� 1
GIVE ��Խ�ָ+2 1
GIVE �����ָ+2 1
GIVE �����ָ+2 1
GIVE ���Ʊ���� 1
GIVE ����ս�� 1
GIVE ����ս�� 1
GIVE ǿ���һ𽣷� 1
GIVE ���ս��� 1
#ELSEACT
MESSAGEBOX �������Ѿ���ȡ����Ա����ˣ�
BREAK

[@ÿ�ո���]
#IF
checknamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
#act
messagebox ���󣺽������Ѿ���ȡ��������
break
#IF
equal U22 5
#act
addnamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
GAMEGOLD + 200000
SENDMSG 7 ��ȡ��Ա����200000Ԫ����
BREAK
#IF
equal U22 4
#act
addnamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
GAMEGOLD + 100000
SENDMSG 7 ��ȡ��Ա����100000Ԫ����
BREAK
#IF
equal U22 3
#act
addnamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
GAMEGOLD + 30000
SENDMSG 7 ��ȡ��Ա����30000Ԫ����
BREAK
#IF
equal U22 2
#act
addnamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
GAMEGOLD + 10000
SENDMSG 7 ��ȡ��Ա����10000Ԫ����
BREAK
#IF
equal U22 1
#act
addnamelist ..\questdiary\��ʱ����\ÿ�ո���.txt
GAMEGOLD + 5000
SENDMSG 7 ��ȡ��Ա����5000Ԫ����
BREAK


[@UserCmd2]
#OR
equal U22 5
equal U22 4
equal U22 3
equal U22 2
equal U22 1
#SAY
\
{                   ��<$SERVERNAME>��/AUTOCOLOR=209,253,254,252,215,95,252,247}\ \
\
<���/FCOLOR=250><��ϴ����/@��ϴ����><���/FCOLOR=250>          <���/FCOLOR=249><װ������/@װ������><���/FCOLOR=249> \ \
<���/FCOLOR=250><ÿ�ո���/@ÿ�ո���><���/FCOLOR=250>��        <���/FCOLOR=250><תְ����/@תְ����><���/FCOLOR=250>          \ \
\��                  <���/FCOLOR=250><������ɫ/@������ɫ><���/FCOLOR=250>          \ \
\
#ACT
#ELSEACT
MESSAGEBOX �����㻹���ǻ�Ա����
BREAK


[@װ������]
#IF
#ACT
ACTREPAIRALL
#ACT
SENDMSG 7 ���װ���޺���
BREAK

[@��ϴ����]
#act
CHANGEPKPOINT = 0
SENDMSG 7 ���Ѿ������������������ú�����Ŷ��
BREAK
;-----------------------------------------------------------------------------------------------------------------
[@MagicStruck]
#IF
#ACT
#CALL [\��Ϸ����\�����˺�.txt] @�����˺�a
BREAK

[@Struck]
#IF
#ACT
#CALL [\��Ϸ����\�����˺�.txt] @�����˺�a
BREAK
;-----------------------------------------------------------------------------------------------------------------
[@�뿪]
#IF
#ACT
mapmove 3 330 330
BREAK
;-----------------------------------------------------------------------------------------------------------------

[@TakeOn2]
#IF
CHECKITEMW 1.5������ѫ�� 1
#ACT
MOV N2 0
#CALL [\��Ϸ����\װ������.txt] @װ������
BREAK

[@TakeOff2]
#IF
#ACT
MOV N2 0
#CALL [\��Ϸ����\װ������.txt] @װ������
BREAK

[@TakeOn1]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOff1]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK


[@TakeOn3]
#IF
CHECKITEMW  ������Ѫ�� 1
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

#IF
CHECKITEMW  �����Ѫ�� 1
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOn14]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOff14]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOn15]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOff15]
#IF
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

[@TakeOff3]
#IF
CheckTakeOffItem  ������Ѫ�� 1
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK

#IF
CheckTakeOffItem �����Ѫ�� 1
#ACT
MOV N1 0
#CALL [\��Ϸ����\װ����Ѫ.txt] @��Ѫ����
BREAK
;-----------------------------------------------------------------------------------------------------------------
[@StartMyShop]
#if
ISDUPMODE
#ACT
MESSAGEBOX ���������ص���һ��
ForbidMyShop
BREAK


#if
CheckLevelEx < 50
#ACT
MESSAGEBOX 50���ſ���ʹ�ð�̯���ܣ���
ForbidMyShop
BREAK

#OR
CheckHumInRange 3 285 330 11
CheckHumInRange 3 308 331 11
#ACT
#ELSEACT
MESSAGEBOX ��ǰ����������߰�ȫ�����ڣ�����ʹ�ð�̯���ܣ�
ForbidMyShop
BREAK


;-----------------------------------------------------------------------------------------------------------------


[@StdModeFunc111]
#IF
random 16
#ACT
GAMEGOLD + 1889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{1889Ԫ��|56:9}
BREAK

#IF
random 14
#ACT
GAMEGOLD + 1589
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{1589Ԫ��|56:9}
BREAK

#IF
random 12
#ACT
GAMEGOLD + 1189
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{1189Ԫ��|56:9}
BREAK

#IF
random 10
#ACT
GAMEGOLD + 889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{889Ԫ��|56:9}
BREAK

#IF
random 9
#ACT
GAMEGOLD + 689
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{689Ԫ��|56:9}
BREAK

#IF
random 7
#ACT
GAMEGOLD + 289
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{289Ԫ��|56:9}
BREAK

#IF
random 6
#ACT
GAMEGOLD + 389
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{389Ԫ��|56:9}
BREAK

#IF
random 5
#ACT
GAMEGOLD + 489
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{489Ԫ��|56:9}
BREAK

#IF
random 4
#ACT
GAMEGOLD + 189
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{189Ԫ��|56:9}
BREAK

#IF
random 3
#ACT
GAMEGOLD + 589
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{589Ԫ��|56:9}
BREAK

#IF
random 2
#ACT
GAMEGOLD + 189
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{189Ԫ��|56:9}
BREAK

#IF
random 1
#ACT
GAMEGOLD + 89
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{89Ԫ��|56:9}
BREAK
;-----------------------------------------------------------------------------------------------------------------
[@StdModeFunc112]
#IF
random 16
#ACT
GAMEGOLD + 11889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{11889Ԫ��|56:9}
BREAK

#IF
random 14
#ACT
GAMEGOLD + 11589
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{11589Ԫ��|56:9}
BREAK

#IF
random 12
#ACT
GAMEGOLD + 11189
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{11189Ԫ��|56:9}
BREAK

#IF
random 10
#ACT
GAMEGOLD + 9889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{9889Ԫ��|56:9}
BREAK

#IF
random 9
#ACT
GAMEGOLD + 8889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{8889Ԫ��|56:9}
BREAK

#IF
random 8
#ACT
GAMEGOLD + 7889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{7889Ԫ��|56:9}
BREAK

#IF
random 7
#ACT
GAMEGOLD + 6689
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{6689Ԫ��|56:9}
BREAK

#IF
random 6
#ACT
GAMEGOLD + 5889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{5889Ԫ��|56:9}
BREAK

#IF
random 5
#ACT
GAMEGOLD + 4889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{4889Ԫ��|56:9}
BREAK

#IF
random 4
#ACT
GAMEGOLD + 3889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{3889Ԫ��|56:9}
BREAK

#IF
random 3
#ACT
GAMEGOLD + 2889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{2889Ԫ��|56:9}
BREAK

#IF
random 2
#ACT
GAMEGOLD + 1889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{1889Ԫ��|56:9}
BREAK

#IF
random 1
#ACT
GAMEGOLD + 1889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{1889Ԫ��|56:9}
BREAK


;-----------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------
[@StdModeFunc113]
#IF
random 16
#ACT
GAMEGOLD + 111889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{111889Ԫ��|56:9}
BREAK

#IF
random 14
#ACT
GAMEGOLD + 101589
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{101589Ԫ��|56:9}
BREAK

#IF
random 12
#ACT
GAMEGOLD + 91189
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{91189Ԫ��|56:9}
BREAK

#IF
random 10
#ACT
GAMEGOLD + 89889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{89889Ԫ��|56:9}
BREAK

#IF
random 9
#ACT
GAMEGOLD + 78889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{78889Ԫ��|56:9}
BREAK

#IF
random 8
#ACT
GAMEGOLD + 67889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{67889Ԫ��|56:9}
BREAK

#IF
random 7
#ACT
GAMEGOLD + 56689
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{56689Ԫ��|56:9}
BREAK

#IF
random 6
#ACT
GAMEGOLD + 45889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{45889Ԫ��|56:9}
BREAK

#IF
random 5
#ACT
GAMEGOLD + 34889
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˺������߾�Ȼ��|56:9}{34889Ԫ��|56:9}
BREAK

#IF
random 4
#ACT
GAMEGOLD + 38889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{38889Ԫ��|56:9}
BREAK

#IF
random 3
#ACT
GAMEGOLD + 28889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{28889Ԫ��|56:9}
BREAK

#IF
random 2
#ACT
GAMEGOLD + 18889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{18889Ԫ��|56:9}
BREAK

#IF
random 1
#ACT
GAMEGOLD + 18889
SENDMSG 6 {��<$USERNAME>:|251:0:0}{���˺������߾�Ȼ��|56:9}{18889Ԫ��|56:9}
BREAK


;-----------------------------------------------------------------------------------------------------------------
[@StdModeFunc114]
#IF
#ACT
give ϴ�赤 50
SENDMSG 6 {��<$USERNAME>:|56:9:0}{����ϴ�赤[��]����߾�Ȼ��|56:9}{50��ϴ�赤|56:9}
BREAK

[@StdModeFunc115]
#IF
#ACT
give ��ħ���� 50
SENDMSG 6 {��<$USERNAME>:|56:9:0}{���˶�ħ����[��]����߾�Ȼ��|56:9}{50����ħ����|56:9}
BREAK

[@StdModeFunc116]
#IF
#ACT
give Ѫ������ 50
SENDMSG 6 {��<$USERNAME>:|56:9:0}{����Ѫ������[��]����߾�Ȼ��|56:9}{50��Ѫ������|56:9}
BREAK


[@StdModeFunc50]
#IF
#ACT
GAMEDIAMOND + 1
SENDMSG 5 ��ϲ��������ҵ�+1��
BREAK

[@StdModeFunc51]
#IF
#ACT
GAMEDIAMOND + 2
SENDMSG 5 ��ϲ��������ҵ�+2��
BREAK

[@StdModeFunc52]
#IF
#ACT
GAMEDIAMOND + 5
SENDMSG 5 ��ϲ��������ҵ�+5��
BREAK

[@StdModeFunc53]
#IF
#ACT
GAMEDIAMOND + 10
SENDMSG 5 ��ϲ��������ҵ�+10��
BREAK

[@StdModeFunc54]
#IF
#ACT
GAMEDIAMOND + 50
SENDMSG 5 ��ϲ��������ҵ�+50��
BREAK


[@StdModeFunc55]
#IF
#ACT
GAMEDIAMOND + 100
SENDMSG 5 ��ϲ��������ҵ�+100��
BREAK


[@�����水ť����]
#CALL [\������ť\�����������ťQF.txt] @������ťQF

[@����]
#IF
Equal <$CLIENTFLAG> 2
#ACT
delbutton 102 2
MOV S$ͼ��2 <Button|x=-230|a=3|y=35|rotate=180|nimg=official/top/1900012531.png|link=@չ��>
addbutton 102 2 <$STR(S$ͼ��2)>


[@չ��]
#IF
Equal <$CLIENTFLAG> 2
#ACT
delbutton 102 2
MOV S$ͼ��2 <Button|x=-230|y=35|nimg=official/top/1900012531.png|link=@����>

INC S$ͼ��2 <Button|x=-320|y=35|nimg=official/top/1900012611.png|link=@����>
INC S$ͼ��2 <Button|x=-400|y=35|nimg=official/top/1900012607.png|link=@�׳�>
INC S$ͼ��2 <Button|x=-480|y=35|nimg=official/top/1900012601.png|link=@�>
INC S$ͼ��2 <Button|x=-560|y=35|nimg=official/top/1900012602.png|link=@��Ь>
addbutton 102 2 <$STR(S$ͼ��2)>
break


[@����ģʽ]
#IF
#ACT
#Call [\Mobile\����NPC\ϵͳ����Ա.txt] @GM


[@ˢ��]
#IF
#ACT
REFRESHBAG



[@��Ь]
#IF
#ACT
#Call [\Mobile\����NPC\����Ա.txt] @Settings_cs


[@StartAutoPlayGame]
#if
#ACT
SENDMSG 7 ��ʼ�һ�����

#if
equal <$CLIENTFLAG> 2
#act
DELBUTTON 104 6
MOV S$�����水ť <Button|x=-127|y=-374|color=251|mimg=private\main\Skill\1900012709.png|size=16|nimg=private\main\Skill\1900012709.png|pimg=private\main\Skill\1900012709.png|link=@ֹͣ�һ�>
ADDBUTTON 104 6 <$STR(S$�����水ť)>



[@StopAutoPlayGame] 
#if
#ACT
SENDMSG 7 �رչһ�����

#if
equal <$CLIENTFLAG> 2
#act
DELBUTTON 104 6
MOV S$�����水ť <Button|x=-127|y=-374|color=251|mimg=private\main\Skill\1900012708.png|size=16|nimg=private\main\Skill\1900012708.png|pimg=private\main\Skill\1900012708.png|link=@��ʼ�һ�>
ADDBUTTON 104 6 <$STR(S$�����水ť)>





----------------------------------------------------------------ͨ�ú���--------------------------------------------------------------------------
----------------------------------------------------------------ͨ�ú���--------------------------------------------------------------------------


]]--