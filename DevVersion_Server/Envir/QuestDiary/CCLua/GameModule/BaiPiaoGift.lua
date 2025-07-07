BaiPiaoGift = {}

--functionid
local NPCPANEL_BUTTONFUNC_ID_1 = 1      --切换礼包页签
local NPCPANEL_BUTTONFUNC_ID_2 = 2      --购买礼包
local NPCPANEL_BUTTONFUNC_ID_3 = 3      --礼包种草

--是否显示功能入口icon
function BaiPiaoGift.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return false
end

--检测玩家数据版本
function BaiPiaoGift.CheckGameDataVersion(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local playerversion = getplaydef(actor, CommonDefine.VAR_U_BAIPIAOGIFT_VERSION)
    local gameversion = getsysvar(CommonDefine.VAR_G_BAIPIAOGIFT_VERSION)
    if playerversion ~= gameversion then
        setplaydef(actor, CommonDefine.VAR_U_BAIPIAOGIFT_VERSION, gameversion)

        local allgiftdata_tab = {}
        for i = 1, #cfgBaiPiaoGroupList, 1 do
            local groupinfo = cfgBaiPiaoGroupList[i]
            if groupinfo ~= nil then
                local rec = {groupid=groupinfo.groupid, grassseq=0, giftdatalist={}}
                allgiftdata_tab[groupinfo.groupid] = rec
            end
        end
        local str = tbl2json(allgiftdata_tab)
        setplaydef(actor, CommonDefine.VAR_U_BAIPIAOGIFT_VERSION, str)
    end
end

--玩家登录时触发
function BaiPiaoGift.OnPlayerEnterGame(actor)	
    BaiPiaoGift.CheckGameDataVersion(actor)
    --增加 ontimer
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, BaiPiaoGift.OnPlayerEnterGame, CommonDefine.FUNC_ID_BAIPIAO_GIFT)


--------------------------------------------------------主面板相关--------------------------------------------------------------------
function BaiPiaoGift.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=白嫖礼包规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、XXXXXXX|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、XXXXXXX|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=3、XXXXXXX|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)    
end

