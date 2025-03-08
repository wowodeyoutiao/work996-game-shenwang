-------------------------
-------------------------
--�������ṩ��������չ
-------------------------
-------------------------

--���Դ�ӡ��Ϣ
function BF_DebugOut(info)
    if CommonDefine.DEBUG_MODE == 1 then
        local sinfo = '===[������Ϣ]:'..info
        release_print(sinfo)
    end    
end

--�쳣��ӡ��Ϣ
function BF_ExceptionOut(info)
    local sinfo = '===[�쳣��Ϣ]:'..info
    release_print(sinfo)
end

--�жϲ����ַ����Ƿ�Ϊ����
function BF_IsNumberStr(value)
    if value == nil then
        return false
    end
    local num = tonumber(value)
    if num ~= nil then
        return true
    else
        return false
    end
end

--�ж϶����Ƿ�Ϊ��
function BF_IsNullObj(obj)
    if (obj == nil) or (obj == '0') then
        return true
    end
    return false
end

--�ж�table���Ƿ����ظ�Ԫ��
function BF_HasDuplicates(table)
    local seen = {}
    for _, value in ipairs(table) do
        if seen[value] then
            return true -- �ҵ��ظ�������true
        end
        seen[value] = true
    end
    return false -- û���ҵ��ظ�������false
end

--������ת��Ϊ��ʾ�ַ��������ڹ������ʾΪ**��
function BF_NumToShowStr(num)
    if num == nil then
        return ''
    end

    local str = ''
    if num >= 10000 then
        str = ''..math.floor(num / 10000)..'��'
    else
        str = ''..num
    end
    return str
end

--���� os.time() ��Ӧ������
function BF_GetDay(t)
	return math.floor((t+8*60*60) / (60*60*24))
end

--���� os.time() ��Ӧ����
function BF_GetWeek(t)
    return math.floor((BF_GetDay(t) + 3) / 7)
end

--���ؼ�����
function BF_GetHour(t)
	return tonumber(os.date("%H", t));
end

--���ؼ�����
function BF_GetMinute(t)
    return tonumber(os.date("%M", t));
end

--����װ�����ַ���װ��λ
function BF_GetEquipPosByNameOrID(nameorid)    
    local stdmode = getstditeminfo(nameorid, CommonDefine.STDITEMINFO_STDMODE)
    return getposbystdmode(stdmode)
end

--���һ�������Ƿ������Լ����ڵ�ͼ��ָ����Χ
function BF_CheckCurrRange(obj, x, y, range)
    if (obj==nil) or (x==nil) or (y==nil) or (range==nil) then
        return false
    end

    local cur_x, cur_y = getbaseinfo(obj, CommonDefine.INFO_MAPX), getbaseinfo(obj, CommonDefine.INFO_MAPY)
    local min_x, max_x = x-range, x+range
    local min_y, max_y = y-range, y+range

    if (cur_x >= min_x) and (cur_x <= max_x) and
       (cur_y >= min_y) and (cur_y <= max_y) then
        return true
    end

    return false
end

--���һ�������Ƿ���ָ����ͼ��ָ����Χ
function BF_CheckMapRange(obj, mapstr, x, y, range)
    if (obj==nil) or (mapstr==nil) or (x==nil) or (y==nil) or (range==nil) then
        return false
    end

    local curr_map = getbaseinfo(obj, CommonDefine.INFO_MAPSTR);
    if string.lower(curr_map) ~= string.lower(mapstr) then
        return false;
    end

    return BF_CheckCurrRange(obj, x, y, range)
end

--����һ����������ͼ��ָ������ľ��룬���ڵ�ͼ�Ϸ���99999
function BF_GetDistanceFromMapPoint(obj, mapstr, x, y)
    if (obj==nil) or (mapstr==nil) or (x==nil) or (y==nil) then
        return CommonDefine.MAX_DISTANCE
    end

    local curr_map = getbaseinfo(obj, CommonDefine.INFO_MAPSTR);
    if string.lower(curr_map) ~= string.lower(mapstr) then
        return CommonDefine.MAX_DISTANCE;
    end    

    local cur_x, cur_y = getbaseinfo(obj, CommonDefine.INFO_MAPX), getbaseinfo(obj, CommonDefine.INFO_MAPY)
    return math.max(math.abs(cur_x-x), math.abs(cur_y-y))
