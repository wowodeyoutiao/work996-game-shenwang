function TestGUIUtil()
    SL:Print("Hello World, This is GUIUtil!")
end

function InitCCPackage()
    SL:Require("GUILayout/CCPackage/CCMsgDefine", true)
    SL:Require("GUILayout/CCPackage/CCServerMsgProcess", true)

    CCServerMsgProcess.RegisterMsgListener()
end

TestGUIUtil()
InitCCPackage()
