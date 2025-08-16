GMHelper = {}

local TEST_SUPER_JUMP_CFG = {
    {sid='3001', showname='第2大陆', mapidstr='jyt01', x=72, y=72},
    {sid='3002', showname='第3大陆', mapidstr='jyt02', x=53, y=48},
    {sid='3003', showname='第4大陆', mapidstr='jyt03', x=19, y=22},
    {sid='3004', showname='第5大陆', mapidstr='jyt04', x=16, y=18},
    {sid='3005', showname='第6大陆', mapidstr='jyt05', x=25, y=25},
    {sid='3006', showname='第7大陆', mapidstr='jyt06', x=78, y=45},
    {sid='3007', showname='远古比奇城', mapidstr='jyt07', x=330, y=260},
    {sid='3008', showname='远古封魔谷', mapidstr='jyt08', x=240, y=200},
    {sid='3009', showname='远古白日门', mapidstr='jyt09', x=179, y=326},
    {sid='3010', showname='远古魔龙城', mapidstr='jyt10', x=123, y=158},
    {sid='3011', showname='远古苍月岛', mapidstr='cyd', x=140, y=333},
    {sid='3012', showname='蛮荒之城', mapidstr='mhzc', x=135, y=184},
    {sid='3013', showname='无尽之海', mapidstr='haidi6', x=73, y=77},
    {sid='3014', showname='卧龙山庄', mapidstr='wlsz', x=66, y=40},
    {sid='3015', showname='神龙帝国', mapidstr='shenlong', x=260, y=321},
    {sid='3016', showname='万年雪山', mapidstr='wnxs', x=40, y=32},
    {sid='3017', showname='返回盟重', mapidstr='rxsc042', x=330, y=330},
    {sid='', showname='', mapidstr='rxsc042', x=330, y=330},
    {sid='', showname='', mapidstr='rxsc042', x=330, y=330},
    {sid='', showname='', mapidstr='rxsc042', x=330, y=330},

    {sid='3021', showname='苍月传送', mapidstr='jyt08', x=122, y=403},
    {sid='3022', showname='幽灵船内', mapidstr='ygylc5', x=33, y=33},
    {sid='3023', showname='锻造', mapidstr='jyt08', x=224, y=193},
    {sid='3024', showname='洗练', mapidstr='tjp', x=6, y=14},
    {sid='3025', showname='渡劫', mapidstr='jyt08', x=250, y=210},
    {sid='3026', showname='目标奖励', mapidstr='jyt07', x=330, y=260},
    {sid='3027', showname='比奇BOSS', mapidstr='m101', x=18, y=36},
    {sid='3028', showname='封魔谷BOSS', mapidstr='b341', x=23, y=29},
    {sid='3029', showname='时装合成', mapidstr='zzzd', x=82, y=26},
    {sid='3030', showname='九幽神力', mapidstr='jyt08', x=234, y=192},
    {sid='3031', showname='卧龙军师圣物', mapidstr='wlsz', x=66, y=40},
    {sid='3032', showname='精品生肖', mapidstr='jyt02', x=56, y=45},
    {sid='3033', showname='仙品生肖', mapidstr='jyt04', x=9, y=12},
    {sid='3034', showname='无极天尊-光环', mapidstr='jyt07', x=334, y=256},
    {sid='3035', showname='卧龙将军', mapidstr='b341', x=25, y=29}, 
    {sid='3036', showname='幽灵船入口', mapidstr='jyt07', x=322, y=252},
    {sid='3037', showname='天赋系统', mapidstr='jyt08', x=249, y=191},
    {sid='3038', showname='葬龙台', mapidstr='shenlong', x=256, y=303},
    {sid='3039', showname='生肖五行-法神', mapidstr='shenlong', x=252, y=319},
}


function GMHelper.InitUI(actor)
    --gm 测试模式
    if getgmlevel(actor) > 0 then
        addbutton(actor, 104, CommonDefine.ADD_BUTTON_ID_2, '<Button|x=-280|y=-380|nimg=official/top/1900012530.png|link=@gmhelper_openpanel>')
    end
end

