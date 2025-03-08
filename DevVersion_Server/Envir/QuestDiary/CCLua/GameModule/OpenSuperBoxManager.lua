--��������ϵͳ
OpenSuperBoxManager = {}

local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 = 1    --��������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 = 2    --����һ���Դ򿪱�������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 = 3    --����һ���Դ򿪱�������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 = 4    --�������������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 = 5    --�ر������������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6 = 6    --�����ñ����Զ��Ľ��� ���򿪸ý���״̬�²��Զ�����    �л��Զ�������״̬  
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7 = 7    --�ر����ñ����Զ��Ľ���
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8 = 8    --���б�������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_9 = 9    --���ٱ�������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10 = 10  --һ������
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11 = 11  --ѡ������Ʒ������

local SELECT_CONDITION_QUALITY_LIST = {
    {showstr='��ɫƷ������', minquality=CommonDefine.ITEM_QUALITY_GREEN},
    {showstr='��ɫƷ������', minquality=CommonDefine.ITEM_QUALITY_BLUE},
    {showstr='��ɫƷ������', minquality=CommonDefine.ITEM_QUALITY_PURPLE},
}

--����ÿ�������Ի�õı�������
local function GetDayMaxAddBoxNum(actor)
    return CommonDefine.DAY_SUPER_BOX_MAX_ADD_NUM
end

--���ӵ�ǰ�ı����ۼ�����
function OpenSuperBoxManager.AddNewBoxNum(actor, addnum)
    if BF_IsNullObj(actor) or (addnum == nil) or (addnum <= 0) then
        return
    end
    local DAY_MAX_ADD_NUM = GetDayMaxAddBoxNum(actor)
    local nDayAddNum = getplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_ADDNUM)
    if nDayAddNum >= DAY_MAX_ADD_NUM then
        return
    end

    local nFinalAddNum = addnum
    if nDayAddNum + nFinalAddNum > DAY_MAX_ADD_NUM then
        nFinalAddNum = DAY_MAX_ADD_NUM - nDayAddNum
    end
    nDayAddNum = nDayAddNum + nFinalAddNum
    setplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_ADDNUM, nDayAddNum)

    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    nCurrBoxNum = nCurrBoxNum + nFinalAddNum
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM, nCurrBoxNum)

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

