ItemComposeManager = {}

--functionid
local COMPOSE_BUTTONFUNC_ID_1 = 1           --切换合成页签
local COMPOSE_BUTTONFUNC_ID_2 = 2           --当前上一页
local COMPOSE_BUTTONFUNC_ID_3 = 3           --当前下一页
local COMPOSE_BUTTONFUNC_ID_4 = 4			--选择合成的初始道具
local COMPOSE_BUTTONFUNC_ID_5 = 5			--快速放入剩下道具--不可叠加道具类
local COMPOSE_BUTTONFUNC_ID_6 = 6			--进行合成--不可叠加道具类

local COMPOSE_BUTTONFUNC_ID_11 = 11			--各放一个--可叠加道具类
local COMPOSE_BUTTONFUNC_ID_12 = 12			--批量放入--可叠加道具类
local COMPOSE_BUTTONFUNC_ID_13 = 13			--进行合成--不可叠加道具类


local COMPOSE_TYPE_1 = 1 	--角色装备
local COMPOSE_TYPE_2 = 2 	--升星宝石
local COMPOSE_TYPE_3 = 3 	--魂石
local COMPOSE_TYPE_4 = 4 	--灵玉
local COMPOSE_TYPE_5 = 5 	--材料
local COMPOSE_TYPE_6 = 6 	--其他

local COMPOSE_TYPE_INFO = {
	{ctype=COMPOSE_TYPE_2, showname='升星宝石'},
	{ctype=COMPOSE_TYPE_3, showname='魂石'},
}

--每页的格子数量
local BAG_ITEM_COUNT_PER_PAGE = 25
--叠加物品每次最多合成数量
local PILED_ITEM_COMPOSE_MAX_ONCE = 10

local function IsPiledItemComposeType(composetype)
	if composetype == COMPOSE_TYPE_1 then
		return false
	end
	return true
end

--返回背包中[min,max]的, 按照类型可以进行合成的道具ID字符串  ,  分割
--返回是否已搜索完毕的标记
local function GetBagItemIDCanComposeStr(actor, composetype, min, max)
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
			if cfgItemValidComposeList[composetype] and  cfgItemValidComposeList[composetype][itemidx] == true then
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

