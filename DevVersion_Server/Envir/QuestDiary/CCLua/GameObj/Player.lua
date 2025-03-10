Player = {}

--��������
function Player.GetName(actor)
    local name = getbaseinfo(actor, CommonDefine.INFO_NAME)
    return name
end

--����playerid
function Player.GetPlayerID(actor)
    local name = getbaseinfo(actor, CommonDefine.INFO_USERID)
    return name
end

--����ǹ�����������е���ʵ����
function Player.GetMonConfigName(mon)
    local configname = getbaseinfo(mon, CommonDefine.INFO_NAME, 1)
    return configname
end

--�����Ƿ�Ϊ���
function Player.IsPlayer(actor)
    return getbaseinfo(actor, -1)
end

--�����Ƿ�����
function Player.IsDead(obj)
    local flag = getbaseinfo(obj, 0)
    return flag
end    

--���صȼ�
function Player.GetLevel(actor)
    local level = getbaseinfo(actor, CommonDefine.INFO_LEVEL)
    return level
end

--���õȼ�
function Player.SetLevel(actor, level)
    changelevel(actor, '=', level)
    Player.FullHPMP(actor)
end

--����ְҵ
function Player.GetJob(actor)
    local level = getbaseinfo(actor, CommonDefine.INFO_JOB)
    return level
end

--�����Ա�
function Player.GetGender(actor)
    local gender = getbaseinfo(actor, CommonDefine.INFO_GENDER)
    return gender
end

--�����л���
function Player.GetGuildName(actor)
    local guildname = getbaseinfo(actor, CommonDefine.INFO_GUILDNAME)
    return guildname
end

--�������ڵ�ͼID[Сд���ַ���]
function Player.GetMapIDStr(actor)
    local mapstr = getbaseinfo(actor, CommonDefine.INFO_MAPSTR)
    return mapstr
end

--���ö�����Ѫ����
function Player.FullHPMP(actor)
    addhpper(actor, '=', 100)
    addmpper(actor, '=', 100)
end

--���ذ�ȫ�� ��Ѫ����
function Player.GoHome(actor)
    gohome(actor)
    Player.FullHPMP(actor)
end

--���ر��氲ȫ�� ��Ѫ����
function Player.GoBQHome(actor)
    mapmove(actor, '0', 326, 272, 3)
    Player.FullHPMP(actor)
end

--�������ذ�ȫ�� ��Ѫ����
function Player.GoMZHome(actor)
    mapmove(actor, '3', 330, 330, 3)
    Player.FullHPMP(actor)
end

--�������ڵ�ͼ������
function Player.GetMapXY(actor)
    local currx = getbaseinfo(actor, CommonDefine.INFO_MAPX)
    local curry = getbaseinfo(actor, CommonDefine.INFO_MAPY)
    return currx, curry
end

--����monid
function Player.GetMonIdx(actor)
    local monid = getbaseinfo(actor, CommonDefine.INFO_MONIDX)
    return monid
end

--���ض����Ѫ���ٷֱ�
function Player.GetCurHPPercent(actor)
    if getbaseinfo(actor, 0) then
        return 0
    else
        local curhp = getbaseinfo(actor, CommonDefine.INFO_CURRHP)
        local maxhp = getbaseinfo(actor, CommonDefine.INFO_MAXHP)
        local percent = math.floor(curhp / maxhp * 100)
        return percent
    end
end

--�����Ƿ���PC�ͻ���
function Player.IsPCClient(actor)
    local sFlag = parsetext("<$CLIENTFLAG>", actor);
    return sFlag == '1'
end

--�������ս��
function Player.GetPlayerPower(actor)
    return tonumber(parsetext("<$PLAYERPOWER>", actor));
end

--�Զ��ﵽĿ�꣬����ͬ��ͼ�ͷɣ���ͬ��ͼ��Ѱ·
function Player.AutoGoToTargMapXY(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) then
        return
    end

    local currmapidstr = Player.GetMapIDStr(actor)
    if (mapidstr==nil) or (currmapidstr == mapidstr) then
        gotonow(actor, x, y)
    else
        map(actor, mapidstr)
        gotonow(actor, x, y)
    end
end

