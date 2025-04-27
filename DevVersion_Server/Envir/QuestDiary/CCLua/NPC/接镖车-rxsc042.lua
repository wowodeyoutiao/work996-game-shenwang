require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()

function main(actor)
    if not Player.IsFunctionOpen(actor, CommonDefine.FUNC_ID_YUNBIAO, true) then
        return
    end

    show_panel(actor)
end

--显示接镖界面
function show_panel(actor)
    YunBiaoManager.ShowAcceptBiaoChePanel(actor)
end

--接下镖车
function accept_biaoche(actor)
    YunBiaoManager.AcceptBiaoChe(actor)
end

--刷新镖车
function refresh_biaoche(actor)
    YunBiaoManager.RefreshBiaoChe(actor)
end