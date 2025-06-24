WeaponAddLuckManager = {}

local AUTO_ADDLUCK_TARG_MIN = 5     --自动祝福的最小目标
local AUTO_ADDLUCK_TARG_MAX = 9     --自动祝福的最大目标
local FAIL_DECLUCK_RATE = 90        --祝福失败扣等级的概率 百分比分子

--武器的祝福面板信息
local function weapon_addluck_str(actor, weaponitem)
    local currLuckLevel = getitemintparam(actor, CommonDefine.EQUIPPOS_WEAPON, CommonDefine.ITEM_INTVAR_ADDLUCK_LV)
    if (currLuckLevel==nil) or (currLuckLevel < 0) then
        currLuckLevel = 0
    end
    local nextLuckLevel = currLuckLevel + 1
    local bCurrIsMaxLv = false
    local cfgCurrKey = currLuckLevel
    if cfgWeaponLuck[cfgCurrKey] == nil then
        release_print("weapon_addluck_str no config key:"..cfgCurrKey)
        return ''
    end
    local cfgNextKey = nextLuckLevel
    if cfgWeaponLuck[cfgNextKey] == nil then
        bCurrIsMaxLv = true
    end

    local weaponname = getiteminfo(actor, weaponitem, CommonDefine.ITEMINFO_SRCNAME)
    local weaponcolor = Item.GetItemQualityColor(actor, weaponitem)
    local sPanelStr = '<Img|id=10|children={11,12,13,14,15,16,17}|x=4.0|y=5.0|show=0|loadDelay=0|move=0|img=private/cc_weaponaddluck/1.png|esc=1|reset=1|bg=1>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
        '<Layout|id=13|children={30,31,32,33,35,36,37,41,42,43,45,46,47}|x=64.0|y=56.0|width=728|height=240>'
        
    sPanelStr = sPanelStr..'<Text|id=17|text='..weaponname..'|size=22|x=360|y=60|color='..weaponcolor..'>'
    --当前祝福等级的属性    
    local tempLeftX = 120
    local tempLeftY = 50
    sPanelStr = sPanelStr..'<Text|id=31|text=当前祝福等级：|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'..
                           '<Text|id=32|text='..currLuckLevel..'|x='..(tempLeftX+120)..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
    tempLeftY = tempLeftY + 30
    sPanelStr = sPanelStr..'<Text|id=33|text=幸运值:'..currLuckLevel..'|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
    --下一祝福等级的属性
    local tempRightX = 460
    local tempRightY = 50
    if bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|text=已达到上限|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        tempRightY = tempRightY + 30
    else
        sPanelStr = sPanelStr..'<Text|id=35|text=下一祝福等级：|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'..
                               '<Text|id=36|text='..nextLuckLevel..'|x='..(tempRightX+120)..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'    
        tempRightY = tempRightY + 30
        sPanelStr = sPanelStr..'<Text|id=37|text=幸运值:'..nextLuckLevel..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
    end

    --等级限制和强化消耗
    local tempCurrY = math.max(tempLeftY, tempRightY)
    tempCurrY = tempCurrY + 40    
    sPanelStr = sPanelStr..'<Img|id=30|x=15|y='..tempCurrY..'|width=700|height=4|esc=0|img=private/cc_common/line_1.png>'
    local tempCurrX = 100    
    tempCurrY = tempCurrY + 30  
    if not bCurrIsMaxLv then
        local sConsumeInfo = BF_GetItemTableDescStr(actor, cfgWeaponLuck[cfgCurrKey].needitems_tab)
        sPanelStr = sPanelStr..'<Text|id=41|text=祝福消耗：'..sConsumeInfo..'|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'

        local currNum = Player.GetItemNumInBag(actor, CommonDefine.ITEMID_XINYUNFU)
        local strTemp1 = ''
        local strTemp2 = ''
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF) == 1 then
            strTemp1 = '启用中'
            strTemp2 = '停用'
        else
            strTemp1 = '停用中'
            strTemp2 = '启用'
        end
        sPanelStr = sPanelStr..'<Text|id=42|text=幸运符('..CommonDefine.ADDLUCK_USE_XYF_NUM..'/'..currNum..') '..strTemp1..'|x='..(tempCurrX+350)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'..
                    '<Button|id=43|text='..strTemp2..'|x='..(tempCurrX+550)..'|y='..(tempCurrY-6)..'|mimg=private/cc_common/button_2.png|nimg=private/cc_common/button_2.png|color='..
                    CSS.NPC_LIGHTGREEN..'|link=@switch_xyf_flag>'
    end
    tempCurrY = tempCurrY + 40

    if not bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|id=45|text=成功几率：'..cfgWeaponLuck[cfgCurrKey].successrate ..'% |x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'

        local currNum = Player.GetItemNumInBag(actor, CommonDefine.ITEMID_BAODIFU)
        local strTemp1 = ''
        local strTemp2 = ''
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF) == 1 then
            strTemp1 = '启用中'
            strTemp2 = '停用'
        else
            strTemp1 = '停用中'
            strTemp2 = '启用'
        end
        sPanelStr = sPanelStr..'<Text|id=46|text=保底符('..CommonDefine.ADDLUCK_USE_BDF_NUM..'/'..currNum..') '..strTemp1..'|x='..(tempCurrX+350)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'..
                    '<Button|id=47|text='..strTemp2..'|x='..(tempCurrX+550)..'|y='..(tempCurrY-6)..'|mimg=private/cc_common/button_2.png|nimg=private/cc_common/button_2.png|color='..
                    CSS.NPC_LIGHTGREEN..'|link=@switch_bdf_flag>'        
    end
    tempCurrY = tempCurrY + 20

    --检测按钮
    tempCurrY = 30
    local nStartX = 80    
    local nStartY = tempCurrY + 25
    for i = AUTO_ADDLUCK_TARG_MIN, AUTO_ADDLUCK_TARG_MAX, 1 do
        local seq = i - AUTO_ADDLUCK_TARG_MIN + 1
        local checkvar = CommonDefine.CHECK_BOX_VAR[seq]
        local flag = getplaydef(actor, checkvar)
        local checkboxid = 50 + seq
        local textid = 60 + seq
        sPanelStr = sPanelStr..'<CheckBox|id='..checkboxid..'|x='..nStartX..'|y='..nStartY..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..
            checkvar..'|default='..flag..'|delay=0|count=1|link=@set_autoaddluck_targ,'..i..'>'..
            '<Text|id='..textid..'|text=幸运+'..i..'|x='..(nStartX+30)..'|y='..(nStartY+5)..'|color='..CSS.NPC_YELLOW..'>'
        nStartX = nStartX + 120
    end
    sPanelStr = sPanelStr..'<Text|id=50|text=自动祝福选项：|x=30|y=10|size=20|color='..CSS.NPC_WHITE..'>'
    sPanelStr = sPanelStr..'<Img|id=14|children={50,51,52,53,54,55,61,62,63,64,65}|x=64.0|y=296.0|width=728|esc=0|img=private/cc_weaponaddluck/5.png>'

    --升级按钮
    tempCurrY = 430
    if bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|id=15|text=已达到最高祝福等级！|x=300|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    else
        sPanelStr = sPanelStr..'<Button|id=15|x=200|y='..tempCurrY..'|mimg=private/cc_common/button_1.png|color=255|nimg=private/cc_common/button_1.png|size=18|text=祝福一次|link=@weapon_addluck_once>'        
        
        if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG) == 0 then
            sPanelStr = sPanelStr..'<Button|id=16|x=500|y='..tempCurrY..'|mimg=private/cc_common/button_1.png|color=255|nimg=private/cc_common/button_1.png|size=18|text=自动祝福|link=@weapon_auto_addluck>'
        else
            sPanelStr = sPanelStr..'<Button|id=16|x=500|y='..tempCurrY..'|mimg=private/cc_common/button_1.png|color=255|nimg=private/cc_common/button_1.png|size=18|text=停止祝福|link=@weapon_auto_addluck_stop>'
        end
    end

    return sPanelStr
