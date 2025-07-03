BaoZhuManager = {}

local DO_FUNCTION_ID_1 = 1      --灵玉的初始面板
local DO_FUNCTION_ID_2 = 2      --灵玉的规则说明面板
local DO_FUNCTION_ID_3 = 3      --灵玉宝盒的面板
local DO_FUNCTION_ID_4 = 4      --灵玉总强化列表面板
local DO_FUNCTION_ID_5 = 5      --打开灵玉的装备界面
local DO_FUNCTION_ID_6 = 6      --快捷穿戴
local DO_FUNCTION_ID_7 = 7      --全部脱下
local DO_FUNCTION_ID_8 = 8      --打开回收灵玉界面
local DO_FUNCTION_ID_9 = 9      --灵玉单件强化面板
local DO_FUNCTION_ID_10 = 10    --灵玉回收设置品质
local DO_FUNCTION_ID_11 = 11    --设置保留更好的宝珠
local DO_FUNCTION_ID_12 = 12    --灵玉单件单次强化

local RecycleSettingPanelCfg = {
    {id=1, tip='白色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_WHITE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_1, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_1},
    {id=2, tip='绿色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GREEN, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_2, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_2},
    {id=3, tip='蓝色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_BLUE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_3, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_3},
    {id=4, tip='紫色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PURPLE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_4, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_4},
    {id=5, tip='粉色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PINK, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_5, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_5},
    {id=6, tip='橙色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GOLD, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_6, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_6},
}

local BAOZHU_ITEM_STDMODE = {100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111}

local function GetRecycleCfg(id)
    for _, value in ipairs(RecycleSettingPanelCfg) do
        if value.id == id then
            return value
        end
    end
    return nil
end

--是否为有效的强化装备位
function BaoZhuManager.IsValidRecycleID(id)
    if id == nil then
        return false
    end
    for _, value in ipairs(RecycleSettingPanelCfg) do
        if value.id == id then
            return true
        end
    end    
    return false
end

--快速穿戴灵玉
function BaoZhuManager.QuickTakeOn(actor)
    local takeonobjids = {}
	local item_num = getbaseinfo(actor, CommonDefine.INFO_HUMBAGITEMNUM)
    local baozhuStdmodeStart = BAOZHU_ITEM_STDMODE[1]
    local baozhuStdmodeEnd = BAOZHU_ITEM_STDMODE[#BAOZHU_ITEM_STDMODE]
   	for i=0, item_num-1 do
		local itemobj = getiteminfobyindex(actor, i)
		if not BF_IsNullObj(itemobj) then 
			local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
            local uniqueid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
            local cfgItemInfo = cfg_item[itemidx];
            if cfgItemInfo and (cfgItemInfo.StdMode>=baozhuStdmodeStart) and (cfgItemInfo.StdMode<=baozhuStdmodeEnd) then
                local equippos = (cfgItemInfo.StdMode - baozhuStdmodeStart) + CommonDefine.EQUIPPOS_SSH_1
                local equipobj = linkbodyitem(actor, equippos) 
                if BF_IsNullObj(equipobj) then
                    local rec = {pos=equippos, objid=uniqueid}
                    takeonobjids[#takeonobjids+1] = rec
                end
            end	
		end
   	end
 
    for _, value in ipairs(takeonobjids) do
        takeonitem(actor, value.pos, value.objid) 
    end       
end

--快速脱下灵玉
function BaoZhuManager.QuickTakeOff(actor)
    for i = CommonDefine.EQUIPPOS_SSH_1, CommonDefine.EQUIPPOS_SSH_12, 1 do
        local itemobj = linkbodyitem(actor, i)
        if not BF_IsNullObj(itemobj) then
            takeoffitem(actor, i)    
        end        
    end        
end

--返回回收宝珠的复选框和信息
function BaoZhuManager.GetRecycleCheckBoxInfo(actor, nStartX, nStartY)
    local msg = ''
    local srcStartY = nStartY
    for _, cfginfo in ipairs(RecycleSettingPanelCfg) do
        local flag = getflagstatus(actor, cfginfo.flagvar)
        local color = CSS.GetQualityColor(cfginfo.qualitylv)
        msg = msg..'<CheckBox|x='..nStartX..'|y='..nStartY..'|id='..cfginfo.id..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..
            cfginfo.tempvar..'|default='..flag..'|delay=0|count=1|link=@baozhu_button_function,'..DO_FUNCTION_ID_10..','..cfginfo.id..'>'..
            '<Text|text=自动回收'..cfginfo.tip..'|x='..(nStartX+30)..'|y='..(nStartY+5)..'|color='..color..'>'            
        nStartY = nStartY + 25
    end    
    local keepflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
    msg = msg..'<CheckBox|x='..(nStartX+230)..'|y='..(srcStartY+50)..'|id=10|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..CommonDefine.VAR_N_NPC_CHECKBOX_10..
        '|default='..keepflag..'|delay=0|count=1|link=@baozhu_button_function,'..DO_FUNCTION_ID_11..'>'..
        '<Text|text=保留比当前穿戴灵玉更好的|x='..(nStartX+260)..'|y='..(srcStartY+55)..'|color='..CSS.NPC_WHITE..'>'  
    return msg
end

--设置玩家回收宝珠的品质
function BaoZhuManager.SetRecycleQuality(actor, recycleid)
    if BF_IsNullObj(actor) or (recycleid==nil) then
        return
    end
    local cfg = GetRecycleCfg(recycleid)
    if cfg == nil then
        return
    end

    local tempvar = 0
    if BF_IsLocalTestServer() then
        tempvar = getplaydef(actor, cfg.tempvar)
    else
        local stemp = getconst(actor, '<$NPCPARAMS(2,'..cfg.tempvar..')>')
        tempvar = tonumber(stemp)        
    end    

    if (tempvar==1) or (tempvar==0) then
        setflagstatus(actor, cfg.flagvar, tempvar)
    end
end

--玩家获得道具时触发，自动回收宝珠
function BaoZhuManager.DoAutoRecycleBaoZhu(actor, itemobj, makeindex)
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then 
        return
    end
    local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
    local cfgItem = cfg_item[itemidx]
    if cfgItem == nil then
        return
    end
    if (cfgItem.StdMode >= BAOZHU_ITEM_STDMODE[1]) and (cfgItem.StdMode <= BAOZHU_ITEM_STDMODE[#BAOZHU_ITEM_STDMODE]) then
        for _, recycleCfg in ipairs(RecycleSettingPanelCfg) do
            if recycleCfg.qualitylv == cfgItem.QualityLv then                
                local flag = getflagstatus(actor, recycleCfg.flagvar)                         
                if flag == 1 then                 
                    --选中自动回收当前品质宝珠
                    local keepbetterflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
                    if keepbetterflag == 1 then                                        
                        --选中保留比穿戴更好的宝珠
                        local equippos = (cfgItem.StdMode - BAOZHU_ITEM_STDMODE[1]) + CommonDefine.EQUIPPOS_SSH_1
                        local equipobj = linkbodyitem(actor, equippos) 
                        if BF_IsNullObj(equipobj) then
                            break
                        end
                        local currequipidx = getiteminfo(actor, equipobj, CommonDefine.ITEMINFO_ITEMIDX)
                        local cfgCurrEquip = cfg_item[currequipidx]
                        if (cfgCurrEquip == nil) or (cfgCurrEquip.QualityLv < cfgItem.QualityLv) then
                            break
                        end                       
                    end
                    --自动回收珠子，并返回1000金币，后面再完成其它回收相关配置
                    local makeindex = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
                    local itemcount = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
                    itemcount = math.max(1, itemcount)
                    delitembymakeindex(actor, makeindex, itemcount, 'autorecycle')
                    giveitem(actor, '金币', 1000 * itemcount)
                end
                break     
            end
        end
    end
end

--玩家登录时触发
function BaoZhuManager.OnPlayerEnterGame(actor)	
	--开启生肖宝盒的功能  这个后面可以调整到升级或其它地方触发
	setsndaitembox(actor, 1)
end

--GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, BaoZhuManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_BAOZHU)
--GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, BaoZhuManager.DoAutoRecycleBaoZhu, CommonDefine.FUNC_ID_BAOZHU)


---------------------------------------------------------------界面显示相关--------------------------------------------

--初始面板
local function ShowPanel1(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y
    local msg = '<Text|text=灵玉尊者:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'..
                '<Text|text=凝聚了十二生肖之力的灵玉你都集齐了吗？|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+20)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Button|text=灵玉宝盒|size=20|x='..(tempCurrX+80)..'|y='..(tempCurrY+100)..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_3..'>'..
               '<Button|text=灵玉强化|size=20|x='..(tempCurrX+300)..'|y='..(tempCurrY+100)..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_4..'>'
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+200)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Text|text=规则说明|x='..(tempCurrX+400)..'|y='..(tempCurrY+220)..'|color='..CSS.NPC_RED..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_2..'>'

    BF_NPCSayExt(actor,msg)
end

--规则说明面板
local function ShowPanel2(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y    
    local msg = '<Text|text=灵玉系统规则说明：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    msg = msg..'<Text|text=返回上一层|x='..(tempCurrX+400)..'|y='..tempCurrY..'|size=15|color='..CSS.NPC_YELLOW..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_1..'>'
    tempCurrY = tempCurrY + 35
    msg = msg..'<Text|text=1、灵玉共分为{白绿蓝紫粉橙红}七种品质，每种品质分为|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=三种星级，每种星级分为12种生肖的部位。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 25    
    msg = msg..'<Text|text=2、相同品质相同星级的灵玉可以每3、6、9、12件穿戴激|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 25    
    msg = msg..'<Text|text=活对应的套装属性。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=3、灵玉为独立的属性加成系统，其所增加的属性将会直接|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 25
    msg = msg..'<Text|text=加成到主角面板。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    BF_NPCSayExt(actor,msg)
end

--灵玉宝盒的面板
local function ShowPanel3(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y
    local msg = '<Text|text=灵玉尊者:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'..
                '<Text|text=可在包裹中单独穿戴灵玉，也可在这进行一键操作！|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+20)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Button|text=快捷穿戴|size=20|x='..(tempCurrX+20)..'|y='..(tempCurrY+100)..'|color='..CSS.NPC_LIGHTGREEN..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_6..'>'..
                '<Button|text=全部卸下|size=20|x='..(tempCurrX+140)..'|y='..(tempCurrY+100)..'|color='..CSS.NPC_LIGHTGREEN..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_7..'>'..
                '<Button|text=开关界面|size=20|x='..(tempCurrX+260)..'|y='..(tempCurrY+100)..'|color='..CSS.NPC_LIGHTGREEN..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_5..'>'..
                '<Button|text=回收灵玉|size=20|x='..(tempCurrX+380)..'|y='..(tempCurrY+100)..'|color='..CSS.NPC_LIGHTGREEN..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@baozhu_button_function,'..DO_FUNCTION_ID_8..'>'

    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+200)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Text|text=返回上一层|x='..(tempCurrX+400)..'|y='..(tempCurrY+220)..'|color='..CSS.NPC_ORANGE..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_1..'>'
    BF_NPCSayExt(actor,msg)

    openhyperlink(actor, 6)
end

--灵玉强化的面板
local function ShowPanel4(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y
    local msg = '<Text|text=灵玉尊者:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'..
                '<Text|text=放心强化，灵玉替换会自动继承！|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+20)..'|color='..CSS.NPC_BLUE_LINE..'>'   

    local yInterval = 40
    msg = msg..'<Text|text=鼠灵玉位|x='..tempCurrX..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_1..'>'..
        '<Text|text=牛灵玉位|x='..(tempCurrX+180)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_2..'>'..
        '<Text|text=虎灵玉位|x='..(tempCurrX+360)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_3..'>'    
    yInterval = yInterval + 35
    msg = msg..'<Text|text=兔灵玉位|x='..tempCurrX..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_4..'>'..
        '<Text|text=龙灵玉位|x='..(tempCurrX+180)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_5..'>'..
        '<Text|text=蛇灵玉位|x='..(tempCurrX+360)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_6..'>'    
    yInterval = yInterval + 35
    msg = msg..'<Text|text=马灵玉位|x='..tempCurrX..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_7..'>'..
        '<Text|text=羊灵玉位|x='..(tempCurrX+180)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_8..'>'..
        '<Text|text=猴灵玉位|x='..(tempCurrX+360)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_9..'>'    
    yInterval = yInterval + 35
    msg = msg..'<Text|text=鸡灵玉位|x='..tempCurrX..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_10..'>'..
        '<Text|text=狗灵玉位|x='..(tempCurrX+180)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_11..'>'..
        '<Text|text=猪灵玉位|x='..(tempCurrX+360)..'|y='..(tempCurrY+yInterval)..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_9..','..CommonDefine.EQUIPPOS_SSH_12..'>'        

    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+200)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Text|text=规则说明|x='..(tempCurrX)..'|y='..(tempCurrY+220)..'|color='..CSS.NPC_RED..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_2..'>'..
               '<Text|text=返回上一层|x='..(tempCurrX+400)..'|y='..(tempCurrY+220)..'|color='..CSS.NPC_ORANGE..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_1..'>'
    BF_NPCSayExt(actor,msg)
end

local function IsValidPosStrForStrength(sid)
    if not BF_IsNumberStr(sid) then
        return false
    end

    local pos = tonumber(sid)
    return EquipPosStrengthManager.IsValidEquipPosForStrength(pos, 2)
end

--单个装备位的强化面板
local function ShowPanel6(actor, sid)
    if (actor == nil) or (sid == nil) then
        return
    end
    if not IsValidPosStrForStrength(sid) then
        return
    end
    local equippos = tonumber(sid)
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)

    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end
    local nextPosLevel = curPosLevel + 1
    local bCurrIsMaxLv = false
    --记录当前npc选择的强化装备位
    setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, equippos)

    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        --异常日志记录！！！！！怎么处理
        release_print("equippos_strength_panel no config key:"..cfgCurrKey)
        return
    end
    local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosStrength[cfgNextKey] == nil then
        bCurrIsMaxLv = true
    end

    local tempCurrX = CSS.NPC_CENTER_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y
    local sPanelStr = '<Text|text='..CommonDefine.EQUIPPOS_NAME[equippos]..'珠位|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    --当前等级属性
    local tempLeftX = CSS.NPC_LEFT_START_X + 30
    local tempLeftY = tempCurrY + 30    
    sPanelStr = sPanelStr..'<Text|text=当前等级：|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'..
                           '<Text|text='..curPosLevel..'|x='..(tempLeftX+100)..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
    tempLeftY = tempLeftY + 30
    local currPropDescTable = cfgEquipPosStrength[cfgCurrKey].addprop_desctab    
  
    for _, descItem in ipairs(currPropDescTable) do
        sPanelStr = sPanelStr..'<Text|text='..descItem.desc..'|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        tempLeftY = tempLeftY + 30
    end
    --下一等级属性
    local tempRightX = CSS.NPC_LEFT_START_X + 300
    local tempRightY = tempCurrY + 30
    if bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|text=已达到等级上限|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        tempRightY = tempRightY + 30
    else
        sPanelStr = sPanelStr..'<Text|text=下一等级：|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'..
                                '<Text|text='..nextPosLevel..'|x='..(tempRightX+100)..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
        tempRightY = tempRightY + 30
        local nextPropDescTable =  cfgEquipPosStrength[cfgNextKey].addprop_desctab
        for _, descItem in ipairs(nextPropDescTable) do
            sPanelStr = sPanelStr..'<Text|text='..descItem.desc..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            tempRightY = tempRightY + 30
        end
    end

    --等级限制和强化消耗
    local tempCurrY = math.max(tempLeftY, tempRightY)
    sPanelStr = sPanelStr..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..tempCurrY..'|color='..CSS.NPC_BLUE_LINE..'>'
    tempCurrX = CSS.NPC_LEFT_START_X + 30
    tempCurrY = tempCurrY + 20       
    local currPlayerLv = Player.GetLevel(actor)
    if not bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|text=等级限制：'..cfgEquipPosStrength[cfgCurrKey].needlv..'级/'..currPlayerLv..'级|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'
    end
    tempCurrY = tempCurrY + 30
    if not bCurrIsMaxLv then
        --local sConsumeInfo = BF_GetItemTableDescStr(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab)
        --sPanelStr = sPanelStr..'<Text|text=强化消耗：'..sConsumeInfo..'|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'
        sPanelStr = sPanelStr..'<Text|text=强化消耗：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'
        local sTempStr = ''
        sTempStr = Item.GetNeedItemsShowInfo(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, tempCurrX, tempCurrY, 170, 180, CSS.NPC_YELLOW)
        if sTempStr ~= '' then
            sPanelStr = sPanelStr..sTempStr
        end        
    end
    tempCurrY = tempCurrY + 20
    sPanelStr = sPanelStr..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..tempCurrY..'|color='..CSS.NPC_BLUE_LINE..'>'
    tempCurrY = tempCurrY + 50
    --升级按钮
    if bCurrIsMaxLv then
        sPanelStr = sPanelStr..'<Text|text=已达到最高强化等级！|x=100|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'    
    else
        sPanelStr = sPanelStr..'<Text|text=升级一次|x=50|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_12..'>'..
            --'<Text|text=一键至顶|x=220|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'|link=@equippos_strength_upgrade_currtop>'..
            '<Text|text=返回上一页|x=400|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_4..'>'
    end

    BF_NPCSayExt(actor, sPanelStr)
end

--装备位 强化一次
local function DoEquipPosStrengthUpgradeOnce(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipPosStrengthManager.IsValidEquipPosForStrength(equippos, 2) then
        return
    end
    local sid = ''..equippos
    
    local infoStr = getplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO)
    local infoTab = {}
    if infoStr ~= '' then
        infoTab = json2tbl(infoStr)
    end
    if infoTab[sid] == nil then
        infoTab[sid] = 0
        infoStr = tbl2json(infoTab)
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    end

    local curPosLevel = infoTab[sid]
    if curPosLevel < 0 then
        return
    end

    local nextPosLevel = curPosLevel + 1
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        return
    end
    local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosStrength[cfgNextKey] == nil then
        Player.SendSelfMsg(actor, '当前强化等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        return
    end

    --条件判断
    local currPlayerLv = Player.GetLevel(actor)
    if currPlayerLv < cfgEquipPosStrength[cfgCurrKey].needlv then
        Player.SendSelfMsg(actor, '强化所需角色等级不足！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        return
    end
    if not Player.CheckItemsEnough(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '强化') then
        return
    end

    --扣除消耗
    Player.TakeItems(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, '装备强化')
    --升级
    infoTab[sid] = nextPosLevel;
    infoStr = tbl2json(infoTab)
    setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, infoStr)
    ShowPanel6(actor, sid)
    Player.SendSelfMsg(actor, '强化成功！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)

    --每日必做计数      
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_BAOZHU, 1)              

    --更新当前装备位的强化状态
    EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, equippos)  
end



--回收宝珠
local function ShowPanel5(actor)
    local tempCurrX = CSS.NPC_LEFT_START_X
    local tempCurrY = CSS.NPC_TOP_START_Y
    local msg = '<Text|text=灵玉尊者:|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'..
                '<Text|text=你可以在这里进行灵玉的自动回收设置！|x='..(tempCurrX+100)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(tempCurrY+20)..'|color='..CSS.NPC_BLUE_LINE..'>'
    msg = msg..BaoZhuManager.GetRecycleCheckBoxInfo(actor, tempCurrX, tempCurrY+40)
    msg = msg..'<Text|text= - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - —— - |x=15|y='..(CSS.NPC_TOP_START_Y+200)..'|color='..CSS.NPC_BLUE_LINE..'>'    
    msg = msg..'<Text|text=返回上一层|x='..(CSS.NPC_LEFT_START_X+400)..'|y='..(CSS.NPC_TOP_START_Y+220)..'|color='..CSS.NPC_ORANGE..'|link=@baozhu_button_function,'..DO_FUNCTION_ID_3..'>'
    BF_NPCSayExt(actor,msg)
end

local function IsValidRecycleID(sid)
    if not BF_IsNumberStr(sid) then
        return false
    end

    local id = tonumber(sid)
    return BaoZhuManager.IsValidRecycleID(id)
end

--设置回收的品质
local function DoSetRecycleQuality(actor, sparam)
    if BF_IsNullObj(actor) or (sparam == nil) then
        return
    end
    if not IsValidRecycleID(sparam) then
        return
    end

    BaoZhuManager.SetRecycleQuality(actor, tonumber(sparam))
    ShowPanel5(actor)
end

--设置保留更好的宝珠
local function DoSetKeepBetter(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local tempvar = 0
    if BF_IsLocalTestServer() then
        tempvar = getplaydef(actor, CommonDefine.VAR_N_NPC_CHECKBOX_10)
    else
        local stemp = getconst(actor, '<$NPCPARAMS(2,'..CommonDefine.VAR_N_NPC_CHECKBOX_10..')>')
        tempvar = tonumber(stemp)        
    end      

    if (tempvar==1) or (tempvar==0) then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER, tempvar)
    end  
    ShowPanel5(actor)
end

function BaoZhuManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or (not BF_IsNumberStr(sid)) then
        return
    end
    local funcid = tonumber(sid)
    if funcid == DO_FUNCTION_ID_1 then
        ShowPanel1(actor)
    elseif funcid == DO_FUNCTION_ID_2 then
        ShowPanel2(actor)
    elseif funcid == DO_FUNCTION_ID_3 then
        ShowPanel3(actor)
    elseif funcid == DO_FUNCTION_ID_4 then
        ShowPanel4(actor)
    elseif funcid == DO_FUNCTION_ID_5 then
        openhyperlink(actor, 6)
    elseif funcid == DO_FUNCTION_ID_6 then
        BaoZhuManager.QuickTakeOn(actor)
    elseif funcid == DO_FUNCTION_ID_7 then
        BaoZhuManager.QuickTakeOff(actor)
    elseif funcid == DO_FUNCTION_ID_8 then
        ShowPanel5(actor)
    elseif funcid == DO_FUNCTION_ID_9 then
        ShowPanel6(actor, sparam)
    elseif funcid == DO_FUNCTION_ID_10 then
        DoSetRecycleQuality(actor, sparam)
    elseif funcid == DO_FUNCTION_ID_11 then
        DoSetKeepBetter(actor)
    elseif funcid == DO_FUNCTION_ID_12 then
        DoEquipPosStrengthUpgradeOnce(actor)
    end
end

---------------------------------------------------------------小红点相关----------------------------------------------
--是否有快捷提示
function BaoZhuManager.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, false) then
        return false
    end

    --这里的功能还需要进一步处理！！！！！

    return false
end

return BaoZhuManager