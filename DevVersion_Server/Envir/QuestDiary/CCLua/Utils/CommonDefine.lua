CommonDefine = {
    --调试模式  0表示正常  1表示调试模式
    DEBUG_MODE = 1,

    --职业
    JOB_Z = 0,
    JOB_F = 1,
    JOB_D = 2,
    JOB_ALL = 3,

    --性别
    GENDER_MAN = 0,
    GENDER_WOMAN = 1,

    --基础道具ID    
    ITEMID_GOLD = 1,                    --金币 
    ITEMID_YB = 2,                      --元宝
    ITEMID_RECHARGE = 3,                --充值【只记录】
    ITEMID_BINDYB = 4,                  --绑定元宝
    ITEMID_EXP = 6,                     --经验        
           
    ITEMID_KUAFU_SCORE = 32,            --跨服积分

    --[[
    ITEMID_YB = 1,                      --元宝
    ITEMID_JINGANGSHI = 2,              --金刚石
    ITEMID_RECHARGE = 3,                --充值【只记录】
    ITEMID_BINDYB = 4,                  --绑定元宝
    ITEMID_EXP = 6,                     --经验        
    ITEMID_GOLD = 28,                   --金币    
    --ITEMID_MOFANGZHEN_JIFEN = 20,     --魔方阵积分
    ITEMID_KUAFU_SCORE = 32,            --跨服积分
    --ITEMID_XINYUNFU = 208,            --幸运符
    --ITEMID_BAODIFU = 209,             --保底符
    ]]--


    --道具的Stdmode
    ITEM_STDMODE_WEAPON = 5,        --武器
    ITEM_STDMODE_DRESS = 10,        --衣服
    ITEM_STDMODE_HELMET = 15,       --头盔
    ITEM_STDMODE_NECKLACE = 20,     --项链
    ITEM_STDMODE_RING = 22,         --戒指
    ITEM_STDMODE_ARMRING = 24,      --手镯
    ITEM_STDMODE_BOOTS = 62,        --鞋子
    ITEM_STDMODE_BELT = 64,         --腰带
    
    ITEM_STDMODE_SOULSTONE = 53,    --魂石的stdmode

    --装备位
    EQUIPPOS_DRESS = 0,
    EQUIPPOS_WEAPON = 1,
    EQUIPPOS_MEDAL = 2,
    EQUIPPOS_NECKLACE = 3,
    EQUIPPOS_HELMET = 4,
    EQUIPPOS_ARMRING_R = 5,
    EQUIPPOS_ARMRING_L = 6,
    EQUIPPOS_RING_R = 7,
    EQUIPPOS_RING_L = 8,
    EQUIPPOS_BELT = 10,
    EQUIPPOS_BOOTS = 11,

    --装备位【首饰盒】
    EQUIPPOS_SSH_1 = 30,
    EQUIPPOS_SSH_2 = 31,
    EQUIPPOS_SSH_3 = 32,
    EQUIPPOS_SSH_4 = 33,
    EQUIPPOS_SSH_5 = 34,
    EQUIPPOS_SSH_6 = 35,
    EQUIPPOS_SSH_7 = 36,
    EQUIPPOS_SSH_8 = 37,
    EQUIPPOS_SSH_9 = 38,
    EQUIPPOS_SSH_10 = 39,
    EQUIPPOS_SSH_11 = 40,
    EQUIPPOS_SSH_12 = 41,
    EQUIPPOS_MAX = 41,   --等于最后一个装备位

    --装备位对应的名称
    EQUIPPOS_NAME = {},
    --基础装备位
    BASE_EQUIPMENT_POS = {},

    --消息位置类型
    MSG_POS_TYPE_SYS_CHANNEL = 1,           --系统频道
    MSG_POS_TYPE_GUILD_CHANNEL = 2,         --行会频道
    MSG_POS_TYPE_TEAM_CHANNEL = 3,          --组队频道
    MSG_POS_TYPE_TOP_ROLL = 4,              --顶部跑马灯
    MSG_POS_TYPE_ALL_ROLL = 5,              --屏幕跑马灯公告,可控制Y轴
    MSG_POS_TYPE_CHATBOX_TOP = 6,           --聊天上方公告
    MSG_POS_TYPE_FIX_CHAT = 8,              --固定聊天
    MSG_POS_TYPE_SYSTEM_TIPS = 9,           --系统提示区域
    MSG_POS_TYPE_XY_BROADCAST = 10,         --可控制xy坐标广播
    --12=系统频道 带超链;
    --13=系统公告缩放    

    --攻击模式
    ATTACK_MODE_ALL = 0,                 --全体攻击
    ATTACK_MODE_PEACE = 1,               --和平攻击
    ATTACK_MODE_COUPLE = 2,              --夫妻攻击
    ATTACK_MODE_SHITU = 3,               --师徒攻击
    ATTACK_MODE_GROUP = 4,               --编组攻击
    ATTACK_MODE_GUILD = 5,               --行会攻击
    ATTACK_MODE_REDNAME = 6,             --红名攻击
    ATTACK_MODE_NATION = 7,              --国家攻击
    ATTACK_MODE_ZHENYIN = 8,             --阵营攻击

    --对象信息属性
    INFO_NAME = 1,
    INFO_USERID = 2,
    INFO_MAPSTR = 3,
    INFO_MAPX = 4,
    INFO_MAPY = 5,
    INFO_LEVEL = 6,
    INFO_JOB = 7,
    INFO_GENDER = 8,
    INFO_CURRHP = 9,
    INFO_MAXHP = 10,
    INFO_CURRMP = 11,
    INFO_MAXMP = 12,
    INFO_EXP = 13,
    INFO_LEVELMAXEXP = 14,
    INFO_HAIRSTYLE = 33,                 --玩家发型
    INFO_HUMBAGITEMNUM = 34,             --玩家背包中的物品数量
    INFO_GUILDNAME = 36,                 --玩家行会名
    INFO_SLAVECOUNT = 38,                --宝宝数量
    INFO_MONIDX = 55,                    --怪物的Idx
    INFO_NAMECOLOR = 56,                 --名字颜色
    INFO_MASTEROBJ = 59,                 --主人
    INFO_BAGCOUNT = 63,                  --背包大小
    INFO_CURRTARG = 67,                  --当前攻击对象

    --标准物品信息
    STDITEMINFO_IDX = 0,                 --物品ID
    STDITEMINFO_NAME = 1,                --物品名
    STDITEMINFO_STDMODE = 2,             --StdMode  大类
    STDITEMINFO_SHAPE = 3,               --Shape    小类
    STDITEMINFO_WEIGHT = 4,              --重量
    STDITEMINFO_ANICOUNT = 5,            --AniCount
    STDITEMINFO_MAXDURA = 6,             --最大持久
    STDITEMINFO_OVERLAP = 7,             --叠加数量
    STDITEMINFO_SELLPRICE = 8,           --价格
                                         --
    STDITEMINFO_NEEDLV = 10,             --使用等级
    STDITEMINFO_PARAM1 = 11,             --自定义变量1
    STDITEMINFO_PARAM2 = 12,             --自定义变量2
    STDITEMINFO_NAMECOLOR = 13,          --道具颜色

    --实体道具信息
    ITEMINFO_UNIQUEID = 1,               --唯一ID
    ITEMINFO_ITEMIDX = 2,                --物品ID
    ITEMINFO_CURRDURA = 3,               --剩余持久
    ITEMINFO_MAXDURA = 4,                --最大持久
    ITEMINFO_OVERLAP = 5,                --叠加数量
    ITEMINFO_BIND = 6,                   --绑定状态
    ITEMINFO_SRCNAME = 7,                --物品名称(引擎64_23.08.30新增)
    ITEMINFO_CHGEDNAME = 8,              --物品改名后的名称(引擎64_24.08.07新增)   

    --道具品质
    ITEM_QUALITY_WHITE = 0,               --白色
    ITEM_QUALITY_GREEN = 1,               --绿色
    ITEM_QUALITY_BLUE = 2,                --蓝色
    ITEM_QUALITY_PURPLE = 3,              --紫色
    ITEM_QUALITY_PINK = 4,                --粉色
    ITEM_QUALITY_GOLD = 5,                --金色
    ITEM_QUALITY_RED = 6,                 --红色
    ITEM_QUALITY_TOP = 7,                 --至尊

    ITEM_QUALITY_COLORNAME = {},          --道具的品质颜色名字

    --怪物颜色  这个和游戏逻辑有关
    MON_NAME_COLOR_WHITE = 255,           --白色
    MON_NAME_COLOR_GOLD = 116,            --橙色
    MON_NAME_COLOR_RED = 22,              --红色
    MON_NAME_COLOR_PURPLE = 241,          --紫色
    
    --道具 additemvalue type=1时 position=0~49的定义
    ITEMADDVALUE_TYPE1_AC = 0,           --物防
    ITEMADDVALUE_TYPE1_MAC = 1,          --魔防
    ITEMADDVALUE_TYPE1_DC = 2,           --攻击
    ITEMADDVALUE_TYPE1_MC = 3,           --魔法
    ITEMADDVALUE_TYPE1_SC = 4,           --道术
    ITEMADDVALUE_TYPE1_LUCK = 5,         --幸运

    --自定义装备属性组
    ITEM_CUSTOMEAB_GROUP_0 = 0,          --强化
    ITEM_CUSTOMEAB_GROUP_1 = 1,          --升星
    ITEM_CUSTOMEAB_GROUP_2 = 2,          --洗炼 极品
    ITEM_CUSTOMEAB_GROUP_3 = 3,          --天赋
    ITEM_CUSTOMEAB_GROUP_4 = 4,          --
    ITEM_CUSTOMEAB_GROUP_5 = 5,          --    

    --邮件ID
    MAIL_ID_BAGFULL = 100,               --背包已满，道具发放到邮件中
    MAIL_ID_OFFLINE = 101,               --离线，道具发放到邮件中

    --游戏成长属性
    ABILITYID_MAX_HP = 1,                --最大生命值
    ABILITYID_MAX_MP = 2,                --最大魔法值
    ABILITYID_MIN_DC = 3,                --最小攻击
    ABILITYID_MAX_DC = 4,                --最大攻击
    ABILITYID_MIN_MC = 5,                --最小魔法
    ABILITYID_MAX_MC = 6,                --最大魔法    
    ABILITYID_MIN_SC = 7,                --最小道术
    ABILITYID_MAX_SC = 8,                --最大道术    
    ABILITYID_MIN_AC = 9,                --最小物防
    ABILITYID_MAX_AC = 10,               --最大物防
    ABILITYID_MIN_MAC = 11,              --最小魔防
    ABILITYID_MAX_MAC = 12,              --最大魔防  doto...后续再加

    ABILITYID_CUS_EQUIPPOS_DC_ADDPERCENT = 220,    --装备位的攻击加成百分比
    ABILITYID_CUS_EQUIPPOS_MC_ADDPERCENT = 221,    --装备位的魔法加成百分比
    ABILITYID_CUS_EQUIPPOS_SC_ADDPERCENT = 222,    --装备位的道术加成百分比
    ABILITYID_CUS_EQUIPPOS_AC_ADDPERCENT = 223,    --装备位的物防加成百分比
    ABILITYID_CUS_EQUIPPOS_MAC_ADDPERCENT = 224,   --装备位的魔防加成百分比

    --自定义的百分比加成属性 对应的基础属性ID
    ADD_PERCENT_ABILITY_PAIR = {},

    --游戏玩家自定义属性组
    ABIL_GROUP_ADD_1 = 'abgroupadd1',        --装备位百分比加成的点数 1
    ABIL_GROUP_ADD_2 = 'abgroupadd2',        --装备位百分比加成的点数 2
    ABIL_GROUP_ADD_3 = 'abgroupadd3',        --装备位百分比加成的点数 3
    ABIL_GROUP_ADD_4 = 'abgroupadd4',        --装备位百分比加成的点数 4  
    ABIL_GROUP_ADD_5 = 'abgroupadd5',        --装备位百分比加成的点数 5
    ABIL_GROUP_ADD_6 = 'abgroupadd6',        --装备位百分比加成的点数 6
    ABIL_GROUP_ADD_7 = 'abgroupadd7',        --装备位百分比加成的点数 7
    ABIL_GROUP_ADD_8 = 'abgroupadd8',        --装备位百分比加成的点数 8
    ABIL_GROUP_ADD_9 = 'abgroupadd9',        --装备位百分比加成的点数 9
    ABIL_GROUP_ADD_10 = 'abgroupadd10',      --装备位百分比加成的点数 10

    ABIL_GROUP_HUWEI1 = 'huwei1',             --紫宸殿 护卫1
    ABIL_GROUP_HUWEI2 = 'huwei2',             --紫宸殿 护卫2
    ABIL_GROUP_HUWEI3 = 'huwei3',             --紫宸殿 护卫3
    ABIL_GROUP_HUWEI4 = 'huwei4',             --紫宸殿 护卫4
    ABIL_GROUP_HUWEI5 = 'huwei5',             --紫宸殿 护卫5    

    ABILITY_GROUP_STONE_PRENAME = 'stone_',   --魂石属性加成的前置组名
    ABILITY_GROUP_STONE_JIBAN = 'stonejiban', --魂石羁绊属性组名
    ABILITY_GROUP_GUANZHI = 'guanzhi',        --官职对应的属性加成
    ABILITY_GROUP_FREEVIP = 'freevip',        --FREEVIP对应的属性加成
    ABILITY_GROUP_TEMPTEST = 'temptest',      --临时测试对应的属性加成

    --装备位百分比增加属性值对应的属性组名  十个装备位分开
    EQUIPPOS_ADDAB_GROUP_NAME = {},    

    --游戏参数
    PLAYER_AUTO_ADDEXP_MAXLV = 50,              --新玩家自动获得经验的最大等级
    MAPNAME_NEWREN = 'xinr1',                   --新人地图
    MAPNAME_JQPD = 'jqpd',                      --激情泡点的地图名  
    ADDLUCK_USE_XYF_NUM = 1,                    --单次祝福使用幸运符数量
    ADDLUCK_USE_BDF_NUM = 1,                    --单次祝福使用保底符数量
    ADDLUCK_USE_XYF_ADDRATE = 20,               --祝福时使用幸运符增加的成功概率
    ITEM_COMPOSE_NEED_NUM = 3,                  --合成时需要的合成道具数量
    SOUL_STONE_SLOT_MAX_HOLE_NUM = 4,           --一个魂石槽位最大的孔数
    BACK_MAP_POSITION = {mapid=3, x=330, y=330},--回城点
    OFFLINE_FETCH_MIN_INTERVAL = 180,           --离线领取奖励的最小间隔，秒
    DAY_FREE_ENTER_MOFANGZHEN_TIMES = 2,        --每日免费进入魔方阵的次数
    MOFANGZHEN_ONCE_FOR_STAY_SECONDS = 1800,    --一次魔方阵可以待多长时间(秒)
    MOFANGZHEN_DAY_MAX_BUY_TIMES = 5,           --魔方阵每天最大购买次数
    MOFANGZHEN_DAY_BUY_NEEDITEMS = {{name='元宝', num=20}},     --魔方阵购买次数需要的消耗
    DAY_RANDOMBOSS_GETREWARD_MAXTIMES = 5,      --随机boss每天奖励最多领取5次
    DAY_RANDOMBOSS_TRIGGER_MAXTIMES = 3,        --随机boss每天最多触发3次
    ACTIVATED_AUTORECYCLE_FREEVIP_LV = 2,       --激活自动回收的免费VIP等级
    ACTIVATED_AUTORECYCLE_NEEDYB = 100,         --激活自动回收需要的元宝数量
    MAX_DISTANCE = 999999,                      --极限距离参数
    DAY_BAOZHUBOSS_GETREWARD_MAXTIMES = 5,      --宝珠boss[灵玉副本]每天奖励最多领取次数    
    EXTEND_STORAGE_ONCE_ADDNUM = 8,                                  --扩展一次仓库增加的格子数量
    EXTEND_STORAGE_ONCE_NEEDITEMS = {{name='绑定元宝', num=800}},     --扩展一次仓库所需的道具消耗
    SHOW_QUICK_TIP_MIN_LEVEL = 20,                                   --显示快捷提示的最小等级
    DAY_SUPER_BOX_MAX_ADD_NUM = 1000000,                                 --每天可以获得的超级宝箱的基础最大数量
    DAY_SUPER_BOX_MAX_OPEN_NUM = 200,                                    --每天可以开启的超级宝箱的基础最大数量
    OPEN_SUPERBOX_SPEEDUP_ONCE_NEEDITEMS = {{name='加速卷轴', num=1}},    --超级宝箱升级加速一次需要的道具
    OPEN_SUPERBOX_SPEEDUP_ONCE_ADDSECONDS = 60,                          --超级宝箱升级加速一次对应的秒数
    NEW_PLAYER_EMAIL_ITEMS = {{name='元宝', num=5000}},                   --新玩家登录给与的邮件奖励
    AUTO_ADDEXP_MAX_LEVEL = 200,                                          --泡点自动得经验的最大等级
    RECHARGE_YB_RATE = 100,                                               --充值转元宝的比率

    --道具用元宝快捷补充的对应关系
    ITEM_EXCHANGE_YB = {
        ["加速卷轴"] = 600,
    },

    --需要离开按钮的地图
    NEED_LEAVEBUTTON_MAPS = {
        'em000', 'fmg', 'hero1', 'rxsc1891', 'rxsc014', 'rxsc001', 'slzs', 'jxd', 'lhzd', 'dyhj', 
        'zwd', 'xbsd', 'sszj', 'sczs', 'e404', 'zzzd', 'huiyuan1', 'huiyuan2', 'huiyuan3', 'huiyuan4'
    },

    --等级升级对应的地图，快捷前往的
    UPGRADE_LEVEL_BASE_MAPS = {
        {minlv=1, maxlv=39, mapidstr='em000', x=35, y=45},
        {minlv=40, maxlv=59, mapidstr='fmg', x=245, y=100},
        {minlv=60, maxlv=79, mapidstr='hero1', x=218, y=36},
        {minlv=80, maxlv=99, mapidstr='rxsc1891', x=100, y=131},
        {minlv=100, maxlv=119, mapidstr='rxsc014', x=87, y=64},
        {minlv=120, maxlv=149, mapidstr='rxsc001', x=47, y=102},
    },

    --通用的特殊地图内原地复活的消耗，随次数变化
    COMMON_LOCAL_RELIVE_NEED_ITEMS = {{{name='金币', num=10000}}, {{name='金币', num=20000}}, {{name='金币', num=30000}}, {{name='金币', num=40000}}, {{name='金币', num=50000}},
        {{name='金币', num=60000}}, {{name='金币', num=70000}}, {{name='金币', num=80000}}, {{name='金币', num=90000}}, {{name='金币', num=100000}},},      

    EQUIP_RANDOMAB_GOLD_NEEDITEMS = {},         --金币洗炼对应的消耗
    EQUIP_RANDOMAB_YB_NEEDITEMS = {},           --元宝洗炼对应的消耗
    CHECK_BOX_VAR = {},                         --CheckBox选项框


    --系统全局数字变量，重启不保存 I0 - I99
    VAR_I_CURR_DYNNPC_GROUPID = 'I1',            --当前系统对应的动态NPC的组编号,玩家登录时+1赋值
    VAR_I_LAST_KFLOGIN_DAY = 'I2',               --记录跨服登录对应天数，用于触发跨服跨天的问题

    --系统全局数字变量，重启保存 G0 - G499
    VAR_G_OPENSERVER_DAY = 'G0',                        --服务器开服天数

    VAR_G_JUMPAREA_DAMAGERANK_REWARD_STATUS = 'G101',   --跨服boss伤害 活动状态 1活动未发奖 2活动已发奖
    VAR_G_JUMPAREA_RANDFIGHTING_REWARD_STATUS = 'G102', --跨服大乱斗 活动状态 1活动未发奖 2活动已发奖

    VAR_G_OPENSERVER_SECOND_COUNTER = 'G200',           --开服后 秒计数 有人才计数
    VAR_G_OPENSERVER_MINITUE_COUNTER = 'G387',          --开服后 分钟计数 有人才计数

    --系统全局字符型变量，重启保存 A0-A499
    VAR_A_PAOKU_SWITCH = 'A10',                         --跑酷活动开关  '已开启'表示开启
    ---------------------
    VAR_A_JUMPAREA_DAMAGE_RANK_DATA = 'A100',           --跨服boss伤害排行数据
    VAR_A_JUMPAREA_DAMAGE_TEST_CFG_DATA = 'A101',       --跨服boss伤害排行测试配置
    VAR_A_JUMPAREA_RANDFIGHTING_RANK_DATA = 'A102',     --跨服大乱斗排行数据
    VAR_A_JUMPAREA_RANDFIGHTING_TEST_CFG_DATA = 'A103', --跨服大乱斗测试配置


    --玩家数字变量，下线不保存 N0 - N99
--[[
    VAR_N_CURR_DYNNPC_GROUPID = 'N17',          --玩家当前的动态NPC的组ID    
    VAR_N_LAST_OPER_TIME1 = 'N19',              --玩家上一次操作的时间记录1   用于处理一些需要操作短时间冷却的  几秒钟的CD
    VAR_N_LAST_OPER_TIME2 = 'N20',              --玩家上一次操作的时间记录2   用于处理一些需要操作短时间冷却的  几秒钟的CD        
]]--    

    VAR_N_NPC_CHECKBOX_1 = 'N51',                --玩家NPC对话框中的第一个CheckBox选项
    VAR_N_NPC_CHECKBOX_2 = 'N52',                --玩家NPC对话框中的第二个CheckBox选项
    VAR_N_NPC_CHECKBOX_3 = 'N53',                --玩家NPC对话框中的第三个CheckBox选项
    VAR_N_NPC_CHECKBOX_4 = 'N54',                --玩家NPC对话框中的第四个CheckBox选项
    VAR_N_NPC_CHECKBOX_5 = 'N55',                --玩家NPC对话框中的第五个CheckBox选项
    VAR_N_NPC_CHECKBOX_6 = 'N56',                --玩家NPC对话框中的第六个CheckBox选项
    VAR_N_NPC_CHECKBOX_7 = 'N57',               --玩家NPC对话框中的第七个CheckBox选项
    VAR_N_NPC_CHECKBOX_8 = 'N58',               --玩家NPC对话框中的第八个CheckBox选项
    VAR_N_NPC_CHECKBOX_9 = 'N59',               --玩家NPC对话框中的第九个CheckBox选项
    VAR_N_NPC_CHECKBOX_10 = 'N60',              --玩家NPC对话框中的第十个CheckBox选项
    VAR_N_NPC_CHECKBOX_11 = 'N61',              --玩家NPC对话框中的第十一个CheckBox选项
    VAR_N_NPC_CHECKBOX_12 = 'N62',              --玩家NPC对话框中的第十二个CheckBox选项
    VAR_N_NPC_CHECKBOX_13 = 'N63',              --玩家NPC对话框中的第十三个CheckBox选项    
    VAR_N_NPC_CHECKBOX_14 = 'N64',              --玩家NPC对话框中的第十四个CheckBox选项      
    VAR_N_NPC_CHECKBOX_15 = 'N65',              --玩家NPC对话框中的第十五个CheckBox选项      
    VAR_N_LAST_PLAYERPOWER = 'N66',             --玩家最近一次变化的战力
    VAR_N_LAST_NPC_CHOOSEID = 'N67',            --玩家最近一次NPC选择的id    
    VAR_N_LAST_ATTACK_MODE = 'N68',             --保存玩家当前的攻击模式
    VAR_N_CHOOSE_RECYCLE_TYPE = 'N69',          --玩家选择的回收类型
    VAR_N_CHOOSE_ITEM_MAKEIDX = 'N70',          --玩家选择的背包中的道具makeidx
    VAR_N_CURR_NPC_DATA_PAGE1 = 'N71',          --玩家当前的NPC数据中的页数
    VAR_N_SOULSTONE_JBLEVEL = 'N72',            --玩家魂石羁绊等级    
    VAR_N_NPC_TEMPPARAM1 = 'N73',               --玩家NPC操作的参数1
    VAR_N_SELECT_COMPOSE_PILE_NUM = 'N74',      --合成可叠加道具时，选择的单个合成数量    
    VAR_N_CHOOSE_OPER_TYPE = 'N75',             --玩家选择的操作类型  通用的临时变量 例如选择技能升级还是技能强化    
    VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1 = 'N76',    --玩家道具合成时，选择的第一件合成物品，每次使用需检测    
    VAR_N_CURR_FUNCTION_ID = 'N77',             --玩家当前选择的功能ID  
    VAR_N_CURR_RANDOMBOSS_FIGHTING_ID = 'N78',  --玩家当前触发的随机BOSS的挑战ID
    VAR_N_COMMON_LOCAL_RELIVE_TIMES = 'N79',    --通用原地复活次数    
    VAR_N_NPC_TEMPPARAM2 = 'N80',               --玩家NPC操作的参数2
    VAR_N_NPC_TEMPPARAM3 = 'N81',               --玩家NPC操作的参数3

        
    --玩家数字型变量，切地图不保存 M0-M99
    VAR_M_ID_0 = 'M0',                          

    --玩家字符型变量，下线不保存 S0 - S99
    VAR_S_SELECT_ITEM = 'S0',
    VAR_S_SUPERBOX_ITEMLIST = 'S50',    
    VAR_S_SELECT_COMPOSE_ITEMS = 'S52',          --选择的所有待合成装备 唯一ID ,分割 
    VAR_S_SELECT_MENUITEM_1 = 'S53',             --下拉菜单1
    VAR_S_SELECT_MENUITEM_2 = 'S54',             --下拉菜单2
    VAR_S_SELECT_MENUITEM_3 = 'S55',             --下拉菜单3
    VAR_S_SELECT_DECOMPOSE_ITEMS = 'S56',        --选择的所有待分解的灵玉 唯一ID ,分割 

    --玩家数字变量，下线保存   U0 - U254  lua脚本使用从130开始

    VAR_U_OLD_VIP_LEVEL = 'U3',                 --原来版本的会员VIP等级
    --[[
    VAR_U_MOFANG_CURR_LAYER = 'U107',           --玩家当前进入的魔方阵的层数
    VAR_U_MOFANG_LEFT_BUYTIMES = 'U108',        --玩家当前剩余购买的进入魔方地图的次数
    VAR_U_MOFANGZHEN_ID = 'U109',               --玩家魔方阵当前进入的ID
    VAR_U_TREASUREMAP_CURRID = 'U126',          --当前对应的藏宝图配置id
    ]]--

    VAR_U_SUPER_BOX_TOTAL_NUM = 'U130',         --超级宝箱  保有总数量
    VAR_U_SUPER_BOX_CURR_LV = 'U131',           --超级宝箱  当前等级
    VAR_U_SUPER_BOX_ONCE_OPEN_NUM = 'U132',     --超级宝箱  一次开几个箱子    
    VAR_U_SUPER_BOX_START_UPGRADE_TIME = 'U133',--超级宝箱  开始升级的时间
    VAR_U_SUPER_BOX_CHOOSE_CONDITION_1 = 'U134',--超级宝箱  保留宝箱选择的条件1编号 - 品质
    VAR_U_SUPER_BOX_CHOOSE_CONDITION_2 = 'U135',--超级宝箱  保留宝箱选择的条件2编号 - 等级

    VAR_U_EQUIPPOS_AUTO_STAR_CONDITION = 'U136',--装备槽位  自动升星选择的条件编号  --目标星级
    VAR_U_FIRST_LOGIN_DAY = 'U137',             --首次登录游戏的日期记录
    VAR_U_LAST_RECORD_WEEK = 'U138',            --玩家跨天时记录的周数
    VAR_U_LOGINDAYS_IN_WEEK = 'U139',           --玩家一周里的跨天次数    

    VAR_U_GUANZHI_LEVEL = 'U140',               --玩家的官职等级
    VAR_U_GUANZHI_CURREXP = 'U141',             --玩家的官职当前经验
    VAR_U_ZCDHW_LEVEL1 = 'U142',                --玩家的紫宸殿护卫1等级
    VAR_U_ZCDHW_LEVEL2 = 'U143',                --玩家的紫宸殿护卫2等级
    VAR_U_ZCDHW_LEVEL3 = 'U144',                --玩家的紫宸殿护卫3等级
    VAR_U_ZCDHW_LEVEL4 = 'U145',                --玩家的紫宸殿护卫4等级
    VAR_U_ZCDHW_LEVEL5 = 'U146',                --玩家的紫宸殿护卫5等级    

    VAR_U_ADVANCE_SKILL1_LV = 'U151',            --进阶技能等级保存，用于伤害计算  占用
    VAR_U_ADVANCE_SKILL2_LV = 'U152',
    VAR_U_ADVANCE_SKILL3_LV = 'U153',
    VAR_U_ADVANCE_SKILL4_LV = 'U154',
    VAR_U_ADVANCE_SKILL5_LV = 'U155',
    VAR_U_ADVANCE_SKILL6_LV = 'U156',
    VAR_U_ADVANCE_SKILL7_LV = 'U157',
    VAR_U_ADVANCE_SKILL8_LV = 'U158',
    VAR_U_ADVANCE_SKILL9_LV = 'U159',
    VAR_U_ADVANCE_SKILL10_LV = 'U160',
    VAR_U_ADVANCE_SKILL11_LV = 'U161',
    VAR_U_ADVANCE_SKILL12_LV = 'U162',
    VAR_U_ADVANCE_SKILL13_LV = 'U163',
    VAR_U_ADVANCE_SKILL14_LV = 'U164',
    VAR_U_ADVANCE_SKILL15_LV = 'U165',
    VAR_U_ADVANCE_SKILL16_LV = 'U166',
    VAR_U_ADVANCE_SKILL17_LV = 'U167',
    VAR_U_ADVANCE_SKILL18_LV = 'U168',
    VAR_U_ADVANCE_SKILL19_LV = 'U169',
    VAR_U_ADVANCE_SKILL20_LV = 'U170',
    VAR_U_ADVANCE_SKILL21_LV = 'U171',
    VAR_U_ADVANCE_SKILL22_LV = 'U172',
    VAR_U_ADVANCE_SKILL23_LV = 'U173',
    VAR_U_ADVANCE_SKILL24_LV = 'U174',
    VAR_U_ADVANCE_SKILL25_LV = 'U175',
    VAR_U_ADVANCE_SKILL26_LV = 'U176',
    VAR_U_ADVANCE_SKILL27_LV = 'U177',
    VAR_U_ADVANCE_SKILL28_LV = 'U178',
    VAR_U_ADVANCE_SKILL29_LV = 'U179',
    VAR_U_ADVANCE_SKILL30_LV = 'U180',     

    VAR_U_ID_TASKLINE1 = 'U191',                --任务1线当前任务ID
    VAR_U_STATUS_TASKLINE1 = 'U192',            --任务1线当前任务状态    
    VAR_U_COUNTER_TASKLINE1 = 'U193',           --任务1线当前任务单个计数
    VAR_U_ID_TASKLINE2 = 'U194',                --任务2线当前任务ID
    VAR_U_STATUS_TASKLINE2 = 'U195',            --任务2线当前任务状态
    VAR_U_COUNTER_TASKLINE2 = 'U196',           --任务2线当前任务单个计数
    VAR_U_ID_TASKLINE3 = 'U197',                --任务3线当前任务ID
    VAR_U_STATUS_TASKLINE3 = 'U198',            --任务3线当前任务状态
    VAR_U_COUNTER_TASKLINE3 = 'U199',           --任务3线当前任务单个计数

    VAR_U_RECHARGE_TOTAL = 'U200',              --累计充值 RMB
    VAR_U_FIRST_RECHARGE_DAY = 'U201',          --首充的日期记录    
    VAR_U_NEWPLAYER_RECHARGE_SINGLE = 'U202',   --新人充值返利活动，单笔最大充值
    VAR_U_NEWPLAYER_RECHARGE_TOTAL = 'U203',    --新人充值返利活动，累计最大充值
    VAR_U_LAST_LOGIN_TIME = 'U204',             --玩家上一次登录时间，跨天重置    
    VAR_U_CURR_TASKLINEID = 'N205',             --当前打开的任务对话对应的tasklineid 
    VAR_U_FREEVIPTASK_COUNTER1 = 'U206',        --免费VIP任务计数1
    VAR_U_FREEVIPTASK_COUNTER2 = 'U207',        --免费VIP任务计数2
    VAR_U_FREEVIPTASK_COUNTER3 = 'U208',        --免费VIP任务计数3
    VAR_U_FREEVIPTASK_COUNTER4 = 'U209',        --免费VIP任务计数4
    VAR_U_FREEVIPTASK_COUNTER5 = 'U210',        --免费VIP任务计数5
    VAR_U_FREEVIP_LEVEL = 'U211',               --免费VIP等级   
    VAR_U_BIAOCHE_CURRID = 'U212',              --当前对应的镖车配置ID
    VAR_U_BIAOCHE_REFRESH_TIMES = 'U213',       --镖车刷新次数，接受镖车后清0   
    VAR_U_JUMPAREA_BOSS_DAMAGE_HIGH = 'U214',   --玩家今日    对跨服boss造成伤害 万位以上
    VAR_U_JUMPAREA_BOSS_DAMAGE_LOW = 'U215',    --玩家今日    对跨服boss造成伤害 万位以下
    VAR_U_JUMPAREA_FIGHTING_KMVALUE = 'U216',   --玩家今日    跨服大乱斗抗魔值
    
    --玩家字符型变量，下线保存 T0 - T254
    VAR_T_EQUIPPOS_STRENGTH_INFO = 'T41',        --玩家的装备位强化信息
    VAR_T_EQUIPPOS_UPGRADESTAR_INFO = 'T42',     --玩家的装备位升星信息
    VAR_T_SOULSTONE_SLOT_INFO = 'T43',           --玩家的魂石槽位信息
    VAR_T_OFFLINE_REWARD_INFO = 'T44',           --玩家的离线奖励相关信息   
    VAR_T_COUNTERDATA_TASKLINE1 = 'T45',         --任务1线的计数变量
    VAR_T_COUNTERDATA_TASKLINE2 = 'T46',         --任务2线的计数变量
    VAR_T_COUNTERDATA_TASKLINE3 = 'T47',         --任务3线的计数变量
    VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA = 'T48',    --新人充值返利领奖信息--单充
    VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA = 'T49',     --新人充值返利领奖信息--累充
    VAR_T_OPENSERVER_REWARDDATA1 = 'T50',                --开服活动领奖信息--每日活跃
    VAR_T_OPENSERVER_REWARDDATA2 = 'T51',                --开服活动领奖信息--每周活跃
    VAR_T_OPENSERVER_REWARDDATA3 = 'T52',                --开服活动领奖信息--等级达标
    VAR_T_OPENSERVER_REWARDDATA4 = 'T53',                --开服活动领奖信息--战力达标
    VAR_T_EXTENDGIFT_REWARDDATA = 'T54',                 --进阶礼包领奖信息
    VAR_T_JUMPAREA_SHOP_BUYDATA = 'T55',                 --跨服商店兑换信息

    --玩家数字变量，下线保存，0点重置 J0 - J499
    --[[        
    VAR_J_DAY_MOFANG_LEFT_FREETIMES = 'J4',     --玩家今日剩余可免费进入魔方地图的次数
    VAR_J_DAY_MOFANG_BUYTIMES = 'J5',           --玩家今日魔方阵购买次数
    VAR_J_DAY_MOFANG_ENTER_TIME = 'J6',         --玩家今日魔方阵进入时间
    VAR_J_DAY_MOFANG_STAY_SECONDS = 'J7',       --玩家今日魔方阵可待时间（秒）
       
    VAR_J_DAY_TREASUREMAP_USETIMES = 'J16',             --玩家 今日使用藏宝图次数
    VAR_J_DAY_TREASUREMAP_NO_PANELTIP_FLAG = 'J17',     --玩家 今日不再显示藏宝图的提示面板
    ]]--
    VAR_J_DAY_RECHARGE_TOTAL_OLDVERSION = 'J9',         --玩家今日的总充值  原来版本中的记录

    VAR_J_DAY_SUPERBOX_ADDNUM = 'J101',                 --玩家 今日获得超级宝箱次数
    VAR_J_DAY_SUPERBOX_OPENNUM = 'J102',                --玩家 今日开启超级宝箱次数
    VAR_J_DAY_GUAZHI_ADDEXP = 'J103',                   --玩家今日获得的官职经验
    VAR_J_DAY_GUAZHI_GETREWARD = 'J104',                --玩家今日是否已领取官职奖励
    VAR_J_DAY_RECHARGE_TOTAL = 'J105',                  --玩家今日的总充值
    VAR_J_DAY_ONLINE_TIME = 'J106',                     --玩家今日的在线时长
    VAR_J_DAY_FREEVIP_REWARDTIMES = 'J107',             --玩家今日领取每日VIP奖励次数
    VAR_J_DAY_BAOZHU_BOSS_TIMES = 'J108',               --玩家今日进入宝珠BOSS地图的次数   
    VAR_J_DAY_RANDOMBOSS_REWARDTIMES = 'J109',          --玩家今日随机BOSS领奖次数
    VAR_J_DAY_RANDOMBOSS_TRIGGERTIMES = 'J110',         --玩家今日随机BOSS触发次数    
    VAR_J_DAY_SINGLEBOSS_KILLTIMES = 'J111',            --玩家今日击杀单人首领的次数
    VAR_J_DAY_SINGLEBOSS_BUYTIMES = 'J112',             --玩家今日购买单人首领的次数    
    VAR_J_DAY_BIAOCHE_ACCEPT_TIMES = 'J113',            --玩家 今日接镖次数    
    VAR_J_DAY_JUMPAREA_BOSS_LAST_ENTERTIME = 'J114',    --玩家今日上次进入跨服boss的时间
    VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX = 'J115',     --玩家 每日任务累计领奖编号  

    
    --玩家字符变量，下线保存，0点重置 Z0 - Z499
    VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA = 'Z1',         --玩家 每日任务 子任务计数
    VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA = 'Z2',          --玩家 每日任务 子任务领奖记录
    

    --玩家的位标记，下线保存  索引【1~800】  
    --[[
    VAR_HUM_BITFLAG_USE_XYF = 201,                --祝福是否使用幸运符
    VAR_HUM_BITFLAG_USE_BDF = 202,                --祝福是否使用保底符   
    VAR_HUM_BITFLAG_MFZ_ADDTIME_FLAG1 = 210,         --魔方阵 增加时间标记1 确认后用1次换增加30分钟
    VAR_HUM_BITFLAG_MFZ_ADDTIME_FLAG2 = 211,         --魔方阵 增加时间标记2 确认后时间不足自动用次数换时间    
    ]]--

    --200-299 作为临时标记，上线后会清0，现在在QManage.txt的login里面处理的
    VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG = 200,      --NPC上的临时操作标记
    VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE = 201,     --激活自动回收功能
    VAR_HUM_BITFLAG_ITEMUSE = 202,                   --道具使用是否成功的标记，返回到txt回调中
    VAR_HUM_BITFLAG_NO_BAG_AUTORECYCLE = 203,        --不进行背包的装备自动回收，在开宝箱过程中才使用
    VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX = 204,        --自动开启超级宝箱   
    VAR_HUM_BITFLAG_AUTO_EQUIPSTAR_FLAG = 205,       --自动升星标记
    VAR_HUM_BITFLAG_AUTO_OPEN_SUPERBOX_PAUSE = 206,  --暂停自动开启超级宝箱   
    VAR_HUM_BITFLAG_SUPERBOX_NOCHECK_TAKEON = 207,   --开宝箱时不触发穿戴检测的状态【一键穿戴不触发】

    VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG = 301,     --玩家是否当前已有复活框弹出

    --300-800 都是可以下线保存的
    VAR_HUM_BITFLAG_AUTORECYCLE_ITEM1 = 300,         --勾选装备自动回收    
    VAR_HUM_BITFLAG_AUTORECYCLE_ITEM2 = 301,         --勾选直升宝石自动回收
    VAR_HUM_BITFLAG_NEW_PLAYER_INIT_FLAG = 302,      --玩家是否进行新手初始化

    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK1 = 310,  --超级宝箱自动回收 保留满足品质的条件
    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK2 = 311,  --超级宝箱自动回收 保留满足等级的条件
    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK3 = 312,  --超级宝箱自动回收 停止开箱条件1
    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK4 = 313,  --超级宝箱自动回收 停止开箱条件2
    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK5 = 314,  --超级宝箱自动回收 停止开箱条件3
    VAR_HUM_BITFLAG_SUPERBOX_RECYCLE_CHECK6 = 315,  --超级宝箱自动回收 自动回收非保留装备        

    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_1 = 320,         --白色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_2 = 321,         --绿色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_3 = 322,         --蓝色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_4 = 323,         --紫色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_5 = 324,         --粉色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_6 = 325,         --橙色灵珠是否回收
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER = 326,--灵珠回收时，是否保留比穿戴更好的  
    
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_1 = 330,           --白色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_2 = 331,           --绿色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_3 = 332,           --蓝色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_4 = 333,           --紫色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_5 = 334,           --粉色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_6 = 335,           --金色装备是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_7 = 336,           --红色装备是否回收 

    VAR_HUM_BITFLAG_RECYCLE_ITEM2_3 = 340,           --蓝色直升宝石是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_4 = 341,           --紫色直升宝石是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_5 = 342,           --粉色直升宝石是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_6 = 343,           --金色直升宝石是否回收
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_7 = 344,           --红色直升宝石是否回收

    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD1 = 350,     --首充奖励领取标记1
    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD2 = 351,     --首充奖励领取标记2
    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD3 = 352,     --首充奖励领取标记3    

    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG1 = 355,    --免费VIP任务1 是否领奖
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG2 = 356,    --免费VIP任务2 是否领奖
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG3 = 357,    --免费VIP任务3 是否领奖
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG4 = 358,    --免费VIP任务4 是否领奖
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG5 = 359,    --免费VIP任务5 是否领奖    

    VAR_HUM_BITFLAG_IS_FIRST_RANDOMBOSS_REWARD = 360,       --是否是第一个战力boss的奖励
    VAR_HUM_BITFLAG_IS_FIRST_RANDOMBOSS_TRIGGER = 361,      --是否是触发的第一个战力boss    


    --道具的int变量 1-50
    ITEM_INTVAR_ADDLUCK_LV = 1,                     --道具的祝福等级
    ITEM_INTVAR_RANDOMAB_NUM = 2,                   --装备洗炼属性的条数
    ITEM_INTVAR_RANDOMAB_CURR_SEQ = 3,              --装备洗炼当前选择的第几条属性  未洗炼状态  作为临时变量
    ITEM_INTVAR_RANDOMAB_STATS = 4,                 --装备洗炼的当前状态 0无洗炼属性待洗炼状态  1已洗炼出属性待处理状态
    ITEM_INTVAR_ATTACK_SPEEDUP_INITGIFT = 6,        --装备加速属性【由装备天赋给予的】
    ITEM_INTVAR_INITGIFT_TYPE = 7,                  --装备的天赋类型 风雨雷电

    --道具的字符串变量 1-20
    --ITEM_STRVAR_RANDOMAB_DATA = 1,                --装备洗炼属性的数据保存
    ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB = 2,       --装备洗炼生成的单挑属性

    --地图的int变量 1-50
    MAP_INTVAR_RANDOMBOSS_TRIGGER_STARTTIME = 1,    --触发随机boss的生成时间
    MAP_INTVAR_RANDOMBOSS_TRIGGER_ID = 2,           --触发随机boss的触发ID

    --地图的string变量 1-50
    MAP_STRVAR_RANDOMBOSS_TRIGGER_NAME = 1,         --触发随机boss的玩家名
    MAP_STRVAR_RANDOMBOSS_MONNAME = 2,              --触发随机boss的怪物名字
    MAP_STRVAR_RANDOMBOSS_MONUNIQUEID = 3,          --触发随机boss的怪物唯一ID

    --监听事件类型名
    EVENT_NAME_PLAYER_ENTERGAME = 'player_entergame',   --玩家进入游戏
    EVENT_NAME_PLAYER_LEAVEGAME = 'player_leavegame',   --玩家退出游戏
    EVENT_NAME_CLICK_TASK = 'click_task',               --点击任务
    EVENT_NAME_PLAYER_RESETDAY = 'player_resetday',     --玩家跨天
    EVENT_NAME_PLAYER_RESETWEEK = 'player_resetweek',   --玩家跨周
    EVENT_NAME_PLAYER_DIE = 'player_die',               --玩家死亡    
    EVENT_NAME_PLAYER_ADDBAGITEM = 'player_addbag',     --玩家道具进背包

    EVENT_NAME_PLAYER_ENTERMAP = 'player_entermap',     --玩家进入地图
    EVENT_NAME_PLAYER_LEAVEMAP = 'player_leavemap',     --玩家离开地图    


    EVENT_NAME_MON_KILLED = 'mon_killed',               --怪物被击杀
    EVENT_NAME_KILL_PLAYER = 'kill_player',             --击杀玩家
    EVENT_NAME_KILL_MON = 'kill_mon',                   --击杀怪物
    EVENT_NAME_CLICK_NPC = 'click_npc',                 --点击NPC    
    EVENT_NAME_DO_RECHARGE = 'do_recharge',             --充值

    --玩家定时器ID
    --TIMER_ID_MOFANGZHEN = 11,                         --魔方阵地图的定时器
    TIMER_ID_CHECK_TOPICON_REDPOINT = 101,              --检测topicon功能入口的小红点
    TIMER_ID_CHECK_QUICK_GOTO_TIP = 102,                --检测npc功能的快捷前往提示

    --全局定时器ID
    --G_TIMER_ID_STARTUP_ONCE = 99,                       --用于触发startup
    G_TIMER_ID_CHECK_JUMPAREA_LOCALTIMER = 101,           --跨服活动对应的本服定时器
    --G_TIMER_ID_CHECK_JUMPAREA_KFTIMER = 102,              --跨服活动对应的跨服定时器   无效


    --跨服传递到本服的消息
    KFBCMSG_UPDATE_JUMPAREA_DAMAGE_RANK = 101,            --更新跨服BOSS伤害排行信息
    KFBCMSG_GOBACK_MZMAP = 102,                           --玩家返回本服盟重安全区
    KFBCMSG_UPDATE_JUMPAREA_RANDFIGHTING_RANK = 103,      --更新跨服大乱斗排行信息

    --本服传递到跨服的消息  现阶段有bug 使用自定义变量来处理消息
    --BCKFMSG_INIT_TIMER = 1,                             --本服触发跨服初始化公用定时器

    --功能模块编号
    FUNC_ID_EQUIPPOS_STRENGTH = 1,              --装备位强化
    FUNC_ID_EQUIPPOS_STAR = 2,                  --装备位升星
    FUNC_ID_EQUIP_RANDOMAB = 3,                 --装备洗炼
    FUNC_ID_WEAPON_ADDLUCK = 4,                 --武器祝福
    FUNC_ID_BAOZHU = 5,                         --宝珠系统
    FUNC_ID_BAOZHU_BOSS = 6,                    --宝珠BOSS
    FUNC_ID_SOUL_STONE = 7,                     --魂石
    FUNC_ID_GUANZHI = 8,                        --官职
    FUNC_ID_OFFLINE = 9,                        --离线系统 紫宸殿
    FUNC_ID_MOFANGZHEN = 10,                    --魔方阵
    FUNC_ID_RANDOMBOSS = 11,                    --随机BOSS
    FUNC_ID_FREEVIP = 12,                       --免费VIP
    FUNC_ID_GAMETASK = 13,                      --任务系统
    FUNC_ID_TOPICON = 14,                       --顶端功能入口
    FUNC_ID_FIRST_RECHARGE = 15,                --首充
    FUNC_ID_NEWPLAYER_RECHARGE = 16,            --新手充值返利
    FUNC_ID_RECYCLE_MANAGER = 17,               --回收系统
    FUNC_ID_OPEN_SERVER = 18,                   --开服活动
    FUNC_ID_PUBLIC_BOSS = 19,                   --野外首领
    FUNC_ID_SINGLE_BOSS = 20,                   --个人首领
    FUNC_ID_EVERYDAY_TASK = 21,                 --每日必做
    FUNC_ID_YUNBIAO = 22,                       --运镖
    FUNC_ID_TREASUREMAP = 23,                   --藏宝图
    FUNC_ID_COMPOSE = 24,                       --合成系统
    FUNC_ID_EXTEND_GIFT = 25,                   --进阶礼包
    FUNC_ID_SUPERBOX = 26,                      --超级宝箱
    FUNC_ID_GMHELPER = 27,                      --GM辅助系统
    FUNC_ID_NEWMAINUI = 28,                     --新主界面
    FUNC_ID_SKILLUPGRADE = 29,                  --技能进阶
    FUNC_ID_JUMPAREA_BASE = 30,                 --跨服活动  基础
    FUNC_ID_JUMPAREA_1 = 31,                    --跨服活动  单人PK
    FUNC_ID_JUMPAREA_2 = 32,                    --跨服活动  大乱斗
    FUNC_ID_JUMPAREA_3 = 33,                    --跨服活动  跨服BOSS
    FUNC_ID_JUMPAREA_4 = 34,                    --跨服活动  跨服夺宝
    FUNC_ID_JUMPAREA_5 = 35,                    --跨服活动  跨服商店
    

    --快捷前往
    QUICK_GOTO_UPGRADE_LEVEL = 1,               --升级
    QUICK_GOTO_INCREASE_POWER = 2,              --涨战力
    QUICK_GOTO_KILL_RANDOMBOSS = 3,             --击杀战力boss
    QUICK_GOTO_KILL_BAOZHUBOSS = 4,             --击杀宝珠【灵玉】boss
    QUICK_GOTO_ENTER_MOFANGZHEN = 5,            --进入魔方阵
    QUICK_GOTO_UPGRADE_EQUIPSTAR = 6,           --装备升星
    QUICK_GOTO_EQUIP_STRENGTH = 7,              --装备强化
    QUICK_GOTO_EQUIP_QUALITY = 8,               --装备品质
    QUICK_GOTO_EQUIP_RANDOMAB = 9,              --装备洗炼
    QUICK_GOTO_EQUIP_COMPOSE = 10,              --装备合成
    QUICK_GOTO_SOULSTONE = 11,                  --魂石系统
    QUICK_GOTO_BAOZHU = 12,                     --宝珠【灵玉】系统
    QUICK_GOTO_FREEVIP = 13,                    --免费VIP系统
    QUICK_GOTO_RECHARGE = 14,                   --充值界面
    QUICK_GOTO_SINGLEBOSS = 15,                 --个人首领
    QUICK_GOTO_PUBLICBOSS = 16,                 --野外首领
    QUICK_GOTO_YUNBIAO = 17,                    --运镖
    QUICK_GOTO_TREASUREMAP = 18,                --藏宝图
    QUICK_GOTO_GUANZHI = 19,                    --官职
    QUICK_GOTO_ZCD = 20,                        --紫宸殿 离线护卫
    QUICK_GOTO_AUTO_OPENBOX = 21,               --自动开宝箱
    QUICK_GOTO_BAG_USEDICE = 22,                --背包开骰子得宝箱
    QUICK_GOTO_SKILL_UPGRADE = 23,              --技能升级
    QUICK_GOTO_SUPERBOX_UPGRADE = 24,           --开宝箱升级
    QUICK_GOTO_COMMON_NAVIGATION = 25,          --通用引导

    --脚本创建的动态npcid    最终的npcid是 系统组编号*10000+动态id
    --[[
    DYN_NPC_ZCD_HUWEI1 = 101,                     --紫宸殿护卫1
    DYN_NPC_ZCD_HUWEI2 = 102,                     --紫宸殿护卫2
    DYN_NPC_ZCD_HUWEI3 = 103,                     --紫宸殿护卫3
    DYN_NPC_ZCD_HUWEI4 = 104,                     --紫宸殿护卫4
    DYN_NPC_ZCD_HUWEI5 = 105,                     --紫宸殿护卫5
    ]]--

    --NPCID
    NPC_ID_NEWPLAYER_ACCEPTER = 1,                --新手接待员
    --NPC_ID_EQUIP_COMPOSE = 203,                   --装备合成
    NPC_ID_BAOZHU_BOSS = 500,                     --灵玉boss
    NPC_ID_RANDOM_BOSS = 501,                     --战力boss
    NPC_ID_SINGLE_BOSS = 502,                     --个人BOSS
    NPC_ID_PUBLIC_BOSS = 503,                     --野外BOSS
    NPC_ID_BIAOCHE_START = 504,                   --运镖NPC
    NPC_ID_BIAOCHE_FINISH = 505,                  --接镖NPC


    --任务线ID
    TASK_LINE_ID_MAIN = 100,                      --任务线，主线任务
    TASK_LINE_ID_BRANCH = 201,                    --任务线，支线任务1

    --任务类型
    TASK_TYPE_KILLMON = 1,                        --杀怪任务
    TASK_TYPE_FREEVIP = 2,                        --免费VIP任务
    TASK_TYPE_LEVEL = 3,                          --玩家等级
    TASK_TYPE_POWERSCORE = 4,                     --玩家战力
    TASK_TYPE_OPENBOXNUM = 5,                     --玩家开箱数量
    TASK_TYPE_EQUIPPOS_STRENGTH = 6,              --装备槽位强化
    TASK_TYPE_SKILL_UPGRADE = 7,                  --技能升级
    TASK_TYPE_SUPERBOX_UPGRADE = 8,               --宝箱升级


    --任务线状态
    TASK_STATUS_NONE = 0,                         --无任务线
    TASK_STATUS_ADD = 1,                          --已添加，未接受
    TASK_STATUS_ACCEPT = 2,                       --已接受，未完成
    TASK_STATUS_FINISH = 3,                       --已完成，未领奖
    TASK_STATUS_END = 4,                          --已领奖，结束  
    
    --窗口ID
    WINDOWS_ID_EQUIPMENT = 3,                     --装备的窗口ID
    WINDOWS_ID_BAG = 7,                           --背包的窗口ID

    --组件ID通用定义
    COMPONENT_ID_BAGITEMSHOW_IMG_BASE = 39100,    --界面上显示持有道具的图片基础ID
    COMPONENT_ID_BAGITEMSHOW_TEXT_BASE = 39200,   --界面上显示持有道具的数字基础ID

    --addbutton 里面对应的buttonid
    ADD_BUTTON_ID_1 = 9001,                       --超级宝箱界面对应的buttonid
    ADD_BUTTON_ID_2 = 9002,                       --GMHelper的buttonid
    ADD_BUTTON_ID_3 = 9003,                       --NPC大号对话框的buttonid
    ADD_BUTTON_ID_4 = 9004,                       --通用功能对话框的buttonid
    ADD_BUTTON_ID_5 = 9005,                       --超级宝箱的弹出界面 升级和自动设置 共用
    ADD_BUTTON_ID_6 = 9006,                       --战力显示
    ADD_BUTTON_ID_7 = 9007,                       --战力变化显示
    ADD_BUTTON_ID_8 = 9008,                       --退出地图的按钮
    ADD_BUTTON_ID_9 = 9009,                       --退出地图的倒计时

    ADD_BUTTON_ID_10 = 9010,                      --装备面板 项链槽位 天赋属性图标
    ADD_BUTTON_ID_11 = 9011,                      --装备面板 左护腕槽位 天赋属性图标
    ADD_BUTTON_ID_12 = 9012,                      --装备面板 右护腕槽位 天赋属性图标
    ADD_BUTTON_ID_13 = 9013,                      --装备面板 左戒指槽位 天赋属性图标
    ADD_BUTTON_ID_14 = 9014,                      --装备面板 右戒指槽位 天赋属性图标
    ADD_BUTTON_ID_15 = 9015,                      --装备面板 腰带槽位 天赋属性图标
    ADD_BUTTON_ID_16 = 9016,                      --装备面板 鞋子槽位 天赋属性图标

    ADD_BUTTON_ID_31 = 9031,                      --成长快捷提示 展开界面
    ADD_BUTTON_ID_32 = 9032,                      --成长快捷提示 接触界面
    ADD_BUTTON_ID_33 = 9033,                      --topicon 第一列
    ADD_BUTTON_ID_34 = 9034,                      --topicon 第二列
    ADD_BUTTON_ID_35 = 9035,                      --地图内功能按钮1
    ADD_BUTTON_ID_36 = 9036,                      --地图内功能按钮2
    ADD_BUTTON_ID_37 = 9037,                      --快捷物品栏上中央提示    
    ADD_BUTTON_ID_38 = 9038,                      --复活框
    ADD_BUTTON_ID_39 = 9039,                      --超级宝箱界面对应防穿透底板的buttonid
}