function OpenSuperBoxManager.GMAddNewBoxNum(actor, addnum)
    if BF_IsNullObj(actor) or (addnum == nil) or (addnum <= 0) then
        return
    end

    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    nCurrBoxNum = nCurrBoxNum + addnum
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM, nCurrBoxNum)

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--���³����������
function OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1)

    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    local nOnceOpenNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local strPanel = '<Img|id=2000|children={2001,2002,2003,2004,2005,2006,2007,2008}|x=-130|y=-300|bg=1|move=0|img=private/cc_superbox/panel_base.png>'..
        '<Button|id=2001|x=60.0|y=-40.0|pimg=private/cc_superbox/button_box.png|nimg=private/cc_superbox/button_box.png|mimg=private/cc_superbox/button_box.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1..'>'..
        '<Text|id=2002|x=85.0|y=69.0|color=255|size=20|text=ͬ:'..nOnceOpenNum..'>'..
        '<Text|id=2003|x=150.0|y=-20.0|color=255|size=20|text=����:'..nCurrBoxNum..'>'..
        '<Button|id=2004|x=144.0|y=70.0|size=18|color=255|nimg=private/cc_superbox/button_add.png|pimg=private/cc_superbox/button_add_1.png|mimg=private/cc_superbox/button_add_1.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2..'>'..
        '<Button|id=2005|x=30.0|y=70.0|size=18|mimg=private/cc_superbox/button_dec_1.png|color=255|nimg=private/cc_superbox/button_dec.png|pimg=private/cc_superbox/button_dec_1.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3..'>'..
        '<Button|id=2006|x=200.0|y=70.0|size=20|mimg=private/cc_superbox/button_level.png|color=255|nimg=private/cc_superbox/button_level.png|pimg=private/cc_superbox/button_level.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4..'|text=�ȼ�:'..nBoxCurrLv..'>'..
        '<Button|id=2007|x=-60.0|y=70.0|size=20|mimg=private/cc_superbox/button_auto.png|color=255|nimg=private/cc_superbox/button_auto.png|pimg=private/cc_superbox/button_auto.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6..'|text=�����Զ�>'

    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        if tabUniqueIDs ~= false then
            local strIDs = ''
            local startid = 2010   
            local startid1 = 2030
            local nLine = 0
            local nColumn = 0
            for seq, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                local itemobj = getitembymakeindex(actor, nItemUniqueID)
                if not BF_IsNullObj(itemobj) then
                    local itemshowname = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_CHGEDNAME)
                    local itemid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
                    local itemcolor = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAMECOLOR)
                    local itemshowid = startid + seq
                    local textid = startid1 + seq
                    if strIDs ~= '' then
                        strIDs = strIDs..','
                    end
                    strIDs = strIDs..itemshowid..','..textid
                    if seq % 5 == 1 then
                        nLine = nLine + 1
                        nColumn = 0
                    else
                        nColumn = nColumn + 1
                    end                    
                    local currx = 30 + 80 * nColumn
                    local curry = 30 + 100 * (nLine - 1)
                    strPanel = strPanel..'<Text|id='..textid..'|x='..currx..'|y='..curry..'|width=70|color='..itemcolor..'|size=12|text='..itemshowname..'>'..
                        '<MKItemShow|id='..itemshowid..'|x='..(currx+4)..'|y='..(curry+20)..'|width=70|height=70|makeindex='..value..'|showtips=1|bgtype=1|link=@testjump>'
                end
            end
            local buttonid = 2099
            strIDs = strIDs..','..buttonid
            local tempy = 30 + 100 * nLine + 30
            strPanel = strPanel..'<Img|id=2008|children={'..strIDs..'}|x=-100|y=-200|height='..(tempy+50)..'|bg=1|move=0|scale9r=10|scale9l=10|scale9b=10|scale9t=10|img=private/cc_superbox/panel_itemlist.png>'..
                '<Button|id='..buttonid..'|x=170|y='..tempy..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=20|color=255|text=һ������|link=@opensuperboxmanager_button#sid='..
                OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10..'>'              
        end
    end

    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1, strPanel)   
end

