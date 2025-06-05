BaoZhuManagerNew = {}

local DO_FUNCTION_ID_1 = 1      --显示灵玉宝盒  穿戴
local DO_FUNCTION_ID_2 = 2      --灵玉的规则说明面板
local DO_FUNCTION_ID_3 = 3      --灵玉强化面板
local DO_FUNCTION_ID_4 = 4      --灵玉回收面板
local DO_FUNCTION_ID_5 = 5      --快捷穿戴
local DO_FUNCTION_ID_6 = 6      --全部脱下
local DO_FUNCTION_ID_7 = 7      --选择要分解的灵玉
local DO_FUNCTION_ID_8 = 8      --手动分解灵玉
local DO_FUNCTION_ID_9 = 9      --打开自动分解的面板

local DO_FUNCTION_ID_10 = 10    --灵玉回收设置品质
local DO_FUNCTION_ID_11 = 11    --设置保留更好的宝珠
local DO_FUNCTION_ID_12 = 12    --灵玉单件单次强化
local DO_FUNCTION_ID_13 = 13    --穿戴单件灵玉
local DO_FUNCTION_ID_14 = 14    --脱下单件灵玉
local DO_FUNCTION_ID_15 = 15    --灵玉宝盒的背包   上一页
local DO_FUNCTION_ID_16 = 16    --灵玉宝盒的背包   下一页
local DO_FUNCTION_ID_17 = 17    --灵玉宝盒里选择灵玉的槽位
local DO_FUNCTION_ID_18 = 18    --灵玉强化里选择灵玉的槽位
local DO_FUNCTION_ID_19 = 19    --灵玉分解里选择灵玉的槽位
local DO_FUNCTION_ID_20 = 20    --灵玉分解的背包   上一页
local DO_FUNCTION_ID_21 = 21    --灵玉分解的背包   下一页

