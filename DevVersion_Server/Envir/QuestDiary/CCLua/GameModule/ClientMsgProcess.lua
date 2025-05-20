ClientMsgProcess = {}

function ClientMsgProcess.DoProcess(actor, msgID, param1, param2, param3, str)
    if BF_IsNullObj(actor) then
        return
    end
    if msgID == MsgDefine.CM_BOX_EQUIPITEM_COMPARE_OPER then
        
    end
end

return ClientMsgProcess