end

--��������ID �� ����ֵ ��������
function BF_GetDescByAbilityIDAndValue(id, value)
    local sDesc = ''
    if (id==nil) or (value==nil) or (id<=0) then
        return sDesc
    end

    -- ����id��������
    local prop = cfg_att_score[id]
    -- ������Դ��ڣ�����¶�Ӧ�ķ�Χ
    if prop then             
        if (prop.Idx ~= CommonDefine.ABILITYID_MIN_DC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MAX_DC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MIN_MC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MAX_MC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MIN_SC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MAX_SC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MIN_AC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MAX_AC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MIN_MAC) and
            (prop.Idx ~= CommonDefine.ABILITYID_MAX_MAC) then
            if prop.type == 3 then
                sDesc = prop.name .. ":" .. value..'%'
            elseif prop.type == 2 then
                local v1 = value / 100
                sDesc = prop.name .. ":" .. v1..'%'
            else
                sDesc = prop.name .. ":" .. value
            end
        else
            --��Χȡֵ������ ��Ҫ�ٿ��ǣ�����������������
            --��Χȡֵ������ ��Ҫ�ٿ��ǣ�����������������
            --��Χȡֵ������ ��Ҫ�ٿ��ǣ�����������������            
        end
    end
    return sDesc
end

--��jsonת��Ϊtable�����ת�����ַ�����������־
function BF_Json2Table(jsonstr)
    local tbl = json2tbl(jsonstr)
    if type(tbl) == 'string' then
        release_print('json is not table :'..jsonstr)
    end      
    return tbl
end

--�������Ե�json�ַ�������������������table
function BF_GetPropDescTableByJson(propTabStr, checkjob)
    local showtab = {}
    if (propTabStr == nil) or (propTabStr == '') then
        return showtab
    end

    local propTab = json2tbl(propTabStr)
    showtab = BF_GetPropDescTableByTab(propTab, checkjob)
    return showtab
end

local function IsABItemForCurrJob(abitem, checkjob)
    if abitem then
        if (checkjob==nil) or (checkjob==CommonDefine.JOB_ALL) or (abitem.job==nil) or (abitem.job==CommonDefine.JOB_ALL) or (abitem.job==checkjob) then
            return true
        end
    end
    return false
end

