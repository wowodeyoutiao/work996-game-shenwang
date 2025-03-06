EquipRandomABManager = {}

--functionid
local EQUIPRANDOM_BUTTONFUNC_ID_1 = 1           --切换待洗练装备
local EQUIPRANDOM_BUTTONFUNC_ID_2 = 2           --选择洗炼的属性序号
local EQUIPRANDOM_BUTTONFUNC_ID_3 = 3           --金币洗炼
local EQUIPRANDOM_BUTTONFUNC_ID_4 = 4           --元宝洗炼
local EQUIPRANDOM_BUTTONFUNC_ID_5 = 5           --放弃当前结果
local EQUIPRANDOM_BUTTONFUNC_ID_6 = 6           --保留当前结果

--取值区间组 1-10 随机获取，并定义颜色
--?????????????????????????????????
--?????????????????????????????????
--?????????????????????????????????  待调整概率
local GROUP_ID_PROP = {{id=1, color=CSS.QUALITY_WHITE, prop=1500}, {id=2, color=CSS.QUALITY_GREEN, prop=1500}, {id=3, color=CSS.QUALITY_GREEN, prop=1200}, 
                       {id=4, color=CSS.QUALITY_BLUE, prop=1200}, {id=5, color=CSS.QUALITY_BLUE, prop=1000}, {id=6, color=CSS.QUALITY_PURPLE, prop=1000}, 
                       {id=7, color=CSS.QUALITY_PURPLE, prop=800}, {id=8, color=CSS.QUALITY_ORANGE, prop=800}, {id=9, color=CSS.QUALITY_PINK, prop=500},
                       {id=10,  color=CSS.QUALITY_RED, prop=500}}

--是否为有效的洗炼装备位
function EquipRandomABManager.IsValidEquipPosForRandomAB(pos)
    if pos == nil then
        return false
    end
    if (pos == CommonDefine.EQUIPPOS_WEAPON) or (pos == CommonDefine.EQUIPPOS_DRESS) or (pos == CommonDefine.EQUIPPOS_NECKLACE) or 
        (pos == CommonDefine.EQUIPPOS_RING_L) or (pos == CommonDefine.EQUIPPOS_RING_R) or (pos == CommonDefine.EQUIPPOS_HELMET) or
        (pos == CommonDefine.EQUIPPOS_ARMRING_L) or (pos == CommonDefine.EQUIPPOS_ARMRING_R) or (pos == CommonDefine.EQUIPPOS_BELT) or
        (pos == CommonDefine.EQUIPPOS_BOOTS) then
        return true
    end
    return false
end