--根据第一个装备itemid，返回剩余参与合成的装备ID字符串  ,分割
local function GetBagItemIDCanComposeStr2(firstitemid)
	local strItemList = ''
	local composeCfgTab = {}
	if firstitemid == nil then		
		return strItemList, composeCfgTab, nil	
	end
	local currItemList = nil
	for _, value in pairs(cfgItemCompose) do
		for _, value1 in pairs(value.srcitemlist_tab) do
			if value1.id == firstitemid then			
				currItemList = value.srcitemlist_tab
				composeCfgTab = value
				break
			end
		end
		if currItemList ~= nil then
			break
		end
	end
	if currItemList == nil then					
		return strItemList, composeCfgTab, nil
	end
	
	local idlist = {}
	for _, value in pairs(currItemList) do
		if strItemList ~= '' then
			strItemList = strItemList..','
		end
		strItemList = strItemList..value.id			
		idlist[#idlist+1] = value.id
	end
	return strItemList, composeCfgTab, idlist	
end

--根据道具的table 返回合成的配置
local function GetCfgComposeTab(actor, itemobjtablist)
	if BF_IsNullObj(actor) or (itemobjtablist==nil) or (table.isempty(itemobjtablist)) then
		return nil
	end
	if #itemobjtablist < CommonDefine.ITEM_COMPOSE_NEED_NUM then
		return nil
	end	
	local cfgCurrTab = nil
	local firstitemid = getiteminfo(actor, itemobjtablist[1], CommonDefine.ITEMINFO_ITEMIDX)

	for _, value in pairs(cfgItemCompose) do		
		for _, value1 in pairs(value.srcitemlist_tab) do		
			if value1.id == firstitemid then
				cfgCurrTab = value
				break
			end
		end
		if cfgCurrTab ~= nil then
			break
		end
	end
	if cfgCurrTab == nil then
		return nil
	end
	for _, itemobj in ipairs(itemobjtablist) do
		local bFind = false
		local itemid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
		for _, value in pairs(cfgCurrTab.srcitemlist_tab) do			
			if itemid == value.id then
				bFind = true
				break
			end
		end
		if not bFind then
			return nil
		end
	end
	return cfgCurrTab
end

--最终的装备合成动作，返回结果标记，返回提示
local function DoFinalEquipCompose(actor, cfgComposeTab)
	local bSuccessFlag = false
	local newMakeIndex = 0
	if BF_IsNullObj(actor) or (cfgComposeTab==nil) or (table.isempty(cfgComposeTab)) then
		return bSuccessFlag, newMakeIndex
	end

    if cfgComposeTab.successrate >= math.random(1, 10000) then
        --合成成功
        Player.SendSelfMsg(actor, '合成成功！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)        
		local targInfo = BF_GetRandomTab(cfgComposeTab.composetarginfo_tab, -1)
		if (targInfo ~= nil) and (targInfo.id ~= nil) and (cfg_equip[targInfo.id] ~= nil) then
			--合成后的装备绑定属性怎么定义？？？？？？？？？？
			local newitemobj = giveitem(actor, cfg_equip[targInfo.id].Name, 1, 0, '装备合成')
			if not BF_IsNullObj(newitemobj) then
				--设置来源
				local srcinfostr = '{source: 8, mon:"合成获取",player:"'..Player.GetName(actor)..'"}'
				setthrowitemly2(actor, newitemobj, srcinfostr)

				--生成装备的初始洗炼属性
				EquipRandomABManager.InitEquipRandomAB(actor, newitemobj)
				--装备的天赋属性
				EquipInitGift.InitEquipGiftAB(actor, newitemobj)
				refreshitem(actor, newitemobj)
				newMakeIndex = getiteminfo(actor, newitemobj, CommonDefine.ITEMINFO_UNIQUEID)
				bSuccessFlag = true				
			end
		end        
    else
        --合成失败
        Player.SendSelfMsg(actor, '合成失败！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)        
    end	
	return bSuccessFlag, newMakeIndex
end

--最终的可叠加道具合成
local function DoFinalPiledItemCompose(actor, cfgComposeTab)
	local bSuccessFlag = false
	local newitemid = 0
	if BF_IsNullObj(actor) or (cfgComposeTab==nil) or (table.isempty(cfgComposeTab)) then
		return bSuccessFlag, newitemid
	end

    if cfgComposeTab.successrate >= math.random(1, 10000) then
		local targInfo = BF_GetRandomTab(cfgComposeTab.composetarginfo_tab, -1)
		if (targInfo ~= nil) and (targInfo.id ~= nil) and (cfg_item[targInfo.id] ~= nil) then
			nothintitem(actor, 2, targInfo.id)
			--设置来源
			local srcinfostr = '{source: 8, mon:"合成获取",player:"'..Player.GetName(actor)..'"}'
			setthrowitemly(srcinfostr)
			giveitem(actor, cfg_item[targInfo.id].Name, 1, 0, '道具合成')
			bSuccessFlag = true	
			newitemid = targInfo.id
		end           
    end	
	return bSuccessFlag, newitemid
end

function ItemComposeManager.ShowBasePanel(actor, makeindex, itemlist)
    local strPanelInfo = '<Img|id=10|children={11,12,13,21,22,23,24,25,26,40,51,52,53,61,62,63,71,72,80}|x=31.0|y=19.0|img=private/cc_compose/12.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
		'<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if composetype == 0 then
		composetype = COMPOSE_TYPE_1
		setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, composetype)
	end
	local startid = 20
	for seq, value in ipairs(COMPOSE_TYPE_INFO) do
		local currid = startid + seq
		local currx = 67
		local curry = 86 + (seq - 1) * 50
		if value.ctype == composetype then
			strPanelInfo = strPanelInfo..'<Button|id='..currid..'|x='..currx..'|y='..curry..'|mimg=private/cc_compose/2.png|nimg=private/cc_compose/2.png|size=20|color=255|text='..value.showname..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..','..value.ctype..'>'
		else
			strPanelInfo = strPanelInfo..'<Button|id='..currid..'|x='..currx..'|y='..curry..'|mimg=private/cc_compose/1.png|nimg=private/cc_compose/1.png|size=20|color=255|text='..value.showname..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..','..value.ctype..'>'
		end
	end

    local currPageNo = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currPageNo <= 0 then
        currPageNo = 1
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currPageNo)
    end

    local strSelectItem1 = getplaydef(actor, CommonDefine.VAR_S_SELECT_ITEM)
    local nTempMin = (currPageNo - 1) * BAG_ITEM_COUNT_PER_PAGE + 1
    local nTempMax = currPageNo * BAG_ITEM_COUNT_PER_PAGE
    local sValidItemIDList, bDataFinished = GetBagItemIDCanComposeStr(actor, composetype, nTempMin, nTempMax)
    if sValidItemIDList ~= '' then
    	strPanelInfo = strPanelInfo..'<BAGITEMS|id=40|x=195|y=90|select='..strSelectItem1..'|filter3='..sValidItemIDList..'|count='..BAG_ITEM_COUNT_PER_PAGE..
			'|showtips=1|selecttype=1|row=5|dblink=@function_button,'..COMPOSE_BUTTONFUNC_ID_4..'>'
    else
        strPanelInfo = strPanelInfo..'<Text|text=暂无对应可合成的道具！|x=250|y=120|color='..CSS.NPC_WHITE..'>'
    end

	local itemmakeidx1 = getplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1)
	if itemmakeidx1 > 0 then
		local itemidx = Bag.GetItemidxByMakeindex(actor, itemmakeidx1)
		strPanelInfo = strPanelInfo..'<ItemShow|id=51|x=637.0|y=94.0|width=70|height=70|itemid='..itemidx..'|itemcount=1|bgtype=1|showtips=1>'..
			'<ItemShow|id=52|x=559.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'..
			'<ItemShow|id=53|x=717.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'

		if IsPiledItemComposeType(composetype) then
			strPanelInfo = strPanelInfo..'<Text|id=61|text=批量放入将自动放满道具|x=570|y=420|size=18|color='..CSS.NPC_WHITE..'>'..
				'<Button|id=62|x=560|y=370|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|text=放入一个|size=18|color='..CSS.NPC_WHITE..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_11..'>'..
				'<Button|id=63|x=680|y=370|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|text=批量放入|size=18|color='..CSS.NPC_WHITE..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_12..'>'
		else
			strPanelInfo = strPanelInfo..'<Text|id=61|text=自动放入可合成道具！|x=570|y=420|size=20|color='..CSS.NPC_WHITE..'>'..
				'<Button|id=62|x=620|y=370|mimg=private/cc_compose/7.png|nimg=private/cc_compose/7.png|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_5..'>'
		end
	else
		strPanelInfo = strPanelInfo..'<ItemShow|id=51|x=637.0|y=94.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'..
			'<ItemShow|id=52|x=559.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'..
			'<ItemShow|id=53|x=717.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'		
		strPanelInfo = strPanelInfo..'<Text|id=61|text=双击选择要合成的物品！|x=570|y=420|size=20|color='..CSS.NPC_YELLOW..'>'
	end	

    if currPageNo > 1 then
        strPanelInfo = strPanelInfo..'<Text|id=71|text=上一页|x=210|y=460|color='..CSS.NPC_WHITE..'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_2..'>'
    end
    if not bDataFinished then
        strPanelInfo = strPanelInfo..'<Text|id=72|text=下一页|x=460|y=460|color='..CSS.NPC_WHITE..'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_3..'>'
    end	

	local tempparam = getplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1)	
	if tempparam == -1 then
		strPanelInfo = strPanelInfo..'<Img|id=80|children={81,82,83,84}|x=300.0|y=180.0|img=private/cc_compose/11.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
			'<Text|id=81|x=160.0|y=15.0|color=151|size=20|text=合成结果>'..
			'<Text|id=82|x=70.0|y=80.0|color=255|size=18|text=合成失败，不要灰心，下次会有好运！>'..
			'<Button|id=83|x=150.0|y=155.0|color=255|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|size=18|text=确定|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..'>'
	elseif tempparam == 1 then
		if makeindex ~= nil then
			strPanelInfo = strPanelInfo..'<Img|id=80|children={81,82,83,84}|x=300.0|y=180.0|img=private/cc_compose/11.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
				'<Text|id=81|x=160.0|y=15.0|color=151|size=20|text=合成结果>'..
				'<Text|id=82|x=40.0|y=60.0|color=255|size=18|text=恭喜获得：>'..
				'<Button|id=83|x=150.0|y=155.0|color=255|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|size=18|text=确定|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..'>'..
				'<MKItemShow|id=84|x=160|y=80|makeindex='..makeindex..'|count=1|showtips=1|bgtype=1|canmove=0>'	
		end
	elseif tempparam == 2 then
		if itemlist ~= nil then
			local idstr = ''
			for key, _ in ipairs(itemlist) do
				idstr = idstr..','..(90+key)
			end
			strPanelInfo = strPanelInfo..'<Img|id=80|children={81,82,83'..idstr..'}|x=300.0|y=180.0|img=private/cc_compose/11.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
				'<Text|id=81|x=160.0|y=15.0|color=151|size=20|text=合成结果>'..
				'<Text|id=82|x=40.0|y=60.0|color=255|size=18|text=恭喜获得：>'..
				'<Button|id=83|x=150.0|y=155.0|color=255|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|size=18|text=确定|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..'>'
			for key, value in ipairs(itemlist) do
				local currx = 40 + 70 * (key-1)
				strPanelInfo = strPanelInfo..'<ItemShow|id='..(90+key)..'|x='..currx..'|y=80|itemid='..value.id..'|itemcount='..value.num..'|bgtype=1|showtips=1>'
			end							
		end
	end

    BF_ShowSpecialUI(actor, strPanelInfo)
