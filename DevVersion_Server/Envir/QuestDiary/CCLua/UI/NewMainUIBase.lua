NewMainUIBase = {}

NewMainUIBase.UI_ICON_POSSTRENGTH = '1'     --槽位强化
NewMainUIBase.UI_ICON_POSSTAR = '2'         --槽位升星
NewMainUIBase.UI_ICON_BAOZHU = '3'          --灵玉
NewMainUIBase.UI_ICON_SOULSTONE = '4'       --魂石
NewMainUIBase.UI_ICON_GUANZHI = '5'         --官职
NewMainUIBase.UI_ICON_HUWEI = '6'           --护卫
NewMainUIBase.UI_ICON_SKILL = '7'           --技能
NewMainUIBase.UI_ICON_COMPOSE = '8'         --合成


function NewMainUIBase.InitUI(actor)
    addbutton(actor, 109, 11, '<Button|x=92|y=170|mimg=private/cc_functionicon/icon_posstrength.png|nimg=private/cc_functionicon/icon_posstrength.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_POSSTRENGTH..'>')        
    addbutton(actor, 109, 12, '<Button|x=92|y=240|mimg=private/cc_functionicon/icon_posstar.png|nimg=private/cc_functionicon/icon_posstar.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_POSSTAR..'>')
    addbutton(actor, 109, 13, '<Button|x=22|y=30|mimg=private/cc_functionicon/icon_baozhu.png|nimg=private/cc_functionicon/icon_baozhu.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_BAOZHU..'>')        
    addbutton(actor, 109, 14, '<Button|x=22|y=100|mimg=private/cc_functionicon/icon_soulstone.png|nimg=private/cc_functionicon/icon_soulstone.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_SOULSTONE..'>')
    addbutton(actor, 109, 15, '<Button|x=22|y=170|mimg=private/cc_functionicon/icon_guanzhi.png|nimg=private/cc_functionicon/icon_guanzhi.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_GUANZHI..'>') 
    addbutton(actor, 109, 16, '<Button|x=22|y=240|mimg=private/cc_functionicon/icon_huwei.png|nimg=private/cc_functionicon/icon_huwei.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_HUWEI..'>')
    addbutton(actor, 109, 17, '<Button|x=-52|y=30|mimg=private/cc_functionicon/icon_skill.png|nimg=private/cc_functionicon/icon_skill.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_SKILL..'>')
    addbutton(actor, 109, 18, '<Button|x=-52|y=100|mimg=private/cc_functionicon/icon_compose.png|nimg=private/cc_functionicon/icon_compose.png|link=@newmainuibase_openpanel#sid='..NewMainUIBase.UI_ICON_COMPOSE..'>')
end

function NewMainUIBase.OpenPanel(actor, sid)
    if (actor == nil) or (sid == nil) then
        return
    end

    if sid == NewMainUIBase.UI_ICON_POSSTRENGTH then        
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_EQUIPPOS_STRENGTH)

        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        EquipPosStrengthManager.ShowBasePanel(actor)        
    elseif sid == NewMainUIBase.UI_ICON_POSSTAR then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_EQUIPPOS_STAR, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_EQUIPPOS_STAR)

        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        for i = EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN, EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MAX, 1 do
            local checkvar = CommonDefine.CHECK_BOX_VAR[i - EquipPosStarManager.AUTO_UPGRADESTAR_TARG_MIN + 1]
            setplaydef(actor, checkvar, 0)
        end    
        EquipPosStarManager.ShowBasePanel(actor)   
    elseif sid == NewMainUIBase.UI_ICON_BAOZHU then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_BAOZHU, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_BAOZHU)
       
        BaoZhuManager.DoOperButton(actor, '1')
    elseif sid == NewMainUIBase.UI_ICON_SOULSTONE then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_SOUL_STONE, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_SOUL_STONE)

        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        setplaydef(actor, CommonDefine.VAR_N_CHOOSE_ITEM_MAKEIDX, 0)        --清空选择的道具
        setplaydef(actor, CommonDefine.VAR_N_CURR_NPC_DATA_PAGE1, 1)        --设置数据页面编号为1    
        SoulStoneManager.ShowBasePanel(actor)
    elseif sid == NewMainUIBase.UI_ICON_GUANZHI then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_GUANZHI, true) then
            return
        end    
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_GUANZHI)

        GuanZhiManager.ShowBasePanel(actor)
    elseif sid == NewMainUIBase.UI_ICON_HUWEI then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_OFFLINE, true) then
            return
        end    
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_OFFLINE)

        OfflineHuWeiManager.ShowBasePanel(actor) 
    elseif sid == NewMainUIBase.UI_ICON_SKILL then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_SKILLUPGRADE, true) then
            return
        end            
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_SKILLUPGRADE)

        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, -1)
        setplaydef(actor, CommonDefine.VAR_N_CHOOSE_OPER_TYPE, 0)
        SkillUpgrade.ShowBasePanel(actor)
    elseif sid == NewMainUIBase.UI_ICON_COMPOSE then
        if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_COMPOSE, true) then
            return
        end
        setplaydef(actor, CommonDefine.VAR_N_CURR_FUNCTION_ID, CommonDefine.FUNC_ID_COMPOSE)

        setplaydef(actor, CommonDefine.VAR_N_LAST_NPC_CHOOSEID, 0)
        setplaydef(actor, CommonDefine.VAR_N_NPC_TEMPPARAM1, 0)
        ItemComposeManager.ShowBasePanel(actor)
    end
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, NewMainUIBase.InitUI, CommonDefine.FUNC_ID_NEWMAINUI)

return NewMainUIBase