--����һ�α��俪��
local function DoOpenBoxOnce(actor)
    if BF_IsNullObj(actor) then
        return false
    end
    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    if nCurrBoxNum <= 0 then
        Player.SendSelfMsg(actor, '��ǰû�п��Կ����ı��䣡', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end    

    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    if levelConfig == nil then
        return false
    end
    local nOnceOpenNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM)
    if (nOnceOpenNum < 1) then
        nOnceOpenNum = 1
    elseif (nOnceOpenNum > levelConfig.maxopennum) then
        nOnceOpenNum = levelConfig.maxopennum
    end

    nOnceOpenNum = math.min(nOnceOpenNum, nCurrBoxNum)
    if nOnceOpenNum <= 0 then
        return false
    end
    if nOnceOpenNum > getbagblank(actor) then
        Player.SendSelfMsg(actor, '�ռ䲻�㣬������������', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end

    local nPlayerLv = Player.GetLevel(actor)
    local boxPoolConfig = cfgSuperBoxRewardPool[nPlayerLv]
    if boxPoolConfig == nil then        
        Player.SendSelfMsg(actor, '��ǰû�п��Կ����ı��䣡 '..nPlayerLv, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        release_print('DoOpenBoxOnce error 1111 level:'..nPlayerLv)
        return false
    end

    --�����Ҫ���������ɵĵ���id
    local newItemIDTab = {}
    for i = 1, nOnceOpenNum, 1 do
        local config = BF_GetRandomTab(levelConfig.rewardpool_tab, -1)
        if config then
            local poolid = config.poolid
            local rewardPoolConfig = cfgSuperBoxRewardPool[nPlayerLv]
            if rewardPoolConfig then                     
                for _, value in ipairs(rewardPoolConfig.poollist_tab) do
                    if value.poolid == poolid then
                        local rand = math.random(1, #value.idlist)
                        newItemIDTab[#newItemIDTab+1] = value.idlist[rand]                 
                        break
                    end
                end        
            end
        end
    end

    if table.isempty(newItemIDTab) then
        --������������пյ�
        release_print('DoOpenBoxOnce error 2222 level:'..nPlayerLv)
        return
    end

    nCurrBoxNum = nCurrBoxNum - nOnceOpenNum
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM, nCurrBoxNum)

    local strItemUniqueIDs = ''
    for _, itemid in ipairs(newItemIDTab) do
        local sItemName = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAME)
        local newitemobj = giveitem(actor, sItemName, 1, 0, '��������')        
        if not BF_IsNullObj(newitemobj) then
            --����װ���ĳ�ʼϴ������
            EquipRandomABManager.InitEquipRandomAB(actor, newitemobj)
            --װ�����츳����
            EquipInitGift.InitEquipGiftAB(actor, newitemobj)
            refreshitem(actor, newitemobj)
            local nNewMakeIndex = getiteminfo(actor, newitemobj, CommonDefine.ITEMINFO_UNIQUEID)
            if strItemUniqueIDs ~= '' then
                strItemUniqueIDs = strItemUniqueIDs..','
            end
            strItemUniqueIDs = strItemUniqueIDs..nNewMakeIndex       
        end    
    end

    setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strItemUniqueIDs)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    return true
end

--���ӱ���ͬʱ����������
local function AddOnceOpenBoxNum(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    if levelConfig == nil then
        return
    end
    local nOnceOpenNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM)
    if nOnceOpenNum >= levelConfig.maxopennum then
        Player.SendSelfMsg(actor, '��ǰͬʱ���������Ѵﵽ���ޣ�������Ҫ��������ȼ���', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    nOnceOpenNum = nOnceOpenNum + 1
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, nOnceOpenNum)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--���ٱ���ͬʱ����������
local function DecOnceOpenBoxNum(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local nOnceOpenNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM)
    if nOnceOpenNum <= 1 then
        return
    end
    nOnceOpenNum = nOnceOpenNum - 1
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, nOnceOpenNum)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--GM��������
function OpenSuperBoxManager.GMUpgradeBaoXiangLevel(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv+1]
    if nextLevelConfig == nil then
        Player.SendSelfMsg(actor, '��ǰ����ȼ��Ѵﵽ���ޣ�', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv + 1)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor) 
end

--GM���ñ���ȼ�
function OpenSuperBoxManager.GMResetBaoXiangLevel(actor)
    if BF_IsNullObj(actor) then
        return
    end
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, 0)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)    
end

--����������Ľ���
local function OpenUpgradeBoxLevelPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)

    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local sNeedItemStr = ''
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    if levelConfig then
        sNeedItemStr = BF_GetSimpleItemTableDescStr(levelConfig.upgradeneeditems_tab)
    end
    local strPanel = '<Img|id=2100|children={2102,2101,2103,2104,2105,2106}|x=40|y=-560|img=private/cc_superbox/panel_level.jpg|move=0|reset=1|bg=1|esc=1|show=0>'..
        '<Layout|id=2102|x=256.0|y=2.0|width=80|height=80|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5..'>'..
        '<Button|id=2101|x=257.0|y=0.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5..'>'..
        '<Text|id=2103|x=85.0|y=18.0|color=255|size=20|text=��������>'..
        '<Text|id=2104|x=81.0|y=75.0|color=255|size=18|text=��ǰ�ȼ���'..nBoxCurrLv..'>'..
        '<Text|id=2105|x=28.0|y=156.0|color=255|size=18|text=�������ģ�'..sNeedItemStr..'>'..
        '<Button|id=2106|x=71.0|y=253.0|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=18|color=255|text=����|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8..'>'

    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5, strPanel)   
end