--�������Ե�table����������������table
function BF_GetPropDescTableByTab(propTab, checkjob)
    local showtab = {}
    if (propTab == nil) or (type(propTab) ~= 'table') then
        return showtab
    end    

    -- ���ڴ洢��Χ����ֵ
    local dcRange = { lower = 0, upper = 0 }
    local mcRange = { lower = 0, upper = 0 }
    local scRange = { lower = 0, upper = 0 }
    local acRange = { lower = 0, upper = 0 }
    local macRange = { lower = 0, upper = 0 }

    -- �������еķ�Χ����ֵ
    for _, item in pairs(propTab) do
        if IsABItemForCurrJob(item, checkjob) then
            -- ����id��������
            local prop = cfg_att_score[item.id]
            -- ������Դ��ڣ�����¶�Ӧ�ķ�Χ
            if prop then
                if prop.Idx == CommonDefine.ABILITYID_MIN_DC then
                    dcRange.lower = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MAX_DC then
                    dcRange.upper = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MIN_MC then
                    mcRange.lower = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MAX_MC then
                    mcRange.upper = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MIN_SC then
                    scRange.lower = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MAX_SC then
                    scRange.upper = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MIN_AC then
                    acRange.lower = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MAX_AC then
                    acRange.upper = item.value 
                elseif prop.Idx == CommonDefine.ABILITYID_MIN_MAC then
                    macRange.lower = item.value
                elseif prop.Idx == CommonDefine.ABILITYID_MAX_MAC then
                    macRange.upper = item.value
                end
            end            
        end
    end

    -- �Ƚ���Χ����ֵ����ӵ�showtab
    if dcRange.lower and dcRange.upper and (dcRange.lower>0 or dcRange.upper>0) then
        showtab[#showtab+1] = {desc="����:" .. dcRange.lower .. "~" .. dcRange.upper}
    end
    if mcRange.lower and mcRange.upper and (mcRange.lower>0 or mcRange.upper>0) then
        showtab[#showtab+1] = {desc="ħ��:" .. mcRange.lower .. "~" .. mcRange.upper}
    end
    if scRange.lower and scRange.upper and (scRange.lower>0 or scRange.upper>0) then
        showtab[#showtab+1] = {desc="����:" .. scRange.lower .. "~" .. scRange.upper}
    end
    if acRange.lower and acRange.upper and (acRange.lower>0 or acRange.upper>0) then
        showtab[#showtab+1] = {desc="���:" .. acRange.lower .. "~" .. acRange.upper}
    end
    if macRange.lower and macRange.upper and (macRange.lower>0 or macRange.upper>0) then
        showtab[#showtab+1] = {desc="ħ��:" .. macRange.lower .. "~" .. macRange.upper}
    end
    
    -- �ٽ��������Բ���
    for _, item in pairs(propTab) do
        if IsABItemForCurrJob(item, checkjob) then
            local sDesc = BF_GetDescByAbilityIDAndValue(item.id, item.value)
            if sDesc ~= '' then
                showtab[#showtab+1] = {desc=sDesc, color=item.color}
            end
        end
    end        

    return showtab    
end

--�������鷵��װ�����Զ������Ե�table
function BF_GetEquipCustomABTab(actor, equipitem, groupid)    
    if BF_IsNullObj(actor) or BF_IsNullObj(equipitem) or (groupid < CommonDefine.ITEM_CUSTOMEAB_GROUP_0) or (groupid > CommonDefine.ITEM_CUSTOMEAB_GROUP_5) then
        return nil
    end
    local allCustomABTab = {}
    local strRandomABData = getitemcustomabil(actor, equipitem)
    if (strRandomABData==nil) or (strRandomABData=='') then
        return nil
    end 

    allCustomABTab = json2tbl(strRandomABData)
    local customRandomABTab = nil
    for _, infoTab in ipairs(allCustomABTab.abil) do
        if infoTab.i == groupid then
            customRandomABTab = infoTab
        end
    end
    return customRandomABTab
end

--��չ�Ĵ��NPC�Ի���
function BF_NPCSayExt(actor, msg, width, height)
    if (actor == nil) or (msg == nil) then
        return
    end
    --[[
    local allmsg = "<Img|bg=1|move=1|reset=0|img=public/bg_npc_04.jpg>"..
                    "<Layout|x=540|width=80|height=80|link=@exit>"..
                    "<Button|x=540|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>"..msg;  
    ]]--
    local finalwidth = 540
    local finalheight = 280
    if width then
        finalwidth = width
    end
    if height then
        finalheight = height
    end
    local allmsg = "<Img|img=public/bg_npc_01.png|width="..finalwidth.."|height="..finalheight.."|scale9t=10|scale9r=10|scale9b=10|scale9l=10|bg=1|move=0|reset=1>"..
                    "<Layout|x="..(finalwidth-5).."|y=3|width=80|height=80|link=@cc_exit_npcsayext>"..
                    "<Button|x="..(finalwidth-5).."|y=2|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@cc_exit_npcsayext>"..msg;    
    --say(actor, allmsg)
    addbutton(actor, 1101, CommonDefine.ADD_BUTTON_ID_3, allmsg)
end

--ר�õ�UI��ʾ
function BF_ShowSpecialUI(actor, msg)
    if (actor == nil) or (msg == nil) then
        return
    end    
    --say(actor, msg)
    addbutton(actor, 1101, CommonDefine.ADD_BUTTON_ID_4, msg)
end

--���ص�ͼ��ˢ�µ�boss����Ϣ
--ˢ�ֱ�cfg_mongen.xls ��7�е�10���ֶα�����1 cfg_monster.xls��23���Ƿ���boss�ֶα�����1
--��������#ʣ��HP�ٷֱ�#ʣ��ˢ��ʱ�䣨��λ�룬���ڵĹ���ˢ��ʱ��Ϊ0��#��ǰX����#��ǰY����#�����������
--����  ʣ��HP�ٷֱ� ʣ��ˢ��ʱ��
function BF_GetMapBossInfo(mapid, bossmonid)
    local lefthprate = 0
    local leftseconds = 0
    local bossname = getmonbaseinfo(bossmonid, 1)
    local mapbosstab = mapbossinfo(mapid, bossname, 0, 0)    
    if mapbosstab and (#mapbosstab > 0) then
        local strTab = string.split(mapbosstab[1], '#')
        if (strTab ~= false) and (#strTab >= 3) then
            lefthprate = tonumber(strTab[2])
            leftseconds = tonumber(strTab[3])            
        end
    end
    return lefthprate, leftseconds
end

--����װ�����Զ�����������Ϣ
function BF_SetCustomEquipABGroup(actor, equipitem, ablisttab, groupid, groupname, defcolor)
    if (actor == nil) or (equipitem == nil) or (ablisttab == nil) or (groupid == nil) or (groupname == nil) or (table.isempty(ablisttab)) then
        return
    end
    if ((groupid < CommonDefine.ITEM_CUSTOMEAB_GROUP_0) or (groupid > CommonDefine.ITEM_CUSTOMEAB_GROUP_5)) then
        return
    end
    if defcolor == nil then
        defcolor = CSS.CUSTOM_AB_GROUP_COLOR
    end

	changecustomitemtext(actor, equipitem, groupname, groupid)
	changecustomitemtextcolor(actor, equipitem, CSS.CUSTOM_AB_GROUP_COLOR, groupid)
    local templine = 1
    local TempLineInfo = {
        {minid=CommonDefine.ABILITYID_MIN_DC, maxid=CommonDefine.ABILITYID_MAX_DC, saveline=0},
        {minid=CommonDefine.ABILITYID_MIN_MC, maxid=CommonDefine.ABILITYID_MAX_MC, saveline=0},
        {minid=CommonDefine.ABILITYID_MIN_SC, maxid=CommonDefine.ABILITYID_MAX_SC, saveline=0},
        {minid=CommonDefine.ABILITYID_MIN_AC, maxid=CommonDefine.ABILITYID_MAX_AC, saveline=0},
        {minid=CommonDefine.ABILITYID_MIN_MAC, maxid=CommonDefine.ABILITYID_MAX_MAC, saveline=0},
    }
	for _, abinfo in pairs(ablisttab) do
        local savepos = 0
        if abinfo.savepos ~= nil then
            savepos = abinfo.savepos
        end
        local color = defcolor
        if abinfo.color ~= nil then
            color = abinfo.color
        end
		changecustomitemabil(actor, equipitem, savepos, 0, color, groupid)		
        if abinfo.captionid ~= nil then       
            changecustomitemabil(actor, equipitem, savepos, 2, abinfo.captionid, groupid)    
        end
        if abinfo.showline ~= nil then
		    changecustomitemabil(actor, equipitem, savepos, 4, abinfo.showline, groupid)
        else
            local currline = templine
            local bIsRangeAB = false
            for _, info in ipairs(TempLineInfo) do
                if (abinfo.id == info.minid) or (abinfo.id == info.maxid) then
                    if info.saveline == 0 then
                        info.saveline = templine
                        templine = templine + 1
                    else
                        currline = info.saveline
                    end
                    bIsRangeAB = true
                    break
                end
            end
            if not bIsRangeAB then
                templine = templine + 1
            end
            changecustomitemabil(actor, equipitem, savepos, 4, currline, groupid)
        end
        if abinfo.ispercentage ~= nil then
            changecustomitemabil(actor, equipitem, savepos, 3, abinfo.ispercentage, groupid)
        else
            local prop = cfg_att_score[abinfo.id]
            if prop then       
                if (prop.type == 3) or (prop.type == 2) then
                    changecustomitemabil(actor, equipitem, savepos, 3, 1, groupid)
                end            
            end
        end
        changecustomitemabil(actor, equipitem, savepos, 1, abinfo.id, groupid)
		changecustomitemvalue(actor, equipitem, savepos, '=', abinfo.value, groupid)
	end
end

--�޸�װ�����Զ��������еĵ������ԣ���ʱ�������������޵ķ�Χ����
function BF_ChgCustomEquipABSingle(actor, equipitem, abinfo, groupid, showline)
    if (actor == nil) or (equipitem == nil) or (abinfo == nil) or (groupid == nil) or (table.isempty(abinfo)) then
        return
    end
    if ((groupid < CommonDefine.ITEM_CUSTOMEAB_GROUP_0) or (groupid > CommonDefine.ITEM_CUSTOMEAB_GROUP_5)) then
        return
    end
    local savepos = 0
    if abinfo.savepos ~= nil then
        savepos = abinfo.savepos
    end

    if abinfo.color ~= nil then
        changecustomitemabil(actor, equipitem, savepos, 0, abinfo.color, groupid)		
    end
    if abinfo.captionid ~= nil then       
        changecustomitemabil(actor, equipitem, savepos, 2, abinfo.captionid, groupid)    
    end
    if showline ~= nil then
        changecustomitemabil(actor, equipitem, savepos, 4, showline, groupid)
    end
    if abinfo.ispercentage ~= nil then
        changecustomitemabil(actor, equipitem, savepos, 3, abinfo.ispercentage, groupid)
    end
    changecustomitemabil(actor, equipitem, savepos, 1, abinfo.id, groupid)
    changecustomitemvalue(actor, equipitem, savepos, '=', abinfo.value, groupid)
end

--�Ƿ�Ϊ������ħ��ֵ������ħ�����������ħ������
function BF_IsMainAbilityID(abid)
    if (abid >= CommonDefine.ABILITYID_MAX_HP) and (abid <= CommonDefine.ABILITYID_MAX_MAC) then
        return true
    end
    return false
end

--�ϲ���������table
function BF_MergeAbilityTables(table1, table2)
    local abMergeTab = {}
    if (table1 ~= nil) and (not table.isempty(table1)) then
        for _, abinfo in pairs(table1) do
            if abinfo and abinfo.id and abinfo.value then
                local skey = ''..abinfo.id
                if abMergeTab[skey] == nil then
                    abMergeTab[skey] = {id = abinfo.id, value = abinfo.value}
                else
                    abMergeTab[skey].value = abMergeTab[skey].value + abinfo.value
                end
            end            
        end
    end
    if (table2 ~= nil) and (not table.isempty(table2)) then
        for _, abinfo in pairs(table2) do
            if abinfo and abinfo.id and abinfo.value then
                local skey = ''..abinfo.id
                if abMergeTab[skey] == nil then
                    abMergeTab[skey] = {id = abinfo.id, value = abinfo.value}
                else
                    abMergeTab[skey].value = abMergeTab[skey].value + abinfo.value
                end
            end
        end
    end
    return abMergeTab
end

--�Ӵ���prop��table��������ص���table
function BF_GetRandomTab(infoTab, wholeprop)
    if (infoTab == nil) or (wholeprop == nil) then
        return nil, -1
    end
    local _totalprop = wholeprop
    if wholeprop == -1 then
        _totalprop = 0
        for _, value in ipairs(infoTab) do
            _totalprop = _totalprop + value.prop
        end
    end
    if _totalprop <= 0 then
        return nil, -1
    end
    local randnum = math.random(1, _totalprop)
    local num = 0 
    for seq, value in ipairs(infoTab) do        
        num = num + value.prop
        if num >= randnum then  
            return value, seq
        end
    end
    return nil, -1
end

--���ص���table�ı���table
function BF_GetItemTabMulti(itemsTab, multi)
    local items = {}
    if (itemsTab == nil) or (multi == nil) then
        return items
    end
    for _, value in pairs(itemsTab) do
        local rec = {name = value.name, num = math.floor(value.num * multi)}
        items[#items+1] = rec
    end
    return items
end

--���ص���table����ͨ���������Ϣ
function BF_GetSimpleItemTableDescStr(itemsTab)
    local sDescStr = ''
    for _, item in pairs(itemsTab) do
        if sDescStr ~= '' then
            sDescStr = sDescStr..';'
        end
        sDescStr = sDescStr..item.name..'*'..BF_NumToShowStr(item.num)
    end
    return sDescStr
end

--���ص���table��������Ϣ��������ҵı���������Ϣ  {{name="����1",num=100},{name="����2",num=10000}}  
function BF_GetItemTableDescStr(actor, itemsTab)
    local sDescStr = ''
    local bShowBagItems = false
    if not BF_IsNullObj(actor) then
        bShowBagItems = true
    end
    for _, item in pairs(itemsTab) do        
        if sDescStr ~= '' then
            sDescStr = sDescStr..';'
        end
        sDescStr = sDescStr..item.name..'*'..BF_NumToShowStr(item.num)
        if bShowBagItems == true then
            local currNum = Player.GetItemNumInBag(actor, item.name)
            sDescStr = sDescStr..'/'..BF_NumToShowStr(currNum)
        end        
    end
    return sDescStr
end

--��ͨ������������ýṹ������һ���������
function BF_GetRandomRewardItems(rewardItemsTab)
    local itemstab = {}
    if (rewardItemsTab == nil) or (type(rewardItemsTab) ~= 'table') then
        return itemstab
    end
    for _, value in ipairs(rewardItemsTab) do
        if math.random(1, value.maxprop) <= value.prop then
            local num1 = math.random(value.min, value.max)
            if num1 > 0 then
                local rec = {name=value.name, num=num1}
                itemstab[#itemstab+1] = rec
            end
        end
    end
    return itemstab
end

--��abilityTab={id=1,value=20,job=1} ת��Ϊ �����ַ��� #job#id#value  
function BF_GetAbilityStrByABTab(abilityTab)
    if (abilityTab==nil) or (type(abilityTab)~="table") then
        return ''
    end 
    local abStr = ''
    for _, abinfo in pairs(abilityTab) do
        local str = ''
        if (abinfo.job == nil) or (abinfo.job == CommonDefine.JOB_ALL) then
            str = '#3#'..abinfo.id..'#'..abinfo.value
        else
            str = '#'..abinfo.job..'#'..abinfo.id..'#'..abinfo.value
        end
        if abStr ~= '' then
            abStr = abStr..'|'
        end
        abStr = abStr..str
    end
    return abStr
end

--[[

--�����Զ�����˱���
function FIniPlayVar(actor, varname, isstr)
    local vartype = isstr and "string" or "integer"
    if type(varname) == "table" then
        varname = table.concat(varname, "|")
    end
    iniplayvar(actor, vartype, "HUMAN", varname)
end

--�����Զ�����˱���
function FSetPlayVar(actor, varname, value, save)
    value = value or 0
    save = save or 1
    if type(varname) == "table" then
        for _,vname in ipairs(varname) do
            setplayvar(actor, "HUMAN", vname, value, save)
        end
    else
        setplayvar(actor, "HUMAN", varname, value, save)
    end
end

--���Լ�����֪ͨ
function FSendOwnNotice(actor, code, ...)
    sendmsg(actor, ConstCfg.notice.own, ssrResponseCfg.get(code, ...))
end


--����Ʒ
function FGiveItem(actor, idx_or_name, num, bind)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return giveitem(actor, idx_or_name, num, bind)
end

--������Ʒ
function FTakeItem(actor, idx_or_name, num)
    num = num or 1
    if type(idx_or_name) == "number" then
        idx_or_name = getstditeminfo(idx_or_name, ConstCfg.stditeminfo.name)
    end
    return takeitem(actor, idx_or_name, num)
end

--��ȡ������ĳ����Ʒ����ͨ��ΨһID
function FGetItemObjByMakeIndex(actor, makeindex)
    local item_num = getbaseinfo(actor, ConstCfg.gbase.bag_num)
	for i=0, item_num-1 do
		local itemobj = getiteminfobyindex(actor, i)
		local itemmakeindex = getiteminfo(actor, itemobj, ConstCfg.iteminfo.id)
		if itemmakeindex == makeindex then
			return itemobj
		end
	end
end

--��ȡװ����λ��Ϣ
function FGetSockeTableItem(actor, itemobj, hole)
    local sockets = json.decode(getsocketableitem(actor, itemobj))
    if hole then return sockets["socket"..hole] end
    return sockets
end

--����װ����λ����
function FDrillOneHole(actor, itemobj, hole, flag)
    flag = flag and 1 or 0
    drillhole(actor, itemobj, "{hole"..hole..":"..flag.."}")
end



--����Լ���npc�ľ���
function FCheckNPCRange(actor, npcidx, range)
    range = range or 15
    local npcobj = getnpcbyindex(npcidx)
    local npc_mapid = getbaseinfo(npcobj, ConstCfg.gbase.mapid)
    local my_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if npc_mapid ~= my_mapid then return false end

    local npc_x = getbaseinfo(npcobj, ConstCfg.gbase.x)
    local npc_y = getbaseinfo(npcobj, ConstCfg.gbase.y)
    return FCheckRange(actor, npc_x, npc_y, range)
end

--���ͻ���·��npc���Ի�
local sdl_npc_list = {
    --����½npc,15ת�Ϳ���10��󿪷�
    [258] = 1,[259] = 1,[260] = 1,[262] = 1,[263] = 1,[276] = 1,[277] = 1,
    [278] = 1,[279] = 1,[280] = 1,[281] = 1,[282] = 1,[283] = 1,[284] = 1,
    [285] = 1,[286] = 1,[287] = 1,[288] = 1,[289] = 1,[290] = 1,
}
function FOpenNpcShowEx(actor, npcidx, range1, range2)
    if sdl_npc_list[npcidx] then
        local day = grobalinfo(1)
        if day < 10 then
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>Ŀ���ͼ����'..(10-day)..'�պ󿪷�</font>","Type":9}')
            return
        end
        if zslevel < 15 then
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>��Ҫת����ʮ��ת</font>","Type":9}')
            return
        end
    end
    if FCheckNPCRange(actor, npcidx) then
        opennpcshowex(actor, npcidx)
    else
        range1 = range1 or 1
        range2 = range2 or 1
        opennpcshowex(actor, npcidx, range1, range2)
    end
end





function ULogin(actor, isnewhuman)
    local level = getbaseinfo(actor, ConstCfg.gbase.level)
    setplaydef(actor, VarCfg.N_cur_level, level)
    --���˱�������
    GameEvent.push(EventCfg.goPlayerVar, actor)
    --��һ�ε�¼
    if isnewhuman then GameEvent.push(EventCfg.onNewHuman, actor) end
    --��¼
    GameEvent.push(EventCfg.onLogin, actor)
    --��¼��������
    local loginattrs = {}
    GameEvent.push(EventCfg.onLoginAttr, actor, loginattrs)
    -- LOGDump(loginattrs)
    Player.updateAddr(actor, loginattrs)
    --��¼���
    local logindatas = {}
    GameEvent.push(EventCfg.onLoginEnd, actor, logindatas)
    -- LOGDump(logindatas, "logindatas")
    table.insert(logindatas, {ssrNetMsgCfg.Global_SyncAdmini, getgmlevel(actor)})

    Message.sendmsg(actor, ssrNetMsgCfg.sync, nil, nil, nil, logindatas)
end

--�жϳɹ���:����ɹ�����false
--suc_rate:�ɹ���
--ratio:����
--return:����trueû�ɹ�
function FProbabilityHit(suc_rate, ratio)
    ratio = ratio or 100
    local rate = math.random(1, ratio)
    return rate > suc_rate
end

--���һ������ķ�Χ
function UCheckRange(x, y, range, obj)
    local min_x, max_x = x-range, x+range
    local min_y, max_y = y-range, y+range
    local cur_x, cur_y = getbaseinfo(obj, ConstCfg.gbase.x), getbaseinfo(obj, ConstCfg.gbase.y)

    if (cur_x >= min_x) and (cur_x <= max_x) and
       (cur_y >= min_y) and (cur_y <= max_y) then
        return true
    end
    
    return false
end

--����Լ���npc�ľ���
function UCheckNPCRange(actor, moduleid, npcidx, range)
    range = range or 10
    local npcobj = getnpcbyindex(npcidx)
    local npc_mapid = getbaseinfo(npcobj, ConstCfg.gbase.mapid)
    local my_mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if npc_mapid ~= my_mapid then return false end

    local npc_x = getbaseinfo(npcobj, ConstCfg.gbase.x)
    local npc_y = getbaseinfo(npcobj, ConstCfg.gbase.y)
    return UCheckRange(npc_x, npc_y, range, actor)
end

--�س�
local base_x,base_y = 333,333
function FBackZone(actor)
    mapmove(actor, "3", math.random(base_x - 9, base_x + 9), math.random(base_y - 9, base_y + 9))
end

--�ɵ�ͼ�̶������
function FMapMove(actor, mapid, x, y, x_ran, y_ran)
    if type(mapid) ~= "string" then mapid = mapid.."" end
    if x and y then
        if x_ran then x = math.random(x-x_ran, x+x_ran) end
        if y_ran then y = math.random(y-y_ran, y+y_ran) end
        mapmove(actor, mapid, x, y)
    else
        map(actor, mapid)
    end
end

--���͹���
local type1str = '{"Msg":"%s","Type":1}'
local type4str = '{"Msg":"%s","Type":5}'
function FSendNotice(actor, noticeid, t, ...)
    local cfg = cfg_announce[noticeid]
    if not cfg then return end
    local str = cfg.Announce
    if t then
        if t.name and actor then
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            str = string.gsub(str, "%%name", name)
        end

        if t.createname and actor then
            local createname = getbaseinfo(actor, ConstCfg.gbase.name)
            str = string.gsub(str, "%%CreatName", createname)
        end

        if t.targetname then
            str = string.gsub(str, "%%Name", t.targetname)
        end

        if t.map and actor then
            local mapname = getbaseinfo(actor, ConstCfg.gbase.mapid)
            str = string.gsub(str, "%%Map", mapname)
        end

        if t.item then
            str = string.gsub(str, "%%Item", t.item)
        end

        if t.itemid then
            str = string.gsub(str, "%%ItemId", t.itemid)
        end

        if t.x and actor then
            local x = getbaseinfo(actor, ConstCfg.gbase.x)
            str = string.gsub(str, "%%X", x)
        end

        if t.y and actor then
            local y = getbaseinfo(actor, ConstCfg.gbase.y)
            str = string.gsub(str, "%%Y", y)
        end
        if t.day then
            str = string.gsub(str, "%%day", t.day)
        end
        if t.level then
            str = string.gsub(str, "%%level", t.level)
        end

        if t.vip then
            str = string.gsub(str, "%%vip", t.vip)
        end
        if t.hitername and actor then
            str = string.gsub(str, "%%hitername",t.hitername)
        end
    end
    local str = string.format(str, ...)
    --cfg.Region==1:ȫ�� cfg.Region==2:��ǰ��ͼ
    for _,type in ipairs(cfg.Type) do
        local region
        if type == 1 then                           --������
            local str = string.format(type1str, str)
            if cfg.Region == 1 then
                region = 2
            elseif cfg.Region == 2 then
                region = 4
            end
            sendmsg(actor, region, str)
        elseif type == 2 then                       --�����Ϸ�
            if cfg.Region == 1 then
                region = 0
            elseif cfg.Region == 2 then
                region = 3
            end
            sendtopchatboardmsg(actor, region, 0, 0, 2, str, 1)
        elseif type == 3 then                       --����ͷ��
            if cfg.Region == 1 then
                region = 1
            elseif cfg.Region == 2 then
                region = 3
            end
            sendmsgnew(actor, 0, 0, str, region, 3)
        elseif type == 4 then                       --��Ļ����
            local str = string.format(type4str, str)
            if cfg.Region == 1 then
                region = 2
            elseif cfg.Region == 2 then
                region = 4
            end
            sendmsg(actor, region, str)
        end
    end
end

--�����ʼ�
function FSendmail(sender, id, ...)
    --LOGWrite("�����ʼ�id", id)
    local cfg = cfg_mail[id]
    if not cfg then return end
    -- if not cfg.items then return end

    --�ʼ�����
    local content
    if cfg.content then
        if cfg.parameter then
            content = string.format(cfg.content, ...)
        else
            content = cfg.content
        end
    end
    --�ʼ���Ʒ
    local stritem
    if cfg.items then
        if type(cfg.items) == "table" then
            local items
            for _,item in ipairs(cfg.items) do
                if type(item) == "table" then
                    items = items or {}
                    if item[3] == 1 then item[3] = ConstCfg.binding end
                    table.insert(items, table.concat(item, "#"))
                else
                    stritem = table.concat(cfg.items, "&")
                    break
                end
            end

            if items then stritem = table.concat(items, "&") end
        else
            stritem = cfg.items.."#1"
        end
    end
    --����
    sendmail(sender, 1, cfg.title, content, stritem)
end

]]--