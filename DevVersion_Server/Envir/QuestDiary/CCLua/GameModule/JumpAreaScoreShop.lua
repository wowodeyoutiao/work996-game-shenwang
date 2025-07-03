JumpAreaScoreShop = {}

local ONE_LINE_SHOP_ITEMS = 4

--显示规则面板
function JumpAreaScoreShop.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28,29,30}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=跨服商店规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=3、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=4、......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=......|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
 
    return strPanelInfo
end

function JumpAreaScoreShop.GetShowInfo(actor)
    local currscore = Player.GetItemNumInBag(actor, CommonDefine.ITEMID_KUAFU_SCORE)
    local sPanelStr = ''
    sPanelStr = sPanelStr..'<Layout|id=50|children={51}|x=10|y=10|width=560|height=40|color='..CSS.NPC_BLACK..'>'
    sPanelStr = sPanelStr..'<Text|id=51|text=当前持有跨服积分：'..currscore..'|size=20|x=200|y=10>'
    sPanelStr = sPanelStr..'<Layout|id=15|children={50,52}|x=200.0|y=65.0|width=580|height=420>'

    local nTotalLine = math.floor(#cfgJumpAreaShop / ONE_LINE_SHOP_ITEMS)
    if #cfgJumpAreaShop % ONE_LINE_SHOP_ITEMS > 0 then
        nTotalLine = nTotalLine + 1
    end

    local sJonStr = getplaydef(actor, CommonDefine.VAR_T_JUMPAREA_SHOP_BUYDATA)
    local buyCounterTab = {}
    if sJonStr~=nil and sJonStr~='' then
        buyCounterTab = json2tbl(sJonStr) 
    end

    local strItems = ''
    local seq = 1
    for i = 1, nTotalLine, 1 do        
        local nLayoutID = 70 + i
        if strItems ~= '' then
            strItems = strItems..','
        end
        strItems = strItems..nLayoutID

        local strItems1 = ''
        for j = 1, ONE_LINE_SHOP_ITEMS, 1 do
            local shopinfo = cfgJumpAreaShop[seq]
            if shopinfo ~= nil then
                local nBasePicID = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 1
                if strItems1 ~= '' then
                    strItems1 = strItems1..','
                end
                strItems1 = strItems1..nBasePicID
                local picx = (j-1) * 140 + 10
                local picy = 0
    
                local textid1 = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 2
                local itemgrid1 = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 3
                local textid2 = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 4
                local textid3 = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 5
                local buttonid1 = 300 + (i*ONE_LINE_SHOP_ITEMS+j) * 20 + 6
                local strItems2 = textid1..','..itemgrid1..','..textid2..','..textid3..','..buttonid1

                local targitem = shopinfo.exchangeitems_tab[1]
                local itemidx = getstditeminfo(targitem.name, CommonDefine.STDITEMINFO_IDX)
                local needitemstr = BF_GetSimpleItemTableDescStr(shopinfo.needitems_tab)                
                sPanelStr = sPanelStr..'<Text|id='..textid1..'|text='..targitem.name..'|size=16|color='..CSS.NPC_WHITE..'|x=35|y=10>'..
                            '<Text|id='..textid2..'|text='..needitemstr..'|size=14|color='..CSS.NPC_WHITE..'|x=15|y=110>'..                            
                            '<Button|id='..buttonid1..'|x=30|y=165|nimg=private/cc_jumparea/12.png|pimg=private/cc_jumparea/12.png|text=兑换|color='..CSS.NPC_WHITE..
                            '|link=@function_button,'..JumpAreaManager.BUTTONFUNC_ID_6..','..shopinfo.seq..'>'
                if shopinfo.daymaxtimes > 0 then
                    local sKey = seq..''
                    local nBuyCounter = 0
                    if buyCounterTab[sKey] ~= nil then
                        nBuyCounter = buyCounterTab[sKey]
                    end
                    local lefttimes = math.max(0, shopinfo.daymaxtimes - nBuyCounter)
                    local limitstr = '今日剩余:'..lefttimes..'次'
                    sPanelStr = sPanelStr..'<Text|id='..textid3..'|text='..limitstr..'|size=14|color='..CSS.NPC_WHITE..'|x=15|y=130>'
                end
                sPanelStr = sPanelStr..'<ItemShow|id='..itemgrid1..'|x=26|y=38|itemid='..itemidx..'|itemcount='..targitem.num..'|bgtype=1|showtips=1>'
                sPanelStr = sPanelStr..'<Img|id='..nBasePicID..'|children={'..strItems2..'}|x='..picx..'|y='..picy..'|img=private/cc_jumparea/16.png>'                    
            end
            seq = seq + 1
        end

        sPanelStr = sPanelStr..'<Layout|id='..nLayoutID..'|children={'..strItems1..'}|x=10|y=10|width=560|height=200>'
    end

    sPanelStr = sPanelStr..'<ListView|id=52|children={'..strItems..'}|x=10.0|y=60|width=560|height=340|margin=0|direction=1>'

    return sPanelStr
end

--兑换道具
function JumpAreaScoreShop.ExchangeShopItem(actor, shopseq)
    if BF_IsNullObj(actor) then
        return
    end

    local shopinfo = cfgJumpAreaShop[shopseq]
    if shopinfo ~= nil then
        if not Player.CheckItemsEnough(actor, shopinfo.needitems_tab, '兑换') then
            return
        end    
        if shopinfo.daymaxtimes > 0 then
            --有每日购买限制则需要判断
            local sJonStr = getplaydef(actor, CommonDefine.VAR_T_JUMPAREA_SHOP_BUYDATA)
            local buyCounterTab = {}
            if sJonStr~=nil and sJonStr~='' then
                buyCounterTab = json2tbl(sJonStr) 
            end
            local sKey = shopseq..''
            if buyCounterTab[sKey] == nil then
                buyCounterTab[sKey] = 0
            end
            if buyCounterTab[sKey] >= shopinfo.daymaxtimes then
                Player.SendSelfMsg(actor, '今日该物品兑换次数已达上限！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
                return
            end
            buyCounterTab[sKey] = buyCounterTab[sKey] + 1
            local tempstr = tbl2json(buyCounterTab)
            setplaydef(actor, CommonDefine.VAR_T_JUMPAREA_SHOP_BUYDATA, tempstr)
        end
        Player.TakeItems(actor, shopinfo.needitems_tab, '跨服积分兑换')
        Player.GiveItemsToBagOrMail(actor, shopinfo.exchangeitems_tab, '跨服积分兑换')
        JumpAreaManager.ShowBasePanel(actor)
    end
end

--玩家跨天回调
function JumpAreaScoreShop.OnResetDay(actor)
    setplaydef(actor, CommonDefine.VAR_T_JUMPAREA_SHOP_BUYDATA, '')
end


GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_RESETDAY, JumpAreaScoreShop.OnResetDay, CommonDefine.FUNC_ID_JUMPAREA_5)

return JumpAreaScoreShop