end

local function inner_show_page(actor)
    local strPanelInfo = '';
    local weaponitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
    if (weaponitem == nil) or (weaponitem == '0') then
        strPanelInfo = '<Img|id=10|children={11,12,13}|x=4.0|y=5.0|show=0|loadDelay=0|move=0|img=private/cc_weaponaddluck/1.png|esc=1|reset=1|bg=1>'..
            '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
            '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
            '<Text|id=13|text=提    示:   只有穿戴武器才能进行祝福|x=200|y=240|size=22|color='..CSS.NPC_WHITE..'>'        
    else
        strPanelInfo = weapon_addluck_str(actor, weaponitem)
    end
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--主面板显示
function WeaponAddLuckManager.ShowBasePanel(actor)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG, 0)
    for i = AUTO_ADDLUCK_TARG_MIN, AUTO_ADDLUCK_TARG_MAX, 1 do
        local checkvar = CommonDefine.CHECK_BOX_VAR[i - AUTO_ADDLUCK_TARG_MIN + 1]
        setplaydef(actor, checkvar, 0)        
    end    
    inner_show_page(actor)
end

--规则说明面板
function WeaponAddLuckManager.ShowRulePanel(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y    
    local msg = '<Text|text=武器祝福的规则说明：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    msg = msg..'<Text|text=返回上一层|x='..(tempCurrX+400)..'|y='..tempCurrY..'|size=15|color='..CSS.NPC_YELLOW..'|link=@main>'
    tempCurrY = tempCurrY + 35
    msg = msg..'<Text|text=1、武器祝福只针对当前已经穿戴的装备才能进行操作。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 25    
    msg = msg..'<Text|text=2、祝福消耗祝福油，且有成功几率的设定，成功则幸运+1，|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=失败则有几率掉幸运等级。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 25    
    msg = msg..'<Text|text=3、幸运数值越高，则角色在攻击时越能发挥最大输出。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=4、可以使用幸运符来增加成功几率或者使用保底符来避免失|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=败后的幸运降低。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'            
    BF_ShowSpecialUI(actor, msg)
end

--切换幸运符使用状态
function switch_xyf_flag(actor)
    local status = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF)
    if status == 1 then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF, 0)
    else
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF, 1)
    end
    inner_show_page(actor)
