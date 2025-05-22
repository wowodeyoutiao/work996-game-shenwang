
CCServerMsgProcess = {}

function CCServerMsgProcess.RegisterMsgListener()
    
    SL:RegisterLuaNetMsg(CCMsgDefine.SM_SERVER_TEST_MSG, 
        function(msgid, param1, param2, param3, sparam)
            SL:Print("msgid:"..msgid..' param1:'..param1..' param2:'..param2..' param3:'..param3..' sparam:'..sparam)
            --SL:Require('GUILayout/CCPackage/CCFirstRecharge', true)
            --CCFirstRecharge.InitShowData(sparam)
        end
    )

    SL:RegisterLuaNetMsg(CCMsgDefine.SM_SHOW_BOX_EQUIPITEM_COMPARE, 
        function(msgid, param1, param2, param3, sparam)
            --SL:Print("msgid:"..msgid..' param1:'..param1..' param2:'..param2..' param3:'..param3..' sparam:'..sparam)
            SL:Require('GUILayout/CCPackage/CCBoxEquipItemCompare', true)
            CCBoxEquipItemCompare.ShowEquipCompare(sparam)
        end
    )    
end

return CCServerMsgProcess