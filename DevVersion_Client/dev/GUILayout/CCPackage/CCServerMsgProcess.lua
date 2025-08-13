
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
    
    SL:RegisterLuaNetMsg(CCMsgDefine.SM_ITEM_QUICK_USE_TIP, 
        function(msgid, param1, param2, param3, sparam)
            SL:Print("msgid:"..msgid..' param1:'..param1..' param2:'..param2..' param3:'..param3..' sparam:'..sparam)
            if sparam ~= '' then
                local infoTab = SL:JsonDecode(sparam, false)
                if infoTab and type(infoTab) == "table" then
                    local makeindex = infoTab.itemmakeidx
                    local autouseflag = infoTab.autouseflag

                    if autouseflag == 1 then
                        local itemdata = SL:GetMetaValue("ITEM_DATA_BY_MAKEINDEX", makeindex)
                        if itemdata == nil then
                            return
                        end     
                        SL:SetMetaValue("AUTOUSE_MAKEINDEX_BY_POS", 1, 0, makeindex)
                        SL:OpenAutoUseTip(itemdata)
                    end
                end
            end


        end
    )    
end

return CCServerMsgProcess