--装备位对应的名称
CommonDefine.EQUIPPOS_NAME = {
    [CommonDefine.EQUIPPOS_DRESS] = '衣服',
    [CommonDefine.EQUIPPOS_WEAPON] = '武器',
    [CommonDefine.EQUIPPOS_MEDAL] = '勋章',
    [CommonDefine.EQUIPPOS_NECKLACE] = '项链',
    [CommonDefine.EQUIPPOS_HELMET] = '头盔',
    [CommonDefine.EQUIPPOS_ARMRING_R] = '右手镯',
    [CommonDefine.EQUIPPOS_ARMRING_L] = '左手镯',
    [CommonDefine.EQUIPPOS_RING_R] = '右戒指',
    [CommonDefine.EQUIPPOS_RING_L] = '左戒指',
    [CommonDefine.EQUIPPOS_BELT] = '腰带',
    [CommonDefine.EQUIPPOS_BOOTS] = '鞋子',

    [CommonDefine.EQUIPPOS_SSH_1] = '鼠灵',
    [CommonDefine.EQUIPPOS_SSH_2] = '牛灵',
    [CommonDefine.EQUIPPOS_SSH_3] = '虎灵',
    [CommonDefine.EQUIPPOS_SSH_4] = '兔灵',
    [CommonDefine.EQUIPPOS_SSH_5] = '龙灵',
    [CommonDefine.EQUIPPOS_SSH_6] = '蛇灵',
    [CommonDefine.EQUIPPOS_SSH_7] = '马灵',
    [CommonDefine.EQUIPPOS_SSH_8] = '羊灵',
    [CommonDefine.EQUIPPOS_SSH_9] = '猴灵',
    [CommonDefine.EQUIPPOS_SSH_10] = '鸡灵',
    [CommonDefine.EQUIPPOS_SSH_11] = '狗灵',
    [CommonDefine.EQUIPPOS_SSH_12] = '猪灵',

}

