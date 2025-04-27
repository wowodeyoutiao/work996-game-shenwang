YunBiaoManager = {}

--不同档次镖车的配置，高级的配到最后
local RANDOM_BIAOCHE_CONFIG = {
    {
        level=1, prop=6000, monid=2201, showname='普通镖车', showcolor=CSS.NPC_LIGHTGREEN, appr=290,
        rewarditems={{name='绑定元宝', num=100}, {name='升星石', num=50}, {name='经验', num=500000}},
        extrewarditems={{name='绑定元宝', num=100}, {name='升星石', num=50}, {name='经验', num=500000}},
    },
    {
        level=2, prop=3000, monid=2202, showname='高级镖车', showcolor=CSS.NPC_PURPLE, appr=291, 
        rewarditems={{name='绑定元宝', num=200}, {name='升星石', num=100}, {name='经验', num=1000000}},
        extrewarditems={{name='绑定元宝', num=200}, {name='升星石', num=100}, {name='经验', num=1000000}},
    },
    {
        level=3, prop=1000, monid=2203, showname='豪华镖车', showcolor=CSS.NPC_ORANGE, appr=292,
        rewarditems={{name='绑定元宝', num=300}, {name='升星石', num=200}, {name='经验', num=1500000}},
        extrewarditems={{name='绑定元宝', num=300}, {name='升星石', num=200}, {name='经验', num=1500000}},
    },
}
--刷镖需要的道具
local REFRESH_BIAOCHE_NEEDITEMS = {{name='元宝', num=100}}
--每天最大接镖次数
local DAY_MAX_ACCEPT_BIAOCHE_TIMES = 2
--多少次刷新必最高等级镖车
local TOP_BIAOCHE_NEED_MAX_REFRESH_TIMES = 10
--镖车持续时间，秒
local BIAOCHE_LAST_SECONDS = 20 * 60
--镖车初始坐标
local BIAOCHE_INIT_POS = {mapid='3', x=322, y=342}
--镖车交镖的坐标
local BIAOCHE_TARG_MAPID = '3'
--镖车的寻路点
local BIAOCHE_TARG_POS = {x=409, y=329}
--镖车需要人的距离
local BIAOCHE_NEED_MASTER_DISTANCE = 10
--运镖加成奖励的时间  对应extrewarditems
local EXT_REWARD_TIME = {starthour=10, endhour=13}