function GMHelper.OpenPanel(actor)
    if getgmlevel(actor) == 0 then
        return
    end

    local strPaoKuSwitch = getsysvar(CommonDefine.VAR_A_PAOKU_SWITCH)
    local strPaoKuMenu = '关闭跑酷'
    if strPaoKuSwitch ~= '已开启' then
        strPaoKuMenu = '开启跑酷'
    end

    local sPanelStr = '<Button|x=40|y=30|nimg=public/bg_hhzy_01_3.png|text=等级加10级|link=@gmhelper_button#sid1=1>'..
        '<Button|x=40|y=60|nimg=public/bg_hhzy_01_3.png|text=超级宝箱升级|link=@gmhelper_button#sid1=1001>'..
        '<Button|x=40|y=90|nimg=public/bg_hhzy_01_3.png|text=超级宝箱重置|link=@gmhelper_button#sid1=1002>'..
        '<Button|x=40|y=120|nimg=public/bg_hhzy_01_3.png|text=增加100个宝箱|link=@gmhelper_button#sid1=1003>'..
        '<Button|x=40|y=150|nimg=public/bg_hhzy_01_3.png|text=增加8w攻魔道|color=253|link=@gmhelper_button#sid1=1004>'..
        '<Button|x=40|y=180|nimg=public/bg_hhzy_01_3.png|text=1000w金币|link=@gmhelper_button#sid1=35>'..
        '<Button|x=40|y=210|nimg=public/bg_hhzy_01_3.png|text=10w元宝,绑元|link=@gmhelper_button#sid1=36>'..
        '<Button|x=40|y=240|nimg=public/bg_hhzy_01_3.png|text=100点跨服积分|link=@gmhelper_button#sid1=1010>'..
        '<Button|x=40|y=270|nimg=public/bg_hhzy_01_3.png|text=给粉色灵玉|link=@gmhelper_button#sid1=6>'..
        '<Button|x=40|y=300|nimg=public/bg_hhzy_01_3.png|text=等级加1级|link=@gmhelper_button#sid1=39>'..
        
        '<Button|x=200|y=30|nimg=public/bg_hhzy_01_3.png|text=等级设置10|link=@gmhelper_button#sid1=1007>'..
        '<Button|x=200|y=60|nimg=public/bg_hhzy_01_3.png|text=清空装备位强化|link=@gmhelper_button#sid1=1008>'..
        '<Button|x=200|y=90|nimg=public/bg_hhzy_01_3.png|text=清空装备位星级|link=@gmhelper_button#sid1=1009>'..
        '<Button|x=200|y=120|nimg=public/bg_hhzy_01_3.png|text=给五星魂石|link=@gmhelper_button#sid1=3>'..        
        '<Button|x=200|y=150|nimg=public/bg_hhzy_01_3.png|text=刷新排行榜|link=@gmhelper_button_refreshrank>'..
        '<Button|x=200|y=180|nimg=public/bg_hhzy_01_3.png|text=停止泡点|link=@gmhelper_button#sid1=1011>'..
        '<Button|x=200|y=210|nimg=public/bg_hhzy_01_3.png|text=各种升级材料加2000|link=@gmhelper_button#sid1=5>'..
        '<Button|x=200|y=240|nimg=public/bg_hhzy_01_3.png|text=免费VIP升级|link=@gmhelper_button#sid1=30>'..
        '<Button|x=200|y=270|nimg=public/bg_hhzy_01_3.png|text=删除支线任务|link=@gmhelper_button#sid1=37>'..
        '<Button|x=200|y=300|nimg=public/bg_hhzy_01_3.png|text=增加500功勋|link=@gmhelper_button#sid1=14>'..

        '<Button|x=350|y=30|nimg=public/bg_hhzy_01_3.png|text=重置跨服活动配置|link=@gmhelper_button#sid1=1996>'..
        '<Button|x=350|y=60|nimg=public/bg_hhzy_01_3.png|text=设置跨服boss配置|link=@gmhelper_button#sid1=1997>'..
        '<Button|x=350|y=90|nimg=public/bg_hhzy_01_3.png|text=设置跨服大乱斗配置|link=@gmhelper_button#sid1=1998>'..        
        '<Button|x=350|y=120|nimg=public/bg_hhzy_01_3.png|text=重置开服天分秒|link=@gmhelper_button#sid1=1901>'..        
        '<Button|x=350|y=150|nimg=public/bg_hhzy_01_3.png|text=开服天数+1|link=@gmhelper_button#sid1=1902>'..        
        '<Button|x=350|y=180|nimg=public/bg_hhzy_01_3.png|text=开服分钟+10|link=@gmhelper_button#sid1=1903>'..
        '<Button|x=350|y=210|nimg=public/bg_hhzy_01_3.png|text=开服分钟+1|link=@gmhelper_button#sid1=1904>'..
        --'<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text='..strPaoKuMenu..'|link=@gmhelper_button#sid1=1905>'..
        '<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text=重置VIP等级|link=@gmhelper_button#sid1=38>'..
        '<Button|x=350|y=270|nimg=public/bg_hhzy_01_3.png|text=刷出战力首领|link=@gmhelper_button#sid1=18>'..
        '<Button|x=350|y=300|nimg=public/bg_hhzy_01_3.png|text=开启攻沙|link=@gmhelper_button#sid1=165>'..
        '<Button|x=350|y=330|nimg=public/bg_hhzy_01_3.png|text=关闭攻沙|link=@gmhelper_button#sid1=166>'..
        

        '<Button|x=500|y=30|nimg=public/bg_hhzy_01_3.png|text=清空首充|link=@gmhelper_button#sid1=154>'..
        '<Button|x=500|y=60|nimg=public/bg_hhzy_01_3.png|text=模拟充值1元|link=@gmhelper_button#sid1=155>'..
        '<Button|x=500|y=90|nimg=public/bg_hhzy_01_3.png|text=模拟充值10元|link=@gmhelper_button#sid1=156>'..
        '<Button|x=500|y=120|nimg=public/bg_hhzy_01_3.png|text=模拟充值100元|link=@gmhelper_button#sid1=157>'..        
        '<Button|x=500|y=150|nimg=public/bg_hhzy_01_3.png|text=清空跨天变量|link=@gmhelper_button#sid1=158>'..        
        '<Button|x=500|y=180|nimg=public/bg_hhzy_01_3.png|text=功能NPC面板|color=252|link=@gmhelper_button#sid1=1995>'..
        '<Button|x=500|y=210|nimg=public/bg_hhzy_01_3.png|text=临时测试|link=@gmhelper_button#sid1=1999>'..
        '<Button|x=500|y=240|nimg=public/bg_hhzy_01_3.png|text=完成会员任务一|link=@gmhelper_button#sid1=160>'..
        '<Button|x=500|y=270|nimg=public/bg_hhzy_01_3.png|text=完成会员任务二|link=@gmhelper_button#sid1=161>'..
        '<Button|x=500|y=300|nimg=public/bg_hhzy_01_3.png|text=完成会员任务三|link=@gmhelper_button#sid1=162>'..
        '<Button|x=500|y=330|nimg=public/bg_hhzy_01_3.png|text=完成会员任务四|link=@gmhelper_button#sid1=163>'..
        '<Button|x=500|y=360|nimg=public/bg_hhzy_01_3.png|text=完成会员任务五|link=@gmhelper_button#sid1=164>'
    --[[                                      
        '<Button|x=40|y=120|nimg=public/bg_hhzy_01_3.png|text=无敌|link=@gmhelper_button,4>'..        
        
        '<Button|x=40|y=210|nimg=public/bg_hhzy_01_3.png|text=学习职业技能|link=@gmhelper_button,13>'..                      
        '<Button|x=40|y=240|nimg=public/bg_hhzy_01_3.png|text=赠送洗炼测试装备|color=253|link=@gmhelper_button,999>'..
        

        '<Button|x=200|y=30|nimg=public/bg_hhzy_01_3.png|text=删除主线任务|link=@gmhelper_button,102>'..
        '<Button|x=200|y=60|nimg=public/bg_hhzy_01_3.png|text=初始主线任务|link=@gmhelper_button,101>'..                      
        '<Button|x=200|y=90|nimg=public/bg_hhzy_01_3.png|text=接受主线任务|link=@gmhelper_button,103>'..
        '<Button|x=200|y=120|nimg=public/bg_hhzy_01_3.png|text=完成主线任务|link=@gmhelper_button,104>'..
        
        '<Button|x=200|y=180|nimg=public/bg_hhzy_01_3.png|text=刷新任务怪|link=@gmhelper_button,106>'..
        '<Button|x=200|y=210|nimg=public/bg_hhzy_01_3.png|text=增加100官职经验|link=@gmhelper_button,107>'..
        
        '<Button|x=350|y=30|nimg=public/bg_hhzy_01_3.png|text=3次魔方阵|link=@gmhelper_button,15>'..                      
        
        '<Button|x=350|y=90|nimg=public/bg_hhzy_01_3.png|text=恢复灵玉副本|link=@gmhelper_button,17>'..
        
        '<Button|x=350|y=150|nimg=public/bg_hhzy_01_3.png|text=设置空血|link=@gmhelper_button,31>'..
        '<Button|x=350|y=180|nimg=public/bg_hhzy_01_3.png|text=未激活回收|link=@gmhelper_button,32>'..
        '<Button|x=350|y=210|nimg=public/bg_hhzy_01_3.png|text=回主城|link=@gmhelper_button,9>'..
        '<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text=打开充值界面|link=@gmhelper_button,33>'..
        '<Button|x=350|y=270|nimg=public/bg_hhzy_01_3.png|text=清空进阶礼包|link=@gmhelper_button,34>'..

        '<Button|x=500|y=30|nimg=public/bg_hhzy_01_3.png|text=设置首充第一天|link=@gmhelper_button,150>'..
        '<Button|x=500|y=60|nimg=public/bg_hhzy_01_3.png|text=设置首充第二天|link=@gmhelper_button,151>'..
        '<Button|x=500|y=90|nimg=public/bg_hhzy_01_3.png|text=设置首充第三天|link=@gmhelper_button,152>'..
        '<Button|x=500|y=120|nimg=public/bg_hhzy_01_3.png|text=设置首充第四天|link=@gmhelper_button,153>'..

    ]]--

    --[[                      
        '<Button|x=200|y=180|nimg=public/bg_hhzy_01_3.png|text=武器升星10级|link=@gmhelper_button,7>'..
        '<Button|x=40|y=210|nimg=public/bg_hhzy_01_3.png|text=清空官职|link=@gmhelper_button,8>'..    
        '<Button|x=40|y=240|nimg=public/bg_hhzy_01_3.png|text=穿戴装备可洗炼|link=@gmhelper_button,10>'..
        
        '<Button|x=200|y=60|nimg=public/bg_hhzy_01_3.png|text=清空装备小极品|link=@gmhelper_button,11>'..
        '<Button|x=200|y=90|nimg=public/bg_hhzy_01_3.png|text=测试自定义属性|link=@gmhelper_button,12>'..                                                    
        '<Button|x=350|y=60|nimg=public/bg_hhzy_01_3.png|text=增加八格背包|link=@gmhelper_button,16>'..                      
        
        '<Button|x=350|y=150|nimg=public/bg_hhzy_01_3.png|text=随机清空地图|link=@gmhelper_button,19>'..
        '<Button|x=350|y=180|nimg=public/bg_hhzy_01_3.png|text=VIP任务变量100|link=@gmhelper_button,20>'..
        '<Button|x=350|y=210|nimg=public/bg_hhzy_01_3.png|text=增加测试属性组|link=@gmhelper_button,21>'..
        '<Button|x=350|y=240|nimg=public/bg_hhzy_01_3.png|text=删除测试属性组|link=@gmhelper_button,22>'
    ]]--

    local mapidstr = Player.GetMapIDStr(actor)
    local posx, posy = Player.GetMapXY(actor)
    local sTempInfo = '位置:'..mapidstr..' ['..posx..','..posy..']'
    sPanelStr = sPanelStr..'<Text|text=【个人信息】： '..sTempInfo..'|x=40|y=350|color='..CSS.NPC_YELLOW..'>'
    sPanelStr = sPanelStr..parsetext('<RText|x=40|y=380|color=103|outline=1|text=【服务器信息】：  开区<$STR(G0)>天/<$KFDAY>    <$STR(G387)>分钟    <$STR(G200)>秒    周：<$STR(G58)> >', '')
    
    BF_NPCSayExt(actor, sPanelStr, 1, 650, 420)