--自定义的百分比加成属性 对应的基础属性ID
CommonDefine.ADD_PERCENT_ABILITY_PAIR = {
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_DC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_DC, CommonDefine.ABILITYID_MAX_DC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_MC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_MC, CommonDefine.ABILITYID_MAX_MC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_SC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_SC, CommonDefine.ABILITYID_MAX_SC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_AC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_AC, CommonDefine.ABILITYID_MAX_AC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_MAC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_MAC, CommonDefine.ABILITYID_MAX_MAC},
}

--装备位百分比增加属性值对应的属性组名  十个装备位分开
CommonDefine.EQUIPPOS_ADDAB_GROUP_NAME = {
    [CommonDefine.EQUIPPOS_DRESS] = CommonDefine.ABIL_GROUP_ADD_1,
    [CommonDefine.EQUIPPOS_WEAPON] = CommonDefine.ABIL_GROUP_ADD_2,
    [CommonDefine.EQUIPPOS_NECKLACE] = CommonDefine.ABIL_GROUP_ADD_3,
    [CommonDefine.EQUIPPOS_HELMET] = CommonDefine.ABIL_GROUP_ADD_4,
    [CommonDefine.EQUIPPOS_ARMRING_R] = CommonDefine.ABIL_GROUP_ADD_5,
    [CommonDefine.EQUIPPOS_ARMRING_L] = CommonDefine.ABIL_GROUP_ADD_6,
    [CommonDefine.EQUIPPOS_RING_R] = CommonDefine.ABIL_GROUP_ADD_7,
    [CommonDefine.EQUIPPOS_RING_L] = CommonDefine.ABIL_GROUP_ADD_8,
    [CommonDefine.EQUIPPOS_BELT] = CommonDefine.ABIL_GROUP_ADD_9,
    [CommonDefine.EQUIPPOS_BOOTS] = CommonDefine.ABIL_GROUP_ADD_10,
}

