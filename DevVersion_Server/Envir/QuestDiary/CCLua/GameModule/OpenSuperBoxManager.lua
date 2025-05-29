--超级宝箱系统
OpenSuperBoxManager = {}

local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 = 1    --开启宝箱
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 = 2    --增加一次性打开宝箱数量
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 = 3    --减少一次性打开宝箱数量
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 = 4    --打开升级宝箱界面
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 = 5    --关闭升级宝箱界面
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6 = 6    --打开设置宝箱自动的界面 【打开该界面状态下不自动开】    切换自动开宝箱状态  
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7 = 7    --关闭设置宝箱自动的界面
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8 = 8    --进行宝箱升级
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_9 = 9    --加速宝箱升级
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10 = 10  --一键回收
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11 = 11  --关闭宝箱列表界面
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_12 = 12  --一键穿戴
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_13 = 13  --查看比较装备


local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_21 = 21  --勾选 保留的品质条件
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_22 = 22  --选择保留的品质条件
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_23 = 23  --勾选 保留的等级条件
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_24 = 24  --选择保留的等级条件
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_25 = 25  --勾选 终止条件1
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_26 = 26  --勾选 终止条件2
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_27 = 27  --勾选 终止条件3
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_28 = 28  --勾选 自动回收


local SELECT_CONDITION_QUALITY_LIST = {
    {showstr='绿色品质以上', minquality=CommonDefine.ITEM_QUALITY_GREEN},
    {showstr='蓝色品质以上', minquality=CommonDefine.ITEM_QUALITY_BLUE},
    {showstr='紫色品质以上', minquality=CommonDefine.ITEM_QUALITY_PURPLE},
}

local SELECT_CONDITION_LEVEL_LIST = {
    {showstr='50级以上', minlevel=50},
    {showstr='70级以上', minlevel=70},
    {showstr='90级以上', minlevel=90},
    {showstr='100级以上', minlevel=100},
    {showstr='110级以上', minlevel=110},
    {showstr='120级以上', minleve=120},
}

local RECYCLE_CHECKBOX_INFO = {
    {seq=1, checkvar=CommonDefine.CHECK_BOX_VAR[10], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK1},
    {seq=2, checkvar=CommonDefine.CHECK_BOX_VAR[11], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK2},
    {seq=3, checkvar=CommonDefine.CHECK_BOX_VAR[12], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK3},
    {seq=4, checkvar=CommonDefine.CHECK_BOX_VAR[13], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK4},
    {seq=5, checkvar=CommonDefine.CHECK_BOX_VAR[14], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK5},
    {seq=6, checkvar=CommonDefine.CHECK_BOX_VAR[15], bitflag=CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK6},
}


--返回每天最大可以获得的宝箱数量
local function GetDayMaxAddBoxNum(actor)
    return CommonDefine.DAY_SUPER_BOX_MAX_ADD_NUM
end

--返回每天最大可以开箱的数量
local function GetDayMaxOpenBoxNum(actor)
    return CommonDefine.DAY_SUPER_BOX_MAX_OPEN_NUM
end

--隐藏宝箱界面
function OpenSuperBoxManager.HideUI(actor)
    if BF_IsNullObj(actor) then
        return
    end
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1)
end

--增加当前的宝箱累计数量
function OpenSuperBoxManager.AddNewBoxNum(actor, addnum)
    if BF_IsNullObj(actor) or (addnum == nil) or (addnum <= 0) then
        return false
    end
    local DAY_MAX_ADD_NUM = GetDayMaxAddBoxNum(actor)
    local nDayAddNum = getplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_ADDNUM)
    if nDayAddNum >= DAY_MAX_ADD_NUM then
        return false
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
    return true
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