local function GetSingleShowInfo(actor, groupid)
    local groupConfig = nil
    for _, value in pairs(cfgBaiPiaoGroupList) do
        if value.groupid == groupid then
            groupConfig = value
        end
    end
    if groupConfig == nil then
        return ''
    end

    local datastr = getplaydef(actor, CommonDefine.VAR_T_BAIPIAOGIFT_DATA)
    local allgiftdata_tab = {}
    if datastr ~= '' then
        allgiftdata_tab = json2tbl(datastr)
    end    

    local strPanelInfo = ''
    local idstr = '300,'
    local listitemidstr = ''

    for seq, singleGift in ipairs(groupConfig.giftlist) do
        local imgbaseid = 300 + seq * 20
        if listitemidstr ~= '' then
            listitemidstr = listitemidstr..','
        end
        listitemidstr = listitemidstr..imgbaseid

        local groupdata = allgiftdata_tab[singleGift.groupid]     
        local singledata = nil
        local grassseq = 0
        if groupdata~=nil and groupdata.giftdatalist~=nil then
            singledata = groupdata.giftdatalist[singleGift.innerseq]
            grassseq = groupdata.grassseq
        end

        local textid1 = imgbaseid + 1
        local textid2 = imgbaseid + 2
        local buttonid1 = imgbaseid + 3
        local buttonid2 = imgbaseid + 4
        local textid3 = imgbaseid + 5
        local textid4 = imgbaseid + 6
        local textid5 = imgbaseid + 7
        local textid6 = imgbaseid + 8
        local tempidstr = textid1..','..textid2..','..buttonid1..','..buttonid2..','..textid3..','..textid4..','..textid5..','..textid6
        
        strPanelInfo = strPanelInfo..'<Text|id='..textid1..'|text='..singleGift.giftname..'|color='..singleGift.giftnamecolor..'|x=10.0|y=8.0>'..
            '<Text|id='..textid2..'|text='..singleGift.valueshow..'|color='..CSS.NPC_WHITE..'|x=300.0|y=8.0>'
        
        if grassseq == 0 then
            --还需要增加一个已领种草奖的状态
            strPanelInfo = strPanelInfo..'<Button|id='..buttonid1..'|x=300|y=45|text=免费种草|size=18|color='..CSS.NPC_LIGHTGREEN..
                '|pimg=private/cc_common/button_down1.png|mimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_up1.png|link=@function_button,'..
                NPCPANEL_BUTTONFUNC_ID_3..','..singleGift.giftid..'>'..
                '<Text|id='..textid3..'|text=种草期:'..math.floor(singleGift.freeminutes / 60)..'小时|size=16|color='..CSS.NPC_WHITE..'|x=390.0|y=50.0>'..
                '<Text|id='..textid4..'|text=限领:1/1|size=16|color='..CSS.NPC_WHITE..'|x=500.0|y=50.0>'
        else
            if grassseq == singleGift.innerseq then
                strPanelInfo = strPanelInfo..'<Text|id='..textid3..'|text=XXXX时间后可免费领取|size=18|color='..CSS.NPC_WHITE..'|x=400.0|y=50.0>'
            else
                strPanelInfo = strPanelInfo..'<Text|id='..textid3..'|text=已种草其它礼包|size=18|color='..CSS.NPC_WHITE..'|x=400.0|y=50.0>'
            end
        end

        local curbuytimes = 0
        if singledata ~= nil then
            curbuytimes = singledata.curbuytimes    
        end
        local leftbuycount = math.max(0, singleGift.maxbuytimes - curbuytimes)
        if curbuytimes >= #singleGift.needitemslist_tab then
            release_print('BaiPiaoGift:GetSingleShowInfo error groupid:'..singleGift.giftid..'  seq:'..singleGift.innerseq)
            return ''
        end
        
        local needitemstr = BF_GetSimpleItemTableDescStr(singleGift.needitemslist_tab[curbuytimes+1])
        strPanelInfo = strPanelInfo..'<Button|id='..buttonid2..'|x=300|y=85|text=元宝购买|size=18|color='..CSS.NPC_ORANGE..
            '|pimg=private/cc_common/button_down1.png|mimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_up1.png|link=@function_button,'..
            NPCPANEL_BUTTONFUNC_ID_2..','..singleGift.giftid..'>'..
            '<Text|id='..textid5..'|text='..needitemstr..'|size=16|color='..CSS.NPC_WHITE..'|x=390.0|y=90.0>'..
            '<Text|id='..textid6..'|text=限购:'..leftbuycount..'/'..singleGift.maxbuytimes..'|size=16|color='..CSS.NPC_WHITE..'|x=500.0|y=90.0>'
            
        for seq1, singleitem in ipairs(singleGift.giftitems_tab) do
            local itemidx = getstditeminfo(singleitem.name, CommonDefine.STDITEMINFO_IDX)
            local currx = 20 + 72 * (seq1-1)
            local showid = imgbaseid + 10 + seq1
            tempidstr = tempidstr..','..showid
            strPanelInfo = strPanelInfo..'<ItemShow|id='..showid..'|x='..currx..'|y=44|itemid='..itemidx..'|itemcount='..singleitem.num..'|bgtype=1|showtips=1>'
        end
        
        strPanelInfo = strPanelInfo..'<Img|id='..imgbaseid..'|children={'..tempidstr..'}|x=0.0|y=0.0|img=private/cc_baipiao/4.png>'
    end
 
    strPanelInfo = strPanelInfo..'<ListView|id=300|children={'..listitemidstr..'}|x=0.0|y=0.0|width=578|height=310|direction=1>'
    strPanelInfo = strPanelInfo..'<Layout|id=15|children={'..idstr..'}|x=214.0|y=116.0|width=578|height=310>'
    return strPanelInfo
end

