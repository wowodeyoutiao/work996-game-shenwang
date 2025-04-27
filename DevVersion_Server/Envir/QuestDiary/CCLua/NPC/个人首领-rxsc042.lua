require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()



function main(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_SINGLE_BOSS, true) then
        return
    end

    show_boss_panel(actor)
end

--显示BOSS面板
function show_boss_panel(actor)
    local msg = '<Img|id=10|children={20,30,40,50,60}|x=148.0|y=56.0|show=0|move=0|bg=1|img=private/cc_bosslist/10.png|reset=1|esc=1|loadDelay=1>'..
        '<Layout|id=20|x=682.0|y=11.0|width=80|height=80|link=@exit>'..
        '<Button|id=30|x=685.0|y=20.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'

    local nStartID = 500
    local idstr = ''
    for i = 1, #cfgSingleBossInfo, 1 do
        if idstr ~= '' then
            idstr = idstr..','
        end
        idstr = idstr..(nStartID + i*20)           
    end
    msg = msg..'<ListView|id=40|children={'..idstr..'}|x=60.0|y=60.0|width=600|height=320|margin=0|direction=1>'
    local currlv = Player.GetLevel(actor)
    for i = 1, #cfgSingleBossInfo, 1 do
        local info = cfgSingleBossInfo[i]
        local baseid = nStartID + i * 20
        local idstr1 = (baseid+1)..','..(baseid+2)..','..(baseid+3)..','..(baseid+4)..','..(baseid+5)..','..(baseid+6)
        msg = msg..'<Img|id='..baseid..'|children={'..idstr1..'}|img=private/cc_bosslist/9.png>'..
            '<Text|id='..(baseid+1)..'|text='..info.showname..'|size=20|x=15|y=10|color='..info.showcolor..'>'..
            '<Text|id='..(baseid+2)..'|text='..info.tipinfo..'|size=15|x=15|y=50|color='..CSS.NPC_WHITE..'>'

        local lefthprate, leftseconds = BF_GetMapBossInfo(info.mapid, info.monidx)
        if info.needlevel > currlv then
            msg = msg..'<Text|id='..(baseid+3)..'|text='..info.needlevel..'级可挑战|size=18|x=480|y=10|color='..CSS.NPC_RED..'>'..
                '<Text|id='..(baseid+4)..'|text=角色等级不足|size=18|x=480|y=50|color='..CSS.NPC_RED..'>'
        else
            msg = msg..'<Text|id='..(baseid+3)..'|text='..info.needlevel..'级可挑战|size=18|x=480|y=10|color='..CSS.NPC_LIGHTGREEN..'>'
            if lefthprate > 0 then
                msg = msg..'<Button|id='..(baseid+4)..'|x=480|y=40|mimg=private/cc_bosslist/7.png|nimg=private/cc_bosslist/7.png|link=@goto_boss,'..i..'>'
            else
                if leftseconds > 0 then
                    msg = msg..'<COUNTDOWN|id='..(baseid+4)..'|x=530|y=50|time='..leftseconds..'|count=1|size=18|color='..CSS.NPC_RED..'|link=@show_boss_panel>'..
                        '<Text|id='..(baseid+6)..'|text=死亡复活|size=18|x=450|y=50|color='..CSS.NPC_RED..'>'
                else
                    msg = msg..'<Text|id='..(baseid+4)..'|text=复活中，请刷新|size=18|x=460|y=50|color='..CSS.NPC_RED..'>'
                end 
            end
        end
        msg = msg..'<Text|id='..(baseid+5)..'|text=血量剩余：'..lefthprate..'%|size=18|x=250|y=10|color='..CSS.NPC_YELLOW..'>'
    end

    local lefttimes = SingleBossManager.GetLeftKillTimes(actor)
    msg = msg..'<Text|id=50|text=今日剩余次数:'..lefttimes..'|size=18|x=280|y=400|color='..CSS.NPC_WHITE..'>'
    msg = msg..'<Button|id=60|x=430|y=395|mimg=private/cc_bosslist/2.png|nimg=private/cc_bosslist/2.png|link=@wrap_show_buytimes_panel>'

    BF_ShowSpecialUI(actor, msg)
end

function wrap_show_buytimes_panel(actor)
    setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 1)
    show_buytimes_panel(actor)
end