--更新超级宝箱界面
function OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1)

    local sText1 = '开启'
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 1 then
        sText1 = '停止'
    end

    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    local nOnceOpenNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    local boxpic = 'private/cc_superbox_1/btn_baoxiang.png'
    if strItemUniqueIDs ~= '' then
        boxpic = 'private/cc_superbox_1/btn_baoxiang_1.png'
    end

    local strPanel = '<Layout|id=2000|children={2001,2004,2005,2006,2007,2008,2010}|x=-130|y=-300|bg=1|move=0|show=0|loadDelay=1>'.. 
        '<Button|id=2001|children={2009}|x=68.0|y=0.0|width=72|height=63|clickInterval=500|nimg='..boxpic..'|mimg='..boxpic..'|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1..'>'..
        '<Img|id=2009|children={2003}|x=-12.0|y=40.0|width=100|height=24|esc=0|img=private/cc_superbox_1/bg_baoxiangshuliang.png>'..
        '<Text|id=2003|x=32.0|y=2.0|color=255|size=20|text='..nCurrBoxNum..'>'..
        '<Button|id=2004|x=142.0|y=68.0|clickInterval=500|size=18|color=255|nimg=private/cc_superbox_1/btn_7.png|mimg=private/cc_superbox_1/btn_7.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2..'>'..
        '<Button|id=2005|x=33.0|y=68.0|clickInterval=500|size=18|mimg=private/cc_superbox_1/btn_8.png|color=255|nimg=private/cc_superbox_1/btn_8.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3..'>'..
        '<Button|id=2006|x=175.0|y=52.0|clickInterval=500|size=20|mimg=private/cc_superbox_1/bg_dengji_baoxiang.png|color=255|nimg=private/cc_superbox_1/bg_dengji_baoxiang.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4..'|text=LV.'..nBoxCurrLv..'>'..        
        '<Button|id=2007|x=-45.0|y=52.0|clickInterval=500|size=20|mimg=private/cc_superbox_1/bg_dengji_baoxiang.png|color=255|nimg=private/cc_superbox_1/bg_dengji_baoxiang.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6..'|text='..sText1..'>'..
        '<Img|id=2008|children={2002}|x=58.0|y=70.0|width=86|esc=0|img=private/cc_superbox_1/bg_baoxiangbeishu.png>'..
        '<Text|id=2002|x=30.0|y=5.0|color=255|size=20|text='..nOnceOpenNum..'>'
    
    if strItemUniqueIDs ~= '' then
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')      
        if tabUniqueIDs ~= false then
            local strIDs = ''
            local startid = 2020   
            local startid1 = 2040
            local startid2 = 2060
            local startid3 = 2080
            local nLine = 0
            local nColumn = 0
            local bHaveBetterFlag = false
            for seq, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                local itemobj = getitembymakeindex(actor, nItemUniqueID)
                if not BF_IsNullObj(itemobj) then
                    local itemshowname = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_CHGEDNAME)                 
                    local itemid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
                    local itemcolor = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAMECOLOR)                    
                    local initgifttype = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_INITGIFT_TYPE, itemobj)
                    local itemshowid = startid + seq
                    local textid = startid1 + seq
                    local picid = startid2 + seq
                    local picid2 = startid3 + seq
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
                    local flag = Item.CompareBagItemToEquipment(actor, itemobj)
                    strPanel = strPanel..'<Text|id='..textid..'|x='..currx..'|y='..curry..'|width=70|color='..itemcolor..'|size=12|text='..itemshowname..'>'
                    strPanel = strPanel..'<DBItemShow|id='..itemshowid..'|children={'..picid..','..picid2..'}|x='..(currx+4)..'|y='..(curry+20)..'|width=70|height=70|makeindex='..value..
                        '|showtips=0|bgtype=1|link=@opensuperboxmanager_button#sid='..OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_13..'#sparam='..value..'>'                        
                    --[[
                    strPanel = strPanel..'<MKItemShow|id='..itemshowid..'|children={'..picid..'}|x='..(currx+4)..'|y='..(curry+20)..'|width=70|height=70|makeindex='..
                        value..'|showtips=0|bgtype=1|link=@cc_showitemex#makeindex='..value..'>'                        
                    ]]--
                    if flag == 1 then
                        strPanel = strPanel..'<Img|id='..picid..'|x=50|y=10|move=0|img=private/cc_superbox_1/cmp_up.png>'
                        bHaveBetterFlag = true
                    elseif flag == -1 then
                        strPanel = strPanel..'<Img|id='..picid..'|x=50|y=10|move=0|img=private/cc_superbox_1/cmp_down.png>'
                    end
                    if initgifttype~=nil and initgifttype > 0 then     
                        local giftpic = EquipInitGift.GetInitGiftPic(initgifttype)                   
                        strPanel = strPanel..'<Img|id='..picid2..'|x=0|y=45|height=25|width=25|move=0|img='..giftpic..'>'
                    end
                end
            end

            local buttonid1 = 2099
            local buttonid2 = 2098
            local buttonid3 = 2097
            strIDs = strIDs..','..buttonid1..','..buttonid2..','..buttonid3
            local tempy = 30 + 100 * nLine + 30            
            strPanel = strPanel..'<Img|id=2010|children={'..strIDs..'}|x=-120|y=-200|width=450|height='..(tempy+50)..'|bg=1|move=0|scale9r=10|scale9l=10|scale9b=10|scale9t=10|img=private/cc_superbox_1/panel_itemlist.png>'..
                '<Button|id='..buttonid1..'|x=180|y='..tempy..'|clickInterval=500|mimg=private/cc_common/button_1.png|nimg=private/cc_superbox_1/button_yjhs.png|size=18|color=255|text=一键回收|link=@opensuperboxmanager_button#sid='..
                OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10..'>'..
                '<Button|id='..buttonid2..'|x=310|y='..tempy..'|clickInterval=500|mimg=private/cc_common/button_1.png|nimg=private/cc_superbox_1/button_tc.png|size=18|color=255|text=退    出|link=@opensuperboxmanager_button#sid='..
                OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11..'>'
            if bHaveBetterFlag == true then
                strPanel = strPanel..'<Button|id='..buttonid3..'|x=50|y='..tempy..'|clickInterval=500|mimg=private/cc_common/button_1.png|nimg=private/cc_superbox_1/button_yjcd.png|size=18|color=255|text=一键穿戴|link=@opensuperboxmanager_button#sid='..
                OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_12..'>'
            end
        end
    else
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 1 then
            if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE) == 1 then
                setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE, 0)
                delaygoto(actor, 2000, 'superbox_delay_checkrecycle', 0)
            end
        end        
    end

    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1)
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1, strPanel)   
end