local function GetBiaoCheConfig(id)
    if (id > 0) and (id <= #RANDOM_BIAOCHE_CONFIG) then
        return RANDOM_BIAOCHE_CONFIG[id]
    end
    return nil
end

local function GetCurrBiaoCheMon(actor, biaocheid)
    local ncount = getbaseinfo(actor,CommonDefine.INFO_SLAVECOUNT)
    local config = GetBiaoCheConfig(biaocheid)
    if config == nil then
        return nil
    end

    for i=0, ncount-1 do
        local mon = getslavebyindex(actor, i)
        if not BF_IsNullObj(mon) then
            local monid = Player.GetMonIdx(mon)
            if (monid == config.monid) then
                return mon
            end
        end
    end
    return nil
end

function YunBiaoManager.ShowAcceptBiaoChePanel(actor)
    local showname = ''
    local showcolor = CSS.NPC_WHITE
    local appr = 290
    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    if currid == 0 then
        currid = 1
        setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID, currid)
    end
    local biaocheinfo = GetBiaoCheConfig(currid)
    if biaocheinfo == nil then
        return
    end

    showname = biaocheinfo.showname
    showcolor = biaocheinfo.showcolor
    appr = biaocheinfo.appr
    local accepttimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES)
    local needitemdesc = BF_GetSimpleItemTableDescStr(REFRESH_BIAOCHE_NEEDITEMS)
    local lefttimes = 0
    if accepttimes < DAY_MAX_ACCEPT_BIAOCHE_TIMES then
        lefttimes = DAY_MAX_ACCEPT_BIAOCHE_TIMES - accepttimes
    end

    if lefttimes == 0 then
        local strPanelInfo = '<Img|id=10|children={11,12,13}|x=150.0|y=21.0|move=0|show=0|loadDelay=1|bg=1|img=private/cc_yunbiao/4.png|esc=1|reset=1>'..
        '<Layout|id=11|x=687.0|y=15.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=688.0|y=15.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Text|id=13|x=85.0|y=98.0|size=18|color=255|text=王镖头：今天运镖次数已达上限，明天再来吧！>'        
        BF_ShowSpecialUI(actor, strPanelInfo)
        return
    end

    local strPanelInfo = '<Img|id=10|children={11,12,13,14,15,16,17,18,19,20,30}|x=150.0|y=21.0|move=0|show=0|loadDelay=1|bg=1|img=private/cc_yunbiao/4.png|esc=1|reset=1>'..
        '<Layout|id=11|x=687.0|y=15.0|width=80|height=80|link=@exit>'..
        '<Button|id=12|x=688.0|y=15.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>'..
        '<Text|id=13|x=85.0|y=98.0|size=18|color=255|text=王镖头：每天的10点到13点运镖可以获得双倍奖励！>'..
        '<Text|id=14|x=85.0|y=140.0|size=22|color=255|text=当前镖车：>'..
        '<Text|id=15|x=190.0|y=140.0|size=22|color='..showcolor..'|text='..showname..'>'..
        '<Effect|id=30|x=460|y=300|effecttype=2|effectid='..appr..'|dir=2|act=1>'

--[[
— — <Effect|effectid=xxxx|effecttype=xx|scale=xx>
— — 特效
— — effectid 特效id
— — effecttype 特效类型 0.特效 1.npc 2.怪物 3.技能 4.人物 5.武器 6.翅膀 7.发型
— — count 播放次数
— — act 特效动作 0.待机 1.走 2.攻击…
— — dir 特效方向 0.上 1.右上 2.右 …
— — speed 特效速度 1.正常速度
— — scale 缩放比例 1.正常缩放
]]--

    local biaochemon = GetCurrBiaoCheMon(actor, currid)
    if biaochemon then
        strPanelInfo = strPanelInfo..'<Text|id=18|x=85.0|y=325.0|size=18|color=255|text=请护送你的镖车到目标点！>'
        BF_ShowSpecialUI(actor, strPanelInfo)
        return
    end        

    strPanelInfo = strPanelInfo..'<Button|id=16|x=85.0|y=360.0|pimg=private/cc_yunbiao/1.png|size=18|mimg=private/cc_yunbiao/1.png|color=255|nimg=private/cc_yunbiao/1.png|link=@accept_biaoche>'..        
            '<Text|id=18|x=85.0|y=325.0|size=17|color=255|text=剩余次数:'..lefttimes..'/'..DAY_MAX_ACCEPT_BIAOCHE_TIMES..'>'        

    if currid < #RANDOM_BIAOCHE_CONFIG then
        strPanelInfo = strPanelInfo..'<Button|id=18|x=240.0|y=360.0|size=18|pimg=private/cc_yunbiao/2.png|mimg=private/cc_yunbiao/2.png|color=255|nimg=private/cc_yunbiao/2.png|link=@refresh_biaoche>'..
        '<Text|id=19|x=235.0|y=325.0|size=18|color=255|text=需：'..needitemdesc..'>'..
        '<Text|id=20|x=235.0|y=400.0|size=18|color=215|text=10次必然为高级镖车>'        
    else
        strPanelInfo = strPanelInfo..'<Text|id=17|x=240.0|y=360.0|size=20|color=215|text=已是最高等级镖车>'
    end

    BF_ShowSpecialUI(actor, strPanelInfo)
end

