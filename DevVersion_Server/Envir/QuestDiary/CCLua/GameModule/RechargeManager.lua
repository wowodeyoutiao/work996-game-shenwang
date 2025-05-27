RechargeManager = {}

--充值ID定义

--充值
--[[
Gold            充值金额
ProductId       产品ID（来源客户端充值面板调用）
MoneyId         货币ID
isReal          =1真实充值 =0扶持充值
orderTime       订单时间(时间戳)
rechargeAmount  实际到账货币金额
giftAmount      额外赠送金额  运营后台配置
refundAmount    开启积分金额  运营后台配置
]]--
--function RechargeManager.DoRecharge(actor, gold, productid, moneyid, isreal, ordertime, rechargeamount, giftamount, refundamount)

function RechargeManager.DoRecharge(actor)
    if BF_IsNullObj(actor) then
        return
    end

    local gold = getplaydef(actor, CommonDefine.VAR_M_ID_0)
    
    --累计充值
    local totalrecharge = getplaydef(actor, CommonDefine.VAR_U_RECHARGE_TOTAL)
    totalrecharge = totalrecharge + gold
    setplaydef(actor, CommonDefine.VAR_U_RECHARGE_TOTAL, totalrecharge)     

    --每日充值
    local dayrecharge = getplaydef(actor, CommonDefine.VAR_J_DAY_RECHARGE_TOTAL)
    dayrecharge = dayrecharge + gold
    setplaydef(actor, CommonDefine.VAR_J_DAY_RECHARGE_TOTAL, dayrecharge)

    --增加 充值 虚拟道具的记录 这个只加不减
    changemoney(actor, CommonDefine.ITEMID_RECHARGE, '+', gold, 'DoRecharge', true)

    --触发充值
    GameEventManager.DoTriggerEvent(CommonDefine.EVENT_NAME_DO_RECHARGE, actor, gold)   
end

return RechargeManager