--对装备的指定第几条属性进行洗炼
function EquipRandomABManager.CreateNewRandomABInSeq(actor, equipitem, randtype) 
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return
    end
    local totalABNum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM, equipitem)
    if (totalABNum==nil) or (totalABNum<=0) then
        return
    end
    local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if (currChooseSeq<1) or (currChooseSeq>totalABNum) then
        return
    end
    --解析装备的洗炼自定义属性
    local customRandomABTab = BF_GetEquipCustomABTab(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_2)
    if customRandomABTab == nil then
        return
    end
    if currChooseSeq > #customRandomABTab.v then
        return
    end       
    local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
    if (itemid == nil) or (cfg_equip[itemid] == nil) then
        return
    end
    local randomid = cfg_equip[itemid].RandomID
    if randomid <= 0 then
        return
    end
    local qualitylv = cfg_equip[itemid].QualityLv
    if qualitylv < CommonDefine.ITEM_QUALITY_PURPLE then
        return
    end    
    --从属性池中屏蔽掉非选择的那个属性外的其它属性
    local randomABTab = {}
    for _, info in ipairs(cfgRandomABCreate[randomid].ABKindPool_Tab) do
        local bAddFlag = true
        if randtype == 0 then
            --普通随机
            for seq, singleInfo in ipairs(customRandomABTab.v) do  
                if (seq ~= currChooseSeq) and (info.abid == singleInfo[2]) then
                   bAddFlag = false
                   break
                end
            end            
        else
            --定向随机
            if (info.abid ~= customRandomABTab.v[currChooseSeq][2]) then
                bAddFlag = false
            end
        end

        if bAddFlag then
            randomABTab[#randomABTab+1] = info
        end
    end
    local abTab = BF_GetRandomTab(randomABTab, -1)
    if abTab ~= nil then
        local abid = abTab.abid
        local randomGroupTab = BF_GetRandomTab(GROUP_ID_PROP, 10000)    
        if randomGroupTab ~= nil then
            local currKey = abid * 100 + randomGroupTab.id
            if cfgRandomABPool[currKey] ~= nil then
                local nValueSeq = qualitylv - CommonDefine.ITEM_QUALITY_PURPLE + 1
                if (nValueSeq >= 1) and (nValueSeq <= #cfgRandomABPool[currKey].RangeValue_Tab) then
                    local minValue = cfgRandomABPool[currKey].RangeValue_Tab[nValueSeq].min
                    local maxValue = cfgRandomABPool[currKey].RangeValue_Tab[nValueSeq].max
                    local randValue = minValue
                    if maxValue > minValue then
                        randValue = math.random(minValue, maxValue)
                    end                    
                    local singleAB = {id=abTab.abid, value=randValue, savepos=customRandomABTab.v[currChooseSeq][7], color=randomGroupTab.color}                
                    local strNewData = tbl2json(singleAB)
                    setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, 1, equipitem)
                    setitemparam(actor, -2, CommonDefine.ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB, strNewData, equipitem)                    
                    updatecustitemparam(actor, -2, equipitem)                    
                end
            end
        end
    end      
end

--放弃指定装备的洗炼结果
function EquipRandomABManager.DropNewRandomAB(actor, equipitem)
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return
    end
    local totalABNum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM, equipitem)
    if (totalABNum==nil) or (totalABNum<=0) then
        return
    end
    local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if (currChooseSeq<1) or (currChooseSeq>totalABNum) then
        return
    end
    setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, 0, equipitem)
    setitemparam(actor, -2, CommonDefine.ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB, '', equipitem)
    updatecustitemparam(actor, -2, equipitem)
end

--保留指定装备的洗炼结果
function EquipRandomABManager.SaveNewRandomAB(actor, equipitem)
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return
    end
    local totalABNum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM, equipitem)
    if (totalABNum==nil) or (totalABNum<=0) then
        return
    end
    local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if (currChooseSeq<1) or (currChooseSeq>totalABNum) then
        return
    end
    local strSingleABData = getitemparam(actor, -2, CommonDefine.ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB, equipitem)
    if (strSingleABData==nil) or (strSingleABData=='') then
        return
    end

    local singleABTab = json2tbl(strSingleABData)
    BF_ChgCustomEquipABSingle(actor, equipitem, singleABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_2, currChooseSeq)

    setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, 0, equipitem)
    setitemparam(actor, -2, CommonDefine.ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB, '', equipitem)
    updatecustitemparam(actor, -2, equipitem)

    refreshitem(actor, equipitem)
    recalcabilitys(actor)	
end

--洗炼属性 自定义属性的起始保存位 3,4,5,6 洗炼最大占4位
local SAVE_POS_START = 3

