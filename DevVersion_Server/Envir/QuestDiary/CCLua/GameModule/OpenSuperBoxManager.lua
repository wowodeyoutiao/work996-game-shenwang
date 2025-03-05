--超级宝箱系统
OpenSuperBoxManager = {}

local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 = 1    --开启宝箱
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 = 2    --增加一次性打开宝箱数量
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 = 3    --减少一次性打开宝箱数量
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 = 4    --打开升级宝箱界面
local OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 = 5    --切换自动开宝箱状态   并打开设置宝箱自动的界面 【打开该界面状态下不自动开】

--返回每天最大可以获得的宝箱数量
local function GetDayMaxAddBoxNum(actor)
    return CommonDefine.DAY_SUPER_BOX_MAX_ADD_NUM
end

--增加当前的宝箱累计数量
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
    nCurrBoxNum = nCurrBoxNum + nDayAddNum
    setplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM, nCurrBoxNum)

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

--升级超级宝箱
function OpenSuperBoxManager.UpgradeBoxLevel(actor)
    --todo...
end

--更新超级宝箱界面
function OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    local str = '<Img|id=2000|children={2001,2002,2003,2004,2005,2006}|x=-130|y=-280|bg=1|move=0|img=private/cc_superbox/basepanel.png>'..
        '<Button|id=2001|x=60.0|y=-40.0|pimg=private/cc_superbox/button_box .png|nimg=private/cc_superbox/button_box.png|mimg=private/cc_superbox/button_box.png|link=@opensuperboxmanager_button_'..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1..'>'..
        '<Text|id=2002|x=85.0|y=69.0|color=255|size=22|text='..nCurrBoxNum..'>'..
        '<Button|id=2003|x=144.0|y=70.0|size=18|color=255|nimg=private/cc_superbox/button_add.png|pimg=private/cc_superbox/button_add_1.png|mimg=private/cc_superbox/button_add_1.png|link=@opensuperboxmanager_button_'..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2..'>'..
        '<Button|id=2004|x=30.0|y=70.0|size=18|mimg=private/cc_superbox/button_dec_1.png|color=255|nimg=private/cc_superbox/button_dec.png|pimg=private/cc_superbox/button_dec_1.png|link=@opensuperboxmanager_button_'..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3..'>'..
        '<Button|id=2005|x=200.0|y=70.0|size=20|mimg=private/cc_superbox/button_level.png|color=255|nimg=private/cc_superbox/button_level.png|pimg=private/cc_superbox/button_level.png|link=@opensuperboxmanager_button_'..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5..'>'..
        '<Button|id=2006|x=-60.0|y=70.0|size=20|mimg=private/cc_superbox/button_auto.png|color=255|nimg=private/cc_superbox/button_auto.png|pimg=private/cc_superbox/button_auto.png|link=@opensuperboxmanager_button_'..
        OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4..'>'
    addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1, str)   
end

--进行一次宝箱开启
function OpenSuperBoxManager.DoOpenBoxOnce(actor)
    if BF_IsNullObj(actor) then
        return false
    end
    local nCurrBoxNum = getplaydef(actor, CommonDefine.VAR_U_SUPER_BOX_TOTAL_NUM)
    if nCurrBoxNum <= 0 then
        Player.SendSelfMsg(actor, '当前没有可以开启的宝箱！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
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

    local nPlayerLv = Player.GetLevel(actor)
    local boxPoolConfig = cfgSuperBoxRewardPool[nPlayerLv]
    if boxPoolConfig == nil then        
        Player.SendSelfMsg(actor, '当前没有可以开启的宝箱！ '..nPlayerLv, CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        release_print('DoOpenBoxOnce error 1111 level:'..nPlayerLv)
        return false
    end

    for i = 1, nOnceOpenNum, 1 do

    end
end


--处理button回调
function OpenSuperBoxManager.DoOperButton(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)

    release_print('funcid:'..funcid)
    if funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_1 then
       
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_2 then
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_3 then
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_4 then
    elseif funcid == OPENSUPERBOX_MANAGER_BUTTONFUNC_ID_5 then
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

    OpenSuperBoxManager.UpdateSuperBoxInfo(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, OpenSuperBoxManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_FREEVIP)

return OpenSuperBoxManager