--������������
local function UpgradeBoxLevel(actor)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv + 1]

    if (levelConfig==nil) or (nextLevelConfig==nil) then
        Player.SendSelfMsg(actor, '��ǰ����ȼ��Ѵﵽ���ޣ�', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end 

    --�����ж�
    if not Player.CheckItemsEnough(actor, levelConfig.upgradeneeditems_tab, '������������') then
        return
    end
    --�۳�����
    Player.TakeItems(actor, levelConfig.upgradeneeditems_tab, '������������')     
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv+1)

    OpenUpgradeBoxLevelPanel(actor)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--�ر���������Ľ���
local function CloseUpgradeBoxLevelPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
end

--�������Զ�������Ľ���
local function OpenAutoOpenBoxPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)

    local strItemList = ''
    for _, value in ipairs(SELECT_CONDITION_QUALITY_LIST) do
        if strItemList ~= '' then
            strItemList = strItemList..'#'
        end
        strItemList = strItemList..value.showstr
    end

    local currSelectStr = 'ѡ������Ʒ��'
    local chooseseq = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_1)
    if (chooseseq >= 1) and (chooseseq <= #SELECT_CONDITION_QUALITY_LIST) then
        currSelectStr = SELECT_CONDITION_QUALITY_LIST[chooseseq].showstr
    end

    local strPanel = '<Img|id=2200|children={2201,2202,2203,2204,2205,2206}|x=-200|y=-560|img=private/cc_superbox/panel_level.jpg|move=0|reset=1|bg=1|esc=1|show=0>'..
        '<Layout|id=2201|x=256.0|y=2.0|width=80|height=80|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7..'>'..
        '<Button|id=2202|x=257.0|y=0.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7..'>'..
        '<Text|id=2203|x=85.0|y=18.0|color=255|size=20|text=��������>'..
        '<Text|id=2204|x=30.0|y=75.0|color=255|size=18|text=������������������װ����>'..
        '<MenuItem|id=2205|menuid=S$chooseitem|x=30|y=150|itemname='..strItemList..'|select='..currSelectStr..
        '|a=2|direction=0|fontcolor=250|selectcolor=254|fontsize=20|itemhei=30|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11..'>'

    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5, strPanel)
end

--�ر��Զ�������Ľ���
local function CloseAutoOpenBoxPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
end

--ѡ��Ҫ������װ������1
local function SelectConditionByQuality(actor, sparam)
    if BF_IsNullObj(actor) or (sparam == nil) then
        return
    end

    for seq, value in ipairs(SELECT_CONDITION_QUALITY_LIST) do
        if value.showstr == sparam then
            setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_1, seq)            
            break
        end
    end    
end

--һ������
local function QuickRecycleOpenItemList(actor)
    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        if tabUniqueIDs ~= false then
            for _, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                local itemobj = getitembymakeindex(actor, nItemUniqueID)
                if not BF_IsNullObj(itemobj) then
                    ------------------------------------
                    ---------------------------------------
                    ---------------------------------------
                    ---------------------------------------
                    ---------------------------------------
                    ---��ɻ���
                end
            end          
        end
        setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, '')
    end

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--����button�ص�
function OpenSuperBoxManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

    local funcid = tonumber(sid)

    if funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 then
        DoOpenBoxOnce(actor) 
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 then
        AddOnceOpenBoxNum(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 then
        DecOnceOpenBoxNum(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 then
        OpenUpgradeBoxLevelPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 then
        CloseUpgradeBoxLevelPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6 then
        OpenAutoOpenBoxPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7 then
        CloseAutoOpenBoxPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8 then
        UpgradeBoxLevel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_9 then

    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10 then
        QuickRecycleOpenItemList(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11 then
        SelectConditionByQuality(actor, sparam)
        OpenAutoOpenBoxPanel(actor)
    end
end


--��ҵ�¼ʱ����
function OpenSuperBoxManager.OnPlayerEnterGame(actor)
    --��ʼ��������ȼ�
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    if nBoxCurrLv == 0 then
        nBoxCurrLv = 1
        setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv)
        setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, 1)
    end

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, OpenSuperBoxManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_SUPERBOX)

return OpenSuperBoxManager