local function CloseOpenBoxItemListPanel(actor)
    setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, '')
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--进行一次宝箱开启
function OpenSuperBoxManager.DoOpenBoxOnce(actor, autoflag, openitemlist)
    if BF_IsNullObj(actor) then
        return false
    end
    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    if nCurrBoxNum <= 0 then
        Player.SendSelfMsg(actor, '当前没有可以开启的宝箱！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end    

    local DAY_MAX_OPEN_NUM = GetDayMaxOpenBoxNum(actor)
    local nDayOpenNum = getplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_OPENNUM)
    if nDayOpenNum >= DAY_MAX_OPEN_NUM then
        Player.SendSelfMsg(actor, '已达到今日开箱上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
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

    if nDayOpenNum + nOnceOpenNum > DAY_MAX_OPEN_NUM then
        nOnceOpenNum = DAY_MAX_OPEN_NUM - nDayOpenNum
    end
    nDayOpenNum = nDayOpenNum + nOnceOpenNum           

    if nOnceOpenNum > getbagblank(actor) then
        Player.SendSelfMsg(actor, '空间不足，清先整理背包！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end

    local nPlayerLv = Player.GetLevel(actor)
    local boxPoolConfig = cfgSuperBoxRewardPool[nPlayerLv]
    if boxPoolConfig == nil then        
        Player.SendSelfMsg(actor, '当前没有可以开启的宝箱！ '..nPlayerLv, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        release_print('DoOpenBoxOnce error 1111 level:'..nPlayerLv)
        return false
    end

    setplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_OPENNUM, nDayOpenNum)

    --随机出要开箱子生成的道具id
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
        --正常情况不会有空的
        release_print('DoOpenBoxOnce error 2222 level:'..nPlayerLv)
        return false
    end

    nCurrBoxNum = nCurrBoxNum - nOnceOpenNum
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM, nCurrBoxNum)

    local strItemUniqueIDs = ''
    local showFirstItemMakeIdx = 0
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NO_BAG_AUTORECYCLE, 1)
    for _, itemid in ipairs(newItemIDTab) do
        --屏蔽当前装备的对比提示和自动使用
        nothintitem(actor, 2, itemid)                
        local sItemName = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAME)                
        local newitemobj = giveitem(actor, sItemName, 1, 0, '超级宝箱')        
        if not BF_IsNullObj(newitemobj) then
            local infotab = {itemobj=newitemobj, randabflag=0, giftabflag=0}
            --生成装备的初始洗炼属性
            if EquipRandomABManager.InitEquipRandomAB(actor, newitemobj) == true then
                infotab.randabflag = 1
            end
            --装备的天赋属性
            if EquipInitGift.InitEquipGiftAB(actor, newitemobj) == true then
                infotab.giftabflag = 1
            end
            refreshitem(actor, newitemobj)
            local nNewMakeIndex = getiteminfo(actor, newitemobj, CommonDefine.ITEMINFO_UNIQUEID)            
            if strItemUniqueIDs ~= '' then
                strItemUniqueIDs = strItemUniqueIDs..','
            end
            strItemUniqueIDs = strItemUniqueIDs..nNewMakeIndex 
            if (autoflag == true) and (openitemlist ~= nil) then                
                openitemlist[#openitemlist+1] = infotab
            end
            if showFirstItemMakeIdx == 0 then
                showFirstItemMakeIdx = nNewMakeIndex
            end
        end
    end
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NO_BAG_AUTORECYCLE, 0)

    setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strItemUniqueIDs)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)

    --触发开箱任务
    TaskManager.OnAddOpenBoxNum(actor, nOnceOpenNum) 
    --触发免费VIP
	FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_OPEN_SUPERBOX_TIMES, '+', nOnceOpenNum)
    return true
end

--客户端保留指定道具
function OpenSuperBoxManager.ClientKeepEquipItem(actor, makeindex)
    if BF_IsNullObj(actor) or (makeindex==nil) or (makeindex==0) then
        return
    end
    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local strNewItemUniqueIDs = ''
        local bChanged = false
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        if tabUniqueIDs ~= false then
            for _, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                if makeindex == nItemUniqueID then
                    bChanged = true
                else
                    if strNewItemUniqueIDs ~= '' then
                        strNewItemUniqueIDs = strNewItemUniqueIDs..','
                    end
                    strNewItemUniqueIDs = strNewItemUniqueIDs..nItemUniqueID
                end
            end
        end
        if bChanged == true then
            setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strNewItemUniqueIDs)
        end
    end
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--增加宝箱同时开启的数量
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
        Player.SendSelfMsg(actor, '当前同时开启数量已达到上限，增加需要提升宝箱等级！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    nOnceOpenNum = nOnceOpenNum + 1
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, nOnceOpenNum)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--减少宝箱同时开启的数量
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

--GM升级宝箱
function OpenSuperBoxManager.GMUpgradeBaoXiangLevel(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv+1]
    if nextLevelConfig == nil then
        Player.SendSelfMsg(actor, '当前宝箱等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv + 1)
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, nextLevelConfig.maxopennum)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor) 
end

--GM重置宝箱等级
function OpenSuperBoxManager.GMResetBaoXiangLevel(actor)
    if BF_IsNullObj(actor) then
        return
    end
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, 1)
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, 1)
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME, 0)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)    
end