--初始化装备的洗炼属性
function EquipRandomABManager.InitEquipRandomAB(actor, equipitem, testabnum)
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) then
        return
    end
    local itemid = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_ITEMIDX)
    if (itemid == nil) or (cfg_equip[itemid] == nil) then
        return
    end

    local randomid = cfg_equip[itemid].RandomID
    if randomid <= 0 then
        return
    end
    local qualitylv = cfg_equip[itemid].QualityLv
    if qualitylv < CommonDefine.ITEM_QUALITY_PURPLE then
        return
    end
    if (cfgRandomABCreate[randomid] == nil) or (cfgRandomABCreate[randomid].ABNumPool_Tab == nil) or
       (table.isempty(cfgRandomABCreate[randomid].ABNumPool_Tab)) then
        return
    end
 
    local abnum = 0
    if testabnum == nil then
        local numTab = BF_GetRandomTab(cfgRandomABCreate[randomid].ABNumPool_Tab, 10000);         
        if numTab == nil then
            return
        end    
        abnum = numTab.num       
    else
        abnum = testabnum
    end
    
    --生成洗炼属性的随机条数
    if abnum <= 0 then
        return
    end
 
    --生成指定条数不重复的属性
    local randomABTab = {}
    for _, info in ipairs(cfgRandomABCreate[randomid].ABKindPool_Tab) do
        randomABTab[#randomABTab+1] = info
    end
    local createABTab = {}    
    local saveCurrPos = SAVE_POS_START
    for i = 1, abnum, 1 do
        local abTab, tabSeq = BF_GetRandomTab(randomABTab, -1)
        if abTab ~= nil then
            local abid = abTab.abid
            local randomGroupTab = BF_GetRandomTab(GROUP_ID_PROP, 10000)    
            if randomGroupTab ~= nil then
                local currKey = abid * 100 + randomGroupTab.id
                if cfgRandomABPool[currKey] ~= nil then
                    local nValueSeq = qualitylv - CommonDefine.ITEM_QUALITY_PURPLE + 1
                    if (nValueSeq >= 1) and (nValueSeq <= #cfgRandomABPool[currKey].RangeValue_Tab) then
                        local minValue = cfgRandomABPool[currKey].RangeValue_Tab[nValueSeq].min
                        local maxValue = cfgRandomABPool[currKey].RangeValue_Tab[nValueSeq].max
                        local randValue = minValue
                        if maxValue > minValue then
                            randValue = math.random(minValue, maxValue)
                        end
                        local singleAB = {id=abTab.abid, value=randValue, savepos=saveCurrPos, color=randomGroupTab.color}     
                        createABTab[#createABTab+1] = singleAB                    
                        saveCurrPos = saveCurrPos + 1  
                        table.remove(randomABTab, tabSeq) 
                    end
                end
            end
        end
    end    

    setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM, #createABTab, equipitem)
    updatecustitemparam(actor, -2, equipitem)

    --增加极品属性
    BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_2, '[极品属性]:', CSS.CUSTOM_AB_GROUP_COLOR)       
    refreshitem(actor, equipitem)
end


--显示规则面板
function EquipRandomABManager.ShowRulePanel(actor)
    local strPanelInfo = '<Img|id=10|children={11,12,21,22,23,24,25,26,27,28}|x=268.0|y=69.0|show=0|esc=1|reset=1|img=private/cc_common/rule_panel.png|bg=1|move=0>'..
        '<Layout|id=11|x=525.0|y=-1.0|width=80|height=80|link=@show_base_panel>'..
        '<Button|id=12|x=528.0|y=0.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@show_base_panel>'

    local tempCurrX = 20
    local tempCurrY = 50
    strPanelInfo = strPanelInfo..'<Text|id=21|text=装备洗炼规则说明:|size=20|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_LIGHTGREEN..'>'
    tempCurrY = tempCurrY + 35
    strPanelInfo = strPanelInfo..'<Text|id=22|text=1、洗炼的属性会绑定在对应装备上，不同品质装备所带有的|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=23|text=极品属性数量不同|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=24|text=2、洗练分为金币洗练和元宝洗炼两种，其中金币洗炼时会在|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=25|text=属性种类和数值两者都进行随机；元宝洗炼则只会随机数值，|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=26|text=种类不会更改|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=27|text=3、装备品质越高，则洗炼出的属性空间越高、可洗炼的属性|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'
    tempCurrY = tempCurrY + 30
    strPanelInfo = strPanelInfo..'<Text|id=28|text=种类越多|x='..tempCurrX..'|y='..tempCurrY..'|color='..CSS.NPC_WHITE..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function GetSingleEquipShowInfo(actor, equipitem)
    local sPanelStr = ''
    if (not BF_IsNullObj(actor)) and (not BF_IsNullObj(equipitem)) then      
        local abnum = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM, equipitem)
        if (abnum==nil) or (abnum<=0) then
            return sPanelStr
        end        
        local customRandomABTab = BF_GetEquipCustomABTab(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_2)    
        if customRandomABTab == nil then
            return sPanelStr
        end

        local currOperStep = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, equipitem)   --当前洗炼状态 0等待洗炼 1洗炼出结果等待进一步操作
        local itemname = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_SRCNAME)
        local weaponcolor = Item.GetItemQualityColor(actor, equipitem)    

        sPanelStr = sPanelStr..'<Layout|id=15|children={101,102,103,120,140,160}|x=200.0|y=65.0|width=580|height=420>'..
            '<Text|id=101|x=215.0|y=12.0|color='..weaponcolor..'|size=20|text='..itemname..'>'..
            '<Img|id=102|x=-8.0|y=40.0|width=600|height=5|img=private/cc_equip_randomab/10.png>'..
            '<Img|id=103|x=-4.0|y=309.0|height=5|img=private/cc_equip_randomab/10.png>'

        --当前极品属性
        local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
                
        local startid = 120
        local idstr = startid..','..(startid+1)
        local tempLeftX = 40
        local tempLeftY = 60
        for seq, descItem in ipairs(customRandomABTab.v) do
            local color = customRandomABTab.c
            if descItem[1] then
                color = descItem[1]
            end        
            local boxid = startid + seq * 2 + 1
            local textid = startid + seq * 2 + 2
            idstr = idstr..','..boxid..','..textid
            if seq == currChooseSeq then
                sPanelStr = sPanelStr..'<CheckBox|id='..boxid..'|x='..tempLeftX..'|y='..tempLeftY..
                    '|nimg=private/cc_equip_randomab/8.png|pimg=private/cc_equip_randomab/7.png|default=1|delay=0|count=1|link=@equip_randomab_button,'..
                    EQUIPRANDOM_BUTTONFUNC_ID_2..','..seq..'>' 
            else
                sPanelStr = sPanelStr..'<CheckBox|id='..boxid..'|x='..tempLeftX..'|y='..tempLeftY..
                    '|nimg=private/cc_equip_randomab/8.png|pimg=private/cc_equip_randomab/7.png|default=0|delay=0|count=1|link=@equip_randomab_button,'..
                    EQUIPRANDOM_BUTTONFUNC_ID_2..','..seq..'>' 
            end            
            local sTempDesc = BF_GetDescByAbilityIDAndValue(descItem[2], descItem[3])
            sPanelStr = sPanelStr..'<Text|id='..textid..'|text='..sTempDesc..'|x='..(tempLeftX+30)..'|y='..tempLeftY..'|color='..color..'>'
            tempLeftY = tempLeftY + 40
        end
        sPanelStr = sPanelStr..'<Layout|id='..startid..'|children={'..idstr..'}|x=30.0|y=50.0|width=200|height=250>'..
            '<Text|id='..(startid+1)..'|x=40.0|y=20.0|color='..CSS.NPC_WHITE..'|size=20|text=当前极品属性>'        

        --洗炼中的属性
        startid = 140
        idstr =  startid..','..(startid+1)
        local tempRightX = 40
        local tempRightY = 100
        if currOperStep == 0 then
            --等待洗炼
            local textid = startid + 2 + 1
            idstr = idstr..','..textid
            sPanelStr = sPanelStr..'<Text|id='..textid..'|text=无属性|x='..tempRightX..'|y='..tempRightY..'|color='..CSS.NPC_WHITE..'>'    
        else
            --洗炼出结果等待进一步操作
            local textid = startid + 2 + 1
            idstr = idstr..','..textid            
            local sData1 = getitemparam(actor, -2, CommonDefine.ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB, equipitem)
            if (sData1~=nil) and (sData1~='') then
                local singleAB = json2tbl(sData1)
                if singleAB ~= nil then
                    local sTempDesc = BF_GetDescByAbilityIDAndValue(singleAB.id, singleAB.value)
                    local tempcolor = CSS.NPC_LIGHTGREEN
                    if singleAB.color then
                        tempcolor = singleAB.color
                    end
                    sPanelStr = sPanelStr..'<Text|id='..textid..'|text='..sTempDesc..'|x='..tempRightX..'|y='..tempRightY..'|color='..tempcolor..'>'    
                end
            end
        end
        sPanelStr = sPanelStr..'<Layout|id='..startid..'|children={'..idstr..'}|x=330.0|y=50.0|width=200|height=250>'..
            '<Text|id='..(startid+1)..'|x=40.0|y=20.0|color='..CSS.NPC_WHITE..'|size=20|text=洗炼属性>'
    
        --洗炼操作按钮    
        sPanelStr = sPanelStr..'<Layout|id=160|children={161,162,163,164}|x=0|y=300.0|width=600|height=120>'
         
        if currOperStep == 0 then
            --等待洗炼            
            local tempx = 120
            local tempy = 50
            sPanelStr = sPanelStr..'<Button|id=161|x='..tempx..'|y='..tempy..'|mimg=private/cc_equip_randomab/6.png|nimg=private/cc_equip_randomab/6.png|size=18|text=金币洗炼|color='..CSS.NPC_WHITE..
                '|link=@equip_randomab_button,'..EQUIPRANDOM_BUTTONFUNC_ID_3..'>'
            local sConsumeInfo = BF_GetItemTableDescStr(actor, CommonDefine.EQUIP_RANDOMAB_GOLD_NEEDITEMS)
            tempy = 100
            sPanelStr = sPanelStr..'<Text|id=162|text=需：'..sConsumeInfo..'|x='..(tempx-30)..'|y='..tempy..'|color='..CSS.NPC_WHITE..'>'
            
            tempx = 380
            tempy = 50
            sPanelStr = sPanelStr..'<Button|id=163|x='..tempx..'|y='..tempy..'|mimg=private/cc_equip_randomab/6.png|nimg=private/cc_equip_randomab/6.png|size=18|text=元宝洗炼|color='..CSS.NPC_WHITE..
                '|link=@equip_randomab_button,'..EQUIPRANDOM_BUTTONFUNC_ID_4..'>'
            tempy = 100
            sConsumeInfo = BF_GetItemTableDescStr(actor, CommonDefine.EQUIP_RANDOMAB_YB_NEEDITEMS)
            sPanelStr = sPanelStr..'<Text|id=164|text=需：'..sConsumeInfo..'|x='..(tempx-30)..'|y='..tempy..'|color='..CSS.NPC_WHITE..'>'
        else
            --洗炼出结果等待进一步操作
            local tempx = 120
            local tempy = 50
            sPanelStr = sPanelStr..'<Button|id=161|x='..tempx..'|y='..tempy..'|mimg=private/cc_equip_randomab/6.png|nimg=private/cc_equip_randomab/6.png|size=18|text=放弃结果|color='..CSS.NPC_WHITE..
                '|link=@equip_randomab_button,'..EQUIPRANDOM_BUTTONFUNC_ID_5..'>'

            tempx = 380
            tempy = 50                
            sPanelStr = sPanelStr..'<Button|id=163|x='..tempx..'|y='..tempy..'|mimg=private/cc_equip_randomab/6.png|nimg=private/cc_equip_randomab/6.png|size=18|text=保存结果|color='..CSS.NPC_WHITE..
                '|link=@equip_randomab_button,'..EQUIPRANDOM_BUTTONFUNC_ID_6..'>'   
        end 
    end
    return sPanelStr
