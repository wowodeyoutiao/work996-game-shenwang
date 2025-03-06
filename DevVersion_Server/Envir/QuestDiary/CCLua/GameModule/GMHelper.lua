GMHelper = {}

function GMHelper.InitUI(actor)
    --gm ����ģʽ
    if getgmlevel(actor) > 0 then
        release_print()
        addbutton(actor, 104, CommonDefine.ADD_BUTTON_ID_2, '<Button|x=-250|y=-350|nimg=official/top/1900012530.png|link=@gmhelper_openpanel>')
    end
end

function GMHelper.OpenPanel(actor)
    if getgmlevel(actor) == 0 then
        return
    end
    local sPanelStr = '<Button|x=40|y=30|nimg=public/bg_hhzy_01_3.png|text=�ȼ���10��|link=@gmhelper_button#sid1=1>'..
        '<Button|x=40|y=60|nimg=public/bg_hhzy_01_3.png|text=������������|link=@gmhelper_button#sid1=1001>'..
        '<Button|x=40|y=90|nimg=public/bg_hhzy_01_3.png|text=������������|link=@gmhelper_button#sid1=1002>'
    --[[
        '<Button|x=40|y=60|nimg=public/bg_hhzy_01_3.png|text=100w���10wԪ��5k��Ԫ|link=@gmhelper_button,2>'..                      
        '<Button|x=40|y=90|nimg=public/bg_hhzy_01_3.png|text=�����ǻ�ʯ|link=@gmhelper_button,3>'..
        '<Button|x=40|y=120|nimg=public/bg_hhzy_01_3.png|text=�޵�|link=@gmhelper_button,4>'..
        '<Button|x=40|y=150|nimg=public/bg_hhzy_01_3.png|text=�����������ϼ�2000|link=@gmhelper_button,5>'..
        '<Button|x=40|y=180|nimg=public/bg_hhzy_01_3.png|text=����ɫ����|link=@gmhelper_button,6>'..
        '<Button|x=40|y=210|nimg=public/bg_hhzy_01_3.png|text=ѧϰְҵ����|link=@gmhelper_button,13>'..                      
        '<Button|x=40|y=240|nimg=public/bg_hhzy_01_3.png|text=����ϴ������װ��|color=253|link=@gmhelper_button,999>'..
        '<Button|x=40|y=270|nimg=public/bg_hhzy_01_3.png|text=����8000����|color=253|link=@gmhelper_button,998>'..

        '<Button|x=200|y=30|nimg=public/bg_hhzy_01_3.png|text=ɾ����������|link=@gmhelper_button,102>'..
        '<Button|x=200|y=60|nimg=public/bg_hhzy_01_3.png|text=��ʼ��������|link=@gmhelper_button,101>'..                      
        '<Button|x=200|y=90|nimg=public/bg_hhzy_01_3.png|text=������������|link=@gmhelper_button,103>'..
        '<Button|x=200|y=120|nimg=public/bg_hhzy_01_3.png|text=�����������|link=@gmhelper_button,104>'..
        '<Button|x=200|y=150|nimg=public/bg_hhzy_01_3.png|text=�콱��������|link=@gmhelper_button,105>'..
        '<Button|x=200|y=180|nimg=public/bg_hhzy_01_3.png|text=ˢ�������|link=@gmhelper_button,106>'..
        '<Button|x=200|y=210|nimg=public/bg_hhzy_01_3.png|text=����100��ְ����|link=@gmhelper_button,107>'..
        
        '<Button|x=350|y=30|nimg=public/bg_hhzy_01_3.png|text=3��ħ����|link=@gmhelper_button,15>'..                      
        '<Button|x=350|y=60|nimg=public/bg_hhzy_01_3.png|text=���VIP����|link=@gmhelper_button,30>'..
        '<Button|x=350|y=90|nimg=public/bg_hhzy_01_3.png|text=�ָ����񸱱�|link=@gmhelper_button,17>'..
        '<Button|x=350|y=120|nimg=public/bg_hhzy_01_3.png|text=ˢ��ս������|link=@gmhelper_button,18>'..
        '<Button|x=350|y=150|nimg=public/bg_hhzy_01_3.png|text=���ÿ�Ѫ|link=@gmhelper_button,31>'..
        '<Button|x=350|y=180|nimg=public/bg_hhzy_01_3.png|text=δ�������|link=@gmhelper_button,32>'..
        '<Button|x=350|y=210|nimg=public/bg_hhzy_01_3.png|text=������|link=@gmhelper_button,9>'..
        '<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text=�򿪳�ֵ����|link=@gmhelper_button,33>'..
        '<Button|x=350|y=270|nimg=public/bg_hhzy_01_3.png|text=��ս������|link=@gmhelper_button,34>'..

        '<Button|x=500|y=30|nimg=public/bg_hhzy_01_3.png|text=�����׳��һ��|link=@gmhelper_button,150>'..
        '<Button|x=500|y=60|nimg=public/bg_hhzy_01_3.png|text=�����׳�ڶ���|link=@gmhelper_button,151>'..
        '<Button|x=500|y=90|nimg=public/bg_hhzy_01_3.png|text=�����׳������|link=@gmhelper_button,152>'..
        '<Button|x=500|y=120|nimg=public/bg_hhzy_01_3.png|text=�����׳������|link=@gmhelper_button,153>'..
        '<Button|x=500|y=150|nimg=public/bg_hhzy_01_3.png|text=����׳�|link=@gmhelper_button,154>'..
        '<Button|x=500|y=180|nimg=public/bg_hhzy_01_3.png|text=ģ���ֵ1Ԫ|link=@gmhelper_button,155>'..
        '<Button|x=500|y=210|nimg=public/bg_hhzy_01_3.png|text=ģ���ֵ10Ԫ|link=@gmhelper_button,156>'..
        '<Button|x=500|y=240|nimg=public/bg_hhzy_01_3.png|text=ģ���ֵ100Ԫ|link=@gmhelper_button,157>'
    ]]--

    --[[                      
        '<Button|x=200|y=180|nimg=public/bg_hhzy_01_3.png|text=��������10��|link=@gmhelper_button,7>'..
        '<Button|x=40|y=210|nimg=public/bg_hhzy_01_3.png|text=��չ�ְ|link=@gmhelper_button,8>'..    
        '<Button|x=40|y=240|nimg=public/bg_hhzy_01_3.png|text=����װ����ϴ��|link=@gmhelper_button,10>'..
        
        '<Button|x=200|y=60|nimg=public/bg_hhzy_01_3.png|text=���װ��С��Ʒ|link=@gmhelper_button,11>'..
        '<Button|x=200|y=90|nimg=public/bg_hhzy_01_3.png|text=�����Զ�������|link=@gmhelper_button,12>'..                      
        '<Button|x=200|y=150|nimg=public/bg_hhzy_01_3.png|text=����500��ѫ|link=@gmhelper_button,14>'..                      
        '<Button|x=350|y=60|nimg=public/bg_hhzy_01_3.png|text=���Ӱ˸񱳰�|link=@gmhelper_button,16>'..                      
        
        '<Button|x=350|y=150|nimg=public/bg_hhzy_01_3.png|text=�����յ�ͼ|link=@gmhelper_button,19>'..
        '<Button|x=350|y=180|nimg=public/bg_hhzy_01_3.png|text=VIP�������100|link=@gmhelper_button,20>'..
        '<Button|x=350|y=210|nimg=public/bg_hhzy_01_3.png|text=���Ӳ���������|link=@gmhelper_button,21>'..
        '<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text=ɾ������������|link=@gmhelper_button,22>'
    ]]--
    BF_NPCSayExt(actor, sPanelStr, 650, 350)