--打开升级宝箱的界面
local function OpenUpgradeBoxLevelPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)

    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local sNeedItemStr = ''
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv+1]
    if levelConfig then
        sNeedItemStr = BF_GetSimpleItemTableDescStr(levelConfig.upgradeneeditems_tab)
    end

    local strPanel = '<Img|id=2100|children={2112,2113,2114,2115}|x=-300|y=-660|img=private/cc_superbox_1/bg_frame_upgrade.png|move=0|reset=1|bg=1|esc=1|show=0>'..
        '<Button|id=2113|x=524.0|y=56.0|nimg=private/cc_superbox_1/btn_fanhui.png|color=255|size=18|mimg=private/cc_superbox_1/btn_fanhui.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5..'>'..
        '<Layout|id=2115|x=524.0|y=56.0|width=80|height=80|link=@opensuperboxmanager_button#sid='..OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5..'>'

    local strItems = ''
    local nStartID = 2120
    for seq, value in ipairs(CommonDefine.ITEM_QUALITY_COLORNAME) do
        local nLayoutID = nStartID + seq
        if strItems ~= '' then
            strItems = strItems..','
        end
        strItems = strItems..nLayoutID

        local nTextID1 = nStartID + 10 + seq
        local nTextID2 = nStartID + 20 + seq
        local nTextID3 = nStartID + 30 + seq
        local nImgID1 = nStartID + 40 + seq
        local strTextIDs = nImgID1..','..nTextID1..','..nTextID2..','..nTextID3
        strPanel = strPanel..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=320|height=40>'..
            --'<Img|id='..nImgID1..'|width=220|height=20|img='..QUALITY_PIC[seq]..'>'..
            --'<Text|id='..nTextID1..'|x=10|y=0|color='..CSS.QUALITY_COLOR[seq]..'|size=16|text='..value..'品质:>'..
            '<Text|id='..nTextID2..'|x=90|y=0|color=255|size=16|text=15%>'
        if nextLevelConfig ~= nil then
            strPanel = strPanel..'<Text|id='..nTextID3..'|x=260|y=0|color=255|size=16|text=25%>'
        end
    end

    if true then
        local nLayoutID = nStartID
        if strItems ~= '' then
            strItems = strItems..','
        end
        strItems = strItems..nLayoutID
        local nTextID1 = nStartID + 10
        local nTextID2 = nStartID + 20
        local nTextID3 = nStartID + 30
        local nImgID1 = nStartID + 40
        local strTextIDs = nImgID1..','..nTextID1..','..nTextID2..','..nTextID3
        strPanel = strPanel..'<Layout|id='..nLayoutID..'|children={'..strTextIDs..'}|width=320|height=40>'..
            --'<Img|id='..nImgID1..'|width=220|height=20|img=private/cc_superbox_1/img_kaixiangshagnxian.png>'..
            --'<Text|id='..nTextID1..'|x=10|y=0|color=255|size=16|text=开箱上限:>'..
            '<Text|id='..nTextID2..'|x=90|y=0|color=255|size=16|text='..levelConfig.maxopennum..'>'        
        if nextLevelConfig ~= nil then
            strPanel = strPanel..'<Text|id='..nTextID3..'|x=260|y=0|color=255|size=16|text='..nextLevelConfig.maxopennum..'>'
        end
    end

    strPanel = strPanel..'<ListView|id=2112|children={'..strItems..'}|x=188.0|y=126.0|width=320|height=360|margin=0|direction=1>'
    strPanel = strPanel..'<Layout|id=2114|children={2105,2106,2107,2108,2109}|x=180.0|y=480.0|width=220|height=90>'

    if nextLevelConfig ~= nil then
        local nStartUpgradeTime = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME)
        if nStartUpgradeTime <= 0 then
            local timestr = BF_ConvertSecondsToTimeStr(levelConfig.upgradeneedseconds)
            strPanel = strPanel..'<Text|id=2105|x=24.0|y=0.0|color=255|size=18|text=升级耗时：'..timestr..'>'..
                '<Text|id=2106|x=54.0|y=70.0|color=255|size=18|text='..sNeedItemStr..'>'..
                '<Button|id=2107|x=54.0|y=24.0|mimg=private/cc_common/button_1.png|nimg=private/cc_superbox_1/button_1.png|color=255|size=18|text=升  级|link=@opensuperboxmanager_button#sid='..
                OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8..'>'
        else
            local leftseconds = 0
            local currtime = os.time()
            if currtime - nStartUpgradeTime < levelConfig.upgradeneedseconds then
                leftseconds = levelConfig.upgradeneedseconds - (currtime - nStartUpgradeTime)
            end
            if leftseconds <= 0 then
                OpenSuperBoxManager.DoUpgradeBoxLevel(actor)
                return
            else
                local totaltimes = math.ceil(leftseconds / CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_ADDSECONDS)
                local totalneeditems = BF_GetItemTabMulti(CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS, totaltimes)
                local sNeedItemStr = BF_GetSimpleItemTableDescStr(totalneeditems)
                local tempcolor = CSS.NPC_LIGHTGREEN
                if not Player.CheckItemsEnough(actor, totalneeditems, '') then
                    tempcolor = CSS.NPC_RED
                end                
                strPanel = strPanel..'<Text|id=2108|x=24.0|y=0.0|color=255|size=18|text=升级耗时：>'..
                    '<COUNTDOWN|id=2105|x=120.0|y=0.0|color=255|size=18|showWay=1|time='..leftseconds..'|link=@opensuperboxmanager_button#sid='..
                    OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4..'>'..
                    '<Text|id=2106|x=24.0|y=70.0|color=255|size=18|text=加速消耗：>'..
                    '<Text|id=2109|x=120.0|y=70.0|color='..tempcolor..'|size=18|text='..sNeedItemStr..'>'..
                    '<Button|id=2107|x=54.0|y=24.0|mimg=private/cc_common/button_1.png|nimg=private/cc_superbox_1/button_1.png|color=255|size=18|text=加速|link=@opensuperboxmanager_button#sid='..
                    OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_9..'>'
            end
        end
    end

    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5, strPanel)   
