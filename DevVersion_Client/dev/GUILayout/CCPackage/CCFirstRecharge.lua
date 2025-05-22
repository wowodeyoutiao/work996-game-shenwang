
CCFirstRecharge = {}
CCFirstRecharge.rechargeday = 0
CCFirstRecharge.getrewardflag = {0, 0, 0}
CCFirstRecharge.rewardlist = {}


function CCFirstRecharge.main()
    local parent = GUI:Win_Create("ccui_first_recharge",110,130,0,0)
    GUI:LoadExport(parent, "ccpackage/cc_first_recharge")
    CCFirstRecharge._ui = GUI:ui_delegate(parent)  
    GUI:addOnClickEvent(CCFirstRecharge._ui.button_close, function()
        GUI:Win_Close(parent)
    end)
end

function CCFirstRecharge.InitShowData(sparam)
    if sparam ~= '' then
        local infoTab = SL:JsonDecode(sparam, false)
        if infoTab and type(infoTab) == "table" then
            CCFirstRecharge.rechargeday = infoTab.rechargeday
            CCFirstRecharge.getrewardflag = infoTab.getrewardflag
            CCFirstRecharge.rewardlist = infoTab.rewardlist
        end
        
        CCFirstRecharge._bottomlayout = GUI:Layout_Create(CCFirstRecharge._ui.Layout, "fr_bottomlayout", 0, 0, 100, 100, false)
        if CCFirstRecharge.rechargeday == 0 then
            local BtnRecharge = GUI:Button_Create(CCFirstRecharge._bottomlayout, "fr_dorecharge", 0, 0, "res/private/cc_first_recharge/7.png")    
            GUI:addOnClickEvent(BtnRecharge, function()
                SL:Print("Click Recharge Button!")
            end)
        end        
    end
end

CCFirstRecharge.main()
return CCFirstRecharge