end

function ItemComposeManager.ChooseOtherItemPanel(actor)
     --展现信息排版后，选择其它两个材料
     local chooseItemMakeIdx = getplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1)
     if chooseItemMakeIdx <= 0 then
         Player.SendSelfMsg(actor, '请双击选择参与合成的第一件装备！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
         return
     end   
    --效验是否为背包道具
    local firstitemid = Bag.GetItemidxByMakeindex(actor, chooseItemMakeIdx)
    if (firstitemid == nil) or (firstitemid == 0) then
        return
    end	

    local strPanelInfo = '<Img|id=10|children={11,12,13,21,22,23,24,25,26,40,51,52,53,61,62,63,80}|x=31.0|y=19.0|img=private/cc_compose/12.png|move=0|show=0|reset=1|esc=1|bg=1|loadDelay=0>'..
        '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=814.0|y=14.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
		'<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if composetype == 0 then
		composetype = COMPOSE_TYPE_1
		setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, composetype)
	end

	local startid = 20
	for seq, value in ipairs(COMPOSE_TYPE_INFO) do
		local currid = startid + seq
		local currx = 67
		local curry = 86 + (seq - 1) * 50
		if value.ctype == composetype then
			strPanelInfo = strPanelInfo..'<Button|id='..currid..'|x='..currx..'|y='..curry..'|mimg=private/cc_compose/2.png|nimg=private/cc_compose/2.png|size=20|color=255|text='..value.showname..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..','..value.ctype..'>'
		else
			strPanelInfo = strPanelInfo..'<Button|id='..currid..'|x='..currx..'|y='..curry..'|mimg=private/cc_compose/1.png|nimg=private/cc_compose/1.png|size=20|color=255|text='..value.showname..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_1..','..value.ctype..'>'
		end
	end

    local sValidItemIDList, cfgCurrComposeTab, _ = GetBagItemIDCanComposeStr2(firstitemid)
    local strSelectItemList = getplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS)
    strPanelInfo = strPanelInfo..'<BAGITEMS|id=40|x=195|y=90|select='..strSelectItemList..'|filter3='..sValidItemIDList..'|count='..BAG_ITEM_COUNT_PER_PAGE..'|showtips=1|selecttype=1|row=5>'

    local strMakeIdxTab = string.split(strSelectItemList, ',')
    if strMakeIdxTab and (#strMakeIdxTab == CommonDefine.ITEM_COMPOSE_NEED_NUM) then
		local itemidx2 = 0
		if strMakeIdxTab[2] ~= nil then
			itemidx2 = Bag.GetItemidxByMakeindex(actor, tonumber(strMakeIdxTab[2]))
		end
		local itemidx3 = 0
		if strMakeIdxTab[3] ~= nil then
			itemidx3 = Bag.GetItemidxByMakeindex(actor, tonumber(strMakeIdxTab[3]))
		end				

		if strMakeIdxTab and strMakeIdxTab[2] and strMakeIdxTab[3] then
			strPanelInfo = strPanelInfo..'<ItemShow|id=51|x=637.0|y=94.0|width=70|height=70|itemid='..firstitemid..'|itemcount=1|bgtype=1|showtips=1>'..
				'<ItemShow|id=52|x=559.0|y=227.0|width=70|height=70|itemid='..itemidx2..'|itemcount=1|bgtype=1|showtips=1>'..
				'<ItemShow|id=53|x=717.0|y=227.0|width=70|height=70|itemid='..itemidx3..'|itemcount=1|bgtype=1|showtips=1>'
		end

		if sValidItemIDList ~= '' then
			local sConsumeInfo = BF_GetSimpleItemTableDescStr(cfgCurrComposeTab.needitems_tab)
			local showrate = math.floor(cfgCurrComposeTab.successrate / 100)
			strPanelInfo = strPanelInfo..'<Text|id=61|text=成功概率：'..showrate..'%|x=590|y=360|color='..CSS.NPC_WHITE..'>'..
				'<Text|id=62|text=合成消耗：'..sConsumeInfo..'|x=590|y=390|color='..CSS.NPC_WHITE..'>'..
				'<Button|id=63|x=620|y=420|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|text=开始合成|size=18|color='..CSS.NPC_WHITE..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_6..'>'
		end	
	else	
		local pilenum = getplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM)	
		if IsPiledItemComposeType(composetype) and (pilenum > 0) then			
			strPanelInfo = strPanelInfo..'<ItemShow|id=51|x=637.0|y=94.0|width=70|height=70|itemid='..firstitemid..'|itemcount='..pilenum..'|bgtype=1|showtips=1>'..
				'<ItemShow|id=52|x=559.0|y=227.0|width=70|height=70|itemid='..firstitemid..'|itemcount='..pilenum..'|bgtype=1|showtips=1>'..
				'<ItemShow|id=53|x=717.0|y=227.0|width=70|height=70|itemid='..firstitemid..'|itemcount='..pilenum..'|bgtype=1|showtips=1>'

			local needitems = BF_GetItemTabMulti(cfgCurrComposeTab.needitems_tab, pilenum)
			local sConsumeInfo = BF_GetSimpleItemTableDescStr(needitems)
			local showrate = math.floor(cfgCurrComposeTab.successrate / 100)
			strPanelInfo = strPanelInfo..'<Text|id=61|text=成功概率：'..showrate..'%|x=590|y=360|color='..CSS.NPC_WHITE..'>'..
				'<Text|id=62|text=合成消耗：'..sConsumeInfo..'|x=590|y=390|color='..CSS.NPC_WHITE..'>'..
				'<Button|id=63|x=620|y=420|mimg=private/cc_compose/3.png|nimg=private/cc_compose/3.png|text=开始合成|size=18|color='..CSS.NPC_WHITE..
				'|link=@function_button,'..COMPOSE_BUTTONFUNC_ID_13..'>'				
		else
			strPanelInfo = strPanelInfo..'<ItemShow|id=51|x=637.0|y=94.0|width=70|height=70|itemid='..firstitemid..'|itemcount=1|bgtype=1|showtips=1>'..
				'<ItemShow|id=52|x=559.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'..
				'<ItemShow|id=53|x=717.0|y=227.0|width=70|height=70|itemid=0|itemcount=1|bgtype=1|showtips=1>'
		end
    end

    BF_ShowSpecialUI(actor, strPanelInfo)
