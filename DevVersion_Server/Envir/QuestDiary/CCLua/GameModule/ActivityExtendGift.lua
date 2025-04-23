ActivityExtendGift = {}

--functionid
local EXTENDGIFT_BUTTONFUNC_ID_1 = 1           --领取奖励
local EXTENDGIFT_BUTTONFUNC_ID_2 = 2           --购买直购礼包

--礼包类型
local GIFT_TYPE_CHECK_PLAYERLV = 1             --礼包类型，满足等级条件可领取
local GIFT_TYPE_CHECK_PLAYERPOWER = 2          --礼包类型，满足战力条件可领取
local GIFT_TYPE_BUY = 10                       --礼包类型，充值直购礼包

--礼包状态
local GIFT_STATUS_NOT_OPEN = 0                 --领取前一档奖励后开放
local GIFT_STATUS_NOT_READY = 1                --未达成
local GIFT_STATUS_CAN_GET = 2                  --可领取
local GIFT_STATUS_CAN_BUY = 3                  --可直购
local GIFT_STATUS_GET_REWARD = 4               --已领取

--单个礼包的四个物品的坐标
local GIFT_ITEM_POS_LIST = {{x=8, y=36}, {x=88, y=36}, {x=8, y=100}, {x=88, y=100}}

--打开界面
function ActivityExtendGift.OpenPanel(actor)
    --打开界面后，默认显示的应该是什么，后面再优化
    ActivityExtendGift.ShowActivityPanel(actor)
end

--是否显示功能入口icon
function ActivityExtendGift.CanShowIcon(actor)
    if BF_IsNullObj(actor) then
        return false
    end

    return true
end

