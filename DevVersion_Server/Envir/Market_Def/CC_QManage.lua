require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()


----------------------------------------------------------------触发回调函数start--------------------------------------------------------------------------
-- 引擎启动触发
function startup()  
    --自定义系统变量，暂时不考虑这个方案
    --inisysvar("integer","系统变量_1",0)  --声明合区时 保留主区
    --inisysvar("integer","系统变量_2",1)  --声明合区时 保留副区
    --inisysvar("integer","系统变量_3",2)  --声明合区时 取大
    --inisysvar("integer","系统变量_4",3)  --声明合区时 取小
    --inisysvar("integer","系统变量_5",4)  --声明合区时 相加
    --inisysvar("string","系统变量_6",5)   --声明合区时 相连
    --inisysvar("string","系统变量_7",6)   --声明合区时 删除       
end

-- 角色登陆触发
function login(actor)
    --自定义玩家变量初始化，这个的管理不是太方便，暂时不使用
    --iniplayvar(actor, "integer", "HUMAN", "玩家变量_1")
    --iniplayvar(actor, "string", "HUMAN", "玩家变量_2")    
--[[
    --界面初始化            
    GameCurrencyUI.InitUI(actor)
    MainUIBase.InitUI(actor) 
]]--

    --玩家是否进行新手初始化
    Player.InitNewPlayer(actor)

    --重连的时候清理残留界面
    if Player.IsReconnectLogin(actor) then
        delbutton(actor, 1101, CommonDefine.ADD_BUTTON_ID_4)    
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_1)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_39)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5) 
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_31)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_32)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_37)
        delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_38)
        delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_8)
        delbutton(actor, 101, CommonDefine.ADD_BUTTON_ID_35)
    end

    --触发玩家上线的事件监听
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, actor)    
    --激活玩家的上线称号
    Player.InitOnlineTitle(actor)
    --触发经验泡点状态更新
    Player.UpdateAutoAddExp(actor)
    --检测加速状态
    Player.CheckSpeedUpStatus(actor)        
    recalcabilitys(actor)

    --更新战力信息
    -- local currpower = Player.GetPlayerPower(actor);
    -- setplaydef(actor, CommonDefine.VAR_N_LAST_PLAYERPOWER, currpower);    
    -- local str = '<Effect|x=-550|y=-40|effectid=15001|effecttype=0|scale=0.8>'..
    --     '<TextAtlas|x=-460|y=-20|img=public/zhnli_num.png|schar=0|iheight=20|iwidth=13|text='..currpower..'>'
    -- addbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_6, str)    
    JumpAreaManager.OnInit()
end

----------------------------------------------------------------触发回调函数end--------------------------------------------------------------------------


----------------------------------------------------------------ontimer个人定时器start--------------------------------------------------------------------------
--[[
---新手快速自动升级到50
function ontimer0(actor)
    if (Player.GetLevel(actor) < CommonDefine.PLAYER_AUTO_ADDEXP_MAXLV) and (Player.GetMapIDStr(actor) == CommonDefine.MAPNAME_NEWREN) then
        changeexp(actor, '+', 20000, false)
    end
end

--激情泡点
function ontimer5(actor)
    local nFlag = getsysvar('I66');
    if nFlag ~= 1 then
        return
    end

    local distance = BF_GetDistanceFromMapPoint(actor, CommonDefine.MAPNAME_JQPD, 23, 26);
    if distance <= 1 then
        changemoney(actor, CommonDefine.ITEMID_GOLD, '+', 20, '泡点', true)
        changeexp(actor, '+', 300000, true)     --激情泡点经验加聚灵珠上
    elseif distance <= 2 then
        changemoney(actor, CommonDefine.ITEMID_GOLD, '+', 15, '泡点', true)
        changeexp(actor, '+', 200000, true)     --激情泡点经验加聚灵珠上
    elseif distance <= 3 then
        changemoney(actor, CommonDefine.ITEMID_GOLD, '+', 10, '泡点', true)
        changeexp(actor, '+', 100000, true)     --激情泡点经验加聚灵珠上
    end 
end
]]--


--topicon的小红点
function ontimer101(actor)
    TopIcon.CheckRedPoint(actor)
end

--快捷前往的提示
function ontimer102(actor)
    TopIcon.CheckQuickInfoTip(actor)
end

----------------------------------------------------------------ontimer个人定时器end--------------------------------------------------------------------------



----------------------------------------------------------------ontimerex全局定时器start----------------------------------------------------------------------
function ontimerex101()
    JumpAreaManager.OnLocalServerTimer()
end
----------------------------------------------------------------ontimerex全局定时器end----------------------------------------------------------------------