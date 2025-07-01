TreasureMap = {}

--单日藏宝图最大寻宝次数
local TREASURE_MAP_DAY_MAX_TIMES = 10
--挖藏宝图消耗
local TREASURE_MAP_NEEDITEMS = {{name='藏宝图', num=1}}
--挖宝藏的进度条 读条秒数
local TREASURE_MAP_DIG_NEED_SECONDS = 8
--藏宝图的随机位置
local TREASURE_MAP_POSITION_CONFIG = {
    {prop=100, mapidstr='rxsc042', x=120, y=200},
    {prop=100, mapidstr='rxsc042', x=220, y=800},
    {prop=100, mapidstr='rxsc042', x=180, y=400},
    {prop=100, mapidstr='rxsc042', x=320, y=600},
    {prop=100, mapidstr='rxsc042', x=420, y=270},
    {prop=100, mapidstr='rxsc042', x=120, y=200},
    {prop=100, mapidstr='rxsc042', x=220, y=600},
    {prop=100, mapidstr='rxsc042', x=180, y=400},
    {prop=100, mapidstr='rxsc042', x=320, y=600},
    {prop=100, mapidstr='rxsc042', x=420, y=270},
}
--触发战力boss的概率，百分比
local TRIGGER_RANDOMBOSS_RATE = 10
--藏宝图挖出的奖励
local TREASURE_MAP_RANDOM_REWARDS = {
    {prop=100, items={{name='强效太阳水', num=5}}},
	{prop=100, items={{name='强化石', num=100}}},
	{prop=100, items={{name='绑定元宝', num=200}}},
	{prop=75, items={{name='升星石', num=50}}},
	{prop=100, items={{name='书页', num=100}}},
	{prop=100, items={{name='祝福油', num=20}}},
	{prop=75, items={{name='幸运符', num=1}}},
	{prop=80, items={{name='保底符', num=1}}},
	{prop=80, items={{name='无双经验珠', num=2}}},
	{prop=100, items={{name='金砖', num=1}}},
	{prop=60, items={{name='魔方阵凭证', num=1}}},
	{prop=60, items={{name='武卫精魄', num=5}}},
	{prop=60, items={{name='御卫精魄', num=5}}},
	{prop=60, items={{name='虎卫精魄', num=5}}},
	{prop=60, items={{name='宿卫精魄', num=5}}},
	{prop=60, items={{name='技能秘籍', num=30}}},
}
local CHECKBOX_VAR = CommonDefine.VAR_N_NPC_CHECKBOX_11

--功能按键
local TREASUREMAP_BUTTONFUNC_ID_1 = 1
local TREASUREMAP_BUTTONFUNC_ID_2 = 2

local function ShowAutoGotoPanel(actor)
    local curridx = getplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID)
    local posinfo = TREASURE_MAP_POSITION_CONFIG[curridx]
    if posinfo == nil then  
        return
    end 
    local mapname = getmapname(posinfo.mapidstr) 

    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15}|x=395.0|y=191.0|show=0|bg=1|img=private/cc_treasuremap/1.png|esc=1|reset=1|move=0>'..
        '<Layout|id=11|x=392.0|y=2.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=395.0|y=3.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
        '<Text|id=13|x=40.0|y=70.0|size=18|color=151|text=本次藏宝点坐标为：'..mapname..'【'..posinfo.x..','..posinfo.y..'】>'..
        '<Text|id=14|x=120.0|y=100.0|size=18|color=151|text=是否立即前往挖宝？>'..
        '<Button|id=15|x=140.0|y=150.0|color=255|mimg=private/cc_common/button_1.png|pimg=private/cc_common/button_1.png|nimg=private/cc_common/button_1.png|size=18|text=立即前往|link=@treasuremap_button,'..
        TREASUREMAP_BUTTONFUNC_ID_1..'>'

    BF_ShowSpecialUI(actor, strPanelInfo)
end