end

--显示初始面板
function EquipRandomABManager.ShowBasePanel(actor)
    local posTab = {}
    for pos, posname in pairs(CommonDefine.EQUIPPOS_NAME) do
        if EquipRandomABManager.IsValidEquipPosForRandomAB(pos) then
            local equipitem = linkbodyitem(actor, pos)
            if (equipitem~=nil) and (equipitem~='0') then
                local abnum = getitemintparam(actor, pos, CommonDefine.ITEM_INTVAR_RANDOMAB_NUM)               
                if (abnum~=nil) and (abnum>0) then
                    local tab = {pos=pos, name=posname, num=abnum}
                    posTab[#posTab + 1] = tab                                    
                end
            end
        end   
    end

    local strPanelInfo = ''
    if table.isempty(posTab) then
        strPanelInfo = strPanelInfo..'<Img|id=10|children={11,12,13,14,15,16}|x=20.0|y=16.0|bg=1|img=private/cc_equip_randomab/11.png|reset=1|loadDelay=0|esc=1|move=0|show=0>'..
            '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
            '<Button|id=12|x=814.0|y=14.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
            '<Text|id=13|x=80.0|y=70.0|color=151|size=20|text=可洗炼装备>'..
            '<Text|id=14|x=120.0|y=256.0|size=22|color=255|text=空>'..
            '<Text|id=15|x=256.0|y=256.0|size=22|color=255|text=只有已穿戴且带有极品属性的装备才可洗炼！>'..
            '<Button|id=16|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'
    else
        strPanelInfo = strPanelInfo..'<Img|id=10|children={11,12,13,14,15,16}|x=20.0|y=16.0|bg=1|img=private/cc_equip_randomab/11.png|reset=1|loadDelay=0|esc=1|move=0|show=0>'..
            '<Layout|id=11|x=813.0|y=14.0|width=80|height=80|link=@exit>'..
            '<Button|id=12|x=814.0|y=14.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
            '<Text|id=13|x=72.0|y=70.0|color=151|size=18|text=双击选择装备>'..
            '<Button|id=16|x=700.0|y=14.0|esc=0|nimg=private/cc_common/button_help.png|pimg=private/cc_common/button_help.png|link=@show_rule_panel>'

        local choosepos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
                
        local idstr1 = ''
        for seq, _ in ipairs(posTab) do
            if idstr1 ~= '' then
                idstr1 = idstr1..','
            end
            idstr1 = idstr1..(30+seq)
        end
        strPanelInfo = strPanelInfo..'<ListView|id=14|children={'..idstr1..'}|x=70.0|y=110.0|width=120|height=350|margin=0|direction=1>'
        for seq, value in ipairs(posTab) do
            local baseid = 30 + seq
            local showid = baseid * 10 + 1
            local tippicid = baseid * 10 + 2
            local equipitem = linkbodyitem(actor, value.pos)
            if not BF_IsNullObj(equipitem) then
                if choosepos == -1 then          
                    choosepos = value.pos         
                    setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, choosepos)
                end

                local makeindex = getiteminfo(actor, equipitem, CommonDefine.ITEMINFO_UNIQUEID)
                strPanelInfo = strPanelInfo..'<Img|id='..baseid..'|children={'..tippicid..','..showid..'}|x=-1.0|y=4.0|width=100|esc=0|img=private/cc_equip_randomab/1.png>'..
                    '<MKItemShow|id='..showid..'|x=18|y=18|makeindex='..makeindex..'|showtips=1|bgtype=1|canmove=0|link=@equip_randomab_button,'..
                    EQUIPRANDOM_BUTTONFUNC_ID_1..','..value.pos..'>'
                if choosepos == value.pos then
                    strPanelInfo = strPanelInfo..'<Img|id='..tippicid..'|x=-6.0|y=-6.0|img=private/cc_equip_randomab/2.png>'
                    --对应当前选中的装备
                    strPanelInfo = strPanelInfo..GetSingleEquipShowInfo(actor, equipitem)
                end
            end
        end                
    end

    BF_ShowSpecialUI(actor, strPanelInfo)