local function GetGiftStatus(actor, giftseq, rewardtab)
    if BF_IsNullObj(actor) then
        return GIFT_STATUS_NOT_OPEN
    end
    if (giftseq < 1) or (giftseq > #cfgActivityExtendGift) then
        return GIFT_STATUS_NOT_OPEN
    end

    if giftseq > 1 then
        if table.indexof(rewardtab, giftseq-1) == false then
            return GIFT_STATUS_NOT_OPEN
        end
    end

    local cfginfo = cfgActivityExtendGift[giftseq]
    if cfginfo == nil then
        return GIFT_STATUS_NOT_OPEN
    end
    if table.indexof(rewardtab, giftseq) ~= false then
        return GIFT_STATUS_GET_REWARD
    end
    if cfginfo.checktype == GIFT_TYPE_CHECK_PLAYERLV then
        if Player.GetLevel(actor) >= cfginfo.checknum then
            return GIFT_STATUS_CAN_GET
        else
            return GIFT_STATUS_NOT_READY
        end
    elseif cfginfo.checktype == GIFT_TYPE_CHECK_PLAYERPOWER then
        if Player.GetPlayerPower(actor) >= cfginfo.checknum then
            return GIFT_STATUS_CAN_GET
        else
            return GIFT_STATUS_NOT_READY
        end
    elseif cfginfo.checktype == GIFT_TYPE_BUY then
        return GIFT_STATUS_CAN_BUY
    end
    return GIFT_STATUS_NOT_OPEN
end

function ActivityExtendGift.ShowActivityPanel(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local strPanelInfo = '<Img|id=10|children={11,12,20}|x=150.0|y=61.0|move=0|show=0|bg=1|esc=1|reset=1|img=private/cc_extend_gift/6.png>'..
        '<Layout|id=11|x=693.0|y=12.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=696.0|y=13.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'    

    local nStartID = 500
    local idstr = ''
    local nline = 1
    for i = 1, #cfgActivityExtendGift, 3 do
        if idstr ~= '' then
            idstr = idstr..','
        end
        idstr = idstr..(nStartID + nline*40)           
        nline = nline + 1
    end
    strPanelInfo = strPanelInfo..'<ListView|id=20|children={'..idstr..'}|x=60.0|y=80.0|width=600|height=350|margin=0|direction=1>'
    
    local datastr = getplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end

    nline = 1
    for i = 1, #cfgActivityExtendGift, 3 do
        local baseid = nStartID + nline*40
        local idstr1 = (baseid+10)..','..(baseid+20)..','..(baseid+30)
        strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..idstr1..'}|x=50.0|y=50.0|width=600|height=230|show=0|img=private/cc_common/listitem_1.png>'
        local n = 1
        local endnum = math.min(i+2, #cfgActivityExtendGift)
        for j = i, endnum, 1 do
            local cfginfo = cfgActivityExtendGift[j]
            local currid = baseid + n * 10
            local currx = 5 + 210 * (n-1)
            local curry = 10
            local idstr2 = (currid+1)..','..(currid+2)
            if j < endnum then
                idstr2 = idstr2..','..(currid+3)
            end
            for key, _ in ipairs(cfginfo.rewards_tab) do
                idstr2 = idstr2..','..(currid+4+key)
            end
            strPanelInfo = strPanelInfo..'<Img|id='..currid..'|children={'..idstr2..'}|x='..currx..'|y='..curry..'|show=0|img=private/cc_extend_gift/1.png>'
            local titleinfo = j..'.'..cfginfo.showinfo
            strPanelInfo = strPanelInfo..'<Text|id='..(currid+1)..'|x=25.0|y=10.0|color='..CSS.NPC_WHITE..'|size=15|text='..titleinfo..'>'
            local giftstatus = GetGiftStatus(actor, j, rewardtab)
            if giftstatus == GIFT_STATUS_NOT_OPEN then
                strPanelInfo = strPanelInfo..'<Text|id='..(currid+2)..'|x=15.0|y=180.0|color='..CSS.NPC_WHITE..'|size=15|text=领取前一档后开放>'
            elseif giftstatus == GIFT_STATUS_NOT_READY then
                strPanelInfo = strPanelInfo..'<Text|id='..(currid+2)..'|x=55.0|y=180.0|color='..CSS.NPC_RED..'|size=18|text=未达成>'
            elseif giftstatus == GIFT_STATUS_CAN_GET then
                strPanelInfo = strPanelInfo..'<Button|id='..(currid+2)..'|x=35.0|y=170.0|mimg=private/cc_extend_gift/2.png|nimg=private/cc_extend_gift/2.png|link=@extendgift_button,'..
                    EXTENDGIFT_BUTTONFUNC_ID_1..','..cfginfo.seq..'>'
                Player.AddRedPoint(actor, 0, (currid+2), 10, 10)
            elseif giftstatus == GIFT_STATUS_CAN_BUY then
                local needstr = BF_GetSimpleItemTableDescStr(cfginfo.needitems_tab)
                strPanelInfo = strPanelInfo..'<Button|id='..(currid+2)..'|x=35.0|y=170.0|text='..needstr..'|mimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|link=@extendgift_button,'..
                    EXTENDGIFT_BUTTONFUNC_ID_2..','..cfginfo.seq..'>'
            elseif giftstatus == GIFT_STATUS_GET_REWARD then
                strPanelInfo = strPanelInfo..'<Text|id='..(currid+2)..'|x=55.0|y=180.0|color='..CSS.NPC_LIGHTGREEN..'|size=18|text=已领取>'
            end
            if j < endnum then
                strPanelInfo = strPanelInfo..'<Img|id='..(currid+3)..'|x=160|y=80|show=0|img=private/cc_extend_gift/3.png>'
            end
            for key, singleitem in ipairs(cfginfo.rewards_tab) do
                local itemidx = getstditeminfo(singleitem.name, CommonDefine.STDITEMINFO_IDX)
                strPanelInfo = strPanelInfo..'<ItemShow|id='..(currid+4+key)..'|x='..GIFT_ITEM_POS_LIST[key].x..'|y='..GIFT_ITEM_POS_LIST[key].y..
                    '|itemid='..itemidx..'|itemcount='..singleitem.num..'|bgtype=1|showtips=1>'
            end     
            n = n + 1
        end
        nline = nline + 1
    end
    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function ActivityExtendGift.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local seq = 0
    if BF_IsNumberStr(sparam) then
        seq = tonumber(sparam)
    end

    if funcid == EXTENDGIFT_BUTTONFUNC_ID_1 then
        if seq ~= 0 then
            ActivityExtendGift.GetRechargeReward(actor, seq)        
        end
    elseif funcid == EXTENDGIFT_BUTTONFUNC_ID_2 then
        if seq ~= 0 then
            ActivityExtendGift.RechargeBuyGift(actor, seq)
        end
    end  
end

--领取奖励
function ActivityExtendGift.GetRechargeReward(actor, seq)
    if BF_IsNullObj(actor) then
        return
    end

    local datastr = getplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end

    local giftstatus = GetGiftStatus(actor, seq, rewardtab)
    if giftstatus ~= GIFT_STATUS_CAN_GET then
        Player.SendSelfMsg(actor, '礼包当前状态还不可领取！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    Player.GiveItemsToBagOrMail(actor, cfgActivityExtendGift[seq].rewards_tab, '进阶礼包：'..seq)
    rewardtab[#rewardtab+1] = seq
    local datastr = tbl2json(rewardtab)
    setplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA, datastr)
    ActivityExtendGift.ShowActivityPanel(actor)
end

--购买礼包
function ActivityExtendGift.RechargeBuyGift(actor, seq)
    if BF_IsNullObj(actor) then
        return
    end   

    local datastr = getplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end    
    local giftstatus = GetGiftStatus(actor, seq, rewardtab)
    if giftstatus ~= GIFT_STATUS_CAN_BUY then
        Player.SendSelfMsg(actor, '礼包当前状态还不可购买！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    
    local cfginfo = cfgActivityExtendGift[seq]
    if cfginfo == nil then
        Player.SendSelfMsg(actor, '礼包不可购买！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    
    if not Player.CheckItemsEnough(actor, cfginfo.needitems_tab, '进阶礼包：') then
        return
    end
    Player.TakeItems(actor, cfginfo.needitems_tab, '进阶礼包：'..seq)
     
    Player.GiveItemsToBagOrMail(actor, cfgActivityExtendGift[seq].rewards_tab, '进阶礼包：'..seq)
    rewardtab[#rewardtab+1] = seq
    local datastr = tbl2json(rewardtab)
    setplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA, datastr)
    ActivityExtendGift.ShowActivityPanel(actor)
end

--直购礼包购买成功后的回调  [现阶段无用]
function ActivityExtendGift.RechargeBuyGiftCallBack(actor, seq)
    if BF_IsNullObj(actor) then
        return
    end
    
    local datastr = getplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end    
    local giftstatus = GetGiftStatus(actor, seq, rewardtab)
    if giftstatus ~= GIFT_STATUS_CAN_BUY then
        Player.SendSelfMsg(actor, '礼包当前状态不可购买!!!', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    
    Player.GiveItemsToBagOrMail(actor, cfgActivityExtendGift[seq].rewards_tab, '进阶礼包：'..seq)
    rewardtab[#rewardtab+1] = seq
    local datastr = tbl2json(rewardtab)
    setplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA, datastr)
    ActivityExtendGift.ShowActivityPanel(actor)
end

function ActivityExtendGift.IsTopIconHaveRedPoint(actor)
    local datastr = getplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA)
    local rewardtab = {}
    if datastr ~= '' then
        rewardtab = json2tbl(datastr)
    end

    for i = 1, #cfgActivityExtendGift, 1 do
        local giftstatus = GetGiftStatus(actor, i, rewardtab)
        if giftstatus == GIFT_STATUS_CAN_GET then            
            return true
        end
    end

    return false
end

return ActivityExtendGift