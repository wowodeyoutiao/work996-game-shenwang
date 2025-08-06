ItemUseManager = {}

--对应 道具表的 Anicount
function ItemUseManager.DoUse(actor, smakeindex)        
    if BF_IsNullObj(actor) or not BF_IsNumberStr(smakeindex) then
        return false
    end
    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ITEMUSE, 0)
        
    local makeindex = tonumber(smakeindex)
    local itemobj = getitembymakeindex(actor, makeindex)  
    if BF_IsNullObj(actor) or BF_IsNullObj(itemobj) then
        return false
    end

    local itemid = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_ITEMIDX)
    local anicount = getstditeminfo(itemid, CommonDefine.STDITEMINFO_ANICOUNT)
    if anicount == 0 then
        Player.SendSelfMsg(actor, '道具功能还未开启！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        return false
    -- elseif anicount == 10 then
    --     --随机传送石
    --     local mapidstr = Player.GetMapIDStr(actor)
    --     map(actor, mapidstr)
    --     return true        
    -- elseif anicount == 11 then
    --     --比奇传送石
    --     Player.GoBQHome(actor)
    --     return true       
    elseif anicount == 12 then
        --盟重回城石
        Player.GoMZHome(actor)
        return true
    elseif anicount == 201 then
        --使用藏宝图
        return TreasureMap.DoUseItem(actor)
    elseif anicount == 202 then
        --使用道具后获得对应的道具，支持固定奖励 和 随机奖励
        local itemname = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAME)
        local config = cfgUnpackItem[itemid]
        if config == nil then
            return false
        end
        --固定奖励
        if config.fixedrewards_tab and not table.isempty(config.fixedrewards_tab) then
            Player.GiveItemsToBagOrMail(actor, config.fixedrewards_tab, '使用:'..itemname)            
        end
        --随机奖励
        if config.randomrewards_tab and not table.isempty(config.randomrewards_tab) then
            local finalrewards = BF_GetRandomTab(config.randomrewards_tab, -1)
            if finalrewards and finalrewards.rewards and not table.isempty(finalrewards.rewards) then
                Player.GiveItemsToBagOrMail(actor, finalrewards.rewards, '使用:'..itemname)
            end
        end   
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ITEMUSE, 1)
        return true
    elseif anicount == 207 then
        --使用道具后获得对应的道具，支持固定奖励 和 随机奖励
        local itemname = getstditeminfo(itemid, CommonDefine.STDITEMINFO_NAME)
        local config = cfgUnpackItem[itemid]
        if config == nil then
            return false
        end
        local nPileCount = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
        for i = 1, nPileCount, 1 do
            --固定奖励
            if config.fixedrewards_tab and not table.isempty(config.fixedrewards_tab) then
                Player.GiveItemsToBagOrMail(actor, config.fixedrewards_tab, '使用:'..itemname)            
            end
            --随机奖励
            if config.randomrewards_tab and not table.isempty(config.randomrewards_tab) then
                local finalrewards = BF_GetRandomTab(config.randomrewards_tab, -1)
                if finalrewards and finalrewards.rewards and not table.isempty(finalrewards.rewards) then
                    Player.GiveItemsToBagOrMail(actor, finalrewards.rewards, '使用:'..itemname)
                end
            end               
        end
        delitembymakeindex(actor, smakeindex, nil, '使用物品 id:'..itemid..' num:'..nPileCount)
        return false    
    elseif anicount == 203 then
        --装备槽位直接升星宝石
        local starconfig = {
            {itemidx=321, star=3},
            {itemidx=322, star=4},
            {itemidx=323, star=5},
            {itemidx=324, star=6},
            {itemidx=325, star=7},
            {itemidx=326, star=8},
            {itemidx=327, star=9},
            {itemidx=328, star=10},
            {itemidx=329, star=11},
            {itemidx=330, star=12},
            {itemidx=331, star=13},
            {itemidx=332, star=14},
            {itemidx=333, star=15},
        }
        for _, value in ipairs(starconfig) do
            if value.itemidx == itemid then
                if EquipPosStarManager.RandomUpgradePosToTargStarNum(actor, value.star) then
                    setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ITEMUSE, 1)
                    return true
                end
                return false
            end
        end
        return false
    -- elseif anicount == 204 then
    --     --改名弹框
    --     local msg = '<Img|children={0,1,2,3,4}|a=1|x=737|y=201|reset=1|move=1|img=private/revive/bg_swfh_1.png|bg=1>'..
    --         '<Layout|id=0|width=348|height=200>'..
    --         '<Text|id=1|x=80|y=25|size=18|color='..CSS.NPC_WHITE..'|text=输入你要改的名字>'..            
    --         '<Input|id=2|inputid=1|type=0|x=80|y=60|width=150|height=25|place=选择新名字|placecolor='..CSS.NPC_WHITE..'|color='..CSS.NPC_WHITE..'|size=20|isChatInput=1|mincount=4|maxcount=14>'..
    --         '<Button|id=3|x=180|y=100|submitInput=1|pimg=public/1900000652.png|nimg=public/1900000653.png|color='..CSS.NPC_WHITE..'|size=17|text=确定|link=@changename_button, 1>'..
    --         '<Button|id=4|x=40|y=100|pimg=public/1900000652.png|nimg=public/1900000653.png|color='..CSS.NPC_WHITE..'|size=17|text=取消|link=@changename_button, 0>'

    --     BF_ShowSpecialUI(actor, msg)
    --     return false
    -- elseif anicount == 205 then
    --     --魔方阵凭证
    --     return MoFangZhenManager.DoAddTimesByItem(actor)
    elseif anicount == 206 then
        --增加开箱次数的筛子        
        local sparam = getstditeminfo(itemid, CommonDefine.STDITEMINFO_PARAM1)    
        if not BF_IsNumberStr(sparam) then
            return false
        end
        local nSingleAddTimes = tonumber(sparam)
        local nPileCount = getiteminfo(actor, itemobj, CommonDefine.ITEMINFO_OVERLAP)
        local nTotalAddTimes = nSingleAddTimes * nPileCount
        if nTotalAddTimes > 0 then        
            if OpenSuperBoxManager.AddNewBoxNum(actor, nTotalAddTimes) then
                setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ITEMUSE, 0)
                --删除道具
                delitembymakeindex(actor, smakeindex, nil, '使用筛子 id:'..itemid..' num:'..nPileCount)
                return false
            else
                Player.SendSelfMsg(actor, '已经达到了今日的最大可用次数！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)                
                return false
            end
        else
            Player.SendSelfMsg(actor, '无法开启 ！！！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
            return false
        end
    end
end

return ItemUseManager