function BaiPiaoGift.ShowBasePanel(actor)        
    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16,17}|x='..CSS.BASE_PANEL_START_X..'|y='..CSS.BASE_PANEL_START_Y..'|height=448|esc=1|bg=1|img=private/cc_baipiao/8.png|loadDelay=0|reset=1|show=0|move=0>'..
        '<Layout|id=11|x=812.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=813.0|y=13.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Button|id=13|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'..
        '<Img|id=16|x=160|y=90|width=300|height=22|img=private/cc_baipiao/1.png>'..
        '<Img|id=17|x=460|y=90|width=320|height=22|img=private/cc_baipiao/2.png>'

    local chooseid = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    local listitemidstr = ''
    for i = 1, #cfgBaiPiaoGroupList, 1 do
        local groupinfo = cfgBaiPiaoGroupList[i]
        if groupinfo ~= nil then
            local picid = 30 + i * 2
            local textid = 30 + i * 2 + 1
            if chooseid == -1 then
                chooseid = i
                setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, chooseid)
            end
    
            local tabpic = 'private/cc_baipiao/9.png'
            if chooseid == i then
                tabpic = 'private/cc_baipiao/10.png'
            end
            strPanelInfo = strPanelInfo..'<Img|id='..picid..'|children={'..textid..'}|x=0.0|y=0.0|img='..tabpic..'|link=@function_button,'..
                NPCPANEL_BUTTONFUNC_ID_1..','..i..'>'
            strPanelInfo = strPanelInfo..'<Text|id='..textid..'|x=30.0|y=14.0|size=20|color='..CSS.NPC_YELLOW..'|text='..groupinfo.groupname..'>'                    
            --对应当前选中的页签
            if chooseid == i then
                strPanelInfo = strPanelInfo..GetSingleShowInfo(actor, chooseid)
            end
    
            if listitemidstr ~= '' then
                listitemidstr = listitemidstr..','
            end
            listitemidstr = listitemidstr..picid
        end       
    end
    strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..listitemidstr..'}|x=68.0|y=120.0|width=142|height=300|direction=1>'
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--购买礼包
function BaiPiaoGift.BuySingleGift(actor, giftid)
    if BF_IsNullObj(actor) then
        return
    end
    local singleGiftConfig = nil
    for _, value in pairs(cfgBaiPiaoGift) do
        if value.giftid == giftid then
            singleGiftConfig = value
            break
        end
    end
    if singleGiftConfig == nil then
        return
    end
    local groupid = singleGiftConfig.groupid
    local innerseq = singleGiftConfig.innerseq

    local curbuytimes = 0
    local datastr = getplaydef(actor, CommonDefine.VAR_T_BAIPIAOGIFT_DATA)
    local allgiftdata_tab = {}
    if datastr ~= '' then
        allgiftdata_tab = json2tbl(datastr)
    end    
    local groupdata = allgiftdata_tab[groupid]     
    local singledata = nil
    if groupdata~=nil and groupdata.giftdatalist~=nil then
        singledata = groupdata.giftdatalist[innerseq]
        if singledata then
            curbuytimes = singledata.curbuytimes
        end
    end

    if curbuytimes >= singleGiftConfig.maxbuytimes then
        Player.SendSelfMsg(actor, '该礼包本轮已买完！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        return
    end

    if curbuytimes >= #singleGiftConfig.needitemslist_tab then
        return
    end

    --条件判断
    if not Player.CheckItemsEnough(actor, singleGiftConfig.needitemslist_tab[curbuytimes+1], '购买白嫖礼包') then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, singleGiftConfig.needitemslist_tab[curbuytimes+1], '购买白嫖礼包')
    --给与礼包物品
    Player.GiveItemsToBagOrMail(actor, singleGiftConfig.giftitems_tab, '白嫖礼包')

    if singledata == nil then
        allgiftdata_tab[groupid].giftlist[innerseq] = {curbuytimes = 0, freegrasstime = 0, freerewardflag = 0}
    end
    allgiftdata_tab[groupid].giftlist[innerseq].curbuytimes = allgiftdata_tab[groupid].giftlist[innerseq].curbuytimes + 1

    local tempstr = tbl2json(allgiftdata_tab)
    setplaydef(actor, CommonDefine.VAR_T_BAIPIAOGIFT_DATA, tempstr)
end

--处理button回调
function BaiPiaoGift.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

    local funcid = tonumber(sid)
    local nparam = 0
    if BF_IsNumberStr(sparam) then
        nparam = tonumber(sparam)
    end

    BaiPiaoGift.CheckGameDataVersion(actor)

    if funcid == NPCPANEL_BUTTONFUNC_ID_1 then
        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID,  nparam)
        BaiPiaoGift.ShowBasePanel(actor)
    elseif funcid == NPCPANEL_BUTTONFUNC_ID_2 then
        BaiPiaoGift.BuySingleGift(actor, nparam)
    end
end

--是否有快捷提示
function BaiPiaoGift.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAIPIAO_GIFT, false) then
        return false
    end
    return false
end


return BaiPiaoGift