end

local function ChooseTargABSeq(actor, chooseseq)
    if BF_IsNullObj(actor) then
        return
    end
    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipRandomABManager.IsValidEquipPosForRandomAB(equippos) then
        return
    end
    local currStatus = getitemintparam(actor, equippos, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS)
    if currStatus == nil then
        return
    end
    if currStatus ~= 0 then
        Player.SendSelfMsg(actor, '洗炼结果还未处理，不能继续洗炼！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end    
    local equipitem = linkbodyitem(actor, equippos)
    if BF_IsNullObj(equipitem) then
        return
    end

    local currseq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if currseq == chooseseq then
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, 0, equipitem)    
    else
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, chooseseq, equipitem)    
    end
    updatecustitemparam(actor, -2, equipitem)
end

--金币洗炼
local function DoRandomABWithGold(actor)
    if actor == nil then
        return
    end
    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipRandomABManager.IsValidEquipPosForRandomAB(equippos) then
        return
    end
    local equipitem = linkbodyitem(actor, equippos)
    if BF_IsNullObj(equipitem) then
        return
    end
    local currStatus = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, equipitem)
    if currStatus ~= 0 then
        Player.SendSelfMsg(actor, '处理洗炼结果后才可再次洗炼！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if currChooseSeq < 1 then
        Player.SendSelfMsg(actor, '请先选择要洗炼的属性，系统默认选择了第一条，请再确认！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        currChooseSeq = 1
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, 1, equipitem)
        updatecustitemparam(actor, -2, equipitem)
        return
    end    

    --条件判断
    if not Player.CheckItemsEnough(actor, CommonDefine.EQUIP_RANDOMAB_GOLD_NEEDITEMS, '金币洗炼') then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, CommonDefine.EQUIP_RANDOMAB_GOLD_NEEDITEMS, '金币洗炼')    

    --进行洗炼操作    
    EquipRandomABManager.CreateNewRandomABInSeq(actor, equipitem, 0)

    --触发金币洗炼
    FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_EQUIPRANDOMAB_GOLDTIMES, '+', 1)
    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_EQUIP_RANDOMAB, 1)              