--处理button回调
function TreasureMap.DoOperButton(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end

release_print('TreasureMap.DoOperButton')

    local funcid = tonumber(sid)
    if funcid == TREASUREMAP_BUTTONFUNC_ID_1 then    
        local curridx = getplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID)
        local posinfo = TREASURE_MAP_POSITION_CONFIG[curridx]
        if posinfo then            
            Player.AutoGoToTargMapXY(actor, posinfo.mapidstr, posinfo.x, posinfo.y)
        end
    elseif funcid == TREASUREMAP_BUTTONFUNC_ID_2 then
        local value = getplaydef(actor, CHECKBOX_VAR)
        if value==0 or value==1 then
            setplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_NO_PANELTIP_FLAG, value)
            ShowAutoGotoPanel(actor)
        end
    end
end

function TreasureMap.DoUseItem(actor)
    if BF_IsNullObj(actor) then
        return false
    end
    local currtimes = getplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_USETIMES)
    if currtimes >= TREASURE_MAP_DAY_MAX_TIMES then
        Player.SendSelfMsg(actor, '藏宝图今日使用次数已达到上限，请明日再来！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return false
    end

    local curridx = getplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID)
    local posinfo = TREASURE_MAP_POSITION_CONFIG[curridx]
    if posinfo == nil then        
        posinfo, curridx = BF_GetRandomTab(TREASURE_MAP_POSITION_CONFIG, -1)      
        if posinfo == nil then
            Player.SendSelfMsg(actor, '暂时无法使用，请稍后再试！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
            return false
        end
        setplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID, curridx)
    end
    
    local distance = BF_GetDistanceFromMapPoint(actor, posinfo.mapidstr, posinfo.x, posinfo.y)
    if distance == 0 then
        showprogressbardlg(actor, TREASURE_MAP_DIG_NEED_SECONDS, '@treasuremap_dig_callback', '挖宝中...', 0, '')
        return false
    else
        local mapname = getmapname(posinfo.mapidstr)        
        Player.SendSelfMsg(actor, '宝藏在['..mapname..', '..posinfo.x..','..posinfo.y..']', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        if getplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_NO_PANELTIP_FLAG) == 0 then
            ShowAutoGotoPanel(actor)
        end
        return false
    end
end

function TreasureMap.DigCallBack(actor)
    if BF_IsNullObj(actor) then
        return
    end
    local currtimes = getplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_USETIMES)
    if currtimes >= TREASURE_MAP_DAY_MAX_TIMES then
        Player.SendSelfMsg(actor, '藏宝图今日使用次数已达到上限，请明日再来！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local curridx = getplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID)
    local posinfo = TREASURE_MAP_POSITION_CONFIG[curridx]
    if posinfo == nil then        
        return
    end

    if not Player.CheckItemsEnough(actor, TREASURE_MAP_NEEDITEMS, '挖藏宝图') then        
        return
    end

    local distance = BF_GetDistanceFromMapPoint(actor, posinfo.mapidstr, posinfo.x, posinfo.y)
    if distance <= 3 then        
        --扣除消耗
        Player.TakeItems(actor, TREASURE_MAP_NEEDITEMS, '挖藏宝图')        
        setplaydef(actor, CommonDefine.VAR_J_DAY_TREASUREMAP_USETIMES, currtimes + 1)
        setplaydef(actor, CommonDefine.VAR_U_TREASUREMAP_CURRID, 0)

        --每日必做计数        
        EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_TREASUREMAP, 1)        

        if math.random(1, 100) <= TRIGGER_RANDOMBOSS_RATE then
            --触发战力boss
            if RandomBossManager.CreateNewRandomBoss(actor) > 0 then
                Player.SendSelfMsg(actor, '当前藏宝图中触发战力首领，前往挑战有惊喜！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)        
                return
            end
        end

        --发放随机奖励        
        Player.SendSelfMsg(actor, '恭喜你挖到宝藏！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        local rewardtab = BF_GetRandomTab(TREASURE_MAP_RANDOM_REWARDS, -1)
        if rewardtab ~= nil then
            Player.GiveItemsToBagOrMail(actor, rewardtab.items, '挖取藏宝图奖励')
        end        
    else
        Player.SendSelfMsg(actor, '当前距离宝藏位置太远！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    end
end

return TreasureMap