local RecycleSettingPanelCfg = {
    {id=1, tip='白色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_WHITE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_1, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_1},
    {id=2, tip='绿色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GREEN, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_2, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_2},
    {id=3, tip='蓝色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_BLUE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_3, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_3},
    {id=4, tip='紫色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PURPLE, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_4, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_4},
    {id=5, tip='粉色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_PINK, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_5, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_5},
    {id=6, tip='橙色灵玉', qualitylv=CommonDefine.ITEM_QUALITY_GOLD, tempvar=CommonDefine.VAR_N_NPC_CHECKBOX_6, flagvar=CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_6},
}

local BAOZHU_BASE_CFG = {
    [1] = {stdmode = 100, pos=CommonDefine.EQUIPPOS_SSH_1, posname = '鼠灵玉位'},
    [2] = {stdmode = 101, pos=CommonDefine.EQUIPPOS_SSH_2, posname = '牛灵玉位'},
    [3] = {stdmode = 102, pos=CommonDefine.EQUIPPOS_SSH_3, posname = '虎灵玉位'},
    [4] = {stdmode = 103, pos=CommonDefine.EQUIPPOS_SSH_4, posname = '兔灵玉位'},
    [5] = {stdmode = 104, pos=CommonDefine.EQUIPPOS_SSH_5, posname = '龙灵玉位'},
    [6] = {stdmode = 105, pos=CommonDefine.EQUIPPOS_SSH_6, posname = '蛇灵玉位'},
    [7] = {stdmode = 106, pos=CommonDefine.EQUIPPOS_SSH_7, posname = '马灵玉位'},
    [8] = {stdmode = 107, pos=CommonDefine.EQUIPPOS_SSH_8, posname = '羊灵玉位'},
    [9] = {stdmode = 108, pos=CommonDefine.EQUIPPOS_SSH_9, posname = '猴灵玉位'},
    [10] = {stdmode = 109, pos=CommonDefine.EQUIPPOS_SSH_10, posname = '鸡灵玉位'},
    [11] = {stdmode = 110, pos=CommonDefine.EQUIPPOS_SSH_11, posname = '狗灵玉位'},
    [12] = {stdmode = 111, pos=CommonDefine.EQUIPPOS_SSH_12, posname = '猪灵玉位'},
}

--每页的格子数量
local BAG_ITEM_COUNT_PER_PAGE1 = 21
local BAG_ITEM_COUNT_PER_PAGE2 = 24

local function GetRecycleCfg(id)
    for _, value in ipairs(RecycleSettingPanelCfg) do
        if value.id == id then
            return value
        end
    end
    return nil
end

--是否为有效的强化装备位
function BaoZhuManagerNew.IsValidRecycleID(id)
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

--根据宝珠的stdmode返回equippos
local function GetBaoZhuEquipPosByStdMode(stdmode)
    local pos = 0
    for _, value in ipairs(BAOZHU_BASE_CFG) do
        if value.stdmode == stdmode then
            pos = value.pos
            break
        end
    end
    return pos
end

--返回背包中[min,max]的, 灵玉道具ID字符串  ,  分割
--返回是否已搜索完毕的标记
local function GetBagBaoZhuItemIDStr(actor, min, max)
    local strItemList = ''
    local bFinished = true
    if BF_IsNullObj(actor) then
        return strItemList, bFinished	
    end

    local currValidItemIDList = {}
    local nValidItemCounter = 0
    local item_num = getbaseinfo(actor, CommonDefine.INFO_HUMBAGITEMNUM)
    for i=0, item_num-1 do
        local itemobj = getiteminfobyindex(actor, i)
        if not BF_IsNullObj(itemobj) then
            local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
            local itemStdmode = getstditeminfo(itemidx, CommonDefine.STDITEMINFO_STDMODE)
            if (itemStdmode >= 100) and (itemStdmode <= 111) then
                nValidItemCounter = nValidItemCounter + 1
                if nValidItemCounter >= min then
                    if nValidItemCounter > max then
                        bFinished = false
                        break
                    end					
                    if not currValidItemIDList[itemidx] then
                        currValidItemIDList[itemidx] = true
                        if strItemList ~= '' then
                            strItemList = strItemList..','
                        end
                        strItemList = strItemList..itemidx						
                    end	
                end
            end		
        end
    end
    return strItemList, bFinished
end

--穿戴单个宝珠
local function TakeOnSingleBaoZhu(actor)
    if BF_IsNullObj(actor) then
        return
    end

	local strSelectItem1 = getplaydef(actor, CommonDefine.VAR_S_SELECT_ITEM)
	if not BF_IsNumberStr(strSelectItem1) then
		return
	end
    local itemmakeindex = tonumber(strSelectItem1)
    local baozhuitemobj = Bag.GetItemByMakeindex(actor, itemmakeindex)
    if not BF_IsNullObj(baozhuitemobj) then
        local itemid = getiteminfo(actor, baozhuitemobj, CommonDefine.ITEMINFO_ITEMIDX)
        local stdmode = getstditeminfo(itemid, CommonDefine.STDITEMINFO_STDMODE)
        local pos = GetBaoZhuEquipPosByStdMode(stdmode)
        takeonitem(actor, pos, itemmakeindex)
    end	
end

--脱下单个宝珠
local function TakeOffSingleBaoZhu(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if (chooseid >= 1) and (chooseid <= #BAOZHU_BASE_CFG) then
        takeoffitem(actor, BAOZHU_BASE_CFG[chooseid].pos)
    end
end

--快速穿戴灵玉
function BaoZhuManagerNew.QuickTakeOn(actor)
    local takeonobjids = {}
	local item_num = getbaseinfo(actor, CommonDefine.INFO_HUMBAGITEMNUM)
    local baozhuStdmodeStart = BAOZHU_BASE_CFG[1].stdmode
    local baozhuStdmodeEnd = BAOZHU_BASE_CFG[#BAOZHU_BASE_CFG].stdmode
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
function BaoZhuManagerNew.QuickTakeOff(actor)
    for i = CommonDefine.EQUIPPOS_SSH_1, CommonDefine.EQUIPPOS_SSH_12, 1 do
        local itemobj = linkbodyitem(actor, i)
        if not BF_IsNullObj(itemobj) then
            local makeindex = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
            nothintitem(actor, 1, makeindex)
            takeoffitem(actor, i)
        end        
    end        
end

--返回回收宝珠的复选框和信息
function BaoZhuManagerNew.GetRecycleCheckBoxInfo(actor, nStartX, nStartY)
    local strPanelInfo = ''
    local srcStartY = nStartY
    local currid = 40
    local stridlist = ''
    local keepflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
    strPanelInfo = strPanelInfo..'<CheckBox|x='..(nStartX+210)..'|y='..(srcStartY+50)..'|id='..(currid+1)..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..CommonDefine.VAR_N_NPC_CHECKBOX_10..
        '|default='..keepflag..'|delay=0|count=1|link=@function_button,'..DO_FUNCTION_ID_11..'>'..
        '<Text|id='..(currid+2)..'|text=保留比当前穿戴灵玉更好的|x='..(nStartX+240)..'|y='..(srcStartY+55)..'|color='..CSS.NPC_WHITE..'>'  
    stridlist = stridlist..','..(currid+1)..','..(currid+2)
    currid = currid + 2
    for _, cfginfo in ipairs(RecycleSettingPanelCfg) do
        local flag = getflagstatus(actor, cfginfo.flagvar)
        local color = CSS.GetQualityColor(cfginfo.qualitylv)        
        strPanelInfo = strPanelInfo..'<CheckBox|x='..nStartX..'|y='..nStartY..'|id='..(currid+1)..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..
            cfginfo.tempvar..'|default='..flag..'|delay=0|count=1|link=@function_button,'..DO_FUNCTION_ID_10..','..cfginfo.id..'>'..
            '<Text|id='..(currid+2)..'|text=自动回收'..cfginfo.tip..'|x='..(nStartX+30)..'|y='..(nStartY+5)..'|color='..color..'>'            
        stridlist = stridlist..','..(currid+1)..','..(currid+2)
        currid = currid + 2
        nStartY = nStartY + 25
    end    

    strPanelInfo = strPanelInfo..'<Layout|id=22|children={'..stridlist..'}|x=20.0|y=80.0|width=480|height=200>'
    return strPanelInfo
end

--设置玩家回收宝珠的品质
function BaoZhuManagerNew.SetRecycleQuality(actor, recycleid)
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
function BaoZhuManagerNew.DoAutoRecycleBaoZhu(actor, itemobj, makeindex)
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then 
        return
    end
    local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
    local cfgItem = cfg_item[itemidx]
    if cfgItem == nil then
        return
    end
    local cfgSimpleRecycle = cfgItemSimpleRecycle[itemidx]
    if cfgSimpleRecycle == nil then
        return
    end

    if (cfgItem.StdMode >= BAOZHU_BASE_CFG[1].stdmode) and (cfgItem.StdMode <= BAOZHU_BASE_CFG[#BAOZHU_BASE_CFG].stdmode) then
        for _, recycleCfg in ipairs(RecycleSettingPanelCfg) do
            if recycleCfg.qualitylv == cfgItem.QualityLv then                
                local flag = getflagstatus(actor, recycleCfg.flagvar)                         
                if flag == 1 then                 
                    --选中自动回收当前品质宝珠
                    local keepbetterflag = getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER)
                    if keepbetterflag == 1 then                                        
                        --选中保留比穿戴更好的宝珠
                        local equippos = GetBaoZhuEquipPosByStdMode(cfgItem.StdMode)
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
                    local givebackitems = BF_GetItemTabMulti(cfgSimpleRecycle.giveitems_tab, itemcount)
                    Player.GiveItemsToBagOrMail(actor, givebackitems, '灵玉自动分解')
                end
                break     
            end
        end
    end
end

--玩家登录时触发
function BaoZhuManagerNew.OnPlayerEnterGame(actor)	
	--开启生肖宝盒的功能  这个后面可以调整到升级或其它地方触发
	setsndaitembox(actor, 1)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, BaoZhuManagerNew.OnPlayerEnterGame, CommonDefine.FUNC_ID_BAOZHU)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, BaoZhuManagerNew.DoAutoRecycleBaoZhu, CommonDefine.FUNC_ID_BAOZHU)


---------------------------------------------------------------界面显示相关--------------------------------------------

--初始面板 灵玉宝盒
function BaoZhuManagerNew.ShowBasePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,13,20,21,22,25,26,27}|x=20.0|y=16.0|img=private/cc_baozhu/7.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
		'<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@function_button,'..DO_FUNCTION_ID_2..'>'..
        '<Button|id=25|x=16.0|children={221,222}|y=133.0|pimg=private/cc_baozhu/2.png|color=255|nimg=private/cc_baozhu/1.png|size=18|mimg=private/cc_baozhu/2.png>'..
        '<Button|id=26|x=16.0|children={231,232}|y=222.0|width=30|height=96|nimg=private/cc_baozhu/2.png|size=18|mimg=private/cc_baozhu/2.png|pimg=private/cc_baozhu/1.png|color=255|link=@function_button,'..DO_FUNCTION_ID_3..'>'..
        '<Button|id=27|ax=0|x=16.0|y=310.0|children={241,242}|width=30|height=96|nimg=private/cc_baozhu/2.png|pimg=private/cc_baozhu/1.png|size=18|color=255|mimg=private/cc_baozhu/2.png|link=@function_button,'..DO_FUNCTION_ID_4..'>'..
        '<Text|id=221|x=9.0|y=9.0|color=161|size=20|text=宝>'..
        '<Text|id=222|x=9.0|y=45.0|color=161|size=20|text=盒>'..
        '<Text|id=231|x=9.0|y=9.0|color=161|size=20|text=强>'..
        '<Text|id=232|x=9.0|y=45.0|color=161|size=20|text=化>'..
        '<Text|id=241|x=9.0|y=9.0|color=161|size=20|text=回>'..
        '<Text|id=242|x=9.0|y=45.0|color=161|size=20|text=收>'        

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if (chooseid < 1) or (chooseid > #BAOZHU_BASE_CFG) then
        chooseid = 1
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
    end

    local equipshowid = 40
    local equipshowidstr = ''
    for i = 1, #BAOZHU_BASE_CFG, 1 do
        local tempid = equipshowid + i
        if equipshowidstr ~= '' then
            equipshowidstr = equipshowidstr..','
        end
        equipshowidstr = equipshowidstr..tempid
        local tempx = 6 + 83 * ((i-1) % 3)
        local tempy = 4 + 88 * math.floor((i-1) / 3)
        if chooseid == i then
            strPanelInfo = strPanelInfo..'<Img|id=40|x=0|y=0|img=private/cc_baozhu/3.png>'
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|children={40}|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_17..','..i..'>'
        else
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_17..','..i..'>'
        end        
    end
    strPanelInfo = strPanelInfo..'<Text|id=29|text=单击选择灵玉位|x=50|y=400|size=20|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=20|children={29,'..equipshowidstr..'}|x=66.0|y=56.0|width=248|height=440>'

    --背包道具
    local currPageNo = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currPageNo <= 0 then
        currPageNo = 1
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currPageNo)
    end

    local nTempMin = (currPageNo - 1) * BAG_ITEM_COUNT_PER_PAGE1 + 1
    local nTempMax = currPageNo * BAG_ITEM_COUNT_PER_PAGE1
    local targstdmode = BAOZHU_BASE_CFG[chooseid].stdmode
    local sValidItemIDList, bDataFinished = Bag.GetBagItemIDInStdmodeStr(actor, targstdmode, 0, nTempMin, nTempMax)
    strPanelInfo = strPanelInfo..'<BAGITEMS|id=31|x=18|y=8|select=|filter3='..sValidItemIDList..'|count='..BAG_ITEM_COUNT_PER_PAGE1..
        '|showtips=1|selecttype=1|row=7|iwidth=50|iheight=50|dblink=@function_button,'..DO_FUNCTION_ID_13..'>'

    if currPageNo > 1 then
        strPanelInfo = strPanelInfo..'<Button|id=32|x=4.0|y=360|nimg=private/cc_rank_ui/6.png|link=@function_button,'..DO_FUNCTION_ID_15..'>'
    end
    if not bDataFinished then
        strPanelInfo = strPanelInfo..'<Button|id=33|x=160.0|y=360|nimg=private/cc_rank_ui/7.png|link=@function_button,'..DO_FUNCTION_ID_16..'>'
    end
    strPanelInfo = strPanelInfo..'<Text|id=34|text=双击穿戴灵玉|x=30|y=400|size=20|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=21|children={31,32,33,34}|x=606.0|y=56.0|width=180|height=440>'

    --槽位对应
    strPanelInfo = strPanelInfo..'<EquipShow|id=91|x=102.0|y=110.0|showtips=1|reload=1|index='..BAOZHU_BASE_CFG[chooseid].pos..'>'
    strPanelInfo = strPanelInfo..'<Text|id=92|text='..BAOZHU_BASE_CFG[chooseid].posname..'|x=86|y=20|size=25|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Button|id=93|x=80.0|y=290.0|size=18|color=255|text=单件脱下|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_14..'>'
    strPanelInfo = strPanelInfo..'<Button|id=94|x=80.0|y=340.0|size=18|color=255|text=一键穿戴|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_5..'>'
    strPanelInfo = strPanelInfo..'<Button|id=95|x=80.0|y=390.0|size=18|color=255|text=全部脱下|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_6..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=22|children={91,92,93,94,95}|x=320.0|y=56.0|width=270|height=440>'    

    BF_ShowSpecialUI(actor, strPanelInfo)
end

--规则说明面板
local function ShowPanel2(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@function_button,'..DO_FUNCTION_ID_1..'>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@function_button,'..DO_FUNCTION_ID_1..'>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=灵玉系统规则说明：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、灵玉共分为{白绿蓝紫粉橙红}七种品质，每种品质分为|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=三种星级，每种星级分为12种生肖的部位。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、相同品质相同星级的灵玉可以每3、6、9、12件穿戴激|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=活对应的套装属性。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'    
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=3、灵玉为独立的属性加成系统，其所增加的属性将会直接|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=加成到主角面板。|x='..(tempCurrX+26)..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

--灵玉强化的面板
local function ShowPanel3(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,13,20,21,25,26,27}|x=20.0|y=16.0|img=private/cc_baozhu/9.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
		'<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@function_button,'..DO_FUNCTION_ID_2..'>'..
        '<Button|id=25|x=16.0|children={221,222}|y=133.0|pimg=private/cc_baozhu/1.png|color=255|nimg=private/cc_baozhu/2.png|size=18|mimg=private/cc_baozhu/1.png|link=@function_button,'..DO_FUNCTION_ID_1..'>'..
        '<Button|id=26|x=16.0|children={231,232}|y=222.0|width=30|height=96|nimg=private/cc_baozhu/1.png|size=18|mimg=private/cc_baozhu/1.png|pimg=private/cc_baozhu/2.png|color=255>'..
        '<Button|id=27|ax=0|x=16.0|y=310.0|children={241,242}|width=30|height=96|nimg=private/cc_baozhu/2.png|pimg=private/cc_baozhu/1.png|size=18|color=255|mimg=private/cc_baozhu/2.png|link=@function_button,'..DO_FUNCTION_ID_4..'>'..
        '<Text|id=221|x=9.0|y=9.0|color=161|size=20|text=宝>'..
        '<Text|id=222|x=9.0|y=45.0|color=161|size=20|text=盒>'..
        '<Text|id=231|x=9.0|y=9.0|color=161|size=20|text=强>'..
        '<Text|id=232|x=9.0|y=45.0|color=161|size=20|text=化>'..
        '<Text|id=241|x=9.0|y=9.0|color=161|size=20|text=回>'..
        '<Text|id=242|x=9.0|y=45.0|color=161|size=20|text=收>'        

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if (chooseid < 1) or (chooseid > #BAOZHU_BASE_CFG) then
        chooseid = 1
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
    end

    --槽位对应
    local equipshowid = 40
    local equipshowidstr = ''
    for i = 1, #BAOZHU_BASE_CFG, 1 do
        local tempid = equipshowid + i
        if equipshowidstr ~= '' then
            equipshowidstr = equipshowidstr..','
        end
        equipshowidstr = equipshowidstr..tempid
        local tempx = 6 + 83 * ((i-1) % 3)
        local tempy = 4 + 88 * math.floor((i-1) / 3)
        if chooseid == i then
            strPanelInfo = strPanelInfo..'<Img|id=40|x=0|y=0|img=private/cc_baozhu/3.png>'
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|children={40}|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_18..','..i..'>'
        else
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_18..','..i..'>'
        end        
    end
    strPanelInfo = strPanelInfo..'<Text|id=29|text=单击选择灵玉位|x=50|y=400|size=20|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=20|children={29,'..equipshowidstr..'}|x=66.0|y=56.0|width=248|height=440>'

    --强化信息
    local equippos = BAOZHU_BASE_CFG[chooseid].pos
    local sid = equippos..''
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
    local bJob = Player.GetJob(actor)
    local cfgCurrKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, curPosLevel)
    if cfgEquipPosStrength[cfgCurrKey] == nil then
        --异常日志记录！！！！
        release_print("equippos_strength_panel no config key:"..cfgCurrKey)
        return
    end
    local cfgNextKey = EquipPosStrengthManager.GetStrengthCfgKey(bJob, equippos, nextPosLevel)
    if cfgEquipPosStrength[cfgNextKey] == nil then
        bCurrIsMaxLv = true
    end

    --当前等级属性
    local tempLeftX = 50
    local tempLeftY = 90
    local tempidstr = '91,92,93,94,101,102,103,104,105,106'
    local tempid = 120
    strPanelInfo = strPanelInfo..'<Text|id=101|text=当前等级：|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_YELLOW..'>'..
                           '<Text|id=102|text='..curPosLevel..'|x='..(tempLeftX+100)..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
    tempLeftY = tempLeftY + 30
    local currPropDescTable = cfgEquipPosStrength[cfgCurrKey].addprop_desctab    

    for _, descItem in ipairs(currPropDescTable) do
        strPanelInfo = strPanelInfo..'<Text|id='..tempid..'|text='..descItem.desc..'|x='..tempLeftX..'|y='..tempLeftY..'|color='..CSS.NPC_WHITE..'>'
        tempidstr = tempidstr..','..tempid
        tempid = tempid + 1        
        tempLeftY = tempLeftY + 30
    end
    --下一等级属性
    local tempRightX = 300
    local tempRightY = 90
    if bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=103|text=已达到等级上限|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'
        tempRightY = tempRightY + 30
    else
        strPanelInfo = strPanelInfo..'<Text|id=103|text=下一等级：|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_YELLOW..'>'..
                                '<Text|id=104|text='..nextPosLevel..'|x='..(tempRightX+100)..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
        tempRightY = tempRightY + 30
        local nextPropDescTable =  cfgEquipPosStrength[cfgNextKey].addprop_desctab
        for _, descItem in ipairs(nextPropDescTable) do
            strPanelInfo = strPanelInfo..'<Text|id='..tempid..'|text='..descItem.desc..'|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'
            tempidstr = tempidstr..','..tempid
            tempid = tempid + 1            
            tempRightY = tempRightY + 30
        end
    end

    --等级限制和强化消耗
    local tempCurrY = math.max(tempLeftY, tempRightY)
    local tempCurrX = 50
    tempCurrY = tempCurrY + 80       
    local currPlayerLv = Player.GetLevel(actor)
    if not bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=105|text=等级限制：'..cfgEquipPosStrength[cfgCurrKey].needlv..'级/'..currPlayerLv..'级|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'
    end
    tempCurrY = tempCurrY + 30
    if not bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=106|text=强化消耗：|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_YELLOW..'>'
        local sTempStr = ''
        local s1 = ''
        sTempStr, s1 = Item.GetNeedItemsShowInfo(actor, cfgEquipPosStrength[cfgCurrKey].needitems_tab, tempCurrX, tempCurrY, 170, 180, CSS.NPC_YELLOW)
        if sTempStr ~= '' then
            strPanelInfo = strPanelInfo..sTempStr
        end
        if s1 ~= '' then
            tempidstr = tempidstr..','..s1
        end
    end
    tempCurrY = tempCurrY + 20

    --强化按钮
    strPanelInfo = strPanelInfo..'<Text|id=92|text='..BAOZHU_BASE_CFG[chooseid].posname..'|x=180|y=50|size=25|color='..CSS.NPC_YELLOW..'>'
    if bCurrIsMaxLv then
        strPanelInfo = strPanelInfo..'<Text|id=93|text=已达到最高强化等级！|x=150|y=350|color='..CSS.NPC_LIGHTGREEN..'>'    
    else
        strPanelInfo = strPanelInfo..'<Button|id=93|x=50.0|y=350.0|size=18|color=255|text=强化一次|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_12..'>'
        strPanelInfo = strPanelInfo..'<Button|id=94|x=300.0|y=350.0|size=18|color=255|text=强化十次|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_12..'>'
    end
    strPanelInfo = strPanelInfo..'<Layout|id=21|children={'..tempidstr..'}|x=320.0|y=56.0|width=470|height=440>'

    BF_ShowSpecialUI(actor, strPanelInfo)  
end

--装备位 强化一次
local function DoEquipPosStrengthUpgradeOnce(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, false) then
        return
    end

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if (chooseid <= 0) or (chooseid >= #BAOZHU_BASE_CFG) then
        return
    end

    local equippos = BAOZHU_BASE_CFG[chooseid].pos
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
        Player.SendSelfMsg(actor, '当前强化等级已达到上限！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    local currPlayerLv = Player.GetLevel(actor)
    if currPlayerLv < cfgEquipPosStrength[cfgCurrKey].needlv then
        Player.SendSelfMsg(actor, '强化所需角色等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
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
    Player.SendSelfMsg(actor, '强化成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)

    --更新当前装备位的强化状态
    EquipPosStrengthManager.UpdateEquipStrengthLvInPos(actor, equippos)  
end

--回收宝珠面板
local function ShowPanel4(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,13,20,21,25,26,27}|x=20.0|y=16.0|img=private/cc_baozhu/13.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
		'<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@function_button,'..DO_FUNCTION_ID_2..'>'..
        '<Button|id=25|x=16.0|children={221,222}|y=133.0|pimg=private/cc_baozhu/1.png|color=255|nimg=private/cc_baozhu/2.png|size=18|mimg=private/cc_baozhu/1.png|link=@function_button,'..DO_FUNCTION_ID_1..'>'..
        '<Button|id=26|x=16.0|children={231,232}|y=222.0|width=30|height=96|nimg=private/cc_baozhu/2.png|size=18|mimg=private/cc_baozhu/2.png|pimg=private/cc_baozhu/1.png|color=255|link=@function_button,'..DO_FUNCTION_ID_3..'>'..
        '<Button|id=27|ax=0|x=16.0|y=310.0|children={241,242}|width=30|height=96|nimg=private/cc_baozhu/1.png|pimg=private/cc_baozhu/2.png|size=18|color=255|mimg=private/cc_baozhu/1.png>'..
        '<Text|id=221|x=9.0|y=9.0|color=161|size=20|text=宝>'..
        '<Text|id=222|x=9.0|y=45.0|color=161|size=20|text=盒>'..
        '<Text|id=231|x=9.0|y=9.0|color=161|size=20|text=强>'..
        '<Text|id=232|x=9.0|y=45.0|color=161|size=20|text=化>'..
        '<Text|id=241|x=9.0|y=9.0|color=161|size=20|text=回>'..
        '<Text|id=242|x=9.0|y=45.0|color=161|size=20|text=收>'        

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if (chooseid < 1) or (chooseid > #BAOZHU_BASE_CFG) then
        chooseid = 1
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
    end

    local equipshowid = 40
    local equipshowidstr = ''
    for i = 1, #BAOZHU_BASE_CFG, 1 do
        local tempid = equipshowid + i
        if equipshowidstr ~= '' then
            equipshowidstr = equipshowidstr..','
        end
        equipshowidstr = equipshowidstr..tempid
        local tempx = 6 + 83 * ((i-1) % 3)
        local tempy = 4 + 88 * math.floor((i-1) / 3)
        if chooseid == i then
            strPanelInfo = strPanelInfo..'<Img|id=40|x=0|y=0|img=private/cc_baozhu/3.png>'
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|children={40}|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_19..','..i..'>'
        else
            strPanelInfo = strPanelInfo..'<Layout|id='..tempid..'|x='..tempx..'|y='..tempy..'|width=70|height=70|link=@function_button,'..DO_FUNCTION_ID_19..','..i..'>'
        end        
    end
    strPanelInfo = strPanelInfo..'<Text|id=29|text=单击选择灵玉位|x=50|y=400|size=20|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=20|children={29,'..equipshowidstr..'}|x=66.0|y=56.0|width=248|height=440>'

    --背包道具
    local currPageNo = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currPageNo <= 0 then
        currPageNo = 1
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currPageNo)
    end

    local strSelectItem1 = getplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS)
    local nTempMin = (currPageNo - 1) * BAG_ITEM_COUNT_PER_PAGE2 + 1
    local nTempMax = currPageNo * BAG_ITEM_COUNT_PER_PAGE2
    local targstdmode = BAOZHU_BASE_CFG[chooseid].stdmode
    local sValidItemIDList, bDataFinished = Bag.GetBagItemIDInStdmodeStr(actor, targstdmode, 0, nTempMin, nTempMax)
    strPanelInfo = strPanelInfo..'<BAGITEMS|id=31|x=30|y=30|select='..strSelectItem1..'|filter3='..sValidItemIDList..'|count='..BAG_ITEM_COUNT_PER_PAGE2..
        '|showtips=0|selecttype=0|row=4|dblink=@function_button,'..DO_FUNCTION_ID_7..'>'

    if currPageNo > 1 then
        strPanelInfo = strPanelInfo..'<Button|id=32|x=30.0|y=340|nimg=private/cc_rank_ui/6.png|link=@function_button,'..DO_FUNCTION_ID_20..'>'
    end
    if not bDataFinished then
        strPanelInfo = strPanelInfo..'<Button|id=33|x=420.0|y=340|nimg=private/cc_rank_ui/7.png|link=@function_button,'..DO_FUNCTION_ID_21..'>'
    end
    strPanelInfo = strPanelInfo..'<Text|id=34|text=双击选择要分解的灵玉|x=160|y=340|size=18|color='..CSS.NPC_YELLOW..'>'
    strPanelInfo = strPanelInfo..'<Button|id=93|x=60.0|y=390.0|size=18|color=255|text=设置自动分解|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_9..'>'
    strPanelInfo = strPanelInfo..'<Button|id=94|x=300.0|y=390.0|size=18|color=255|text=进行分解|nimg=private/cc_common/button_up.png|pimg=private/cc_common/button_down.png|mimg=private/cc_common/button_down.png|link=@function_button,'..DO_FUNCTION_ID_8..'>'
    strPanelInfo = strPanelInfo..'<Layout|id=21|children={31,32,33,34,93,94}|x=320.0|y=56.0|width=470|height=440>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function DoSelectDecomposeItem(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local strNewSelectItem = getplaydef(actor, CommonDefine.VAR_S_SELECT_ITEM) 
    local nSelectItemMakeIndex = tonumber(strNewSelectItem)
    local selectItemObj = Bag.GetItemByMakeindex(actor, nSelectItemMakeIndex)
    if BF_IsNullObj(selectItemObj) then
        return
    end
    local strOldSelectItemList = getplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS)
    local tabStrTempList = string.split(strOldSelectItemList, ',')
    local strFinalSelectStr = ''
    local bFind = false
    if tabStrTempList ~= false then
        if #tabStrTempList > 10 then
            Player.SendSelfMsg(actor, '单次不超过10种灵玉！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return
        end        
        for _, value in ipairs(tabStrTempList) do
            if BF_IsNumberStr(value) then
                local makeindex = tonumber(value)
                if makeindex == nSelectItemMakeIndex then
                    bFind = true
                else
                    if strFinalSelectStr ~= '' then
                        strFinalSelectStr = strFinalSelectStr..','
                    end
                    strFinalSelectStr = strFinalSelectStr..makeindex
                end                
            end
        end
        if bFind == false then
            if strFinalSelectStr ~= '' then
                strFinalSelectStr = strFinalSelectStr..','
            end
            strFinalSelectStr = strFinalSelectStr..nSelectItemMakeIndex        
        end
    end    
    setplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS, strFinalSelectStr)
end

--手动批量回收宝珠
local function DoDecomposeSelectItems(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local strOldSelectItemList = getplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS)
    local tabStrTempList = string.split(strOldSelectItemList, ',')
    if tabStrTempList ~= false then
        for _, value in ipairs(tabStrTempList) do
            if BF_IsNumberStr(value) then
                local makeindex = tonumber(value)
                local itemobj = Bag.GetItemByMakeindex(actor, makeindex)
                if not BF_IsNullObj(itemobj) then
                    local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
                    local cfgSimpleRecycle = cfgItemSimpleRecycle[itemidx]
                    if cfgSimpleRecycle ~= nil then
                        local itemcount = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
                        itemcount = math.max(1, itemcount)
                        delitembymakeindex(actor, makeindex, itemcount, '灵玉手动分解')
                        local tempitems = BF_GetItemTabMulti(cfgSimpleRecycle.giveitems_tab, itemcount)
                        Player.GiveItemsToBagOrMail(actor, tempitems, '灵玉手动分解')                    
                    end                                
                end                
            end
        end
    end    
    setplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS, '')
end

--设置自动回收宝珠
local function ShowPanel5(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@function_button,'..DO_FUNCTION_ID_4..'>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@function_button,'..DO_FUNCTION_ID_4..'>'

    strPanelInfo = strPanelInfo..'<Text|id=21|text=灵玉自动回收|x=200|y=50|size=20|color='..CSS.NPC_LIGHTGREEN..'>'
    strPanelInfo = strPanelInfo..BaoZhuManagerNew.GetRecycleCheckBoxInfo(actor, 20, 20)

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function IsValidRecycleID(sid)
    if not BF_IsNumberStr(sid) then
        return false
    end

    local id = tonumber(sid)
    return BaoZhuManagerNew.IsValidRecycleID(id)
end

--设置回收的品质
local function DoSetRecycleQuality(actor, sparam)
    if BF_IsNullObj(actor) or (sparam == nil) then
        return
    end
    if not IsValidRecycleID(sparam) then
        return
    end

    BaoZhuManagerNew.SetRecycleQuality(actor, tonumber(sparam))
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

function BaoZhuManagerNew.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or (not BF_IsNumberStr(sid)) then
        return
    end
    local funcid = tonumber(sid)
    if funcid == DO_FUNCTION_ID_1 then
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_2 then
        ShowPanel2(actor)
    elseif funcid == DO_FUNCTION_ID_3 then
        ShowPanel3(actor)
    elseif funcid == DO_FUNCTION_ID_4 then
        setplaydef(actor, CommonDefine.VAR_S_SELECT_DECOMPOSE_ITEMS, '')
        ShowPanel4(actor)
    elseif funcid == DO_FUNCTION_ID_5 then
        BaoZhuManagerNew.QuickTakeOn(actor)
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_6 then
        BaoZhuManagerNew.QuickTakeOff(actor)
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_7 then      
		DoSelectDecomposeItem(actor)
		ShowPanel4(actor)
    elseif funcid == DO_FUNCTION_ID_8 then
        DoDecomposeSelectItems(actor)
        ShowPanel4(actor)
    elseif funcid == DO_FUNCTION_ID_9 then
        ShowPanel5(actor)
    elseif funcid == DO_FUNCTION_ID_10 then
        DoSetRecycleQuality(actor, sparam)
    elseif funcid == DO_FUNCTION_ID_11 then
        DoSetKeepBetter(actor)
    elseif funcid == DO_FUNCTION_ID_12 then
        DoEquipPosStrengthUpgradeOnce(actor)
        ShowPanel3(actor)
    elseif funcid == DO_FUNCTION_ID_13 then
        TakeOnSingleBaoZhu(actor)
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_14 then
        TakeOffSingleBaoZhu(actor)
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_15 then
        local currpage = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)       
        if currpage > 0 then
            setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currpage - 1)
            BaoZhuManagerNew.ShowBasePanel(actor)
        end
    elseif funcid == DO_FUNCTION_ID_16 then
        local currpage = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)       
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currpage + 1)        
        BaoZhuManagerNew.ShowBasePanel(actor)
    elseif funcid == DO_FUNCTION_ID_17 then
        if BF_IsNumberStr(sparam) then
            local chooseid = tonumber(sparam)
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
            BaoZhuManagerNew.ShowBasePanel(actor)
        end
    elseif funcid == DO_FUNCTION_ID_18 then
        if BF_IsNumberStr(sparam) then
            local chooseid = tonumber(sparam)
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
            ShowPanel3(actor)
        end
    elseif funcid == DO_FUNCTION_ID_19 then
        if BF_IsNumberStr(sparam) then
            local chooseid = tonumber(sparam)
            setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
            ShowPanel4(actor)
        end        
    elseif funcid == DO_FUNCTION_ID_20 then
        local currpage = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)       
        if currpage > 0 then
            setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currpage - 1)
            ShowPanel4(actor)
        end
    elseif funcid == DO_FUNCTION_ID_21 then
        local currpage = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)       
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currpage + 1)        
        ShowPanel4(actor)
    end    
end

---------------------------------------------------------------小红点相关----------------------------------------------
--是否有快捷提示
function BaoZhuManagerNew.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, false) then
        return false
    end

    --这里的功能还需要进一步处理！！！！！

    return false
end

return BaoZhuManagerNew