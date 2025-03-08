RecycleManager = {}

local RECYCLEMANAGER_BUTTONFUNC_ID_1 = 1    --回收价目
local RECYCLEMANAGER_BUTTONFUNC_ID_2 = 2    --一键全选
local RECYCLEMANAGER_BUTTONFUNC_ID_3 = 3    --一键反选
local RECYCLEMANAGER_BUTTONFUNC_ID_4 = 4    --点击回收
local RECYCLEMANAGER_BUTTONFUNC_ID_5 = 5    --设置当前类型的自动回收

local RECYCLEMANAGER_BUTTONFUNC_ID_10 = 10  --打开装备回收界面
local RECYCLEMANAGER_BUTTONFUNC_ID_11 = 11  --打开直升宝石回收界面
local RECYCLEMANAGER_BUTTONFUNC_ID_12 = 12  --打开之前的回收界面

local RECYCLEMANAGER_BUTTONFUNC_ID_14 = 14  --引导前往免费VIP的NPC处完成任务
local RECYCLEMANAGER_BUTTONFUNC_ID_15 = 15  --购买激活自动回收的功能

local RECYCLE_TYPE_1 = 1                   --回收类型 装备
local RECYCLE_TYPE_2 = 2                   --回收类型 升星宝石

local AUTO_RECYCLE_BITFLAGVAR = {
    [RECYCLE_TYPE_1] = CommonDefine.VAR_HUM_BITFLAG_AUTORECYCLE_ITEM1,
    [RECYCLE_TYPE_2] = CommonDefine.VAR_HUM_BITFLAG_AUTORECYCLE_ITEM2,
}
local AUTO_RECYCLE_CHECKBOX_TEMPVAR = 'N26'


local CHECK_TYPE_NONE = 0                  --无进一步条件检测
local CHECK_TYPE_QUALITYLV = 1             --判断道具的品质

--显示回收主界面
function RecycleManager.ShowRecycleEnterUI(actor)
    --[[
    local sPanelStr = '<Img|x=173.0|y=154.0|show=0|loadDelay=1|reset=1|bg=1|move=0|esc=1|img=private/cc_recycle/7.png>'..
        '<Layout|x=566.0|y=156.0|width=80|height=80|link=@exit>'..
        '<Button|x=566.0|y=156.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Button|x=239.0|y=250.0|nimg=private/cc_recycle/9.png|pimg=private/cc_recycle/9.png|mimg=private/cc_recycle/9.png|color=255|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_10..'>'..
        '<Button|x=399.0|y=250.0|nimg=private/cc_recycle/11.png|pimg=private/cc_recycle/11.png|mimg=private/cc_recycle/11.png|color=255|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_11..'>'
    BF_ShowSpecialUI(actor, sPanelStr)
    ]]--
    --后面就在这个页面上增加两个页签，用来切换装备和其它道具类的
    setplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE, RECYCLE_TYPE_1)
    RecycleManager.ShowRecyclePanelInfo(actor)    
end

local function GetRecycleCfg(id)
    for _, value in pairs(cfgRecycleSetting) do
        if value.id == id then
            return value
        end
    end
    return nil
end

local function GetValidSettingKeysInOrder(recycletype)
    local keys = {}
    for key, value in pairs(cfgRecycleSetting) do
        if value.recycletype == recycletype then
            table.insert(keys, key)
        end
    end
    table.sort(keys)
    return keys
end