end

function GMHelper.OpenSuperJumpPanel(actor)
    if getgmlevel(actor) == 0 then
        return
    end

    local sPanelStr = ''
    local column = 0
    local line = 0
    for index, value in ipairs(TEST_SUPER_JUMP_CFG) do
        local currx = 40 + 150 * column
        local curry = 30 + 30 * line
        if value.sid ~= '' then
            sPanelStr = sPanelStr..'<Button|x='..currx..'|y='..curry..'|nimg=public/bg_hhzy_01_3.png|text='..value.showname..'|link=@gmhelper_button#sid1='..value.sid..'>'
        end
        line = line + 1
        if line % 10 == 0 then
            line = 0
            column = column + 1
        end        
    end
    
    BF_NPCSayExt(actor, sPanelStr, 1, 650, 350)
end

function GMHelper.GMStartSBK(actor)
    --开启前需要把所有行会添加到攻城列表]
    addtocastlewarlistex("*")
    gmexecute("0","ForcedWallConQuestwar")
    setsysvar(CommonDefine.VAR_A_SBK_GM_SWITCH, '攻沙')    
end

function GMHelper.GMStopSBK(actor)
    --攻城战开启状态下再次调用ForcedWallConQuestwar命令即可关闭攻城战
    if castleinfo(5) then
        gmexecute("0","ForcedWallConQuestwar")
        setsysvar(CommonDefine.VAR_A_SBK_GM_SWITCH, '不攻沙')
    end    