function show_buytimes_panel(actor)
    local leftbuytimes = SingleBossManager.GetLeftBuyTimes(actor)
    local currshowtimes = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)    
    currshowtimes = math.min(currshowtimes, leftbuytimes)
    currshowtimes = math.max(1, currshowtimes)
    local msg = '<Img|id=50|children={51,52,53,54,55,56,57,58}|x=397.0|y=186.0|move=0|bg=1|img=private/cc_bosslist/8.png|loadDelay=0|esc=1|show=0|reset=1>'..
        '<Layout|id=51|x=393.0|y=-0.0|width=80|height=80|link=@show_boss_panel>'..
        '<Button|id=52|x=394.0|y=1.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@show_boss_panel>'..
        '<Text|id=53|x=122.0|y=52.0|color=215|size=18|text=今日还可购买:'..leftbuytimes..'次>'

    local needitems = SingleBossManager.GetBuyOnceNeedItems()
    if currshowtimes > 1 then
        needitems = BF_GetItemTabMulti(needitems, currshowtimes)
    end
    local needitemdesc = BF_GetSimpleItemTableDescStr(needitems)
    msg = msg..'<Button|id=54|x=80.0|y=85.0|nimg=private/cc_bosslist/3.png|mimg=private/cc_bosslist/3.png|color=255|pimg=private/cc_bosslist/3.png|size=18|link=@dec_buytimes>'..
        '<Button|id=55|x=275.0|y=85.0|nimg=private/cc_bosslist/2.png|mimg=private/cc_bosslist/2.png|color=255|pimg=private/cc_bosslist/2.png|size=18|link=@add_buytimes>'..
        '<Text|id=56|x=134.0|y=130.0|color=255|size=18|text=需要：'..needitemdesc..'>'..
        '<Button|id=57|x=140.0|y=158.0|width=100|height=35|nimg=private/cc_bosslist/6.png|mimg=private/cc_bosslist/6.png|pimg=private/cc_bosslist/6.png|color=255|size=18|link=@do_buytimes>'..
        '<Text|id=58|x=180.0|y=92.0|color=255|size=20|text='..currshowtimes..'>'
    BF_ShowSpecialUI(actor, msg)
end

--减少购买次数
function dec_buytimes(actor)
    local currshowtimes = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currshowtimes > 1 then
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currshowtimes - 1)
        show_buytimes_panel(actor)
    end
end

--增加购买次数
function add_buytimes(actor)
    local leftbuytimes = SingleBossManager.GetLeftBuyTimes(actor)
    local currshowtimes = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currshowtimes < leftbuytimes then
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, currshowtimes + 1)
        show_buytimes_panel(actor)
    end
end

--增加次数
function do_buytimes(actor)
    local currshowtimes = getplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1)
    if currshowtimes < 1 then
        return
    end
    local leftbuytimes = SingleBossManager.GetLeftBuyTimes(actor)
    if currshowtimes > leftbuytimes then
        Player.SendSelfMsg(actor, '剩余今日购买次数不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end
 
    local needitems = SingleBossManager.GetBuyOnceNeedItems()
    if currshowtimes > 1 then
        needitems = BF_GetItemTabMulti(needitems, currshowtimes)
    end
    if not Player.CheckItemsEnough(actor, needitems, '购买个人首领次数') then
        return
    end
    Player.TakeItems(actor, needitems, '购买个人首领次数')
    setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 1)
    local currbuytimes = getplaydef(actor, CommonDefine.VAR_J_DAY_SINGLEBOSS_BUYTIMES)
    setplaydef(actor, CommonDefine.VAR_J_DAY_SINGLEBOSS_BUYTIMES, currbuytimes + currshowtimes)    
    show_buytimes_panel(actor)
end

--前往挑战boss
function goto_boss(actor, sid)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_SINGLE_BOSS, false) then
        return
    end
    if not BF_IsNumberStr(sid) then
        return
    end
    local lefttimes = SingleBossManager.GetLeftKillTimes(actor)
    if lefttimes <= 0 then
        Player.SendSelfMsg(actor, '挑战剩余次数不足，可以购买增加次数！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local id = tonumber(sid)
    if (id < 1) or (id > #cfgSingleBossInfo) then
        return
    end
    local bossinfo = cfgSingleBossInfo[id]
    if bossinfo == nil then
        return
    end
    if Player.GetLevel(actor) < bossinfo.needlevel then
        Player.SendSelfMsg(actor, '挑战需要的等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    local humcount = getplaycountinmap(actor, bossinfo.mapid, 0)
    if humcount > 0 then
        Player.SendSelfMsg(actor, '有玩家还在地图中，无人时方可进入！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    map(actor, bossinfo.mapid)
end