end

--元宝洗炼
local function DoRandomABWithYB(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIP_RANDOMAB, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipRandomABManager.IsValidEquipPosForRandomAB(equippos) then
        return
    end
    local equipitem = linkbodyitem(actor, equippos)
    if BF_IsNullObj(equipitem) then
        return
    end
    local currStatus = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, equipitem)
    if currStatus ~= 0 then
        Player.SendSelfMsg(actor, '处理洗炼结果后才可再次洗炼！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    local currChooseSeq = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, equipitem)
    if currChooseSeq < 1 then
        Player.SendSelfMsg(actor, '请先选择要洗炼的属性，系统默认选择了第一条，请再确认！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        currChooseSeq = 1
        setitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_CURR_SEQ, 1, equipitem)
        updatecustitemparam(actor, -2, equipitem)
        return
    end    

    --条件判断
    if not Player.CheckItemsEnough(actor, CommonDefine.EQUIP_RANDOMAB_YB_NEEDITEMS, '元宝洗炼') then
        return
    end
    --扣除消耗
    Player.TakeItems(actor, CommonDefine.EQUIP_RANDOMAB_YB_NEEDITEMS, '元宝洗炼')    

    --进行洗炼操作    
    EquipRandomABManager.CreateNewRandomABInSeq(actor, equipitem, 1)

    --触发元宝洗炼
    FreeVIPManager.TriggerChgTaskCounter(actor, FreeVIPManager.TASK_TYPE_EQUIPRANDOMAB_YBTIMES, '+', 1)    
    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_EQUIP_RANDOMAB, 1)                  