--����ͨ�ý���ר����ͼ��ԭ�ظ�����Ҫ������
function Player.GetCommonLocalReliveNeedItems(relivetimes)
    if relivetimes <= 0 then
        relivetimes = 1
    elseif relivetimes > #CommonDefine.COMMON_LOCAL_RELIVE_NEED_ITEMS then
        relivetimes = #CommonDefine.COMMON_LOCAL_RELIVE_NEED_ITEMS
    end
    return CommonDefine.COMMON_LOCAL_RELIVE_NEED_ITEMS[relivetimes]
end

--������ҵ�ְҵ���Ա�ͨ�ù���table
function Player.FilterTable(actor, srctab)
    if BF_IsNullObj(actor) then
        return srctab
    end
    local targtab = {}
    local job = Player.GetJob(actor)
    local gender = Player.GetGender(actor)
    for _, singleitem in pairs(srctab) do
        if singleitem then
            local bIsValid = true
            if singleitem.job and (singleitem.job ~= CommonDefine.JOB_ALL) and (singleitem.job ~= job) then
                bIsValid = false
            end
            if singleitem.gender and (singleitem.gender ~= gender) then
                bIsValid = false
            end

            if bIsValid then
                targtab[#targtab+1] = singleitem
            end
        end
    end
    return targtab
end

--������Ҹ����
function Player.ShowReliveDialogue(actor, msg)    
    say(actor, msg)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG, 1)
end

--������Ԫ������С���
function Player.AddRedPoint(actor, winid, buttonid, x, y)
    if not BF_IsNullObj(actor) then
        reddot(actor, winid, buttonid, x, y, 0, 'res/private/cc_common/redpoint.png')
    end
end

--ɾ������Ԫ�ص�С��㣬��Ҫ��Ե���������
function Player.DelRedPoint(actor, winid, buttonid)
    if not BF_IsNullObj(actor) then
        reddel(actor, winid, buttonid)
    end
end

--���װ���Ƿ�װ��������
function Player.CheckEquipIsOnBody(actor, itemobj)
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then
        return false
    end

    for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
        local equipitem = linkbodyitem(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        if not BF_IsNullObj(equipitem) then
            if getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_UNIQUEID) == getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID) then
               return true 
            end
        end
    end
    return false
end

--����������
function Player.CheckMoneyNum(actor, moneytype, num)
    local moneynum = querymoney(actor, moneytype)
    --[[
    ��Ԫ������Ԫ��
    if moneytype == ConstCfg.money.bdyb then
        moneynum = moneynum + querymoney(actor, ConstCfg.money.yb)
    end
    ]]--
    return moneynum >= num
end

--������ұ����е���Ʒ���������������
function Player.GetItemNumInBag(actor, nameOrIdx)
    if (actor == nil) or (nameOrIdx == nil) then
        return 0, ''
    end

    local itemidx = getstditeminfo(nameOrIdx, CommonDefine.STDITEMINFO_IDX)
    local itemname = getstditeminfo(nameOrIdx, CommonDefine.STDITEMINFO_NAME)
    if (itemidx==nil) or (itemname=='') or (itemidx==0) or (itemname=='') then
        return 0, ''
    end

    if Item.isCurrency(itemidx) then     
        --�������   
        return querymoney(actor, itemidx), itemname
    else  
        --���ߺ�װ��
        return getbagitemcount(actor, itemname), itemname
    end
end