end

function GMHelper.DoGmOper(actor, sid)
    if (actor == nil) or (sid == nil) then
        return
    end
    if getgmlevel(actor) == 0 then
        return
    end

    if sid == '1' then
        changelevel(actor, '+', 10)
        Player.FullHPMP(actor)    
    elseif sid == '2' then
        changemoney(actor, CommonDefine.ITEMID_GOLD, '+', 1000000, 'DoGmOper', true)
        changemoney(actor, CommonDefine.ITEMID_YB, '+', 100000, 'DoGmOper', true)
        changemoney(actor, CommonDefine.ITEMID_BINDYB, '+', 5000, 'DoGmOper', true)
        changemoney(actor, CommonDefine.ITEMID_MOFANGZHEN_JIFEN, '+', 5000, 'DoGmOper', true)
    elseif sid == '3' then  
        giveitem(actor, '5�����ʯ', 12)
        giveitem(actor, '5���̻�ʯ', 12)
        giveitem(actor, '5������ʯ', 12)
        giveitem(actor, '5���ƻ�ʯ', 12)  
    elseif sid == '4' then
        gmexecute(actor, 'Superman')
    elseif sid == '5' then
        giveitem(actor, 'ǿ��ʯ', 2000)
        giveitem(actor, '����ʯ', 2000)
        giveitem(actor, '��ҳ', 2000)
        giveitem(actor, '�����ؼ�', 2000)
        giveitem(actor, 'ף����', 2000)
        giveitem(actor, '���˷�', 200)
        giveitem(actor, '���׷�', 200)        
    elseif sid == '6' then
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, 'ţ���񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
        giveitem(actor, '�����񡤷�1��', 1)
    elseif sid == '7' then
        local equipitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
        if equipitem ~= '0' then
            local starnum = getitemaddvalue(actor, equipitem, 2, 3, 0)
            setitemaddvalue(actor, equipitem, 2, 3, starnum + 10);
        end 
    elseif sid == '8' then        
        setplaydef(actor, CommonDefine.VAR_U_GUANZHI_LEVEL, 0)
        setplaydef(actor, CommonDefine.VAR_U_GUANZHI_CURREXP, 0)
        delattlist(actor, CommonDefine.ABILITY_GROUP_GUANZHI)
        GuanZhiManager.SetTitle(actor, '')
        recalcabilitys(actor)
    elseif sid == '9' then
        Player.GoMZHome(actor)
    elseif sid == '10' then
        for i = CommonDefine.EQUIPPOS_DRESS, CommonDefine.EQUIPPOS_BOOTS, 1 do       
            if EquipRandomABManager.IsValidEquipPosForRandomAB(i) then
                local equipitem = linkbodyitem(actor, i)
                if not BF_IsNullObj(equipitem) then
                    EquipRandomABManager.InitEquipRandomAB(actor, equipitem, 1)
                end
            end
        end
        recalcabilitys(actor)
    elseif sid == '11' then
        for i = CommonDefine.EQUIPPOS_DRESS, CommonDefine.EQUIPPOS_BOOTS, 1 do
            if EquipRandomABManager.IsValidEquipPosForRandomAB(i) then
                local equipitem = linkbodyitem(actor, i)
                if not BF_IsNullObj(equipitem) then
                    clearitemcustomabil(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_2)
                    refreshitem(actor, equipitem)
                end
            end
        end        
        recalcabilitys(actor)
    elseif sid == '12' then
        local equipitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
        if not BF_IsNullObj(equipitem) then
            local createABTab = {
                {id=3, value=3, savepos=3, color=250, captionid=1},{id=4, value=10, savepos=4, color=250, captionid=1},
                {id=5, value=3, savepos=5, color=251, captionid=2},{id=6, value=10, savepos=6, color=251, captionid=2},
                {id=7, value=3, savepos=7, color=252, captionid=3},{id=8, value=10, savepos=8, color=252, captionid=3}
            }
            BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_2, '[��Ʒ����]:', CSS.CUSTOM_AB_GROUP_COLOR)       
            refreshitem(actor, equipitem)
            recalcabilitys(actor)
        end
    elseif sid == '13' then
        local bJob = Player.GetJob(actor)
        if bJob == CommonDefine.JOB_Z then
            addskill(actor, 3, 0)
            addskill(actor, 7, 0)
            addskill(actor, 12, 0)            
            addskill(actor, 25, 0)
            addskill(actor, 26, 0)
            addskill(actor, 27, 0)
        elseif bJob == CommonDefine.JOB_F then
            addskill(actor, 1, 0)
            addskill(actor, 5, 0)
            addskill(actor, 9, 0)
            addskill(actor, 10, 0)
            addskill(actor, 11, 0)
            addskill(actor, 22, 0)
            addskill(actor, 23, 0)
            addskill(actor, 24, 0)
            addskill(actor, 31, 0)
        elseif bJob == CommonDefine.JOB_D then
            addskill(actor, 2, 0)
            addskill(actor, 6, 0)
            addskill(actor, 13, 0)
            addskill(actor, 14, 0)
            addskill(actor, 15, 0)
            addskill(actor, 17, 0)          
        end
    elseif sid == '14' then
        GuanZhiManager.AddExp(actor, 500)
    elseif sid == '15' then
        local times = getplaydef(actor, CommonDefine.VAR_J_DAY_MOFANG_LEFT_FREETIMES)
        setplaydef(actor, CommonDefine.VAR_J_DAY_MOFANG_LEFT_FREETIMES, times+3)
    elseif sid == '16' then
        local totalbagcount = getbaseinfo(actor, CommonDefine.INFO_BAGCOUNT)
        if totalbagcount < 126 then
            local tempcount = math.min(146, totalbagcount + 8)
            setbagcount(actor, tempcount)
        end
    elseif sid == '17' then
        setplaydef(actor, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES, 0)
    elseif sid == '18' then
        if RandomBossManager.CreateNewRandomBoss(actor) ~= -1 then
            Player.SendSelfMsg(actor, 'ս��������ˢ������ǰ���������߲鿴��', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        else
            Player.SendSelfMsg(actor, 'ս�������Ѵ����޻������ս���������ޣ�', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        end
    elseif sid == '19' then
        RandomBossManager.TestClearAllFightingMapInfo()
    elseif sid == '20' then
        for i = 1, FreeVIPManager.MAX_TASK_NUM, 1 do
            local counter = getplaydef(actor, FreeVIPManager.TASK_COUNTER_VARLIST[i]) + 100
            setplaydef(actor, FreeVIPManager.TASK_COUNTER_VARLIST[i], counter)
        end
    elseif sid == '21' then
        addattlist(actor, 'ceshigroup', '=', '3#23#10')
        recalcabilitys(actor)
    elseif sid == '22' then
        delattlist(actor, 'ceshigroup')
        recalcabilitys(actor)
    elseif sid == '30' then
        local currVIPLv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
        if currVIPLv < FreeVIPManager.MAX_LEVEL then
            currVIPLv = currVIPLv + 1
            FreeVIPManager.SetVIPLevel(actor, currVIPLv)            
            Player.SendSelfMsg(actor, 'VIP������'..currVIPLv, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        else
            setplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL, 0)
            Player.SendSelfMsg(actor, 'VIP�ص�'..0, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        end
    elseif sid == '31' then
        addhpper(actor, '=', 1)
    elseif sid == '32' then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE, 0)
    elseif sid == '33' then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_RECHARGE)
    elseif sid == '34' then
        setplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA, '')
    elseif sid == '101' then
        TaskManager.AddNewTask(actor, CommonDefine.TASK_LINE_ID_MAIN, 0)
    elseif sid == '102' then
        TaskManager.DeleteTask(actor, CommonDefine.TASK_LINE_ID_MAIN)
    elseif sid == '103' then
        TaskManager.AcceptTask(actor, CommonDefine.TASK_LINE_ID_MAIN)
    elseif sid == '104' then
        TaskManager.FinishTask(actor, CommonDefine.TASK_LINE_ID_MAIN)        
    elseif sid == '105' then
        TaskManager.EndTask(actor, CommonDefine.TASK_LINE_ID_MAIN) 
    elseif sid == '106' then
        local mapidstr = Player.GetMapIDStr(actor)
        local x, y = Player.GetMapXY(actor)
        genmon(mapidstr, x, y, '��', 5, 10)
        genmon(mapidstr, x, y, '¹1', 5, 10)
    elseif sid == '107' then
        GuanZhiManager.AddExp(actor, 100)
    elseif sid == '150' then
        local currday = BF_GetDay(os.time())
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)
        FirstRecharge.AutoGiveFirstRechargeRewardAtOnce(actor)
    elseif sid == '151' then
        local currday = BF_GetDay(os.time()) - 1
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)        
    elseif sid == '152' then
        local currday = BF_GetDay(os.time()) - 2
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)                
    elseif sid == '153' then
        local currday = BF_GetDay(os.time()) - 3
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)                
    elseif sid == '154' then
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, 0)        
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD1, 0)
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD2, 0)
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD3, 0)
    elseif sid == '155' then
        RechargeManager.DoRecharge(actor, 1, 1)
    elseif sid == '156' then
        RechargeManager.DoRecharge(actor, 10, 1)
    elseif sid == '157' then
        RechargeManager.DoRecharge(actor, 100, 1)
    elseif sid == '998' then
        addattlist(actor, CommonDefine.ABILITY_GROUP_TEMPTEST, "=", "3#3#800000|3#4#800000|3#5#8000|3#6#8000|3#7#8000|3#8#8000|")      
        recalcabilitys(actor)
        setplaydef(actor, CommonDefine.VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA, '')        
        setplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_NO_PANELTIP_FLAG, 0)
        setplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES, 0)
    elseif sid == '999' then
        Player.TestSuperInitPlayer(actor)
    elseif sid == '1001' then
        OpenSuperBoxManager.GMUpgradeBaoXiangLevel(actor)
    elseif sid == '1002' then
        OpenSuperBoxManager.GMResetBaoXiangLevel(actor)
    end   
end

--��ҵ�¼ʱ����
function GMHelper.OnPlayerEnterGame(actor)
    GMHelper.InitUI(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, GMHelper.OnPlayerEnterGame, CommonDefine.FUNC_ID_GMHELPER)


return GMHelper