end

--开始升级超级宝箱
local function StartUpgradeBoxLevel(actor)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv + 1]

    if (levelConfig==nil) or (nextLevelConfig==nil) then
        Player.SendSelfMsg(actor, '当前宝箱等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end 

    --条件判断
    if not Player.CheckItemsEnough(actor, levelConfig.upgradeneeditems_tab, '升级超级宝箱') then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, levelConfig.upgradeneeditems_tab, '升级超级宝箱')         

    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME, os.time())    
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    OpenUpgradeBoxLevelPanel(actor)
end

--加速超级宝箱升级
local function SpeedupUpgradeBoxLevel(actor)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv+1]
    if levelConfig==nil or nextLevelConfig==nil then
        Player.SendSelfMsg(actor, '当前宝箱等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        OpenUpgradeBoxLevelPanel(actor)
        return
    end

    local nStartUpgradeTime = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME)
    if nStartUpgradeTime <= 0 then
        Player.SendSelfMsg(actor, '当前宝箱不在升级中！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        OpenUpgradeBoxLevelPanel(actor)
        return
    end

    local leftseconds = 0
    local currtime = os.time()
    if currtime - nStartUpgradeTime < levelConfig.upgradeneedseconds then
        leftseconds = levelConfig.upgradeneedseconds - (currtime - nStartUpgradeTime)
    end
    if leftseconds <= 0 then
        OpenSuperBoxManager.DoUpgradeBoxLevel(actor)        
        return
    end

    local totaltimes = math.ceil(leftseconds / CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_ADDSECONDS)
    local totalneeditems = BF_GetItemTabMulti(CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS, totaltimes)
    if Player.CheckItemsEnough(actor, totalneeditems, '') then
        --如果加速的材料满足
        Player.TakeItems(actor, totalneeditems, '加速升级超级宝箱1')
        OpenSuperBoxManager.DoUpgradeBoxLevel(actor)
    else
        --如果加速的材料不足
        if not Player.CheckItemsEnough(actor, CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS, '') then
            Player.SendSelfMsg(actor, '材料不足加速'..CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_ADDSECONDS..'秒！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
        
        local bagitemcount = Player.GetItemNumInBag(actor, CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS[1].name)
        totaltimes = math.floor(bagitemcount / CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS[1].num)
        totalneeditems = BF_GetItemTabMulti(CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS, totaltimes)
        Player.TakeItems(actor, totalneeditems, '加速升级超级宝箱2')
        local addseconds = CommonDefine.OPEN_SUPERBOX_SPEEDUP_ONCE_ADDSECONDS * totaltimes        
        setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME, nStartUpgradeTime - addseconds)        
        Player.SendSelfMsg(actor, '升级加速'..addseconds..'秒！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        OpenUpgradeBoxLevelPanel(actor)
    end
end

--升级超级宝箱
function OpenSuperBoxManager.DoUpgradeBoxLevel(actor)
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    local levelConfig = cfgSuperBoxLevel[nBoxCurrLv]
    local nextLevelConfig = cfgSuperBoxLevel[nBoxCurrLv + 1]

    if (levelConfig==nil) or (nextLevelConfig==nil) then
        Player.SendSelfMsg(actor, '当前宝箱等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
  
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_START_UPGRADE_TIME, 0)
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv+1)  
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, nextLevelConfig.maxopennum)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    OpenUpgradeBoxLevelPanel(actor)
end

--关闭升级宝箱的界面
local function CloseUpgradeBoxLevelPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
end