end

function GMHelper.DoGmOper(actor, sid)
    if (actor == nil) or (sid == nil) then
        return
    end
    if getgmlevel(actor) == 0 then
        return
    end
    if sid == '1' then
        changelevel(actor, '+', 10)
        Player.FullHPMP(actor)    
    elseif sid == '3' then  
        giveitem(actor, '5级红魂石', 12)
        giveitem(actor, '5级绿魂石', 12)
        giveitem(actor, '5级蓝魂石', 12)
        giveitem(actor, '5级黄魂石', 12)  
    elseif sid == '4' then
        gmexecute(actor, 'Superman')
    elseif sid == '5' then
        giveitem(actor, '强化石', 2000)
        giveitem(actor, '升星石', 2000)
        giveitem(actor, '书页', 2000)
        giveitem(actor, '技能秘籍', 2000)
        giveitem(actor, '武卫精魄', 2000)
        giveitem(actor, '御卫精魄', 2000)
        giveitem(actor, '虎卫精魄', 2000)
        giveitem(actor, '禁卫精魄', 2000)
        giveitem(actor, '宿卫精魄', 2000)
    elseif sid == '6' then
        giveitem(actor, '鼠灵玉·粉1星', 1)
        giveitem(actor, '牛灵玉·粉1星', 1)
        giveitem(actor, '虎灵玉·粉1星', 1)
        giveitem(actor, '兔灵玉·粉1星', 1)
        giveitem(actor, '龙灵玉·粉1星', 1)
        giveitem(actor, '蛇灵玉·粉1星', 1)
        giveitem(actor, '马灵玉·粉1星', 1)
        giveitem(actor, '羊灵玉·粉1星', 1)
        giveitem(actor, '猴灵玉·粉1星', 1)
        giveitem(actor, '鸡灵玉·粉1星', 1)
        giveitem(actor, '狗灵玉·粉1星', 1)
        giveitem(actor, '猪灵玉·粉1星', 1)
        giveitem(actor, '鼠灵玉·粉2星', 1)
        giveitem(actor, '牛灵玉·粉2星', 1)
        giveitem(actor, '虎灵玉·粉2星', 1)
        giveitem(actor, '兔灵玉·粉2星', 1)
        giveitem(actor, '龙灵玉·粉2星', 1)
        giveitem(actor, '蛇灵玉·粉2星', 1)
        giveitem(actor, '马灵玉·粉2星', 1)
        giveitem(actor, '羊灵玉·粉2星', 1)
        giveitem(actor, '猴灵玉·粉2星', 1)
        giveitem(actor, '鸡灵玉·粉2星', 1)
        giveitem(actor, '狗灵玉·粉2星', 1)
        giveitem(actor, '猪灵玉·粉2星', 1)        
        giveitem(actor, '鼠灵玉·粉3星', 1)
        giveitem(actor, '牛灵玉·粉3星', 1)
        giveitem(actor, '虎灵玉·粉3星', 1)
        giveitem(actor, '兔灵玉·粉3星', 1)
        giveitem(actor, '龙灵玉·粉3星', 1)
        giveitem(actor, '蛇灵玉·粉3星', 1)
        giveitem(actor, '马灵玉·粉3星', 1)
        giveitem(actor, '羊灵玉·粉3星', 1)
        giveitem(actor, '猴灵玉·粉3星', 1)
        giveitem(actor, '鸡灵玉·粉3星', 1)
        giveitem(actor, '狗灵玉·粉3星', 1)
        giveitem(actor, '猪灵玉·粉3星', 1)        
    elseif sid == '7' then
        local equipitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
        if equipitem ~= '0' then
            local starnum = getitemaddvalue(actor, equipitem, 2, 3, 0)
            setitemaddvalue(actor, equipitem, 2, 3, starnum + 10);
        end 
    elseif sid == '8' then        
        setplaydef(actor, CommonDefine.VAR_U_GUANZHI_LEVEL, 0)
        setplaydef(actor, CommonDefine.VAR_U_GUANZHI_CURREXP, 0)
        delattlist(actor, CommonDefine.ABILITY_GROUP_GUANZHI)
        GuanZhiManager.SetTitle(actor, '')
        recalcabilitys(actor)
    elseif sid == '9' then
        Player.GoMZHome(actor)
    elseif sid == '10' then
        for i = CommonDefine.EQUIPPOS_DRESS, CommonDefine.EQUIPPOS_BOOTS, 1 do       
            if EquipRandomABManager.IsValidEquipPosForRandomAB(i) then
                local equipitem = linkbodyitem(actor, i)
                if not BF_IsNullObj(equipitem) then
                    EquipRandomABManager.InitEquipRandomAB(actor, equipitem, 1)
                end
            end
        end
        recalcabilitys(actor)
    elseif sid == '11' then
        for i = CommonDefine.EQUIPPOS_DRESS, CommonDefine.EQUIPPOS_BOOTS, 1 do
            if EquipRandomABManager.IsValidEquipPosForRandomAB(i) then
                local equipitem = linkbodyitem(actor, i)
                if not BF_IsNullObj(equipitem) then
                    clearitemcustomabil(actor, equipitem, CommonDefine.ITEM_CUSTOMEAB_GROUP_2)
                    refreshitem(actor, equipitem)
                end
            end
        end        
        recalcabilitys(actor)
    elseif sid == '12' then
        local equipitem = linkbodyitem(actor, CommonDefine.EQUIPPOS_WEAPON)
        if not BF_IsNullObj(equipitem) then
            local createABTab = {
                {id=3, value=3, savepos=3, color=250, captionid=1},{id=4, value=10, savepos=4, color=250, captionid=1},
                {id=5, value=3, savepos=5, color=251, captionid=2},{id=6, value=10, savepos=6, color=251, captionid=2},
                {id=7, value=3, savepos=7, color=252, captionid=3},{id=8, value=10, savepos=8, color=252, captionid=3}
            }
            BF_SetCustomEquipABGroup(actor, equipitem, createABTab, CommonDefine.ITEM_CUSTOMEAB_GROUP_2, '[极品属性]:', CSS.CUSTOM_AB_GROUP_COLOR)       
            refreshitem(actor, equipitem)
            recalcabilitys(actor)
        end
    elseif sid == '13' then
        local bJob = Player.GetJob(actor)
        if bJob == CommonDefine.JOB_Z then
            addskill(actor, 3, 0)
            addskill(actor, 7, 0)
            addskill(actor, 12, 0)            
            addskill(actor, 25, 0)
            addskill(actor, 26, 0)
            addskill(actor, 27, 0)
        elseif bJob == CommonDefine.JOB_F then
            addskill(actor, 1, 0)
            addskill(actor, 5, 0)
            addskill(actor, 9, 0)
            addskill(actor, 10, 0)
            addskill(actor, 11, 0)
            addskill(actor, 22, 0)
            addskill(actor, 23, 0)
            addskill(actor, 24, 0)
            addskill(actor, 31, 0)
        elseif bJob == CommonDefine.JOB_D then
            addskill(actor, 2, 0)
            addskill(actor, 6, 0)
            addskill(actor, 13, 0)
            addskill(actor, 14, 0)
            addskill(actor, 15, 0)
            addskill(actor, 17, 0)          
        end
    elseif sid == '14' then
        GuanZhiManager.AddExp(actor, 500)
        EverydayTask.AddTaskCounter(actor, CommonDefine.FUNC_ID_GUANZHI, 500)  
    elseif sid == '15' then
        local times = getplaydef(actor, CommonDefine.VAR_J_DAY_MOFANG_LEFT_FREETIMES)
        setplaydef(actor, CommonDefine.VAR_J_DAY_MOFANG_LEFT_FREETIMES, times+3)
    elseif sid == '16' then
        local totalbagcount = getbaseinfo(actor, CommonDefine.INFO_BAGCOUNT)
        if totalbagcount < 126 then
            local tempcount = math.min(146, totalbagcount + 8)
            setbagcount(actor, tempcount)
        end
    elseif sid == '17' then
        setplaydef(actor, CommonDefine.VAR_J_DAY_BAOZHU_BOSS_TIMES, 0)
    elseif sid == '18' then
        if RandomBossManager.CreateNewRandomBoss(actor) ~= -1 then
            Player.SendSelfMsg(actor, '战力首领已刷出，请前往首领尊者查看！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        else
            Player.SendSelfMsg(actor, '战力首领已达上限或者玩家战力超过界限！', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        end
    elseif sid == '19' then
        RandomBossManager.TestClearAllFightingMapInfo()
    elseif sid == '20' then
        for i = 1, FreeVIPManager.MAX_TASK_NUM, 1 do
            local counter = getplaydef(actor, FreeVIPManager.TASK_COUNTER_VARLIST[i]) + 100
            setplaydef(actor, FreeVIPManager.TASK_COUNTER_VARLIST[i], counter)
        end
    elseif sid == '21' then
        addattlist(actor, 'ceshigroup', '=', '3#23#10')
        recalcabilitys(actor)
    elseif sid == '22' then
        delattlist(actor, 'ceshigroup')
        recalcabilitys(actor)
    elseif sid == '30' then
        local currVIPLv = getplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL)
        if currVIPLv < FreeVIPManager.MAX_LEVEL then
            currVIPLv = currVIPLv + 1
            FreeVIPManager.SetVIPLevel(actor, currVIPLv)            
            Player.SendSelfMsg(actor, 'VIP升级到'..currVIPLv, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        else
            setplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL, 0)
            Player.SendSelfMsg(actor, 'VIP回到'..0, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        end
    elseif sid == '31' then
        addhpper(actor, '=', 1)
    elseif sid == '32' then
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE, 0)
    elseif sid == '33' then
        Player.QuickGoTo(actor, CommonDefine.QUICK_GOTO_RECHARGE)
    elseif sid == '34' then
        setplaydef(actor, CommonDefine.VAR_T_EXTENDGIFT_REWARDDATA, '')
    elseif sid == '35' then
        changemoney(actor, CommonDefine.ITEMID_GOLD, '+', 10000000, 'DoGmOper', true)
    elseif sid == '36' then
        changemoney(actor, CommonDefine.ITEMID_YB, '+', 100000, 'DoGmOper', true)
        changemoney(actor, CommonDefine.ITEMID_BINDYB, '+', 100000, 'DoGmOper', true)
    elseif sid == '37' then
        TaskManager.DeleteTask(actor, CommonDefine.TASK_LINE_ID_BRANCH)
    elseif sid == '38' then
        setplaydef(actor, CommonDefine.VAR_U_FREEVIP_LEVEL, 0)
        Player.SendSelfMsg(actor, 'VIP回到'..0, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)    
    elseif sid == '39' then
        changelevel(actor, '+', 1)
        Player.FullHPMP(actor)        
    elseif sid == '101' then
        TaskManager.AddNewTask(actor, CommonDefine.TASK_LINE_ID_MAIN, 0)
    elseif sid == '102' then
        TaskManager.DeleteTask(actor, CommonDefine.TASK_LINE_ID_MAIN)
    elseif sid == '103' then
        TaskManager.AcceptTask(actor, CommonDefine.TASK_LINE_ID_MAIN)
    elseif sid == '104' then
        TaskManager.FinishTask(actor, CommonDefine.TASK_LINE_ID_MAIN)        
    elseif sid == '105' then
        TaskManager.EndTask(actor, CommonDefine.TASK_LINE_ID_MAIN) 
    elseif sid == '106' then
        local mapidstr = Player.GetMapIDStr(actor)
        local x, y = Player.GetMapXY(actor)
        genmon(mapidstr, x, y, '鸡', 5, 10)
        genmon(mapidstr, x, y, '鹿1', 5, 10)
    elseif sid == '107' then
        GuanZhiManager.AddExp(actor, 100)
    elseif sid == '150' then
        local currday = BF_GetDay(os.time())
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)
        FirstRecharge.AutoGiveFirstRechargeRewardAtOnce(actor)
    elseif sid == '151' then
        local currday = BF_GetDay(os.time()) - 1
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)        
    elseif sid == '152' then
        local currday = BF_GetDay(os.time()) - 2
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)                
    elseif sid == '153' then
        local currday = BF_GetDay(os.time()) - 3
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, currday)                
    elseif sid == '154' then
        setplaydef(actor, CommonDefine.VAR_U_FIRST_RECHARGE_DAY, 0)        
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD1, 0)
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD2, 0)
        setflagstatus(actor, CommonDefine.VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD3, 0)
    elseif sid == '155' then
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 1)
        RechargeManager.DoRecharge(actor)
        changemoney(actor, CommonDefine.ITEMID_YB, '+', 1 * CommonDefine.RECHARGE_YB_RATE, 'GMDoRecharge', true)
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 0)
    elseif sid == '156' then
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 10)
        RechargeManager.DoRecharge(actor)
        changemoney(actor, CommonDefine.ITEMID_YB, '+', 10 * CommonDefine.RECHARGE_YB_RATE, 'GMDoRecharge', true)
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 0)
    elseif sid == '157' then
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 100)
        RechargeManager.DoRecharge(actor)
        changemoney(actor, CommonDefine.ITEMID_YB, '+', 100 * CommonDefine.RECHARGE_YB_RATE, 'GMDoRecharge', true)
        setplaydef(actor, CommonDefine.VAR_M_ID_0, 0)
    elseif sid == '158' then
        setplaydef(actor, CommonDefine.VAR_J_DAY_BIAOCHE_ACCEPT_TIMES, 0)
        setplaydef(actor, CommonDefine.VAR_U_BIAOCHE_REFRESH_TIMES, 0)
        setplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_OPENNUM, 0)
        setplaydef(actor, CommonDefine.VAR_J_DAY_RANDOMBOSS_TRIGGERTIMES, 0)     
        setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH, 0)
        setplaydef(actor, CommonDefine.VAR_U_JUMPAREA_BOSS_DAMAGE_LOW, 0)
    elseif sid == '160' then
        FreeVIPManager.GMFetchTaskReward(actor, 1)
    elseif sid == '161' then
        FreeVIPManager.GMFetchTaskReward(actor, 2)
    elseif sid == '162' then
        FreeVIPManager.GMFetchTaskReward(actor, 3)
    elseif sid == '163' then
        FreeVIPManager.GMFetchTaskReward(actor, 4)
    elseif sid == '164' then
        FreeVIPManager.GMFetchTaskReward(actor, 5)
    elseif sid == '165' then
        GMHelper.GMStartSBK(actor)
    elseif sid == '166' then
        GMHelper.GMStopSBK(actor)
    elseif sid == '999' then
        Player.TestSuperInitPlayer(actor)
    elseif sid == '1001' then
        OpenSuperBoxManager.GMUpgradeBaoXiangLevel(actor)
    elseif sid == '1002' then
        OpenSuperBoxManager.GMResetBaoXiangLevel(actor)
    elseif sid == '1003' then
        OpenSuperBoxManager.GMAddNewBoxNum(actor, 100)
    elseif sid == '1004' then
        addattlist(actor, CommonDefine.ABILITY_GROUP_TEMPTEST, "+", "3#3#80000|3#4#80000|3#5#80000|3#6#80000|3#7#80000|3#8#80000")      
        recalcabilitys(actor)
    elseif sid == '1007' then
        changelevel(actor, '=', 10)
        Player.FullHPMP(actor)   
    elseif sid == '1008' then
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_STRENGTH_INFO, '')
        for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
            EquipPosStrengthManager.ClearEquipStrengthLvInPos(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        end        
    elseif sid == '1009' then
        setplaydef(actor, CommonDefine.VAR_T_EQUIPPOS_UPGRADESTAR_INFO, '')
        for i = 1, #CommonDefine.BASE_EQUIPMENT_POS, 1 do
            EquipPosStarManager.ClearEquipStarLvInPos(actor, CommonDefine.BASE_EQUIPMENT_POS[i])
        end  
    elseif sid == '1010' then
        changemoney(actor, CommonDefine.ITEMID_KUAFU_SCORE, '+', 100, 'DoGmOper', true)
    elseif sid == '1011' then
        setautogetexp(actor, 1, 1, 0, '*', 0, 3, CommonDefine.AUTO_ADDEXP_MAX_LEVEL)
    elseif sid == '1901' then
        setsysvar(CommonDefine.VAR_G_OPENSERVER_DAY, 0)
        setsysvar(CommonDefine.VAR_G_OPENSERVER_MINITUE_COUNTER, 0)
        setsysvar(CommonDefine.VAR_G_OPENSERVER_SECOND_COUNTER, 0)
        Player.SendSelfMsg(actor, '重置为开服第1天 0分 0秒', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        GMHelper.OpenPanel(actor)
    elseif sid == '1902' then
        local openday = getsysvar(CommonDefine.VAR_G_OPENSERVER_DAY) + 1        
        setsysvar(CommonDefine.VAR_G_OPENSERVER_DAY, openday)
        Player.SendSelfMsg(actor, '设置开服天数:'..openday, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        GMHelper.OpenPanel(actor)
    elseif sid == '1903' then
        local counter = getsysvar(CommonDefine.VAR_G_OPENSERVER_MINITUE_COUNTER) + 10        
        setsysvar(CommonDefine.VAR_G_OPENSERVER_MINITUE_COUNTER, counter)
        Player.SendSelfMsg(actor, '设置开服分钟:'..counter, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        GMHelper.OpenPanel(actor)
    elseif sid == '1904' then
        local counter = getsysvar(CommonDefine.VAR_G_OPENSERVER_MINITUE_COUNTER) + 1        
        setsysvar(CommonDefine.VAR_G_OPENSERVER_MINITUE_COUNTER, counter)
        Player.SendSelfMsg(actor, '设置开服分钟:'..counter, CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
        GMHelper.OpenPanel(actor)
    elseif sid == '1905' then
        local strPaoKuSwitch = getsysvar(CommonDefine.VAR_A_PAOKU_SWITCH)
        if strPaoKuSwitch == '已开启' then
            setsysvar(CommonDefine.VAR_A_PAOKU_SWITCH, '')
            Player.SendSelfMsg(actor, '跑酷已关闭', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
            GMHelper.OpenPanel(actor)            
        else
            setsysvar(CommonDefine.VAR_A_PAOKU_SWITCH, '已开启')
            Player.SendSelfMsg(actor, '跑酷已开启', CommonDefine.MSG_POS_TYPE_SYSTEM_TIPS)
            GMHelper.OpenPanel(actor)            
        end
    elseif sid == '1995' then
        GMHelper.OpenSuperJumpPanel(actor)
    elseif sid == '1996' then
        setsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA, '')
        setsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA, '')    
        setsysvar(CommonDefine.VAR_A_JUMPAREA_DAMAGE_RANK_DATA, '')
        setsysvar(CommonDefine.VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA, '')        
    elseif sid == '1997' then
        JumpAreaBossDamageRank.GMResetCfg(actor)
    elseif sid == '1998' then
        JumpAreaRandomFighting.GMResetCfg(actor)
    elseif sid == '1999' then 
        --changeexp(actor, '+', 500, true)
        --delbutton(actor, 108, CommonDefine.ADD_BUTTON_ID_5)
        --setplaydef(actor, CommonDefine.VAR_J_DAY_SUPERBOX_OPENNUM, 0)
        --addattlist(actor, CommonDefine.ABILITY_GROUP_TEMPTEST, "+", "3#72#1")      
        --recalcabilitys(actor)        
        --mapmove(actor, 'rxsc1560', 648, 622, 3)
        --setplaydef(actor, 'U1', 18)
        setplaydef(actor, CommonDefine.VAR_T_BAIPIAOGIFT_DATA, '')
        setplaydef(actor, CommonDefine.VAR_U_BAIPIAOGIFT_VERSION, 0)
    else
        --超级跳转
        for index, value in ipairs(TEST_SUPER_JUMP_CFG) do
            if value.sid == sid then
                mapmove(actor, value.mapidstr, value.x, value.y, 3)                
                break
            end       
        end       
    end   
end

--玩家登录时触发
function GMHelper.OnPlayerEnterGame(actor)
    GMHelper.InitUI(actor)
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, GMHelper.OnPlayerEnterGame, CommonDefine.FUNC_ID_GMHELPER)


return GMHelper