function RecycleManager.ShowRecyclePanelInfo(actor)    
    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    local keys = GetValidSettingKeysInOrder(recycletype)
    local childidstr = '201,202,210,211,212,213,214,215,216'
    local startid = 250
    for seq, _ in ipairs(keys) do
        local id1 = startid + (seq-1) * 2 + 1
        local id2 = startid + (seq-1) * 2 + 2
        childidstr = childidstr..','..id1..','..id2
    end

    local backpic = 'private/cc_recycle/18.png'
    if recycletype == RECYCLE_TYPE_1 then
        backpic = 'private/cc_recycle/18.png'
    elseif recycletype == RECYCLE_TYPE_2 then
        backpic = 'private/cc_recycle/20.png'
    end

    local msg = '<Img|id=200|children={'..childidstr..'}|x=22.0|y=51.0|move=1|loadDelay=0|show=0|bg=1|img='..backpic..'|esc=1|reset=1>'..
        '<Layout|id=201|x=688.0|y=20.0|width=80|height=80|link=@cc_exit_specialui>'..
        '<Button|id=202|x=688.0|y=20.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@cc_exit_specialui>'    

    local nStartX = 100
    local nStartY = 100
    for seq, key in ipairs(keys) do
        local cfginfo = cfgRecycleSetting[key]
        local flag = getflagstatus(actor, cfginfo.flagvar)
        local id1 = startid + (seq-1) * 2 + 1
        local id2 = startid + (seq-1) * 2 + 2
        local color = cfginfo.showcolor
        msg = msg..'<CheckBox|x='..nStartX..'|y='..nStartY..'|id='..id1..'|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..
            cfginfo.tempvar..'|default='..flag..'|delay=0|count=1|link=@set_recycle_option,'..cfginfo.id..'>'..
            '<Text|text='..cfginfo.tip..'|x='..(nStartX+30)..'|y='..(nStartY+5)..'|id='..id2..'|color='..color..'>'            
        if seq % 3 == 0 then
            nStartX = 100
            nStartY = nStartY + 50
        else
            nStartX = nStartX + 180
        end                
    end    

    local tempx = 95
    local tempy = 315
    --玩家NPC对话框中的第十四个CheckBox选项 
    local tempflag = getflagstatus(actor, AUTO_RECYCLE_BITFLAGVAR[recycletype])
    msg = msg..'<CheckBox|x='..tempx..'|y='..tempy..'|id=214|nimg=private/cc_common/checkbox_1.png|pimg=private/cc_common/checkbox_2.png|checkboxid='..AUTO_RECYCLE_CHECKBOX_TEMPVAR..
        '|default='..tempflag..'|delay=0|count=1|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_5..'>'
        
    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE) == 1 then
        msg = msg..'<Text|text=开启自动回收|x='..(tempx+30)..'|y='..(tempy+5)..'|id=215|color='..CSS.NPC_YELLOW..'>'
    else
        msg = msg..'<Text|text=开启自动回收|x='..(tempx+30)..'|y='..(tempy+5)..'|id=215|color='..CSS.NPC_GRAY..'>'..
            '<Text|text=[达到VIP2或者花费100元宝开启]|x='..(tempx+150)..'|y='..(tempy+5)..'|id=216|color='..CSS.NPC_YELLOW..'>'
    end

    msg = msg..'<Button|id=210|x=95.0|y=375.0|nimg=private/cc_recycle/13.png|mimg=private/cc_recycle/13.png|color=255|pimg=private/cc_recycle/13.png|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_1..'>'..
        '<Button|id=211|x=240.0|y=375.0|nimg=private/cc_recycle/14.png|mimg=private/cc_recycle/14.png|color=255|pimg=private/cc_recycle/14.png|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_2..'>'..
        '<Button|id=212|x=380.0|y=375.0|nimg=private/cc_recycle/15.png|mimg=private/cc_recycle/15.png|color=255|pimg=private/cc_recycle/15.png|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_3..'>'..
        '<Button|id=213|x=525.0|y=375.0|nimg=private/cc_recycle/16.png|mimg=private/cc_recycle/16.png|color=255|pimg=private/cc_recycle/16.png|size=18|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_4..'>'
    BF_ShowSpecialUI(actor, msg)
end