--金币洗炼对应的消耗
CommonDefine.EQUIP_RANDOMAB_GOLD_NEEDITEMS = {
    {name='金币', num=10000},
}       

--道具的品质颜色
CommonDefine.ITEM_QUALITY_COLORNAME = {
    [CommonDefine.ITEM_QUALITY_WHITE+1]     = '白色',
    [CommonDefine.ITEM_QUALITY_GREEN+1]     = '绿色',
    [CommonDefine.ITEM_QUALITY_BLUE+1]      = '蓝色',
    [CommonDefine.ITEM_QUALITY_PURPLE+1]    = '紫色',
    [CommonDefine.ITEM_QUALITY_PINK+1]      = '粉色',
    [CommonDefine.ITEM_QUALITY_GOLD+1]      = '金色',
    [CommonDefine.ITEM_QUALITY_RED+1]       = '红色',
    [CommonDefine.ITEM_QUALITY_TOP+1]       = '至尊',
}

--元宝洗炼对应的消耗
CommonDefine.EQUIP_RANDOMAB_YB_NEEDITEMS = {
    {name='元宝', num=100},
}

--CheckBox选项框对应变量
CommonDefine.CHECK_BOX_VAR = {
    CommonDefine.VAR_N_NPC_CHECKBOX_1,
    CommonDefine.VAR_N_NPC_CHECKBOX_2,
    CommonDefine.VAR_N_NPC_CHECKBOX_3,
    CommonDefine.VAR_N_NPC_CHECKBOX_4,
    CommonDefine.VAR_N_NPC_CHECKBOX_5,
    CommonDefine.VAR_N_NPC_CHECKBOX_6,
    CommonDefine.VAR_N_NPC_CHECKBOX_7,
    CommonDefine.VAR_N_NPC_CHECKBOX_8,
    CommonDefine.VAR_N_NPC_CHECKBOX_9,
    CommonDefine.VAR_N_NPC_CHECKBOX_10,
    CommonDefine.VAR_N_NPC_CHECKBOX_11,
    CommonDefine.VAR_N_NPC_CHECKBOX_12,
    CommonDefine.VAR_N_NPC_CHECKBOX_13,
    CommonDefine.VAR_N_NPC_CHECKBOX_14,
    CommonDefine.VAR_N_NPC_CHECKBOX_15,
}

--玩家的基础装备位  对应强化，升星，普通穿戴
CommonDefine.BASE_EQUIPMENT_POS = {
    CommonDefine.EQUIPPOS_DRESS, 
    CommonDefine.EQUIPPOS_WEAPON, 
    CommonDefine.EQUIPPOS_NECKLACE, 
    CommonDefine.EQUIPPOS_HELMET, 
    CommonDefine.EQUIPPOS_RING_L,
    CommonDefine.EQUIPPOS_RING_R, 
    CommonDefine.EQUIPPOS_ARMRING_L, 
    CommonDefine.EQUIPPOS_ARMRING_R, 
    CommonDefine.EQUIPPOS_BELT, 
    CommonDefine.EQUIPPOS_BOOTS
}

return CommonDefine