--打开设置自动开宝箱的界面
local function OpenAutoOpenBoxPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)

    local strItemList1 = ''
    for _, value in ipairs(SELECT_CONDITION_QUALITY_LIST) do
        if strItemList1 ~= '' then
            strItemList1 = strItemList1..'#'
        end
        strItemList1 = strItemList1..value.showstr
    end

    local currSelectStr1 = SELECT_CONDITION_QUALITY_LIST[1].showstr
    local chooseseq = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_1)
    if (chooseseq >= 1) and (chooseseq <= #SELECT_CONDITION_QUALITY_LIST) then
        currSelectStr1 = SELECT_CONDITION_QUALITY_LIST[chooseseq].showstr
    end

    local strItemList2 = ''
    for _, value in ipairs(SELECT_CONDITION_LEVEL_LIST) do
        if strItemList2 ~= '' then
            strItemList2 = strItemList2..'#'
        end
        strItemList2 = strItemList2..value.showstr
    end

    local currSelectStr2 = SELECT_CONDITION_LEVEL_LIST[1].showstr
    chooseseq = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_2)
    if (chooseseq >= 1) and (chooseseq <= #SELECT_CONDITION_LEVEL_LIST) then
        currSelectStr2 = SELECT_CONDITION_LEVEL_LIST[chooseseq].showstr
    end    

    
    local flaglist = {}
    for i = 1, #RECYCLE_CHECKBOX_INFO, 1 do
        local info = {checkvar=RECYCLE_CHECKBOX_INFO[i].checkvar, flag=getflagstatus(actor, RECYCLE_CHECKBOX_INFO[i].bitflag)}
        flaglist[#flaglist+1] = info
    end    

    local strPanel = '<Img|id=2200|children={2203,2204,2205,2206}|x=-300|y=-660|img=private/cc_superbox_1/bg_frame_autosetting.png|esc=1|move=0|bg=1|reset=1|loadDelay=0|show=0>'..        
        '<Button|id=2204|x=523.0|y=57.0|color=255|mimg=private/cc_superbox_1/btn_fanhui.png|nimg=private/cc_superbox_1/btn_fanhui.png|size=18|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7..'>'..
        '<Button|id=2206|x=240.0|y=540.0|color=255|text=开启自动|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=18|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7..'>'..        
        '<Layout|id=2203|x=524.0|y=56.0|width=80|height=80|link=@opensuperboxmanager_button#sid='..OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7..'>'

    strPanel = strPanel..'<Layout|id=2205|children={2211,2212,2213,2214,2215,2216,2253,2252}|x=70.0|y=110.0|width=270|height=440>'..

        '<CheckBox|id=2211|x=18.0|y=46.0|count=1|default='..flaglist[1].flag..'|checkboxid='..flaglist[1].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_21..'>'..
        '<CheckBox|id=2212|x=18.0|y=110.0|count=1|default='..flaglist[2].flag..'|checkboxid='..flaglist[2].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_23..'>'..
        '<CheckBox|id=2213|x=18.0|y=220.0|count=1|default='..flaglist[3].flag..'|checkboxid='..flaglist[3].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_25..'>'..    
        '<CheckBox|id=2214|x=18.0|y=264.0|count=1|default='..flaglist[4].flag..'|checkboxid='..flaglist[4].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_26..'>'..
        '<CheckBox|id=2215|x=18.0|y=304.0|count=1|default='..flaglist[5].flag..'|checkboxid='..flaglist[5].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_27..'>'..
        '<CheckBox|id=2216|x=18.0|y=386.0|count=1|default='..flaglist[6].flag..'|checkboxid='..flaglist[6].checkvar..'|nimg=private/cc_superbox_1/checkbox_1.png|pimg=private/cc_superbox_1/checkbox_2.png|link=@opensuperboxmanager_button#sid='..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_28..'>'..

        '<MenuItem|id=2252|a=2|x=60.0|y=73.0|itemname='..strItemList1..'|select='..currSelectStr1..
        '|fontsize=18|img=private/cc_superbox_1/xlk_1.png|arrowimg=private/cc_superbox_1/btn_1.png|itemhei=20|menuid='..CommonDefine.VAR_S_SELECT_MENUITEM_1..
        '|selectcolor=254|fontcolor=250|direction=0|link=@opensuperboxmanager_button#sid='..OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_22..'>'..  

        '<MenuItem|id=2253|a=2|x=60.0|y=136.0|itemname='..strItemList2..'|select='..currSelectStr2..
        '|fontsize=18|img=private/cc_superbox_1/xlk_1.png|arrowimg=private/cc_superbox_1/btn_1.png|itemhei=20|menuid='..CommonDefine.VAR_S_SELECT_MENUITEM_2..
        '|selectcolor=254|fontcolor=250|direction=0|link=@opensuperboxmanager_button#sid='..OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_24..'>'

    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5, strPanel)
end

--关闭自动开宝箱的界面
local function CloseAutoOpenBoxPanel(actor)
    delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 0 then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX, 1)
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE, 0)
        OpenSuperBoxManager.AutoOpenSuperBox(actor)  
    end
end

--选择回收要保留的装备条件1 品质
local function SelectRecycleConditionByQuality(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local sparam = ''
    if BF_IsLocalTestServer() then
        sparam = getconst(actor, '$STR('..CommonDefine.VAR_S_SELECT_MENUITEM_1..')')
    else
        sparam = getconst(actor, '<$NPCPARAMS(4,'..CommonDefine.VAR_S_SELECT_MENUITEM_1..')>')
    end
    for seq, value in ipairs(SELECT_CONDITION_QUALITY_LIST) do
        if value.showstr == sparam then
            setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_1, seq)            
            break
        end
    end    
end

--选择回收要保留的装备条件2 等级
local function SelectRecycleConditionByLevel(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local sparam = ''
    if BF_IsLocalTestServer() then
        sparam = getconst(actor, '$STR('..CommonDefine.VAR_S_SELECT_MENUITEM_2..')')
    else
        sparam = getconst(actor, '<$NPCPARAMS(4,'..CommonDefine.VAR_S_SELECT_MENUITEM_2..')>')
    end
    for seq, value in ipairs(SELECT_CONDITION_LEVEL_LIST) do
        if value.showstr == sparam then
            setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_2, seq)            
            break
        end
    end    
end

