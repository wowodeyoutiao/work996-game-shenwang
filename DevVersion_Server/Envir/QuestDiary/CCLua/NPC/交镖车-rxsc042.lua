require("Envir/QuestDiary/CCLua/GameInit")
UIncludes()

function main(actor)    
    show_panel(actor)
end

--显示交镖界面
function show_panel(actor)
    YunBiaoManager.ShowSubmitBiaoChePanel(actor)
end


--领取奖励
function get_reward(actor)
    YunBiaoManager.GetBiaoCheReward(actor)
end