function RecycleManager.ShowRecyclePriceInfo(actor)
    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    local keys = GetValidSettingKeysInOrder(recycletype)
    local childidstr = '201,202,203'
    local startid = 250
    for seq, _ in ipairs(keys) do
        childidstr = childidstr..','..(startid + seq)
    end

    local backpic = 'private/cc_recycle/19.png'
    if recycletype == RECYCLE_TYPE_1 then
        backpic = 'private/cc_recycle/19.png'
    elseif recycletype == RECYCLE_TYPE_2 then
        backpic = 'private/cc_recycle/21.png'
    end

    local msg = '<Img|id=200|children={'..childidstr..'}|x=22.0|y=51.0|move=1|loadDelay=0|show=0|bg=1|img='..backpic..'|esc=1|reset=1>'..
        '<Layout|id=201|x=688.0|y=20.0|width=80|height=80|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_12..'>'..
        '<Button|id=202|x=688.0|y=20.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_12..'>' 

    if recycletype == RECYCLE_TYPE_1 then
        msg = msg..'<Text|text=装备回收价目如下：|size=22|x=100|y=70|id=203|color='..CSS.NPC_YELLOW..'>'
    elseif recycletype == RECYCLE_TYPE_2 then
        msg = msg..'<Text|text=升星宝石回收价目如下：|size=22|x=100|y=70|id=203|color='..CSS.NPC_YELLOW..'>'
    end

    local nStartX = CSS.NPC_LEFT_START_X + 150
    local nStartY = 180
    for seq, key in ipairs(keys) do
        local cfginfo = cfgRecycleSetting[key]
        local color = cfginfo.showcolor
        local recycleitemsdesc = BF_GetSimpleItemTableDescStr(cfginfo.recycleitems_tab)
        msg = msg..'<Text|x='..nStartX..'|y='..nStartY..'|size=18|color='..color..'|text='..cfginfo.tip..'='..recycleitemsdesc..'>'       
        if seq % 2 == 0 then
            nStartX = CSS.NPC_LEFT_START_X + 150
            nStartY = nStartY + 50
        else
            nStartX = nStartX + 250
        end                
    end    
    BF_ShowSpecialUI(actor, msg)
end

function RecycleManager.ShowActivatedAutoRecyclePanel(actor)
    local sPanelStr = '<Img|x=173.0|y=154.0|reset=1|loadDelay=1|img=private/cc_recycle/24.png|esc=1|show=0|move=0|bg=1>'..
        '<Button|x=566.0|y=156.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@cc_exit_specialui>'..        
        '<Button|x=566.0|y=156.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@cc_exit_specialui>'..
        '<Button|x=235.0|y=295.0|nimg=private/cc_common/button_1.png|pimg=private/cc_common/button_1.png|color=255|size=18|mimg=private/cc_common/button_1.png|text=100元宝购买|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_15..'>'..
        '<Button|x=405.0|y=295.0|nimg=private/cc_common/button_1.png|pimg=private/cc_common/button_1.png|color=255|size=18|mimg=private/cc_common/button_1.png|text=前往提升|link=@recyclemanager_button#sid='..RECYCLEMANAGER_BUTTONFUNC_ID_14..'>'..
        '<Text|x=196.0|y=221.0|color=255|size=18|text=角色达到VIP2即可开启自动回收，完成任务>'..
        '<Text|x=223.0|y=249.0|color=255|size=18|text=即可免费激活VIP2，是否立即前往?>'
    BF_ShowSpecialUI(actor, sPanelStr) 
end

