PublicBossManager = {}

--functionid
local PUBLICBOSS_BUTTONFUNC_ID_1 = 1    --野外首领地图中的功能按键-退出地图
local PUBLICBOSS_BUTTONFUNC_ID_3 = 3    --野外首领地图中的功能按键-复活并退出地图
local PUBLICBOSS_BUTTONFUNC_ID_4 = 4    --野外首领地图中的功能按键-原地复活

--判断是否为野外首领地图
function PublicBossManager.IsBossMap(mapidstr)
    for _, value in pairs(cfgPublicBossInfo) do
        --这里放置配置mapid的时候，是数字的情况
        local idstr = value.mapid..''        
        if idstr == mapidstr then
            return true
        end
    end
    return false
end

local function InitMapUI(actor)
    addbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8, '<Button|text=离开地图|x=260|y=36|color='..CSS.NPC_WHITE..'|pimg=public/1900000662.png|nimg=public/1900000663.png|link=@publicboss_button#sid='..
        PUBLICBOSS_BUTTONFUNC_ID_1..'>')      
end

local function ClearMapUI(actor)
    delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
end

function PublicBossManager.DoMapButton(actor, sid)
    if BF_IsNullObj(actor) or not BF_IsNumberStr(sid) then
        return
    end
    local funcid = tonumber(sid)
    if funcid == PUBLICBOSS_BUTTONFUNC_ID_1 then
        --返回安全区
        Player.GoHome(actor)
    elseif funcid == PUBLICBOSS_BUTTONFUNC_ID_3 then
        --复活并返回安全区
        if Player.IsDead(actor) then
            realive(actor)                       
        end        
        Player.GoHome(actor)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_38)
    elseif funcid == PUBLICBOSS_BUTTONFUNC_ID_4 then
        --原地复活        
        if not Player.IsDead(actor) then
            return
        end

        local relivetimes = getplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES) + 1
        local needitems = Player.GetCommonLocalReliveNeedItems(relivetimes)
        if not Player.CheckItemsEnough(actor, needitems, '复活') then
            delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_38)
            return
        end        
        --扣除消耗
        Player.TakeItems(actor, needitems, '野外首领地图复活')
        setplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES, relivetimes + 1)        
        realive(actor)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_38)
    end
end

--进地图的回调
function PublicBossManager.OnEnterMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (not PublicBossManager.IsBossMap(mapidstr)) then
        return
    end
    InitMapUI(actor)
    local attackmode = getattackmode(actor)
    setplaydef(actor, CommonDefine.VAR_N_LAST_ATTACK_MODE, attackmode)
    setattackmode(actor, CommonDefine.ATTACK_MODE_ALL, 36000) 
    setplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES, 0)

    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_PUBLIC_BOSS, 1)    
end

--离开地图的回调
function PublicBossManager.OnLeaveMap(actor, mapidstr, x, y)
    if BF_IsNullObj(actor) or (not PublicBossManager.IsBossMap(mapidstr)) then
        return
    end    
    ClearMapUI(actor)    
    setattackmode(actor, -1, 0)        
    local attackmode = getplaydef(actor, CommonDefine.VAR_N_LAST_ATTACK_MODE)
    changeattackmode(actor, attackmode)
end

--玩家死亡回调
function PublicBossManager.OnPlayerDie(actor, killername)
    if BF_IsNullObj(actor) then
        return
    end
    local mapid = Player.GetMapIDStr(actor)
    if not PublicBossManager.IsBossMap(mapid) then
        return
    end
    if killername == nil then
        killername = ''
    end    

    local relivetimes = getplaydef(actor, CommonDefine.VAR_N_COMMON_LOCAL_RELIVE_TIMES)
    local needitems = Player.GetCommonLocalReliveNeedItems(relivetimes+1)
    local needitemstr = BF_GetItemTableDescStr(nil, needitems)
    local msg = '<Img|children={0,1,2,3,4,5,6}|a=1|x=120|y=-450|reset=1|move=1|img=private/revive/bg_swfh_1.png|bg=1>'..
        '<Layout|id=0|width=348|height=200>'..
        '<Text|id=1|x=110|y=15|size=18|color='..CSS.NPC_WHITE..'|text=死亡复活>'..
        '<Text|id=2|x=77|y=45|size=16|color='..CSS.NPC_WHITE..'|text=你被 '..killername..' 杀死了！>'..        
        '<Button|id=3|x=45|y=75|pimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_down1.png|color='..CSS.NPC_WHITE..'|size=17|text=立即返回|link=@publicboss_button#sid='..PUBLICBOSS_BUTTONFUNC_ID_3..'>'..
        '<Button|id=4|x=170|y=75|pimg=private/cc_common/button_up1.png|nimg=private/cc_common/button_down1.png|color='..CSS.NPC_WHITE..'|size=17|text=原地复活|link=@publicboss_button#sid='..PUBLICBOSS_BUTTONFUNC_ID_4..'>'..
        '<COUNTDOWN|id=5|x=70|y=110|time=30|count=1|size=16|color='..CSS.NPC_RED..'|link=@publicboss_button#sid='..PUBLICBOSS_BUTTONFUNC_ID_3..'>'..
        '<Text|id=6|x=170|y=110|size=16|color='..CSS.NPC_WHITE..'|text='..needitemstr..'>'  
    Player.ShowReliveDialogue(actor, msg)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERMAP, PublicBossManager.OnEnterMap, CommonDefine.FUNC_ID_PUBLIC_BOSS)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_LEAVEMAP, PublicBossManager.OnLeaveMap, CommonDefine.FUNC_ID_PUBLIC_BOSS)
GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_DIE, PublicBossManager.OnPlayerDie, CommonDefine.FUNC_ID_PUBLIC_BOSS)

return PublicBossManager