end

--放弃洗炼结果
local function DropCurrRandomAB(actor)
    if BF_IsNullObj(actor) then
        return
    end
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIP_RANDOMAB, false) then
        return
    end

    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipRandomABManager.IsValidEquipPosForRandomAB(equippos) then
        return
    end
    local equipitem = linkbodyitem(actor, equippos)
    if BF_IsNullObj(equipitem) then
        return
    end
    local currStatus = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, equipitem)
    if currStatus == 0 then
        Player.SendSelfMsg(actor, '还未进行洗炼！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    
    --放弃当前装备的洗炼结果
    EquipRandomABManager.DropNewRandomAB(actor, equipitem)
end

--保留洗炼结果
local function SaveCurrRandomAB(actor)
    if actor == nil then
        return
    end
    local equippos = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID) 
    if not EquipRandomABManager.IsValidEquipPosForRandomAB(equippos) then
        return
    end
    local equipitem = linkbodyitem(actor, equippos)
    if BF_IsNullObj(equipitem) then
        return
    end
    local currStatus = getitemintparam(actor, -2, CommonDefine.ITEM_INTVAR_RANDOMAB_STATS, equipitem)
    if currStatus == 0 then
        Player.SendSelfMsg(actor, '还未进行洗炼！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    --保留指定装备的洗炼结果
    EquipRandomABManager.SaveNewRandomAB(actor, equipitem)    
end

--处理button回调
function EquipRandomABManager.DoOperButton(actor, sid, sparam)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end    
    local funcid = tonumber(sid)
    local param = getplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID)
    if BF_IsNumberStr(sparam) then
        param = tonumber(sparam)
    end

    if funcid == EQUIPRANDOM_BUTTONFUNC_ID_1 then
		setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID,  param)
    elseif funcid == EQUIPRANDOM_BUTTONFUNC_ID_2 then
        ChooseTargABSeq(actor, param)
    elseif funcid == EQUIPRANDOM_BUTTONFUNC_ID_3 then
        DoRandomABWithGold(actor)
    elseif funcid == EQUIPRANDOM_BUTTONFUNC_ID_4 then
        DoRandomABWithYB(actor)        
    elseif funcid == EQUIPRANDOM_BUTTONFUNC_ID_5 then
        DropCurrRandomAB(actor)
    elseif funcid == EQUIPRANDOM_BUTTONFUNC_ID_6 then
        SaveCurrRandomAB(actor)
    end
    EquipRandomABManager.ShowBasePanel(actor)
end

return EquipRandomABManager