function YunBiaoManager.ShowSubmitBiaoChePanel(actor)
    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    local biaochemon = GetCurrBiaoCheMon(actor, currid)
    local strPanelInfo = ''    
    if biaochemon and (BF_GetDistanceFromMapPoint(biaochemon, BIAOCHE_TARG_MAPID, BIAOCHE_TARG_POS.x, BIAOCHE_TARG_POS.y) <= 3) then
        local curhour = BF_GetHour(os.time())
        local config = GetBiaoCheConfig(currid)
        if config then
            local rewarditems = config.rewarditems
            if (curhour >= EXT_REWARD_TIME.starthour) and (curhour < EXT_REWARD_TIME.endhour) then
                rewarditems = config.extrewarditems
            end

            local nStartID = 20
            local idstr = ''
            for seq, _ in ipairs(rewarditems) do
                if idstr ~= '' then
                    idstr = idstr..','
                end
                idstr = idstr..(nStartID + seq)   
            end   

            strPanelInfo = '<Img|id=10|children={11,12,13,14,'..idstr..'}|x=188.0|y=135.0|move=0|loadDelay=1|bg=1|reset=1|esc=1|show=0|img=private/cc_yunbiao/8.png>'..
                '<Layout|id=11|x=583.0|y=43.0|width=80|height=80|link=@exit>'..
                '<Button|id=12|x=583.0|y=44.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
                '<Text|id=13|x=160.0|y=71.0|size=18|color=255|text=陈镖头：辛苦你了，这是你的奖励！>'..
                '<Button|id=14|x=246.0|y=214.0|pimg=private/cc_yunbiao/5.png|color=255|size=18|mimg=private/cc_yunbiao/5.png|nimg=private/cc_yunbiao/5.png|link=@get_reward>'

            for seq, value in ipairs(rewarditems) do
                local currid = nStartID + seq
                local currx = 100 + 100 * (seq - 1)
                local curry = 125
                local itemidx = getstditeminfo(value.name, CommonDefine.STDITEMINFO_IDX)
                strPanelInfo = strPanelInfo..'<ItemShow|id='..currid..'|x='..currx..'|y='..curry..'|width=70|height=70|itemid='..itemidx..'|itemcount='..value.num..'|bgtype=1|showtips=1>'
            end            
        end
    else
        strPanelInfo = '<Img|id=10|children={11,12,13}|x=188.0|y=135.0|reset=1|show=0|img=private/cc_yunbiao/8.png|move=0|esc=1|bg=1|loadDelay=1>'..
            '<Layout|id=11|x=583.0|y=43.0|width=80|height=80|link=@exit>'..
            '<Button|id=12|x=583.0|y=44.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'..
            '<Text|id=13|x=106.0|y=69.0|size=18|color=255|text=陈镖头：从王镖头那里运镖过来就能获得奖励了！>'
    end
    BF_ShowSpecialUI(actor, strPanelInfo)
end