end

function ItemComposeManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=道具合成规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、装备合成后会有几率获得更高等级装备的同时，生成|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=天赋属性或者极品属性|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、升星宝石合成成功之后将获得高一级的升星宝石。|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=3、魂石合成成功之后将获得高一级的魂石|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=4、所有的合成物品，如果合成失败，将不会返还合成|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
	tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=材料和合成消耗|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)   
end

local function DoSelectItem1(actor)
	local strSelectItem1 = getplaydef(actor, CommonDefine.VAR_S_SELECT_ITEM)
	if not BF_IsNumberStr(strSelectItem1) then
		Player.SendSelfMsg(actor, '请双击选择参与合成的第一件道具！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return
	end
	setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, tonumber(strSelectItem1))
end

--对于不可叠加道具的合成，选择其它合成对象
local function DoAutoSelectOtherItems(actor)
	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if IsPiledItemComposeType(composetype) then
		return false
	end

    local chooseItemMakeIdx = getplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1)
    if chooseItemMakeIdx <= 0 then
        Player.SendSelfMsg(actor, '请双击选择参与合成的第一件道具！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end
    --效验是否为背包道具
    local firstitemid = Bag.GetItemidxByMakeindex(actor, chooseItemMakeIdx)
    if (firstitemid == nil) or (firstitemid == 0) then
        return false
    end

    local strSelectItemList = ''..chooseItemMakeIdx
    setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, strSelectItemList)

	local chooseCounter = 0
	local _, _, itemidTab = GetBagItemIDCanComposeStr2(firstitemid)
	if itemidTab and (type(itemidTab)=="table") then
		local item_num = getbaseinfo(actor, CommonDefine.INFO_HUMBAGITEMNUM)		
		for i=0, item_num-1 do
			local itemobj = getiteminfobyindex(actor, i)
			local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
			if table.indexof(itemidTab, itemidx) ~= false then			
				local makeindex = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_UNIQUEID)
				if makeindex ~= chooseItemMakeIdx then
					if strSelectItemList ~= '' then
						strSelectItemList = strSelectItemList..','
					end
					strSelectItemList = strSelectItemList..makeindex
					chooseCounter = chooseCounter + 1
				end
				if chooseCounter >= CommonDefine.ITEM_COMPOSE_NEED_NUM-1 then
					break
				end
			end
		end
	else
		Player.SendSelfMsg(actor, '当前无充足的道具供合成', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return false
	end
	
	if chooseCounter< CommonDefine.ITEM_COMPOSE_NEED_NUM-1 then
		Player.SendSelfMsg(actor, '当前无充足的道具供合成', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return false
	end

	setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, strSelectItemList)
	return true
end

--对于可叠加道具的合成，选择其它合成对象  selecttype=0表示选择单个 =1表示选择最大
local function DoAutoSelectOtherPiledItems(actor, selecttype)
	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if not IsPiledItemComposeType(composetype) then
		return false
	end

    local chooseItemMakeIdx = getplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1)
    if chooseItemMakeIdx <= 0 then
        Player.SendSelfMsg(actor, '请双击选择参与合成的第一件道具！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end	
    --效验是否为背包道具
	local chooseitemobj = Bag.GetItemByMakeindex(actor, chooseItemMakeIdx)
	if chooseitemobj == nil then
		return false
	end
    local firstitemid = getiteminfo(actor, chooseitemobj, CommonDefine.ITEMINFO_ITEMIDX)
    if (firstitemid == nil) or (firstitemid == 0) then
        return false
    end
	--当前 道具叠加数量大于等于3个才可进行合成
	local pilecount = getiteminfo(actor, chooseitemobj, CommonDefine.ITEMINFO_OVERLAP)
	if pilecount < CommonDefine.ITEM_COMPOSE_NEED_NUM then
		Player.SendSelfMsg(actor, '选择的道具数量不足，无法合成', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return false
	end

    local strSelectItemList = ''..chooseItemMakeIdx
    setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, strSelectItemList)
	local singlecount = 1
	if selecttype == 1 then
		singlecount = math.floor(pilecount / CommonDefine.ITEM_COMPOSE_NEED_NUM)
		singlecount = math.min(PILED_ITEM_COMPOSE_MAX_ONCE, singlecount)
	end
	setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, singlecount)

	return true