end

--切换保底符使用状态
function switch_bdf_flag(actor)
    local status = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF)
    if status == 1 then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF, 0)
    else
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF, 1)
    end
    inner_show_page(actor)
end

--设置自动祝福的目标
function set_autoaddluck_targ(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local seq = tonumber(sid)
    if (seq < AUTO_ADDLUCK_TARG_MIN) or (seq > AUTO_ADDLUCK_TARG_MAX) then
        return
    end

    for i = AUTO_ADDLUCK_TARG_MIN, AUTO_ADDLUCK_TARG_MAX, 1 do
        if i ~= seq then
            local checkvar = CommonDefine.CHECK_BOX_VAR[i - AUTO_ADDLUCK_TARG_MIN + 1]
            setplaydef(actor, checkvar, 0)            
        end
    end
    inner_show_page(actor)
end

--武器祝福一次
function weapon_addluck_once(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_WEAPON_ADDLUCK, false) then
        return
    end
    local weaponitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
    if BF_IsNullObj(weaponitem) then
        return
    end

    local currLuckLevel = getitemintparam(actor, CommonDefine.EQUIPPOS_WEAPON, CommonDefine.ITEM_INTVAR_ADDLUCK_LV)
    if (currLuckLevel==nil) or (currLuckLevel < 0) then
        currLuckLevel = 0
    end
    local nextLuckLevel = currLuckLevel + 1
    local cfgCurrKey = currLuckLevel
    if cfgWeaponLuck[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = nextLuckLevel
    if cfgWeaponLuck[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前祝福已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgWeaponLuck[cfgCurrKey].needitems_tab, '祝福') then
        return
    end
    --判断幸运符
    local bUseXinYunFuFlag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF)
    if bUseXinYunFuFlag == 1 then
        if Player.GetItemNumInBag(actor, CommonDefine.ITEMID_XINYUNFU) < CommonDefine.ADDLUCK_USE_XYF_NUM then
            Player.SendSelfMsg(actor, '幸运符不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
    end
    --判断保底符
    local bUseBaoDiFuFlag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF)
    if bUseBaoDiFuFlag == 1 then
        if Player.GetItemNumInBag(actor, CommonDefine.ITEMID_BAODIFU) < CommonDefine.ADDLUCK_USE_BDF_NUM then
            Player.SendSelfMsg(actor, '保底符不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
    end    

    --扣除消耗
    Player.TakeItems(actor, cfgWeaponLuck[cfgCurrKey].needitems_tab, '武器祝福')

    if bUseXinYunFuFlag == 1 then
        local itemname = getstditeminfo(CommonDefine.ITEMID_XINYUNFU, CommonDefine.STDITEMINFO_NAME)
        takeitem(actor, itemname, CommonDefine.ADDLUCK_USE_XYF_NUM)
    end

    if bUseBaoDiFuFlag == 1 then
        local itemname = getstditeminfo(CommonDefine.ITEMID_BAODIFU, CommonDefine.STDITEMINFO_NAME)
        takeitem(actor, itemname, CommonDefine.ADDLUCK_USE_BDF_NUM)
    end    

    local successrate = cfgWeaponLuck[cfgCurrKey].successrate
    if bUseXinYunFuFlag == 1 then
        successrate = successrate + CommonDefine.ADDLUCK_USE_XYF_ADDRATE
    end
    if successrate >= math.random(1, 100) then
        --祝福成功    
        currLuckLevel = currLuckLevel + 1
        setitemintparam(actor, CommonDefine.EQUIPPOS_WEAPON, CommonDefine.ITEM_INTVAR_ADDLUCK_LV, currLuckLevel)
        updatecustitemparam(actor, CommonDefine.EQUIPPOS_WEAPON)
        setitemaddvalue(actor, weaponitem, 1, CommonDefine.ITEMADDVALUE_TYPE1_LUCK, currLuckLevel)  
        refreshitem(actor, weaponitem)
        recalcabilitys(actor)        

        Player.SendSelfMsg(actor, '祝福成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    else
        --祝福失败
        if bUseBaoDiFuFlag ~= 1 then
            --没有保底会降级 按概率扣幸运
            if math.random(1, 100) <= FAIL_DECLUCK_RATE then
                currLuckLevel = math.max(currLuckLevel - 1, 0)            
                setitemintparam(actor, CommonDefine.EQUIPPOS_WEAPON, CommonDefine.ITEM_INTVAR_ADDLUCK_LV, currLuckLevel)
                updatecustitemparam(actor, CommonDefine.EQUIPPOS_WEAPON)
                setitemaddvalue(actor, weaponitem, 1, CommonDefine.ITEMADDVALUE_TYPE1_LUCK, currLuckLevel)  
                refreshitem(actor, weaponitem)
                recalcabilitys(actor)             
            end
        end
        Player.SendSelfMsg(actor, '祝福失败！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)                     
    end

    inner_show_page(actor)
end

--武器自动祝福
function weapon_auto_addluck(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_WEAPON_ADDLUCK, false) then
        return
    end

    local weaponitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
    if BF_IsNullObj(weaponitem) then
        return
    end    

    local currLuckLevel = getitemintparam(actor, CommonDefine.EQUIPPOS_WEAPON, CommonDefine.ITEM_INTVAR_ADDLUCK_LV)
    if (currLuckLevel==nil) or (currLuckLevel < 0) then
        currLuckLevel = 0
    end
    
    local nextLuckLevel = currLuckLevel + 1
    local cfgCurrKey = currLuckLevel
    if cfgWeaponLuck[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = nextLuckLevel
    if cfgWeaponLuck[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前祝福已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgWeaponLuck[cfgCurrKey].needitems_tab, '祝福') then
        return
    end

    --判断幸运符
    local bUseXinYunFuFlag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_XYF)
    if bUseXinYunFuFlag == 1 then
        if Player.GetItemNumInBag(actor, CommonDefine.ITEMID_XINYUNFU) < CommonDefine.ADDLUCK_USE_XYF_NUM then
            Player.SendSelfMsg(actor, '幸运符不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
    end

    --判断保底符
    local bUseBaoDiFuFlag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_USE_BDF)
    if bUseBaoDiFuFlag == 1 then
        if Player.GetItemNumInBag(actor, CommonDefine.ITEMID_BAODIFU) < CommonDefine.ADDLUCK_USE_BDF_NUM then
            Player.SendSelfMsg(actor, '保底符不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end
    end 

    
    local targLuckLevel = 0
    for i = AUTO_ADDLUCK_TARG_MIN, AUTO_ADDLUCK_TARG_MAX, 1 do
        local checkvar = CommonDefine.CHECK_BOX_VAR[i - AUTO_ADDLUCK_TARG_MIN + 1]
        if getplaydef(actor, checkvar) == 1 then
            targLuckLevel = i
            break
        end
    end

    if currLuckLevel < targLuckLevel then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG, 1)
        weapon_addluck_once(actor) 
        delaygoto(actor, 1000, 'weapon_auto_addluck', 0)
    end
end

function WeaponAddLuckManager.AutoAddLuck(actor)
    weapon_auto_addluck(actor)
end

--停止武器自动祝福
function weapon_auto_addluck_stop(actor)
    for i = AUTO_ADDLUCK_TARG_MIN, AUTO_ADDLUCK_TARG_MAX, 1 do
        local checkvar = CommonDefine.CHECK_BOX_VAR[i - AUTO_ADDLUCK_TARG_MIN + 1]
        setplaydef(actor, checkvar, 0)        
    end
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG, 0)
    inner_show_page(actor)
end