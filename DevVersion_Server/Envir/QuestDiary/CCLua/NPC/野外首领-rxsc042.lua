require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()

function main(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_PUBLIC_BOSS, true) then
        return
    end

    show_boss_panel(actor)
end

--显示BOSS面板
function show_boss_panel(actor)
    local msg = '<Img|id=10|children={20,30,40}|x=148.0|y=56.0|show=0|move=0|bg=1|img=private/cc_bosslist/11.png|reset=1|esc=1|loadDelay=1>'..
        '<Layout|id=20|x=682.0|y=11.0|width=80|height=80|link=@exit>'..
        '<Button|id=30|x=685.0|y=20.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>'

    local nStartID = 500
    local idstr = ''
    for i = 1, #cfgPublicBossInfo, 1 do
        if idstr ~= '' then
            idstr = idstr..','
        end
        idstr = idstr..(nStartID + i*20)           
    end
    msg = msg..'<ListView|id=40|children={'..idstr..'}|x=60.0|y=60.0|width=600|height=350|margin=0|direction=1>'
    local currlv = Player.GetLevel(actor)
    for i = 1, #cfgPublicBossInfo, 1 do
        local info = cfgPublicBossInfo[i]
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
                    msg = msg..'<Text|id='..(baseid+4)..'|text=死亡复活中，请刷新|size=18|x=420|y=50|color='..CSS.NPC_RED..'>'
                end                                
            end
        end
        msg = msg..'<Text|id='..(baseid+5)..'|text=血量剩余：'..lefthprate..'%|size=18|x=250|y=10|color='..CSS.NPC_YELLOW..'>'
    end

    BF_ShowSpecialUI(actor, msg)
end

--前往挑战boss
function goto_boss(actor, sid)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_PUBLIC_BOSS, false) then
        return
    end

    if not BF_IsNumberStr(sid) then
        return
    end
    local id = tonumber(sid)
    if (id < 1) or (id > #cfgPublicBossInfo) then
        return
    end
    local bossinfo = cfgPublicBossInfo[id]
    if bossinfo == nil then
        return
    end
    if Player.GetLevel(actor) < bossinfo.needlevel then
        Player.SendSelfMsg(actor, '挑战需要的等级不足！', CommonDefine.MSG_POS_TYPE_SYS_CHANNEL)
        return
    end

    map(actor, bossinfo.mapid)
end