--��� ��Ʒ ���� װ���Ƿ��������� items = {[1]={name="XX", id=999, num=1}}  name �� id ��һ������
function Player.CheckItemsEnough(actor, checkitems, notifyreason, multiple)
    if (actor == nil) or (checkitems == nil) then
        return false
    end

    for _, checkitem in pairs(checkitems) do
        local nameOrIdx = checkitem.name
        if nameOrIdx == nil then
            nameOrIdx = checkitem.id
        end
        if nameOrIdx == nil then
            return false
        end
            
        local itemnum = checkitem.num
        if multiple then 
            itemnum = itemnum * multiple
        end

        local bagItemNum, needitemname = Player.GetItemNumInBag(actor, nameOrIdx);
        if bagItemNum < itemnum then
            if notifyreason and (notifyreason~='') and (needitemname~=nil) then
                Player.SendSelfMsg(actor, notifyreason..'�����'..needitemname..'���㣡', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            end
            return false
        end
    end

    return true
end

--������Ʒ
function Player.TakeItems(actor, needitems, desc, multiple)
    if BF_IsNullObj(actor) or (needitems == nil) or (type(needitems) ~= 'table') then
        return
    end

    for _, item in pairs(needitems) do
        local nameOrIdx = item.name
        if nameOrIdx == nil then
            nameOrIdx = item.id
        end
        if nameOrIdx == nil then
            return
        end

        local itemnum = item.num
        if multiple then 
            itemnum = itemnum * multiple
        end

        local itemidx = getstditeminfo(nameOrIdx, CommonDefine.STDITEMINFO_IDX)
        local itemname = getstditeminfo(nameOrIdx, CommonDefine.STDITEMINFO_NAME)
        if (itemidx == 0) or (itemname == '') then
            return
        end

        if Item.isCurrency(itemidx) then       
            --������� 
            changemoney(actor, itemidx, "-", itemnum, desc, true)
        else
            --��Ʒ װ��
            takeitem(actor, itemname, itemnum)
        end
    end
end

--������ߣ�����������ʼ�
function Player.GiveItemsToBagOrMail(actor, rewarditems, desc)
    if BF_IsNullObj(actor) or (rewarditems == nil) or (type(rewarditems) ~= 'table') or (#rewarditems == 0) then
        BF_DebugOut('����Ϊ�գ�'..desc)
        return
    end

    local itemstr = '';
    for _, value in ipairs(rewarditems) do
        if itemstr ~= '' then
            itemstr = itemstr..'&'
        end
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        itemstr = itemstr..value.name..'#'..value.num
    end 
    if Bag.IsHaveEnoughBagSpace(actor, rewarditems) then
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        --���ﻹ�ǲ���ȷ�ϣ�����������������߿��Ե��ӵ�����£��Ƿ��ܸ���ɹ���������������
        gives(actor, itemstr, desc)
    else
        local playerid = Player.GetPlayerID(actor)
        sendmail(playerid, CommonDefine.MAIL_ID_BAGFULL, "�����ռ䲻��", desc, itemstr)
    end    
end

--����ҷ��ŵ����ʼ�
function Player.GiveItemsByMail(actor, rewarditems, mailtitle, maildesc)
    if BF_IsNullObj(actor) or (rewarditems == nil) or (type(rewarditems) ~= 'table') or (#rewarditems == 0) then
        BF_DebugOut('����Ϊ�գ�'..mailtitle)
        return
    end

    local itemstr = '';
    for _, value in ipairs(rewarditems) do
        if itemstr ~= '' then
            itemstr = itemstr..'&'
        end
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        --���ﴦ���״̬����������
        itemstr = itemstr..value.name..'#'..value.num
    end 

    local playerid = Player.GetPlayerID(actor)
    sendmail(playerid, CommonDefine.MAIL_ID_BAGFULL, mailtitle, maildesc, itemstr)    
    Player.SendSelfMsg(actor, '������ʼ�:'..mailtitle, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--�����������װ�����Ʒ��
function Player.GetAllEquipmentMinQualityLv(actor)
    if BF_IsNullObj(actor) then
        return -1
    end

    local minquality = 999
    for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
        local equipitem = linkbodyitem(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        if BF_IsNullObj(equipitem) then
            minquality = -1
            break
        end
        local itemquality = Item.GetItemQualityLv(actor, equipitem)
        if itemquality < minquality then
            minquality = itemquality
        end
    end
    if minquality == 999 then
        minquality = -1
    end
    return minquality
end

--�ж���ҹ����Ƿ���
function Player.IsFunctionOpen(actor, funcid, bNotify)
    if BF_IsNullObj(actor) then
        return false, 0
    end
    local currlv = Player.GetLevel(actor)
    for _, value in pairs(cfgFunctionCtrl) do
        if value.id == funcid then
            if currlv >= value.needlv then
                return true, 0
            else
                if bNotify == true then
                    local tempCurrX = CSS.NPC_LEFT_START_X
                    local tempCurrY = CSS.NPC_TOP_START_Y                    
                    local msg = '<Text|text=��������['..value.name..']����Ҫ�ﵽ'..value.needlv..'����|x='..(tempCurrX+100)..'|y='..(tempCurrY+100)..'|color='..CSS.NPC_WHITE..'>'
                    BF_NPCSayExt(actor, msg)
                end
                return false, value.needlv
            end
        end
    end
    return true, 0
end

--�����˷�����Ϣ
function Player.SendSelfMsg(actor, msg, postype,fcolor,bcolor)
    if (actor == nil) or (msg == nil) or (postype == nil) then
        return
    end
    local fontcolor = CSS.CHAT_RED
    if fcolor then
        fontcolor = fcolor
    end
    local backcolor = CSS.CHAT_WHITE
    if bcolor then
        backcolor = bcolor
    end
    sendmsg(actor, 1, '{"Msg":"'..msg..'","Type":'..postype..',"FColor":'..fontcolor..',"BColor":'..backcolor..'}')
end

--��ȫ��������Ϣ
function Player.SendServerMsg(actor, msg, postype,fcolor,bcolor)
    if (actor == nil) or (msg == nil) or (postype == nil) then
        return
    end
    if fcolor==nil or bcolor==nil then
        sendmsg(actor, 2, '{"Msg":"'..msg..'","Type":'..postype..'}')
    else
        sendmsg(actor, 2, '{"Msg":"'..msg..'","Type":'..postype..',"FColor":'..fcolor..',"BColor":'..bcolor..'}')
    end
end

--���лᷢ����Ϣ
function Player.SendGuildMsg(actor, msg, postype,fcolor,bcolor)
    if (actor == nil) or (msg == nil) or (postype == nil) then
        return
    end
    local fontcolor = CSS.CHAT_WHITE
    if fcolor then
        fontcolor = fcolor
    end
    local backcolor = CSS.CHAT_BLUE
    if bcolor then
        backcolor = bcolor
    end    
    sendmsg(actor, 3, '{"Msg":"'..msg..'","Type":'..postype..',"FColor":'..fontcolor..',"BColor":'..backcolor..'}')
end

--����ͼ������Ϣ
function Player.SendMapMsg(actor, msg, postype)
    if (actor == nil) or (msg == nil) or (postype == nil) then
        return
    end
    sendmsg(actor, 4, '{"Msg":"'..msg..'","Type":'..postype..'}')
end

--����ӷ�����Ϣ
function Player.SendTeamMsg(actor, msg, postype)
    if (actor == nil) or (msg == nil) or (postype == nil) then
        return
    end
    sendmsg(actor, 5, '{"Msg":"'..msg..'","Type":'..postype..'}')
end

--��ʼ�������
function Player.InitNewPlayer(actor)
    if BF_IsNullObj(actor) then
        return
    end
    
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NEW_PLAYER_INIT_FLAG) == 0 then
        setplaydef(actor, CommonDefine.VAR_J_DAY_MOFANG_LEFT_FREETIMES, CommonDefine.DAY_FREE_ENTER_MOFANGZHEN_TIMES)        
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NEW_PLAYER_INIT_FLAG, 1)

        --�����״ε�¼����
        local currday = BF_GetDay(os.time())
        setplaydef(actor, CommonDefine.VAR_U_FIRST_LOGIN_DAY, currday)        

        --������ʼװ��
        local job = Player.GetJob(actor)
        local gender = Player.GetGender(actor)
        if job == CommonDefine.JOB_Z then
            giveonitem(actor, CommonDefine.EQUIPPOS_WEAPON, '�����������', 1, 1, '��������')
            if gender == CommonDefine.GENDER_MAN then
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵĴֲ���(��)', 1, 1, '��������')
            else
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵĴֲ���(Ů)', 1, 1, '��������')
            end
        elseif job == CommonDefine.JOB_F then
            giveonitem(actor, CommonDefine.EQUIPPOS_WEAPON, '�����ľ����', 1, 1, '��������')
            if gender == CommonDefine.GENDER_MAN then
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵ�ɴ����(��)', 1, 1, '��������')
            else
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵ�ɴ����(Ů)', 1, 1, '��������')
            end
        elseif job == CommonDefine.JOB_D then
            giveonitem(actor, CommonDefine.EQUIPPOS_WEAPON, '�����ľ�齣', 1, 1, '��������')
            if gender == CommonDefine.GENDER_MAN then
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵ���Ƥ��(��)', 1, 1, '��������')
            else
                giveonitem(actor, CommonDefine.EQUIPPOS_DRESS, '�ƾɵ���Ƥ��(Ů)', 1, 1, '��������')
            end
        end

        giveitem(actor, '�������ʯ', 1, 1, '��������')
        giveitem(actor, '���洫��ʯ', 1, 1, '��������')
        giveitem(actor, '���ػس�ʯ', 1, 1, '��������')
        giveitem(actor, 'ǿ��ʯ', 200, 1, '��������')
        giveitem(actor, '̫��ˮ', 50, 1, '��������')
        Player.SetLevel(actor, 1)
        SkillUpgrade.CheckAutoLearnSkill(actor)        

        Player.FullHPMP(actor)                
        TaskManager.AddNewTask(actor, CommonDefine.TASK_LINE_ID_MAIN, 0)

        --Player.GoMZHome(actor)
        mapmove(actor, '0', 651, 628, 3)
    end
end

function Player.TestSuperInitPlayer(actor)    
    if BF_IsNullObj(actor) then
        return
    end

    local QUICK_WEAR_EQUIPMENT = {
        [CommonDefine.JOB_Z] = {
            [CommonDefine.GENDER_MAN] = {'��˫�ı�˪�޽�', '��˫�ı�˪ս��(��)', '��˫�ı�˪ͷ��(ս)', '��˫�ı�˪����(ս)', '��˫�ı�˪���ָ(ս)', '��˫�ı�˪�ҽ�ָ(ս)', 
                                        '��˫�ı�˪������(ս)', '��˫�ı�˪������(ս)', '��˫�ı�˪����(ս)', '��˫�ı�˪��ѥ(ս)'},
            [CommonDefine.GENDER_WOMAN] = {'��˫�ı�˪�޽�', '��˫�ı�˪ս��(Ů)', '��˫�ı�˪ͷ��(ս)', '��˫�ı�˪����(ս)', '��˫�ı�˪���ָ(ս)', '��˫�ı�˪�ҽ�ָ(ս)',
                                        '��˫�ı�˪������(ս)', '��˫�ı�˪������(ս)', '��˫�ı�˪����(ս)', '��˫�ı�˪��ѥ(ս)'},
        },
        [CommonDefine.JOB_F] = {
            [CommonDefine.GENDER_MAN] = {'��˫�ı�˪����', '��˫�ı�˪ս��(��)', '��˫�ı�˪ͷ��(��)', '��˫�ı�˪����(��)', '��˫�ı�˪���ָ(��)', '��˫�ı�˪�ҽ�ָ(��)',
                                        '��˫�ı�˪������(��)', '��˫�ı�˪������(��)', '��˫�ı�˪����(��)', '��˫�ı�˪��ѥ(��)'},
            [CommonDefine.GENDER_WOMAN] = {'��˫�ı�˪����', '��˫�ı�˪ս��(Ů)', '��˫�ı�˪ͷ��(��)', '��˫�ı�˪����(��)', '��˫�ı�˪���ָ(��)', '��˫�ı�˪�ҽ�ָ(��)', 
                                        '��˫�ı�˪������(��)', '��˫�ı�˪������(��)', '��˫�ı�˪����(��)', '��˫�ı�˪��ѥ(��)'},
        },
        [CommonDefine.JOB_D] = {
            [CommonDefine.GENDER_MAN] = {'��˫�ı�˪�齣', '��˫�ı�˪����(��)', '��˫�ı�˪ͷ��(��)', '��˫�ı�˪����(��)', '��˫�ı�˪���ָ(��)', '��˫�ı�˪�ҽ�ָ(��)', 
                                        '��˫�ı�˪������(��)', '��˫�ı�˪������(��)', '��˫�ı�˪����(��)', '��˫�ı�˪��ѥ(��)'},
            [CommonDefine.GENDER_WOMAN] = {'��˫�ı�˪�齣', '��˫�ı�˪����(Ů)', '��˫�ı�˪ͷ��(��)', '��˫�ı�˪����(��)', '��˫�ı�˪���ָ(��)', '��˫�ı�˪�ҽ�ָ(��)', 
                                        '��˫�ı�˪������(��)', '��˫�ı�˪������(��)', '��˫�ı�˪����(��)', '��˫�ı�˪��ѥ(��)'},
        },
    }    

    --���õȼ�
    Player.SetLevel(actor, 80)

    --����װ��
    local job = Player.GetJob(actor)
    local gender = Player.GetGender(actor)
    local equiplist = QUICK_WEAR_EQUIPMENT[job][gender]
    if equiplist and #equiplist > 0 then
        for _, equipname in ipairs(equiplist) do
            local pos = BF_GetEquipPosByNameOrID(equipname)
            local newitem = giveitem(actor, equipname, 1, 0, 'GM����')
            if newitem then
                EquipRandomABManager.InitEquipRandomAB(actor, newitem, math.random(1,2))
                local uniqueid = getiteminfo(actor, newitem, CommonDefine.ITEMINFO_UNIQUEID)
                takeonitem(actor, pos, uniqueid)
            end
        end
    end    
    Player.FullHPMP(actor)                 
end

--���ǰ��
function Player.QuickGoTo(actor, gotoid)
    if BF_IsNullObj(actor) then
        return
    end

    --todo...................
    --todo...................
    --todo...................�������npc��������Ҫ��һ��ʵ��

    local currlv = Player.GetLevel(actor)
    if gotoid == CommonDefine.QUICK_GOTO_UPGRADE_LEVEL then
        --����
        opennpcshowex(actor, 211, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_INCREASE_POWER then
        --��ս��
        if currlv <= 40 then
            --ǿ����ʦ
            opennpcshowex(actor, 200, 3, 3)
        elseif currlv <= 55 then
            --���Ǵ�ʦ
            opennpcshowex(actor, 201, 3, 3)
        elseif currlv <= 60 then
            --ϴ����ʦ
            opennpcshowex(actor, 203, 3, 3)
        elseif currlv <= 70 then
            --��ʯ��ʦ
            opennpcshowex(actor, 208, 3, 3)
        else
            --��������
            opennpcshowex(actor, 206, 3, 3)
        end        
    elseif gotoid == CommonDefine.QUICK_GOTO_KILL_RANDOMBOSS then
        --��ɱս��boss
        opennpcshowex(actor, 212, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_KILL_BAOZHUBOSS then
        --��ɱ���顾����boss
        opennpcshowex(actor, 207, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_ENTER_MOFANGZHEN then
        --����ħ����
        opennpcshowex(actor, 211, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_UPGRADE_EQUIPSTAR then
        --װ������
        opennpcshowex(actor, 201, 3, 3)             
    elseif gotoid == CommonDefine.QUICK_GOTO_EQUIP_STRENGTH then
        --װ��ǿ��
        opennpcshowex(actor, 200, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_EQUIP_QUALITY then
        --װ��Ʒ��
        opennpcshowex(actor, 211, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_EQUIP_RANDOMAB then
        --װ��ϴ��
        opennpcshowex(actor, 203, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_EQUIP_COMPOSE then
        --װ���ϳ�
        opennpcshowex(actor, 205, 3, 3)           
    elseif gotoid == CommonDefine.QUICK_GOTO_SOULSTONE then
        --��ʯϵͳ
        opennpcshowex(actor, 208, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_BAOZHU then
        --���顾����ϵͳ
        opennpcshowex(actor, 206, 3, 3)  
    elseif gotoid == CommonDefine.QUICK_GOTO_FREEVIP then
        --���VIPϵͳ
        opennpcshowex(actor, 213, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_RECHARGE then
        --��ֵϵͳ
        openhyperlink(actor, 26)
    elseif gotoid == CommonDefine.QUICK_GOTO_SINGLEBOSS then
        --��������
        opennpcshowex(actor, 223, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_PUBLICBOSS then
        --Ұ������
        opennpcshowex(actor, 224, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_YUNBIAO then
        --����
        opennpcshowex(actor, 225, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_TREASUREMAP then
        --�ر�ͼ
        --????
    elseif gotoid == CommonDefine.QUICK_GOTO_GUANZHI then
        --��ְ
        opennpcshowex(actor, 209, 3, 3)
    elseif gotoid == CommonDefine.QUICK_GOTO_ZCD then
        --��巵� ���߻���
        opennpcshowex(actor, 210, 3, 3)
    end          
end

--������װ����������ҵļ���״̬
function Player.CheckSpeedUpStatus(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local FIRST_RECHARGE_SPEEDUP_WEAPON_ID = 15001
    local FIRST_RECHARGE_SPEEDUP_WEAPON_ADDNUM = 100

    local nSpeedUp = 0
    for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
        local equipitem = linkbodyitem(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        if not BF_IsNullObj(equipitem) then
            --�ж��׳����
            local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
            if itemid == FIRST_RECHARGE_SPEEDUP_WEAPON_ID then
                nSpeedUp = nSpeedUp + FIRST_RECHARGE_SPEEDUP_WEAPON_ADDNUM
            end

            --�ж�װ�����츳�ļ�������
            local naddnum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_ATTACK_SPEEDUP_INITGIFT, equipitem)
            if naddnum ~= nil then 
                nSpeedUp = nSpeedUp + naddnum
            end
        end
    end

    changespeedex(actor, 2, nSpeedUp)
    changespeedex(actor, 3, nSpeedUp)
end

--�Զ���ĵ���������ʾ
function Player.ShowItemEx(actor, makeindex)
    if BF_IsNullObj(actor) or (makeindex==nil) or (makeindex==0) then
        return
    end

    local itemobj = getitembymakeindex(actor, makeindex)
    if BF_IsNullObj(itemobj) then
        return
    end

    local itemjson = getitemjsonex(itemobj)
    local tempstr = [[<ItemShow|x=0.0|y=0.0|width=70|height=70|itemdata=]]..itemjson..[[|showtips=1|bgtype=1|color=250>]]
    say(actor, tempstr)
end

--[[
--��ȡ������ɫ����
function Player.getCreateActorDay(actor)
    local openday = grobalinfo(ConstCfg.global.openday)
    local create_actor_openday = getplaydef(actor, VarCfg.U_create_actor_openday)
    local create_actor_day = openday - create_actor_openday + 1
    return create_actor_day
end

--��� ��Ʒ ���� װ���Ƿ���������(�������㷵�ز�����Ʒ������)
function Player.checkItemNumByTable(actor, t, multiple)
    for _,item in ipairs(t) do
        local idx,num = item[1],item[2]
        if multiple then num=num*multiple end

        local name = idx==ConstCfg.money.bdyb and "Ԫ��" or getstditeminfo(idx, ConstCfg.stditeminfo.name)
        if Item.isCurrency(idx) then        --����
            if not Player.checkMoneyNum(actor, idx, num) then
                return name, num
            end
        else                                    --��Ʒ װ��
            if not Bag.checkItemNumByIdx(actor, idx, num) then
                return name, num
            end
        end
    end
end

--�������������guid�����֣�name����ȡ��Ʒ����
--luo��ȡ�����Ʒ���� 1.guid 2.itemname 3.�Ƿ��ж�װ���� ����ֵnumber ���򷵻�nil
function Player.libcheckItemNumByTableEx(actor, name, boolean)
    local idx = getstditeminfo(name, 0)  --����name��ȡidx
    if idx ~= 0 then
        local count = 0
        local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)   --��ȡ������Ʒ����
        for i=0, item_num-1 do
            local itemobj = getiteminfobyindex(actor, i)
            local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)  --��ȡ������Ʒidx
            if itemidx == idx then   --ƥ��idx
                local item_mun = getiteminfo(actor, itemobj, ConstCfg.iteminfo.overlap)  --ע��ѵ�
                if item_mun == 0 then   --�ѵ�Ϊ0 Ϊ���ѵ� ����Ϊ1
                    item_mun = 1
                end
                count = count + item_mun
            end
        end
        if boolean then  --�Ƿ����װ����
            local stdmode = getstditeminfo(idx, ConstCfg.stditeminfo.stdmode)  --��ȡװ������
            local where = ConstCfg.stdmodewheremap[stdmode]   --��ȡװ��λ��
            local equipobj = linkbodyitem(actor, where)
            if equipobj ~= "0" then
                local equipidx = getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
                if equipidx == idx then
                    count = count + 1
                end
            end

        end
        return count
    end
    return
end

-- local moneynum = querymoney(actor, moneytype)
--     if moneytype == ConstCfg.money.bdyb then
--         moneynum = moneynum + querymoney(actor, ConstCfg.money.yb)
--     end
--     return moneynum >= num

--������Ʒ
function Player.takeItemByTable(actor, t, desc, multiple)
    for _,item in ipairs(t) do
        local idx,num = item[1],item[2]
        if multiple then num=num*multiple end
        if Item.isCurrency(idx) then        --����
            if idx == 4 then  --��Ϸ�趨 ��Ԫ������۳�����Ԫ��
                local bdyb = querymoney(actor, 4)  
                if num > bdyb then    --����Ԫ�����ڰ�Ԫ��ʱ
                    changemoney(actor, 4, "-", bdyb, desc, true)   --���ȿ۳����а�Ԫ��
                    changemoney(actor, 2, "-", (num-bdyb), desc, true)  --����Ԫ�����䲻��Ԫ��
                end
            end
            changemoney(actor, idx, "-", num, desc, true)
        else                                    --��Ʒ װ��
            local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
            takeitem(actor, name, num)
        end
    end
end

--����Ʒ
function Player.giveItemByTable(actor, t, desc, multiple, isbind)
    multiple = multiple or 1         --����

    for _,item in ipairs(t) do
        local idx,num,bind = item[1],item[2],item[3]
        if Item.isCurrency(idx) then        --����
            changemoney(actor, idx, "+", num * multiple, desc, true)
        else                                    --��Ʒ װ��
            local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
            if bind or isbind then
                giveitem(actor, name, num * multiple, ConstCfg.binding)
            else
                giveitem(actor, name, num * multiple)
            end
        end
    end
end

--����Ʒ����
function Player.giveItemBoxByIdx(actor, idx)
    local name = getstditeminfo(idx, ConstCfg.stditeminfo.name)
    giveitem(actor, name)
end

--��ȡ��ǰ����װ����Ψһid����ͨ��idx
function Player.getEquipIdsByIdx(actor, idx)
    if not Item.isEquip(idx) then return {} end

    local equipids = {}
    local wheres = Item.getWheresByIdx(idx)
    for _,where in ipairs(wheres) do
        local equipobj = linkbodyitem(actor, where)
        if equipobj ~= "0" then
            local equipidx = getiteminfo(actor, equipobj, ConstCfg.iteminfo.idx)
            if equipidx == idx then
                local equipmakeindex = getiteminfo(actor, equipobj, ConstCfg.iteminfo.id)
                table.insert(equipids, equipmakeindex)
            end
        end
    end
    return equipids
end

--��ȡװ��λidx
function Player.getEquipPosIdx(actor, pos)
    local itemobj = linkbodyitem(actor, pos)
    if itemobj=="0" then return end
    local idx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    return idx
end


--��������
local _addrs = {}
function Player.updateAddr(actor, loginattrs)
    --��������
    for attridx=1,250 do
        _addrs[attridx] = 0
    end

    for _,addr in ipairs(loginattrs) do
        for _,v in ipairs(addr) do
            local attridx = v[1]
            _addrs[attridx] = _addrs[attridx] + v[2]
        end
    end

    --������������
    for attridx,value in ipairs(_addrs) do
        if value > 0 then
            changehumnewvalue(actor, attridx, _addrs[attridx], ConstCfg.attrtime)
        end
    end
end

--���²�������
function Player.updateSomeAddr(actor, cur_attr, next_attr)
    local newattr = {}
    if cur_attr then
        for _,attr in ipairs(cur_attr) do
            local attridx, attrvalue = attr[1], attr[2]
            newattr[attridx] = newattr[attridx] or gethumnewvalue(actor, attridx)
            newattr[attridx] = newattr[attridx] - attrvalue
            if newattr[attridx] < 0 then newattr[attridx] = 0 end
        end
    end

    -- LOGDump(newattr)

    if next_attr then
        for _,attr in ipairs(next_attr) do
            local attridx, attrvalue = attr[1], attr[2]
            newattr[attridx] = newattr[attridx] or gethumnewvalue(actor, attridx)
            newattr[attridx] = newattr[attridx] + attrvalue
        end
    end

    -- LOGDump(newattr)

    --cfg_att_score.xls ����
    for attridx,attrvalue in pairs(newattr) do
        changehumnewvalue(actor, attridx, attrvalue, ConstCfg.attrtime)
    end
end

]]--

return Player