end

--返回合成成功的单个装备
local function show_success_panel(actor, makeindex)
	setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1, 1)

	setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
	setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
	setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')
	setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
	ItemComposeManager.ShowBasePanel(actor, makeindex, nil)	
end

--返回合成成功的道具列表
local function  show_success_panel_ex(actor, itemlist)
	setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1, 2)

	setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
	setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
	setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')
	setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
	ItemComposeManager.ShowBasePanel(actor, 0, itemlist)		
end

local function show_fail_panel(actor)
	setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1, -1)

	setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
	setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
	setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')
	setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
	ItemComposeManager.ShowBasePanel(actor, 0, nil)	
end

--合成不可叠加道具
local function DoCompose(actor)
	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if IsPiledItemComposeType(composetype) then
		Player.SendSelfMsg(actor, '选择的合成类型不符！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return
	end

    local strSelectItemList = getplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS)
    if strSelectItemList == '' then
        return
    end
    local strSelectTable = string.split(strSelectItemList, ',')
    if #strSelectTable ~= CommonDefine.ITEM_COMPOSE_NEED_NUM then
        Player.SendSelfMsg(actor, '选择的合成道具的数量不足'..CommonDefine.ITEM_COMPOSE_NEED_NUM..'个！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    local itemMakeidxList = {}
    if strSelectTable ~= false then
        for _, value in ipairs(strSelectTable) do
            if not BF_IsNumberStr(value) then
                return
            end
            itemMakeidxList[#itemMakeidxList+1] = tonumber(value)
        end        
    end
    if BF_HasDuplicates(itemMakeidxList) then
        --外挂
        return
    end
    local chooseItemObjList = {}
    for _, value in ipairs(itemMakeidxList) do
        local itemobj = Bag.GetItemByMakeindex(actor, value)
        if BF_IsNullObj(itemobj) then
            --外挂
            return
        else
            chooseItemObjList[#chooseItemObjList+1] = itemobj
        end
    end
    local cfgCurrComposeTab = GetCfgComposeTab(actor, chooseItemObjList)
    if cfgCurrComposeTab == nil then
        Player.SendSelfMsg(actor, '未找到有效的合成配置！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, cfgCurrComposeTab.needitems_tab, '合成') then
        return
    end
    --扣除材料消耗
    Player.TakeItems(actor, cfgCurrComposeTab.needitems_tab, '装备合成')
    --扣除装备消耗
    for _, value in ipairs(itemMakeidxList) do
        delitembymakeindex(actor, value)
    end
    --最终合成
    local bComposeFlag, newItemMakeIdx = DoFinalEquipCompose(actor, cfgCurrComposeTab)
    if bComposeFlag then
        --触发装备合成成功
		--[[
		-----------------------------------------todo
        FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_COMPOSE_EQUIP_SUCCESSTIMES, '+', 1)       
		]]--
		show_success_panel(actor, newItemMakeIdx)
    else
		show_fail_panel(actor)
    end

    --每日必做计数        
	--[[
	-----------------------------------------todo	
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_COMPOSE, 1)       	
	]]--
end

--合成可叠加道具
local function DoComposeEx(actor)
	local composetype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
	if not IsPiledItemComposeType(composetype) then
		Player.SendSelfMsg(actor, '选择的合成类型不符！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
		return
	end

	local chooseItemMakeIdx = getplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1)
	if chooseItemMakeIdx <= 0 then
		return
	end   
	local firstitemid = Bag.GetItemidxByMakeindex(actor, chooseItemMakeIdx)
	if (firstitemid == nil) or (firstitemid == 0) then
		return
	end
	local pilecount = getplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM)
	if pilecount <= 0 then
		return
	end

	local cfgCurrComposeTab = nil
	for _, value in pairs(cfgItemCompose) do		
		for _, value1 in pairs(value.srcitemlist_tab) do		
			if value1.id == firstitemid then
				cfgCurrComposeTab = value
				break
			end
		end
		if cfgCurrComposeTab ~= nil then
			break
		end
	end
	if cfgCurrComposeTab == nil then
		return
	end

	--检测合成道具消耗
	local needitemlist1 = {{id=firstitemid, num=pilecount*CommonDefine.ITEM_COMPOSE_NEED_NUM}}
    if not Player.CheckItemsEnough(actor, needitemlist1, '叠加道具合成') then
        return
    end
	--检测合成材料消耗
	local needitemlist2 = BF_GetItemTabMulti(cfgCurrComposeTab.needitems_tab, pilecount)
    if not Player.CheckItemsEnough(actor, needitemlist2, '叠加道具合成') then
        return
    end	
	--扣道具
	Player.TakeItems(actor, needitemlist1, '道具合成1')
	Player.TakeItems(actor, needitemlist2, '道具合成2')

	--进行合成
	local resultinfo = {}
	for i = 1, pilecount, 1 do
		local bComposeFlag, newItemID = DoFinalPiledItemCompose(actor, cfgCurrComposeTab)
		if bComposeFlag == true then
			local bFind = false
			for _, value in ipairs(resultinfo) do
				if value.id == newItemID then
					bFind = true
					value.num = value.num + 1
				end
			end
			if bFind == false then
				local rec = {id=newItemID, num=1}
				resultinfo[#resultinfo+1] = rec
			end
		end
	end
	
	if #resultinfo > 0 then
		show_success_panel_ex(actor, resultinfo)
	else	
		show_fail_panel(actor)
	end

    --每日必做计数   
	--[[
	-----------------------------------------todo	
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_COMPOSE, pilecount)       	
	]]--
end

--处理button回调
function ItemComposeManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local ctype = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if BF_IsNumberStr(sparam) then
        ctype = tonumber(sparam)
    end

    if funcid == COMPOSE_BUTTONFUNC_ID_1 then
		setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, ctype)
		setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
		setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
		setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')
		setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
		ItemComposeManager.ShowBasePanel(actor)
    elseif funcid == COMPOSE_BUTTONFUNC_ID_2 then
		local currPageNo = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
		if currPageNo > 1 then
			setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currPageNo - 1)
		end
		ItemComposeManager.ShowBasePanel(actor)
	elseif funcid == COMPOSE_BUTTONFUNC_ID_3 then
		local currPageNo = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
		setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currPageNo + 1)
		ItemComposeManager.ShowBasePanel(actor)		
	elseif funcid == COMPOSE_BUTTONFUNC_ID_4 then
		DoSelectItem1(actor)
		ItemComposeManager.ShowBasePanel(actor)
	elseif funcid == COMPOSE_BUTTONFUNC_ID_5 then
		if DoAutoSelectOtherItems(actor) == true then
			ItemComposeManager.ChooseOtherItemPanel(actor)
		end
	elseif funcid == COMPOSE_BUTTONFUNC_ID_6 then
		--这里的处理还需确认?????????	
		DoCompose(actor)
		setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
		setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
		setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')	
		setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
	elseif funcid == COMPOSE_BUTTONFUNC_ID_11 then
		if DoAutoSelectOtherPiledItems(actor, 0) == true then
			ItemComposeManager.ChooseOtherItemPanel(actor)
		end
	elseif funcid == COMPOSE_BUTTONFUNC_ID_12 then
		if DoAutoSelectOtherPiledItems(actor, 1) == true then
			ItemComposeManager.ChooseOtherItemPanel(actor)
		end
	elseif funcid == COMPOSE_BUTTONFUNC_ID_13 then
		--这里的处理还需确认?????????	
		DoComposeEx(actor)
		setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 0)
		setplaydef(actor, CommonDefine.VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1, 0)
		setplaydef(actor, CommonDefine.VAR_S_SELECT_COMPOSE_ITEMS, '')	
		setplaydef(actor, CommonDefine.VAR_N_SELECT_COMPOSE_PILE_NUM, 0)
    end
end

return ItemComposeManager