--勾选回收的条件checkbox
local function SelectRecycleCheckBox(actor, varseq)
    if BF_IsNullObj(actor) or (varseq == nil) then
        return
    end
    if (varseq < 1) or (varseq > #RECYCLE_CHECKBOX_INFO) then
        return
    end
    
    local flag = 0
    if BF_IsLocalTestServer() then
        flag = getplaydef(actor, RECYCLE_CHECKBOX_INFO[varseq].checkvar)
    else
        local stemp = getconst(actor, '<$NPCPARAMS(2,'..RECYCLE_CHECKBOX_INFO[varseq].checkvar..')>')
        flag = tonumber(stemp)        
    end
    
    if flag == 1 then
        setflagstatus(actor, RECYCLE_CHECKBOX_INFO[varseq].bitflag, 1) 
    else
        setflagstatus(actor, RECYCLE_CHECKBOX_INFO[varseq].bitflag, 0)
    end
    OpenAutoOpenBoxPanel(actor)
end

--一键回收
local function QuickRecycleOpenItemList(actor)
    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        if tabUniqueIDs ~= false then
            local itemobjlist = {}
            for _, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                local itemobj = getitembymakeindex(actor, nItemUniqueID)
                if (not BF_IsNullObj(itemobj)) and (not Player.CheckEquipIsOnBody(actor, itemobj)) then
                    itemobjlist[#itemobjlist+1] = itemobj
                end
            end
            if not table.isempty(itemobjlist) then
                RecycleManager.SuperBoxForceRecycleItemList(actor, itemobjlist)
            end
        end
        setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, '')  
        OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    end    
end

--一键穿戴
local function QuickTakeOnBetterEquip(actor)
    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local strNewItemUniqueIDs = ''
        local bChanged = false
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        if tabUniqueIDs ~= false then
            setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_NOCHECK_TAKEON, 1)
            for _, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                local itemobj = getitembymakeindex(actor, nItemUniqueID)
                if (not BF_IsNullObj(itemobj)) and (not Player.CheckEquipIsOnBody(actor, itemobj)) then
                    local cmpflag, equippos = Item.CompareBagItemToEquipment(actor, itemobj)
                    if cmpflag == 1 then
                        takeonitem(actor, equippos, nItemUniqueID)
                        bChanged = true
                    else
                        if strNewItemUniqueIDs ~= '' then
                            strNewItemUniqueIDs = strNewItemUniqueIDs..','
                        end
                        strNewItemUniqueIDs = strNewItemUniqueIDs..nItemUniqueID
                    end
                end
            end
            setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_NOCHECK_TAKEON, 0)
        end
        if bChanged == true then
            setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strNewItemUniqueIDs)
        end
    end
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--触发穿戴装备
function OpenSuperBoxManager.OnTakeOnEquipItem(actor, strmakeindex)
    if BF_IsNullObj(actor) or (not BF_IsNumberStr(strmakeindex)) then
        return
    end
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_NOCHECK_TAKEON) == 1 then
        return
    end

    local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
    if strItemUniqueIDs ~= '' then
        local strNewItemUniqueIDs = ''
        local bChanged = false
        local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
        local makeindex = tonumber(strmakeindex)
        if tabUniqueIDs ~= false then
            for _, value in ipairs(tabUniqueIDs) do
                local nItemUniqueID = tonumber(value)
                if makeindex == nItemUniqueID then
                    bChanged = true
                else
                    if strNewItemUniqueIDs ~= '' then
                        strNewItemUniqueIDs = strNewItemUniqueIDs..','
                    end
                    strNewItemUniqueIDs = strNewItemUniqueIDs..nItemUniqueID
                end
            end
        end
        if bChanged == true then
            setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strNewItemUniqueIDs)
        end
    end
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--自动开宝箱
function OpenSuperBoxManager.AutoOpenSuperBox(actor)
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 0 then
        return
    end

    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE) == 0 then
        --自动开宝箱
        local openitemlist = {}
        if not OpenSuperBoxManager.DoOpenBoxOnce(actor, true, openitemlist) then        
            setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX, 0)
            OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
            return
        end
        
        --根据结果判断是否停止    
        local bNeedPause = false
        local checkstopflag1 = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[3].bitflag)
        local checkstopflag2 = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[4].bitflag)
        local checkstopflag3 = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[5].bitflag)

        for _, value in ipairs(openitemlist) do
            if not BF_IsNullObj(value.itemobj) then
                local itemname = getiteminfo(actor, value.itemobj, CommonDefine.ITEMINFO_CHGEDNAME)
                if checkstopflag1 == 1 then
                    if Item.CompareBagItemToEquipment(actor, value.itemobj) == 1 then
                        bNeedPause = true
                        Player.SendSelfMsg(actor, '请查看装备：'..itemname..' 比身上的评分更高！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
                        break
                    end
                end        
                if checkstopflag2 == 1 then
                    if value.randabflag == 1 then
                        bNeedPause = true
                        Player.SendSelfMsg(actor, '请查看装备：'..itemname..' 有极品属性！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
                        break                    
                    end
                end
                if checkstopflag3 == 1 then
                    if value.giftabflag == 1 then
                        bNeedPause = true
                        Player.SendSelfMsg(actor, '请查看装备：'..itemname..' 有天赋属性！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
                        break
                    end
                end
            end
        end
        if bNeedPause == true then
            setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE, 1)
            OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
            return
        end     
    end

    delaygoto(actor, 2000, 'superbox_delay_checkrecycle', 0)
end

--延迟检测开启的道具是否自动回收，并触发一下轮开启
function OpenSuperBoxManager.DelayCheckRecycle(actor)
    --根据结果判断是否回收[勾选自动回收的条件下]
    local checkrecycleflag1 = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[1].bitflag)
    local checkrecycleflag2 = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[2].bitflag)
    local dorecycleflag = getflagstatus(actor, RECYCLE_CHECKBOX_INFO[6].bitflag)
    if dorecycleflag == 1 then
        local recycleitemlist = {}
        local strItemUniqueIDs = getplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST)
        if strItemUniqueIDs ~= '' then
            local strNewItemUniqueIDs = ''
            local tabUniqueIDs = string.split(strItemUniqueIDs, ',')
            if tabUniqueIDs ~= false then
                for _, value in ipairs(tabUniqueIDs) do
                    local nItemUniqueID = tonumber(value)
                    local itemobj = getitembymakeindex(actor, nItemUniqueID)
                    if (not BF_IsNullObj(itemobj)) and (not Player.CheckEquipIsOnBody(actor, itemobj)) then
                        local bNeedRecycle = true
                        if checkrecycleflag1 == 1 then
                            local chooseseq = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_1)
                            if (chooseseq >= 1) and (chooseseq <= #SELECT_CONDITION_QUALITY_LIST) then
                                if Item.GetItemQualityLv(actor, itemobj) >= SELECT_CONDITION_QUALITY_LIST[chooseseq].minquality then
                                    bNeedRecycle = false
                                end
                            end
                        end
                        if (bNeedRecycle == false) and (checkrecycleflag2 == 1) then
                            local chooseseq = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CHOOSE_CONDITION_2)
                            if (chooseseq >= 1) and (chooseseq <= #SELECT_CONDITION_LEVEL_LIST) then
                                local itemid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
                                local needlv = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NEEDLV)                 
                                if needlv >= SELECT_CONDITION_LEVEL_LIST[chooseseq].minlevel then
                                    bNeedRecycle = false
                                end
                            end                            
                        end
                        if bNeedRecycle == true then
                            recycleitemlist[#recycleitemlist+1] = itemobj
                        else
                            if strNewItemUniqueIDs ~= '' then
                                strNewItemUniqueIDs = strNewItemUniqueIDs..','
                            end
                            strNewItemUniqueIDs = strNewItemUniqueIDs..nItemUniqueID
                        end
                    end
                end
            end
            --进行回收操作
            if not table.isempty(recycleitemlist) then
                RecycleManager.SuperBoxForceRecycleItemList(actor, recycleitemlist)        
                setplaydef(actor, CommonDefine.VAR_S_SUPERBOX_ITEMLIST, strNewItemUniqueIDs)
                OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
            end
        end            
    end

    delaygoto(actor, 1500, 'superbox_auto_open', 0)
end

local function SendEquipItemCompareRequest(actor, strMakeIndex)
    if BF_IsNumberStr(strMakeIndex) then
        local infoTab = {newitemmakeidx = tonumber(strMakeIndex), pos = nil}
        local strTabData = tbl2json(infoTab)
        sendluamsg(actor, MsgDefine.SM_SHOW_BOX_EQUIPITEM_COMPARE, 0, 0, 0, strTabData)
    end
end

--处理button回调
function OpenSuperBoxManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

    local funcid = tonumber(sid)
    if funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 then
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 1 then
            Player.SendSelfMsg(actor, '正在自动开箱中！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
        OpenSuperBoxManager.DoOpenBoxOnce(actor, false, nil) 
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 then
        AddOnceOpenBoxNum(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 then
        DecOnceOpenBoxNum(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 then
        OpenUpgradeBoxLevelPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 then
        CloseUpgradeBoxLevelPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_6 then
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX) == 1 then
            setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX, 0) 
            OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
        else
            OpenAutoOpenBoxPanel(actor)
        end                
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_7 then
        CloseAutoOpenBoxPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_8 then
        StartUpgradeBoxLevel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_9 then
        SpeedupUpgradeBoxLevel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_10 then
        QuickRecycleOpenItemList(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_11 then
        CloseOpenBoxItemListPanel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_12 then
        QuickTakeOnBetterEquip(actor)          
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_22 then
        SelectRecycleConditionByQuality(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_24 then
        SelectRecycleConditionByLevel(actor)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_21 then
        SelectRecycleCheckBox(actor, 1)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_23 then
        SelectRecycleCheckBox(actor, 2)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_25 then
        SelectRecycleCheckBox(actor, 3)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_26 then
        SelectRecycleCheckBox(actor, 4)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_27 then
        SelectRecycleCheckBox(actor, 5)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_28 then
        SelectRecycleCheckBox(actor, 6)
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_13 then
        SendEquipItemCompareRequest(actor, sparam)
    end
end


--玩家登录时触发
function OpenSuperBoxManager.OnPlayerEnterGame(actor)
    --初始超级宝箱等级
    local nBoxCurrLv = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV)
    if nBoxCurrLv == 0 then
        nBoxCurrLv = 1
        setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_CURR_LV, nBoxCurrLv)
        setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_ONCE_OPEN_NUM, 1)
    end    

    --每次上线都把除保留的都自动回收的这个选项勾选
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK3, 1)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK6, 1)
    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, OpenSuperBoxManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_SUPERBOX)

return OpenSuperBoxManager