--处理button回调
function RecycleManager.DoOperButton(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)

    if funcid == RECYCLEMANAGER_BUTTONFUNC_ID_1 then
        RecycleManager.ShowRecyclePriceInfo(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_2 then
        RecycleManager.SelectAll(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_3 then
        RecycleManager.InvertAll(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_4 then
        RecycleManager.DoBagItemRecycle(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_5 then
        RecycleManager.SetAutoRecycleOption(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_10 then
        setplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE, RECYCLE_TYPE_1)
        RecycleManager.ShowRecyclePanelInfo(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_11 then
        setplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE, RECYCLE_TYPE_2)
        RecycleManager.ShowRecyclePanelInfo(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_12 then
        RecycleManager.ShowRecyclePanelInfo(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_14 then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_FREEVIP)
        close(actor)
    elseif funcid == RECYCLEMANAGER_BUTTONFUNC_ID_15 then
        RecycleManager.ActivatedAutoRecycle(actor)
    end
end

function RecycleManager.ActivatedAutoRecycle(actor)
    if BF_IsNullObj(actor) then
        return
    end
    
    if Player.GetItemNumInBag(actor, CommonDefine.ITEMID_YB) < CommonDefine.ACTIVATED_AUTORECYCLE_NEEDYB then
        Player.SendSelfMsg(actor, '你的元宝不足，请先去充值！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    changemoney(actor, CommonDefine.ITEMID_YB, '-', CommonDefine.ACTIVATED_AUTORECYCLE_NEEDYB, 'ActivateAutoRecycle', true)
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE, 1)
    RecycleManager.SetAutoRecycleOption(actor)
end

function RecycleManager.SetAutoRecycleOption(actor)
    if BF_IsNullObj(actor) then
        return
    end

    if getflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE) ~= 1 then
        RecycleManager.ShowActivatedAutoRecyclePanel(actor)
        return
    end

    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    local tempvar = getplaydef(actor, AUTO_RECYCLE_CHECKBOX_TEMPVAR)
    if (tempvar==1) or (tempvar==0) then
        if AUTO_RECYCLE_BITFLAGVAR[recycletype] then
            setflagstatus(actor, AUTO_RECYCLE_BITFLAGVAR[recycletype], tempvar)
            RecycleManager.ShowRecyclePanelInfo(actor)
        end
    end
end

function RecycleManager.SetRecycleOption(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

    local recycleid = tonumber(sid)
    local cfg = GetRecycleCfg(recycleid)
    if cfg == nil then
        return
    end

    local tempvar = getplaydef(actor, cfg.tempvar)
    if (tempvar==1) or (tempvar==0) then
        setflagstatus(actor, cfg.flagvar, tempvar)
        RecycleManager.ShowRecyclePanelInfo(actor)
    end
end

function RecycleManager.SelectAll(actor)
    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    for _, cfginfo in pairs(cfgRecycleSetting) do
        if cfginfo.recycletype == recycletype then
            setflagstatus(actor, cfginfo.flagvar, 1)                
        end
    end  
    RecycleManager.ShowRecyclePanelInfo(actor)
end

function RecycleManager.InvertAll(actor)
    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    for _, cfginfo in pairs(cfgRecycleSetting) do
        if cfginfo.recycletype == recycletype then
            local flag = getflagstatus(actor, cfginfo.flagvar)
            if flag == 0 then
                setflagstatus(actor, cfginfo.flagvar, 1)
            else
                setflagstatus(actor, cfginfo.flagvar, 0)
            end
        end
    end
    RecycleManager.ShowRecyclePanelInfo(actor)
end

function RecycleManager.IsItemNeedRecycle(actor, singleitem)
    local bFlag = false
    local targitems = {}

    if BF_IsNullObj(actor) or BF_IsNullObj(singleitem) then
        return bFlag, targitems
    end    
    
    local itemidx = getiteminfo(actor, singleitem, CommonDefine.ITEMINFO_ITEMIDX)
    local itemnum = getiteminfo(actor, singleitem, CommonDefine.ITEMINFO_OVERLAP)
    itemnum = math.max(1, itemnum)
    local stdmode = getstditeminfo(itemidx, CommonDefine.STDITEMINFO_STDMODE) 
    local qualitylv = Item.GetItemQualityLv(actor, singleitem)    

    local recycletype = getplaydef(actor, CommonDefine.VAR_N_CHOOSE_RECYCLE_TYPE)
    for _, value in pairs(cfgRecycleSetting) do
        if value.recycletype == recycletype then
            if ((value.checktype == CHECK_TYPE_QUALITYLV) and (value.checkparam == qualitylv)) or
                (value.checktype == CHECK_TYPE_NONE) then
                if (table.indexof(value.stdmodelist_tab, stdmode) ~= false) or
                   (table.indexof(value.itemidlist_tab, itemidx) ~= false) then                              
                    if getflagstatus(actor, value.flagvar) == 1 then
                        bFlag = true
                        targitems = BF_GetItemTabMulti(value.recycleitems_tab, itemnum)
                        break
                    end                                        
                end                
            end            
        end
    end
    return bFlag, targitems
end

function RecycleManager.IsItemNeedAutoRecycle(actor, itemobj)
    local bFlag = false
    local targitems = {}

    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then
        return bFlag, targitems
    end

    local itemidx = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
    local itemnum = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
    itemnum = math.max(1, itemnum)
    local stdmode = getstditeminfo(itemidx, CommonDefine.STDITEMINFO_STDMODE) 
    local qualitylv = Item.GetItemQualityLv(actor, itemobj)    

    --自动回收的玩家标记
    local autorecycleflag1 = getflagstatus(actor, AUTO_RECYCLE_BITFLAGVAR[RECYCLE_TYPE_1])
    local autorecycleflag2 = getflagstatus(actor, AUTO_RECYCLE_BITFLAGVAR[RECYCLE_TYPE_2])

    for _, value in pairs(cfgRecycleSetting) do        
        if ((value.checktype == CHECK_TYPE_QUALITYLV) and (value.checkparam == qualitylv)) or
            (value.checktype == CHECK_TYPE_NONE) then
            if ((value.recycletype == RECYCLE_TYPE_1) and (autorecycleflag1 == 1)) or
                ((value.recycletype == RECYCLE_TYPE_2) and (autorecycleflag2 == 1)) then
                if (table.indexof(value.stdmodelist_tab, stdmode) ~= false) or
                   (table.indexof(value.itemidlist_tab, itemidx) ~= false) then
                    if getflagstatus(actor, value.flagvar) == 1 then
                        bFlag = true    
                        targitems = BF_GetItemTabMulti(value.recycleitems_tab, itemnum)
                        break
                    end                    
                end
            end
        end
    end
    return bFlag, targitems
end

function RecycleManager.DoBagItemRecycle(actor)
    local bagitems = getbagitems(actor)
    if bagitems and type(bagitems)=="table" then
        local finalrecycitems = {}
        for _, singleitem in ipairs(bagitems) do
            local bFlag, targitems = RecycleManager.IsItemNeedRecycle(actor, singleitem)
            if bFlag == true then
               local rec = {itemobj = singleitem, recycleitems=targitems} 
               finalrecycitems[#finalrecycitems+1] = rec               
            end
        end

        for _, value in ipairs(finalrecycitems) do
            if not BF_IsNullObj(value.itemobj) then
                local makeindex = getiteminfo(actor, value.itemobj, CommonDefine.ITEMINFO_UNIQUEID)
                local itemcount = getiteminfo(actor, value.itemobj, CommonDefine.ITEMINFO_OVERLAP)
                itemcount = math.max(1, itemcount)
                delitembymakeindex(actor, makeindex, itemcount, 'recycleitems')
                Player.GiveItemsToBagOrMail(actor, value.recycleitems, '装备回收')
            end
        end
    end
end

--玩家获得道具时触发，自动回收
function RecycleManager.DoAutoRecycleItem(actor, itemobj)
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then 
        return
    end
    local finalrecycitems = {}
    local bFlag, targitems = RecycleManager.IsItemNeedAutoRecycle(actor, itemobj)
    if bFlag == true then    
       local rec = {itemobj = itemobj, recycleitems=targitems} 
       finalrecycitems[#finalrecycitems+1] = rec               
    end
    for _, value in ipairs(finalrecycitems) do
        if not BF_IsNullObj(value.itemobj) then
            local makeindex = getiteminfo(actor, value.itemobj, CommonDefine.ITEMINFO_UNIQUEID)
            local itemcount = getiteminfo(actor, value.itemobj, CommonDefine.ITEMINFO_OVERLAP)
            itemcount = math.max(1, itemcount)
            delitembymakeindex(actor, makeindex, itemcount, 'autorecycleitems')
            Player.GiveItemsToBagOrMail(actor, value.recycleitems, '自动回收')
        end
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ADDBAGITEM, RecycleManager.DoAutoRecycleItem, CommonDefine.FUNC_ID_RECYCLE_MANAGER)

return RecycleManager