function YunBiaoManager.AcceptBiaoChe(actor)
    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    local biaocheinfo = GetBiaoCheConfig(currid)
    if biaocheinfo == nil then
        Player.SendSelfMsg(actor, '请先刷新出有效镖车！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local accepttimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES)
    if accepttimes >= DAY_MAX_ACCEPT_BIAOCHE_TIMES then
        Player.SendSelfMsg(actor, '今日运镖次数已达上限，请明日再来！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    
    local biaochemon = GetCurrBiaoCheMon(actor, currid)
    if biaochemon ~= nil then
        Player.SendSelfMsg(actor, '你已有镖车，请完成当前运镖后再来！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local monname = getmonbaseinfo(biaocheinfo.monid, 1)
    biaochemon = recallmob(actor, monname, 0, 3600, 0, 0, 1)
    if biaochemon == nil then
        Player.SendSelfMsg(actor, '系统繁忙，请稍后再试！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    mapmove(biaochemon, BIAOCHE_INIT_POS.mapid, BIAOCHE_INIT_POS.x, BIAOCHE_INIT_POS.y)
    --镖车时间到了才消失，人物下线不消失
    darttime(actor, BIAOCHE_LAST_SECONDS, 1)
    --设置镖车的目标 和 与主人距离
    dartmap(actor, BIAOCHE_TARG_POS.x, BIAOCHE_TARG_POS.y, BIAOCHE_NEED_MASTER_DISTANCE)    
    setplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES, accepttimes+1)
    setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_REFRESH_TIMES, 0)
    Player.SendSelfMsg(actor, '镖车已刷出！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    close(actor)

    --每日必做计数        
    EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_YUNBIAO, 1)       
end

function YunBiaoManager.RefreshBiaoChe(actor)
    local accepttimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES)
    if accepttimes >= DAY_MAX_ACCEPT_BIAOCHE_TIMES then
        Player.SendSelfMsg(actor, '今日运镖次数已达上限，请明日再来！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    if currid >= #RANDOM_BIAOCHE_CONFIG then
        Player.SendSelfMsg(actor, '当前镖车等级已是最佳，无需再刷新！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end 

    if not Player.CheckItemsEnough(actor, REFRESH_BIAOCHE_NEEDITEMS, '镖车刷新') then
        return
    end
    Player.TakeItems(actor, REFRESH_BIAOCHE_NEEDITEMS, '镖车刷新')        

    local refreshtimes = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_REFRESH_TIMES) + 1
    if refreshtimes >= TOP_BIAOCHE_NEED_MAX_REFRESH_TIMES then
        local id = #RANDOM_BIAOCHE_CONFIG
        setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID, id)
    else
        local biaocheinfo, id = BF_GetRandomTab(RANDOM_BIAOCHE_CONFIG, -1)
        if biaocheinfo then
            setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID, id)
        end
    end
    setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_REFRESH_TIMES, refreshtimes)
    Player.SendSelfMsg(actor, '镖车已刷新！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    YunBiaoManager.ShowAcceptBiaoChePanel(actor)
end

--领取镖车奖励
function YunBiaoManager.GetBiaoCheReward(actor)
    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    local config = GetBiaoCheConfig(currid)
    if config == nil then
        Player.SendSelfMsg(actor, '当前镖车不存在！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local biaochemon = GetCurrBiaoCheMon(actor, currid)
    if biaochemon == nil then
        Player.SendSelfMsg(actor, '当前镖车不存在！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local curhour = BF_GetHour(os.time())
    local rewarditems = config.rewarditems
    if (curhour >= EXT_REWARD_TIME.starthour) and (curhour < EXT_REWARD_TIME.endhour) then
        rewarditems = config.extrewarditems
    end

    setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID, 0)
    killmonbyobj(actor, biaochemon, false, false, false)
    Player.GiveItemsToBagOrMail(actor, rewarditems, '镖车奖励:'..currid)
    Player.SendSelfMsg(actor, '恭喜你获得镖车奖励！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    close(actor)    
end

--镖车到达当前目标
function YunBiaoManager.OnArriveTargetPos(actor)
    Player.SendSelfMsg(actor, '镖车已到达终点，请及时前往交镖！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
end

--玩家丢失镖车触发
function YunBiaoManager.LostBiaoChe(actor, biaoche)
    Player.SendSelfMsg(actor, '很遗憾，你的镖车已丢失！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
    setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID, 0)
end

--是否有快捷提示
function YunBiaoManager.IsHaveQuickTip(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_YUNBIAO, false) then
        return false
    end

    local currid = getplaydef(actor, CommonDefine.VAR_U_BIAOCHE_CURRID)
    local accepttimes = getplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES)
    if accepttimes >= DAY_MAX_ACCEPT_BIAOCHE_TIMES then
        return false
    end    
    local biaochemon = GetCurrBiaoCheMon(actor, currid)
    if biaochemon ~= nil then       
        return false
    end    

    return true
end

return YunBiaoManager