CommonDefine = {
    --����ģʽ  0��ʾ����  1��ʾ����ģʽ
    DEBUG_MODE = 1,

    --ְҵ
    JOB_Z = 0,
    JOB_F = 1,
    JOB_D = 2,
    JOB_ALL = 3,

    --�Ա�
    GENDER_MAN = 0,
    GENDER_WOMAN = 1,

    --��������ID
    ITEMID_GOLD = 1,        --���
    ITEMID_YB = 2,          --Ԫ��
    ITEMID_BINDGOLD = 3,    --�󶨽��
    ITEMID_BINDYB = 4,      --��Ԫ��
    ITEMID_JINGANGSHI = 5,  --���ʯ
    ITEMID_EXP = 6,         --����
    ITEMID_MOFANGZHEN_JIFEN = 20,   --ħ�������
    ITEMID_XINYUNFU = 208,  --���˷�
    ITEMID_BAODIFU = 209,   --���׷�

    --���ߵ�Stdmode
    ITEM_STDMODE_SOULSTONE = 53,    --��ʯ��stdmode

    --װ��λ
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

    --װ��λ�����κС�
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

    --װ��λ��Ӧ������
    EQUIPPOS_NAME = {},
    --����װ��λ
    BASE_EQUIPMENT_POS = {},

    --��Ϣλ������
    MSG_POS_TYPE_SYS_CHANNEL = 1,           --ϵͳƵ��
    MSG_POS_TYPE_GUILD_CHANNEL = 2,         --�л�Ƶ��
    MSG_POS_TYPE_TEAM_CHANNEL = 3,          --���Ƶ��
    MSG_POS_TYPE_TOP_ROLL = 4,              --���������
    MSG_POS_TYPE_ALL_ROLL = 5,              --��Ļ����ƹ���,�ɿ���Y��
    MSG_POS_TYPE_CHATBOX_TOP = 6,           --�����Ϸ�����
    MSG_POS_TYPE_FIX_CHAT = 8,              --�̶�����
    MSG_POS_TYPE_SYSTEM_TIPS = 9,           --ϵͳ��ʾ����
    MSG_POS_TYPE_XY_BROADCAST = 10,         --�ɿ���xy����㲥
    --12=ϵͳƵ�� ������;
    --13=ϵͳ��������    

    --����ģʽ
    ATTACK_MODE_ALL = 0,                 --ȫ�幥��
    ATTACK_MODE_PEACE = 1,               --��ƽ����
    ATTACK_MODE_COUPLE = 2,              --���޹���
    ATTACK_MODE_SHITU = 3,               --ʦͽ����
    ATTACK_MODE_GROUP = 4,               --���鹥��
    ATTACK_MODE_GUILD = 5,               --�лṥ��
    ATTACK_MODE_REDNAME = 6,             --��������
    ATTACK_MODE_NATION = 7,              --���ҹ���
    ATTACK_MODE_ZHENYIN = 8,             --��Ӫ����

    --������Ϣ����
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
    INFO_HUMBAGITEMNUM = 34,             --��ұ����е���Ʒ����
    INFO_GUILDNAME = 36,                 --����л���
    INFO_SLAVECOUNT = 38,                --��������
    INFO_MONIDX = 55,                    --�����Idx
    INFO_NAMECOLOR = 56,                 --������ɫ
    INFO_BAGCOUNT = 63,                  --������С

    --��׼��Ʒ��Ϣ
    STDITEMINFO_IDX = 0,                 --��ƷID
    STDITEMINFO_NAME = 1,                --��Ʒ��
    STDITEMINFO_STDMODE = 2,             --StdMode  ����
    STDITEMINFO_SHAPE = 3,               --Shape    С��
    STDITEMINFO_WEIGHT = 4,              --����
    STDITEMINFO_ANICOUNT = 5,            --AniCount
    STDITEMINFO_MAXDURA = 6,             --���־�
    STDITEMINFO_OVERLAP = 7,             --��������
    STDITEMINFO_SELLPRICE = 8,           --�۸�
                                         --
    STDITEMINFO_NEEDLV = 10,             --ʹ�õȼ�
    STDITEMINFO_PARAM1 = 11,             --�Զ������1
    STDITEMINFO_PARAM2 = 12,             --�Զ������2
    STDITEMINFO_NAMECOLOR = 13,          --������ɫ

    --ʵ�������Ϣ
    ITEMINFO_UNIQUEID = 1,               --ΨһID
    ITEMINFO_ITEMIDX = 2,                --��ƷID
    ITEMINFO_CURRDURA = 3,               --ʣ��־�
    ITEMINFO_MAXDURA = 4,                --���־�
    ITEMINFO_OVERLAP = 5,                --��������
    ITEMINFO_BIND = 6,                   --��״̬
    ITEMINFO_SRCNAME = 7,                --��Ʒ����(����64_23.08.30����)
    ITEMINFO_CHGEDNAME = 8,              --��Ʒ�����������(����64_24.08.07����)   

    --����Ʒ��
    ITEM_QUALITY_WHITE = 0,               --��ɫ
    ITEM_QUALITY_GREEN = 1,               --��ɫ
    ITEM_QUALITY_BLUE = 2,                --��ɫ
    ITEM_QUALITY_PURPLE = 3,              --��ɫ
    ITEM_QUALITY_PINK = 4,                --��ɫ
    ITEM_QUALITY_GOLD = 5,                --��ɫ
    ITEM_QUALITY_RED = 6,                 --��ɫ

    ITEM_QUALITY_COLORNAME = {},          --���ߵ�Ʒ����ɫ����

    --������ɫ  �������Ϸ�߼��й�
    MON_NAME_COLOR_WHITE = 255,           --��ɫ
    MON_NAME_COLOR_GOLD = 116,            --��ɫ
    MON_NAME_COLOR_RED = 22,              --��ɫ
    
    --���� additemvalue type=1ʱ position=0~49�Ķ���
    ITEMADDVALUE_TYPE1_AC = 0,           --���
    ITEMADDVALUE_TYPE1_MAC = 1,          --ħ��
    ITEMADDVALUE_TYPE1_DC = 2,           --����
    ITEMADDVALUE_TYPE1_MC = 3,           --ħ��
    ITEMADDVALUE_TYPE1_SC = 4,           --����
    ITEMADDVALUE_TYPE1_LUCK = 5,         --����

    --�Զ���װ��������
    ITEM_CUSTOMEAB_GROUP_0 = 0,          --ǿ��
    ITEM_CUSTOMEAB_GROUP_1 = 1,          --����
    ITEM_CUSTOMEAB_GROUP_2 = 2,          --ϴ�� ��Ʒ
    ITEM_CUSTOMEAB_GROUP_3 = 3,          --�츳
    ITEM_CUSTOMEAB_GROUP_4 = 4,          --
    ITEM_CUSTOMEAB_GROUP_5 = 5,          --    

    --�ʼ�ID
    MAIL_ID_BAGFULL = 100,               --�������������߷��ŵ��ʼ���

    --��Ϸ�ɳ�����
    ABILITYID_MAX_HP = 1,                --�������ֵ
    ABILITYID_MAX_MP = 2,                --���ħ��ֵ
    ABILITYID_MIN_DC = 3,                --��С����
    ABILITYID_MAX_DC = 4,                --��󹥻�
    ABILITYID_MIN_MC = 5,                --��Сħ��
    ABILITYID_MAX_MC = 6,                --���ħ��    
    ABILITYID_MIN_SC = 7,                --��С����
    ABILITYID_MAX_SC = 8,                --������    
    ABILITYID_MIN_AC = 9,                --��С���
    ABILITYID_MAX_AC = 10,               --������
    ABILITYID_MIN_MAC = 11,              --��Сħ��
    ABILITYID_MAX_MAC = 12,              --���ħ��  doto...�����ټ�

    ABILITYID_CUS_EQUIPPOS_DC_ADDPERCENT = 200,    --װ��λ�Ĺ����ӳɰٷֱ�
    ABILITYID_CUS_EQUIPPOS_MC_ADDPERCENT = 201,    --װ��λ��ħ���ӳɰٷֱ�
    ABILITYID_CUS_EQUIPPOS_SC_ADDPERCENT = 202,    --װ��λ�ĵ����ӳɰٷֱ�
    ABILITYID_CUS_EQUIPPOS_AC_ADDPERCENT = 203,    --װ��λ������ӳɰٷֱ�
    ABILITYID_CUS_EQUIPPOS_MAC_ADDPERCENT = 204,   --װ��λ��ħ���ӳɰٷֱ�

    --�Զ���İٷֱȼӳ����� ��Ӧ�Ļ�������ID
    ADD_PERCENT_ABILITY_PAIR = {},

    --��Ϸ����Զ���������
    ABIL_GROUP_ADD_1 = 'abgroupadd1',        --װ��λ�ٷֱȼӳɵĵ��� 1
    ABIL_GROUP_ADD_2 = 'abgroupadd2',        --װ��λ�ٷֱȼӳɵĵ��� 2
    ABIL_GROUP_ADD_3 = 'abgroupadd3',        --װ��λ�ٷֱȼӳɵĵ��� 3
    ABIL_GROUP_ADD_4 = 'abgroupadd4',        --װ��λ�ٷֱȼӳɵĵ��� 4  
    ABIL_GROUP_ADD_5 = 'abgroupadd5',        --װ��λ�ٷֱȼӳɵĵ��� 5
    ABIL_GROUP_ADD_6 = 'abgroupadd6',        --װ��λ�ٷֱȼӳɵĵ��� 6
    ABIL_GROUP_ADD_7 = 'abgroupadd7',        --װ��λ�ٷֱȼӳɵĵ��� 7
    ABIL_GROUP_ADD_8 = 'abgroupadd8',        --װ��λ�ٷֱȼӳɵĵ��� 8
    ABIL_GROUP_ADD_9 = 'abgroupadd9',        --װ��λ�ٷֱȼӳɵĵ��� 9
    ABIL_GROUP_ADD_10 = 'abgroupadd10',      --װ��λ�ٷֱȼӳɵĵ��� 10

    ABIL_GROUP_HUWEI1 = 'huwei1',             --��巵� ����1
    ABIL_GROUP_HUWEI2 = 'huwei2',             --��巵� ����2
    ABIL_GROUP_HUWEI3 = 'huwei3',             --��巵� ����3
    ABIL_GROUP_HUWEI4 = 'huwei4',             --��巵� ����4
    ABIL_GROUP_HUWEI5 = 'huwei5',             --��巵� ����5    

    ABILITY_GROUP_STONE_PRENAME = 'stone_',   --��ʯ���Լӳɵ�ǰ������
    ABILITY_GROUP_STONE_JIBAN = 'stonejiban', --��ʯ���������
    ABILITY_GROUP_GUANZHI = 'guanzhi',        --��ְ��Ӧ�����Լӳ�
    ABILITY_GROUP_FREEVIP = 'freevip',        --FREEVIP��Ӧ�����Լӳ�
    ABILITY_GROUP_TEMPTEST = 'temptest',      --��ʱ���Զ�Ӧ�����Լӳ�

    --װ��λ�ٷֱ���������ֵ��Ӧ����������  ʮ��װ��λ�ֿ�
    EQUIPPOS_ADDAB_GROUP_NAME = {},    

    --��Ϸ����
    PLAYER_AUTO_ADDEXP_MAXLV = 50,              --������Զ���þ�������ȼ�
    MAPNAME_NEWREN = 'xinr1',                   --���˵�ͼ
    MAPNAME_JQPD = 'jqpd',                      --�����ݵ�ĵ�ͼ��  
    ADDLUCK_USE_XYF_NUM = 1,                    --����ף��ʹ�����˷�����
    ADDLUCK_USE_BDF_NUM = 1,                    --����ף��ʹ�ñ��׷�����
    ADDLUCK_USE_XYF_ADDRATE = 20,               --ף��ʱʹ�����˷����ӵĳɹ�����
    ITEM_COMPOSE_NEED_NUM = 3,                  --�ϳ�ʱ��Ҫ�ĺϳɵ�������
    SOUL_STONE_SLOT_MAX_HOLE_NUM = 4,           --һ����ʯ��λ���Ŀ���
    BACK_MAP_POSITION = {mapid=3, x=330, y=330},--�سǵ�
    OFFLINE_FETCH_MIN_INTERVAL = 180,           --������ȡ��������С�������
    DAY_FREE_ENTER_MOFANGZHEN_TIMES = 2,        --ÿ����ѽ���ħ����Ĵ���
    MOFANGZHEN_ONCE_FOR_STAY_SECONDS = 1800,    --һ��ħ������Դ��೤ʱ��(��)
    MOFANGZHEN_DAY_MAX_BUY_TIMES = 5,           --ħ����ÿ����������
    MOFANGZHEN_DAY_BUY_NEEDITEMS = {{name='Ԫ��', num=20}},     --ħ�����������Ҫ������
    DAY_RANDOMBOSS_GETREWARD_MAXTIMES = 5,      --���bossÿ�콱�������ȡ5��
    DAY_RANDOMBOSS_TRIGGER_MAXTIMES = 3,        --���bossÿ����ഥ��3��
    ACTIVATED_AUTORECYCLE_FREEVIP_LV = 2,       --�����Զ����յ����VIP�ȼ�
    ACTIVATED_AUTORECYCLE_NEEDYB = 100,         --�����Զ�������Ҫ��Ԫ������
    MAX_DISTANCE = 999999,                      --���޾������
    DAY_BAOZHUBOSS_GETREWARD_MAXTIMES = 5,      --����boss[���񸱱�]ÿ�콱�������ȡ����    
    EXTEND_STORAGE_ONCE_ADDNUM = 8,                                  --��չһ�βֿ����ӵĸ�������
    EXTEND_STORAGE_ONCE_NEEDITEMS = {{name='��Ԫ��', num=800}},     --��չһ�βֿ�����ĵ�������
    SHOW_QUICK_TIP_MIN_LEVEL = 20,                                   --��ʾ�����ʾ����С�ȼ�
    DAY_SUPER_BOX_MAX_ADD_NUM = 100,                                 --ÿ����Ի�õĳ���������������


    --ͨ�õ������ͼ��ԭ�ظ�������ģ�������仯
    COMMON_LOCAL_RELIVE_NEED_ITEMS = {{{name='���', num=10000}}, {{name='���', num=20000}}, {{name='���', num=30000}}, {{name='���', num=40000}}, {{name='���', num=50000}},
        {{name='���', num=60000}}, {{name='���', num=70000}}, {{name='���', num=80000}}, {{name='���', num=90000}}, {{name='���', num=100000}},},      

    EQUIP_RANDOMAB_GOLD_NEEDITEMS = {},         --���ϴ����Ӧ������
    EQUIP_RANDOMAB_YB_NEEDITEMS = {},           --Ԫ��ϴ����Ӧ������
    CHECK_BOX_VAR = {},                         --CheckBoxѡ���


    --ϵͳ���ֱ��������������� I0 - I99
    VAR_I_CURR_DYNNPC_GROUPID = 'I1',            --��ǰϵͳ��Ӧ�Ķ�̬NPC������,��ҵ�¼ʱ+1��ֵ

    --������ֱ��������߲����� N0 - N99
    VAR_N_NPC_CHECKBOX_1 = 'N4',                --���NPC�Ի����еĵ�һ��CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_2 = 'N5',                --���NPC�Ի����еĵڶ���CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_3 = 'N6',                --���NPC�Ի����еĵ�����CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_4 = 'N7',                --���NPC�Ի����еĵ��ĸ�CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_5 = 'N8',                --���NPC�Ի����еĵ����CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_6 = 'N9',                --���NPC�Ի����еĵ�����CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_7 = 'N10',               --���NPC�Ի����еĵ��߸�CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_8 = 'N11',               --���NPC�Ի����еĵڰ˸�CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_9 = 'N12',               --���NPC�Ի����еĵھŸ�CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_10 = 'N13',              --���NPC�Ի����еĵ�ʮ��CheckBoxѡ��
    VAR_N_CHOOSE_ITEM_MAKEIDX = 'N14',          --���ѡ��ı����еĵ���makeidx
    VAR_N_CURR_NPC_DATA_PAGE1 = 'N15',          --��ҵ�ǰ��NPC�����е�ҳ��
    VAR_N_SOULSTONE_JBLEVEL = 'N16',            --��һ�ʯ�ȼ�
    VAR_N_CURR_DYNNPC_GROUPID = 'N17',          --��һ굱ǰ�Ķ�̬NPC����ID
    VAR_N_CURR_RANDOMBOSS_FIGHTING_ID = 'N18',  --��ҵ�ǰ���������BOSS����սID
    VAR_N_LAST_OPER_TIME1 = 'N19',              --�����һ�β�����ʱ���¼1   ���ڴ���һЩ��Ҫ������ʱ����ȴ��  �����ӵ�CD
    VAR_N_LAST_OPER_TIME2 = 'N20',              --�����һ�β�����ʱ���¼2   ���ڴ���һЩ��Ҫ������ʱ����ȴ��  �����ӵ�CD
    VAR_N_LAST_ATTACK_MODE = 'N21',             --������ҵ�ǰ�Ĺ���ģʽ
    VAR_U_CURR_TASKLINEID = 'N22',              --��ǰ�򿪵�����Ի���Ӧ��tasklineid
    VAR_N_NPC_CHECKBOX_11 = 'N23',              --���NPC�Ի����еĵ�ʮһ��CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_12 = 'N24',              --���NPC�Ի����еĵ�ʮ����CheckBoxѡ��
    VAR_N_NPC_CHECKBOX_13 = 'N25',              --���NPC�Ի����еĵ�ʮ����CheckBoxѡ��    
    VAR_N_NPC_CHECKBOX_14 = 'N26',              --���NPC�Ի����еĵ�ʮ�ĸ�CheckBoxѡ��    
    VAR_N_CHOOSE_RECYCLE_TYPE = 'N27',          --���ѡ��Ļ�������
    VAR_N_COMMON_LOCAL_RELIVE_TIMES = 'N28',    --ͨ��ԭ�ظ������
    VAR_N_SELECT_COMPOSE_PILE_NUM = 'N29',      --�ϳɿɵ��ӵ���ʱ��ѡ��ĵ����ϳ�����
    VAR_N_NPC_TEMPPARAM1 = 'N30',               --���NPC�����Ĳ���1
    VAR_N_CHOOSE_OPER_TYPE = 'N31',             --���ѡ��Ĳ�������  ͨ�õ���ʱ���� ����ѡ�����������Ǽ���ǿ��
    VAR_N_LAST_PLAYERPOWER = 'N32',             --������һ�α仯��ս��
    VAR_N_LAST_NPC_CHOOSEID = 'N33',            --������һ��NPCѡ���id
    VAR_N_ITEM_COMPOSE_CHOOSE_ITEM1 = 'N34',    --��ҵ��ߺϳ�ʱ��ѡ��ĵ�һ���ϳ���Ʒ��ÿ��ʹ������

    --����ַ��ͱ��������߲����� S0 - S99
    --[[
    VAR_S_SELECT_ITEM = 'S0',
    VAR_S_SELECT_COMPOSE_ITEMS = 'S1',          --ѡ������д��ϳ�װ�� ΨһID ,�ָ�    
    ]]--
    VAR_S_SUPERBOX_ITEMLIST = 'S50',

    --������ֱ��������߱���   U0 - U254  lua�ű�ʹ�ô�130��ʼ
    --[[
    VAR_U_ADVANCE_SKILL1_LV = 'U51',            --���׼��ܵȼ����棬�����˺�����  ռ��
    VAR_U_ADVANCE_SKILL2_LV = 'U52',
    VAR_U_ADVANCE_SKILL3_LV = 'U53',
    VAR_U_ADVANCE_SKILL4_LV = 'U54',
    VAR_U_ADVANCE_SKILL5_LV = 'U55',
    VAR_U_ADVANCE_SKILL6_LV = 'U56',
    VAR_U_ADVANCE_SKILL7_LV = 'U57',
    VAR_U_ADVANCE_SKILL8_LV = 'U58',
    VAR_U_ADVANCE_SKILL9_LV = 'U59',
    VAR_U_ADVANCE_SKILL10_LV = 'U60',
    VAR_U_ADVANCE_SKILL11_LV = 'U61',
    VAR_U_ADVANCE_SKILL12_LV = 'U62',
    VAR_U_ADVANCE_SKILL13_LV = 'U63',
    VAR_U_ADVANCE_SKILL14_LV = 'U64',
    VAR_U_ADVANCE_SKILL15_LV = 'U65',
    VAR_U_ADVANCE_SKILL16_LV = 'U66',
    VAR_U_ADVANCE_SKILL17_LV = 'U67',
    VAR_U_ADVANCE_SKILL18_LV = 'U68',
    VAR_U_ADVANCE_SKILL19_LV = 'U69',
    VAR_U_ADVANCE_SKILL20_LV = 'U70',
    VAR_U_ADVANCE_SKILL21_LV = 'U71',
    VAR_U_ADVANCE_SKILL22_LV = 'U72',
    VAR_U_ADVANCE_SKILL23_LV = 'U73',
    VAR_U_ADVANCE_SKILL24_LV = 'U74',
    VAR_U_ADVANCE_SKILL25_LV = 'U75',
    VAR_U_ADVANCE_SKILL26_LV = 'U76',
    VAR_U_ADVANCE_SKILL27_LV = 'U77',
    VAR_U_ADVANCE_SKILL28_LV = 'U78',
    VAR_U_ADVANCE_SKILL29_LV = 'U79',
    VAR_U_ADVANCE_SKILL30_LV = 'U80',    
    
    VAR_U_GUANZHI_LEVEL = 'U100',               --��ҵĹ�ְ�ȼ�
    VAR_U_GUANZHI_CURREXP = 'U101',             --��ҵĹ�ְ��ǰ����
    VAR_U_ZCDHW_LEVEL1 = 'U102',                --��ҵ���巵��1�ȼ�
    VAR_U_ZCDHW_LEVEL2 = 'U103',                --��ҵ���巵��2�ȼ�
    VAR_U_ZCDHW_LEVEL3 = 'U104',                --��ҵ���巵��3�ȼ�
    VAR_U_ZCDHW_LEVEL4 = 'U105',                --��ҵ���巵��4�ȼ�
    VAR_U_ZCDHW_LEVEL5 = 'U106',                --��ҵ���巵��5�ȼ�
    VAR_U_MOFANG_CURR_LAYER = 'U107',           --��ҵ�ǰ�����ħ����Ĳ���
    VAR_U_MOFANG_LEFT_BUYTIMES = 'U108',        --��ҵ�ǰʣ�๺��Ľ���ħ����ͼ�Ĵ���
    VAR_U_MOFANGZHEN_ID = 'U109',               --���ħ����ǰ�����ID
    VAR_U_FREEVIPTASK_COUNTER1 = 'U110',        --���VIP�������1
    VAR_U_FREEVIPTASK_COUNTER2 = 'U111',        --���VIP�������2
    VAR_U_FREEVIPTASK_COUNTER3 = 'U112',        --���VIP�������3
    VAR_U_FREEVIPTASK_COUNTER4 = 'U113',        --���VIP�������4
    VAR_U_FREEVIPTASK_COUNTER5 = 'U114',        --���VIP�������5
    VAR_U_FREEVIP_LEVEL = 'U115',               --���VIP�ȼ�
    VAR_U_ID_TASKLINE1 = 'U116',                --����1�ߵ�ǰ����ID
    VAR_U_STATUS_TASKLINE1 = 'U117',            --����1�ߵ�ǰ����״̬
    VAR_U_ID_TASKLINE2 = 'U116',                --����2�ߵ�ǰ����ID
    VAR_U_STATUS_TASKLINE2 = 'U117',            --����2�ߵ�ǰ����״̬
    VAR_U_ID_TASKLINE3 = 'U116',                --����3�ߵ�ǰ����ID
    VAR_U_STATUS_TASKLINE3 = 'U117',            --����3�ߵ�ǰ����״̬     
    VAR_U_RECHARGE_TOTAL = 'U118',              --�ۼƳ�ֵ RMB
    VAR_U_FIRST_RECHARGE_DAY = 'U119',          --�׳�����ڼ�¼
    VAR_U_FIRST_LOGIN_DAY = 'U120',             --�״ε�¼��Ϸ�����ڼ�¼
    VAR_U_NEWPLAYER_RECHARGE_SINGLE = 'U121',   --���˳�ֵ���������������ֵ
    VAR_U_NEWPLAYER_RECHARGE_TOTAL = 'U122',    --���˳�ֵ��������ۼ�����ֵ
    VAR_U_LAST_RECORD_WEEK = 'U123',            --��ҿ���ʱ��¼������
    VAR_U_LOGINDAYS_IN_WEEK = 'U124',           --���һ����Ŀ������
    VAR_U_LAST_LOGIN_TIME = 'U125',             --�����һ�ε�¼ʱ�䣬��������
    VAR_U_TREASUREMAP_CURRID = 'U126',          --��ǰ��Ӧ�Ĳر�ͼ����id
    VAR_U_BIAOCHE_CURRID = 'U127',              --��ǰ��Ӧ���ڳ�����ID
    VAR_U_BIAOCHE_REFRESH_TIMES = 'U128',       --�ڳ�ˢ�´����������ڳ�����0
    ]]--
    VAR_U_SUPER_BOX_TOTAL_NUM = 'U130',         --��������  ����������
    VAR_U_SUPER_BOX_CURR_LV = 'U131',           --��������  ��ǰ�ȼ�
    VAR_U_SUPER_BOX_ONCE_OPEN_NUM = 'U132',     --��������  һ�ο���������
    VAR_U_SUPER_BOX_CHOOSE_CONDITION_1 = 'U133',--��������  ��������ѡ�������1��� - Ʒ��
    
    --����ַ��ͱ��������߱��� T0 - T254
    VAR_T_EQUIPPOS_STRENGTH_INFO = 'T1',        --��ҵ�װ��λǿ����Ϣ
    VAR_T_EQUIPPOS_UPGRADESTAR_INFO = 'T2',     --��ҵ�װ��λ������Ϣ
    VAR_T_SOULSTONE_SLOT_INFO = 'T3',           --��ҵĻ�ʯ��λ��Ϣ
    VAR_T_OFFLINE_REWARD_INFO = 'T4',           --��ҵ����߽��������Ϣ   
    VAR_T_COUNTERDATA_TASKLINE1 = 'T5',         --����1�ߵļ�������
    VAR_T_COUNTERDATA_TASKLINE2 = 'T6',         --����2�ߵļ�������
    VAR_T_COUNTERDATA_TASKLINE3 = 'T7',         --����3�ߵļ�������
    VAR_T_NEWPLAYER_SINGLERECHARGE_REWARDDATA = 'T8',    --���˳�ֵ�����콱��Ϣ--����
    VAR_T_NEWPLAYER_TOTALRECHARGE_REWARDDATA = 'T9',     --���˳�ֵ�����콱��Ϣ--�۳�
    VAR_T_OPENSERVER_REWARDDATA1 = 'T10',                --������콱��Ϣ--ÿ�ջ�Ծ
    VAR_T_OPENSERVER_REWARDDATA2 = 'T11',                --������콱��Ϣ--ÿ�ܻ�Ծ
    VAR_T_OPENSERVER_REWARDDATA3 = 'T12',                --������콱��Ϣ--�ȼ����
    VAR_T_OPENSERVER_REWARDDATA4 = 'T13',                --������콱��Ϣ--ս�����
    VAR_T_EXTENDGIFT_REWARDDATA = 'T14',                 --��������콱��Ϣ

    --������ֱ��������߱��棬0������ J0 - J499
    --[[
    VAR_J_DAY_BAOZHU_BOSS_TIMES = 'J1',         --��ҽ��ս��뱦��BOSS��ͼ�Ĵ���
    VAR_J_DAY_GUAZHI_ADDEXP = 'J2',             --��ҽ��ջ�õĹ�ְ����
    VAR_J_DAY_GUAZHI_GETREWARD = 'J3',          --��ҽ����Ƿ�����ȡ��ְ����
    VAR_J_DAY_MOFANG_LEFT_FREETIMES = 'J4',     --��ҽ���ʣ�����ѽ���ħ����ͼ�Ĵ���
    VAR_J_DAY_MOFANG_BUYTIMES = 'J5',           --��ҽ���ħ���������
    VAR_J_DAY_MOFANG_ENTER_TIME = 'J6',         --��ҽ���ħ�������ʱ��
    VAR_J_DAY_MOFANG_STAY_SECONDS = 'J7',       --��ҽ���ħ����ɴ�ʱ�䣨�룩
    VAR_J_DAY_RANDOMBOSS_REWARDTIMES = 'J8',    --��ҽ������BOSS�콱����
    VAR_J_DAY_RANDOMBOSS_TRIGGERTIMES = 'J9',   --��ҽ������BOSS��������
    VAR_J_DAY_FREEVIP_REWARDTIMES = 'J10',      --��ҽ�����ȡÿ��VIP��������
    VAR_J_DAY_RECHARGE_TOTAL = 'J11',           --��ҽ��յ��ܳ�ֵ
    VAR_J_DAY_ONLINE_TIME = 'J12',              --��ҽ��յ�����ʱ��
    VAR_J_DAY_SINGLEBOSS_KILLTIMES = 'J13',     --��ҽ��ջ�ɱ��������Ĵ���
    VAR_J_DAY_SINGLEBOSS_BUYTIMES = 'J14',      --��ҽ��չ���������Ĵ���
    VAR_J_DAY_EVERYDAYTASK_FINALREWARD_IDX = 'J15',     --��� ÿ�������ۼ��콱���     
    VAR_J_DAY_TREASUREMAP_USETIMES = 'J16',             --��� ����ʹ�òر�ͼ����
    VAR_J_DAY_TREASUREMAP_NO_PANELTIP_FLAG = 'J17',     --��� ���ղ�����ʾ�ر�ͼ����ʾ���
    VAR_J_DAY_BIAOCHE_ACCEPT_TIMES = 'J18',             --��� ���ս��ڴ���
    ]]--
    VAR_J_DAY_SUPERBOX_ADDNUM = 'J101',                 --��� ���ջ�ó����������
    
    --����ַ����������߱��棬0������ Z0 - Z499
    VAR_Z_DAY_EVERYDAYTASK_COUNTER_DATA = 'Z1',         --��� ÿ������ ���������
    VAR_Z_DAY_EVERYDAYTASK_REWARD_DATA = 'Z2',          --��� ÿ������ �������콱��¼
    

    --��ҵ�λ��ǣ����߱���  ������1~800��
    VAR_HUM_BITFLAG_USE_XYF = 1,                --ף���Ƿ�ʹ�����˷�
    VAR_HUM_BITFLAG_USE_BDF = 2,                --ף���Ƿ�ʹ�ñ��׷�
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_1 = 3,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_2 = 4,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_3 = 5,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_4 = 6,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_5 = 7,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_6 = 8,       --��ɫ�����Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_BAOZHU_KEEPBETTER = 9,  --�������ʱ���Ƿ����ȴ������õ�    
    VAR_HUM_BITFLAG_MFZ_ADDTIME_FLAG1 = 10,         --ħ���� ����ʱ����1 ȷ�Ϻ���1�λ�����30����
    VAR_HUM_BITFLAG_MFZ_ADDTIME_FLAG2 = 11,         --ħ���� ����ʱ����2 ȷ�Ϻ�ʱ�䲻���Զ��ô�����ʱ��
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG1 = 12,    --���VIP����1 �Ƿ��콱
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG2 = 13,    --���VIP����2 �Ƿ��콱
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG3 = 14,    --���VIP����3 �Ƿ��콱
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG4 = 15,    --���VIP����4 �Ƿ��콱
    VAR_HUM_BITFLAG_FREEVIP_TASK_DRAWFLAG5 = 16,    --���VIP����5 �Ƿ��콱
    VAR_HUM_BITFLAG_NPC_TEMP_CHOOSE_FLAG = 17,      --NPC�ϵ���ʱ�������
    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD1 = 18,     --�׳佱����ȡ���1
    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD2 = 19,     --�׳佱����ȡ���2
    VAR_HUM_BITFLAG_FIRSTRECHARGE_REWARD3 = 20,     --�׳佱����ȡ���3

    VAR_HUM_BITFLAG_RECYCLE_ITEM1_1 = 21,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_2 = 22,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_3 = 23,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_4 = 24,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_5 = 25,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_6 = 26,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM1_7 = 27,           --��ɫװ���Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_1 = 28,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_2 = 29,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_3 = 30,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_4 = 31,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_5 = 32,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_6 = 33,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_RECYCLE_ITEM2_7 = 34,           --��ɫֱ����ʯ�Ƿ����
    VAR_HUM_BITFLAG_ACTIVATED_AUTORECYCLE = 35,     --�����Զ����չ���
    VAR_HUM_BITFLAG_AUTORECYCLE_ITEM1 = 36,         --��ѡװ���Զ�����
    VAR_HUM_BITFLAG_AUTORECYCLE_ITEM2 = 37,         --��ѡֱ����ʯ�Զ�����
    VAR_HUM_BITFLAG_IS_FIRST_RANDOMBOSS_REWARD = 38,       --�Ƿ��ǵ�һ��ս��boss�Ľ���
    VAR_HUM_BITFLAG_IS_FIRST_RANDOMBOSS_TRIGGER = 39,      --�Ƿ��Ǵ����ĵ�һ��ս��boss


    VAR_HUM_BITFLAG_NEW_PLAYER_INIT_FLAG = 100,     --����Ƿ�������ֳ�ʼ��
    VAR_HUM_BITFLAG_RELIVE_DIALOGUE_FLAG = 101,     --����Ƿ�ǰ���и���򵯳�

    --���ߵ�int���� 1-50
    ITEM_INTVAR_ADDLUCK_LV = 1,                 --���ߵ�ף���ȼ�
    ITEM_INTVAR_RANDOMAB_NUM = 2,               --װ��ϴ�����Ե�����
    ITEM_INTVAR_RANDOMAB_CURR_SEQ = 3,          --װ��ϴ����ǰѡ��ĵڼ�������  δϴ��״̬  ��Ϊ��ʱ����
    ITEM_INTVAR_RANDOMAB_STATS = 4,             --װ��ϴ���ĵ�ǰ״̬ 0��ϴ�����Դ�ϴ��״̬  1��ϴ�������Դ�����״̬
    ITEM_INTVAR_ATTACK_SPEEDUP_INITGIFT = 6,    --װ���������ԡ���װ���츳����ġ�

    --���ߵ��ַ������� 1-20
    --ITEM_STRVAR_RANDOMAB_DATA = 1,                --װ��ϴ�����Ե����ݱ���
    ITEM_STRVAR_RANDOMAB_CREATE_SINGLEAB = 2,       --װ��ϴ�����ɵĵ�������

    --��ͼ��int���� 1-50
    MAP_INTVAR_RANDOMBOSS_TRIGGER_STARTTIME = 1,    --�������boss������ʱ��
    MAP_INTVAR_RANDOMBOSS_TRIGGER_ID = 2,           --�������boss�Ĵ���ID

    --��ͼ��string���� 1-50
    MAP_STRVAR_RANDOMBOSS_TRIGGER_NAME = 1,         --�������boss�������
    MAP_STRVAR_RANDOMBOSS_MONNAME = 2,              --�������boss�Ĺ�������
    MAP_STRVAR_RANDOMBOSS_MONUNIQUEID = 3,          --�������boss�Ĺ���ΨһID

    --�����¼�������
    EVENT_NAME_PLAYER_ENTERGAME = 'player_entergame',   --��ҽ�����Ϸ
    EVENT_NAME_PLAYER_LEAVEGAME = 'player_leavegame',   --����˳���Ϸ
    EVENT_NAME_PLAYER_ADDBAGITEM = 'player_addbag',     --��ҵ��߽�����
    EVENT_NAME_PLAYER_ENTERMAP = 'player_entermap',     --��ҽ����ͼ
    EVENT_NAME_PLAYER_LEAVEMAP = 'player_leavemap',     --����뿪��ͼ
    EVENT_NAME_PLAYER_DIE = 'player_die',               --�������
    EVENT_NAME_MON_KILLED = 'mon_killed',               --���ﱻ��ɱ
    EVENT_NAME_KILL_PLAYER = 'kill_player',             --��ɱ���
    EVENT_NAME_PLAYER_RESETDAY = 'player_resetday',     --��ҿ���
    EVENT_NAME_PLAYER_RESETWEEK = 'player_resetweek',   --��ҿ���
    EVENT_NAME_KILL_MON = 'kill_mon',                   --��ɱ����
    EVENT_NAME_CLICK_NPC = 'click_npc',                 --���NPC
    EVENT_NAME_CLICK_TASK = 'click_task',               --�������
    EVENT_NAME_DO_RECHARGE = 'do_recharge',             --��ֵ

    --��Ҷ�ʱ��ID
    TIMER_ID_MOFANGZHEN = 11,                   --ħ�����ͼ�Ķ�ʱ��
    TIMER_ID_CHECK_TOPICON_REDPOINT = 12,       --���topicon������ڵ�С���
    TIMER_ID_CHECK_QUICK_GOTO_TIP = 13,         --���npc���ܵĿ��ǰ����ʾ

    --����ģ����
    FUNC_ID_EQUIPPOS_STRENGTH = 1,              --װ��λǿ��
    FUNC_ID_EQUIPPOS_STAR = 2,                  --װ��λ����
    FUNC_ID_EQUIP_RANDOMAB = 3,                 --װ��ϴ��
    FUNC_ID_WEAPON_ADDLUCK = 4,                 --����ף��
    FUNC_ID_BAOZHU = 5,                         --����ϵͳ
    FUNC_ID_BAOZHU_BOSS = 6,                    --����BOSS
    FUNC_ID_SOUL_STONE = 7,                     --��ʯ
    FUNC_ID_GUANZHI = 8,                        --��ְ
    FUNC_ID_OFFLINE = 9,                        --����ϵͳ ��巵�
    FUNC_ID_MOFANGZHEN = 10,                    --ħ����
    FUNC_ID_RANDOMBOSS = 11,                    --���BOSS
    FUNC_ID_FREEVIP = 12,                       --���VIP
    FUNC_ID_GAMETASK = 13,                      --����ϵͳ
    FUNC_ID_TOPICON = 14,                       --���˹������
    FUNC_ID_FIRST_RECHARGE = 15,                --�׳�
    FUNC_ID_NEWPLAYER_RECHARGE = 16,            --���ֳ�ֵ����
    FUNC_ID_RECYCLE_MANAGER = 17,               --����ϵͳ
    FUNC_ID_OPEN_SERVER = 18,                   --�����
    FUNC_ID_PUBLIC_BOSS = 19,                   --Ұ������
    FUNC_ID_SINGLE_BOSS = 20,                   --��������
    FUNC_ID_EVERYDAY_TASK = 21,                 --ÿ�ձ���
    FUNC_ID_YUNBIAO = 22,                       --����
    FUNC_ID_TREASUREMAP = 23,                   --�ر�ͼ
    FUNC_ID_COMPOSE = 24,                       --�ϳ�ϵͳ
    FUNC_ID_EXTEND_GIFT = 25,                   --�������
    FUNC_ID_SUPERBOX = 26,                      --��������
    FUNC_ID_GMHELPER = 27,                      --GM����ϵͳ
    

    --���ǰ��
    QUICK_GOTO_UPGRADE_LEVEL = 1,               --����
    QUICK_GOTO_INCREASE_POWER = 2,              --��ս��
    QUICK_GOTO_KILL_RANDOMBOSS = 3,             --��ɱս��boss
    QUICK_GOTO_KILL_BAOZHUBOSS = 4,             --��ɱ���顾����boss
    QUICK_GOTO_ENTER_MOFANGZHEN = 5,            --����ħ����
    QUICK_GOTO_UPGRADE_EQUIPSTAR = 6,           --װ������
    QUICK_GOTO_EQUIP_STRENGTH = 7,              --װ��ǿ��
    QUICK_GOTO_EQUIP_QUALITY = 8,               --װ��Ʒ��
    QUICK_GOTO_EQUIP_RANDOMAB = 9,              --װ��ϴ��
    QUICK_GOTO_EQUIP_COMPOSE = 10,              --װ���ϳ�
    QUICK_GOTO_SOULSTONE = 11,                  --��ʯϵͳ
    QUICK_GOTO_BAOZHU = 12,                     --���顾����ϵͳ
    QUICK_GOTO_FREEVIP = 13,                    --���VIPϵͳ
    QUICK_GOTO_RECHARGE = 14,                   --��ֵ����
    QUICK_GOTO_SINGLEBOSS = 15,                 --��������
    QUICK_GOTO_PUBLICBOSS = 16,                 --Ұ������
    QUICK_GOTO_YUNBIAO = 17,                    --����
    QUICK_GOTO_TREASUREMAP = 18,                --�ر�ͼ
    QUICK_GOTO_GUANZHI = 19,                    --��ְ
    QUICK_GOTO_ZCD = 20,                        --��巵� ���߻���

    --�ű������Ķ�̬npcid    ���յ�npcid�� ϵͳ����*10000+��̬id
    DYN_NPC_ZCD_HUWEI1 = 101,                     --��巵��1
    DYN_NPC_ZCD_HUWEI2 = 102,                     --��巵��2
    DYN_NPC_ZCD_HUWEI3 = 103,                     --��巵��3
    DYN_NPC_ZCD_HUWEI4 = 104,                     --��巵��4
    DYN_NPC_ZCD_HUWEI5 = 105,                     --��巵��5

    --������ID
    TASK_LINE_ID_MAIN = 100,                      --�����ߣ���������
    TASK_LINE_ID_BRANCH = 201,                    --�����ߣ�֧������1

    --��������
    TASK_TYPE_KILLMON = 1,                        --ɱ������
    TASK_TYPE_FREEVIP = 2,                        --���VIP����

    --������״̬
    TASK_STATUS_NONE = 0,                         --��������
    TASK_STATUS_ADD = 1,                          --����ӣ�δ����
    TASK_STATUS_ACCEPT = 2,                       --�ѽ��ܣ�δ���
    TASK_STATUS_FINISH = 3,                       --����ɣ�δ�콱
    TASK_STATUS_END = 4,                          --���콱������    

    --addbutton �����Ӧ��buttonid
    ADD_BUTTON_ID_1 = 9001,                       --������������Ӧ��buttonid
    ADD_BUTTON_ID_2 = 9002,                       --GMHelper��buttonid
    ADD_BUTTON_ID_3 = 9003,                       --NPC��ŶԻ����buttonid
    ADD_BUTTON_ID_4 = 9004,                       --ͨ�ù��ܶԻ����buttonid
    ADD_BUTTON_ID_5 = 9005,                       --��������ĵ������� �������Զ����� ����
}

--װ��λ��Ӧ������
CommonDefine.EQUIPPOS_NAME = {
    [CommonDefine.EQUIPPOS_DRESS] = '�·�',
    [CommonDefine.EQUIPPOS_WEAPON] = '����',
    [CommonDefine.EQUIPPOS_MEDAL] = 'ѫ��',
    [CommonDefine.EQUIPPOS_NECKLACE] = '����',
    [CommonDefine.EQUIPPOS_HELMET] = 'ͷ��',
    [CommonDefine.EQUIPPOS_ARMRING_R] = '������',
    [CommonDefine.EQUIPPOS_ARMRING_L] = '������',
    [CommonDefine.EQUIPPOS_RING_R] = '�ҽ�ָ',
    [CommonDefine.EQUIPPOS_RING_L] = '���ָ',
    [CommonDefine.EQUIPPOS_BELT] = '����',
    [CommonDefine.EQUIPPOS_BOOTS] = 'Ь��',

    [CommonDefine.EQUIPPOS_SSH_1] = '����',
    [CommonDefine.EQUIPPOS_SSH_2] = 'ţ��',
    [CommonDefine.EQUIPPOS_SSH_3] = '����',
    [CommonDefine.EQUIPPOS_SSH_4] = '����',
    [CommonDefine.EQUIPPOS_SSH_5] = '����',
    [CommonDefine.EQUIPPOS_SSH_6] = '����',
    [CommonDefine.EQUIPPOS_SSH_7] = '����',
    [CommonDefine.EQUIPPOS_SSH_8] = '����',
    [CommonDefine.EQUIPPOS_SSH_9] = '����',
    [CommonDefine.EQUIPPOS_SSH_10] = '����',
    [CommonDefine.EQUIPPOS_SSH_11] = '����',
    [CommonDefine.EQUIPPOS_SSH_12] = '����',

}

--�Զ���İٷֱȼӳ����� ��Ӧ�Ļ�������ID
CommonDefine.ADD_PERCENT_ABILITY_PAIR = {
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_DC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_DC, CommonDefine.ABILITYID_MAX_DC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_MC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_MC, CommonDefine.ABILITYID_MAX_MC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_SC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_SC, CommonDefine.ABILITYID_MAX_SC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_AC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_AC, CommonDefine.ABILITYID_MAX_AC},
    [CommonDefine.ABILITYID_CUS_EQUIPPOS_MAC_ADDPERCENT] = {CommonDefine.ABILITYID_MIN_MAC, CommonDefine.ABILITYID_MAX_MAC},
}

--װ��λ�ٷֱ���������ֵ��Ӧ����������  ʮ��װ��λ�ֿ�
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

--���ϴ����Ӧ������
CommonDefine.EQUIP_RANDOMAB_GOLD_NEEDITEMS = {
    {name='���', num=10000},
}       

--���ߵ�Ʒ����ɫ
CommonDefine.ITEM_QUALITY_COLORNAME = {
    [CommonDefine.ITEM_QUALITY_WHITE+1]     = '��ɫ',
    [CommonDefine.ITEM_QUALITY_GREEN+1]     = '��ɫ',
    [CommonDefine.ITEM_QUALITY_BLUE+1]      = '��ɫ',
    [CommonDefine.ITEM_QUALITY_PURPLE+1]    = '��ɫ',
    [CommonDefine.ITEM_QUALITY_PINK+1]      = '��ɫ',
    [CommonDefine.ITEM_QUALITY_GOLD+1]      = '��ɫ',
    [CommonDefine.ITEM_QUALITY_RED+1]       = '��ɫ',
}

--Ԫ��ϴ����Ӧ������
CommonDefine.EQUIP_RANDOMAB_YB_NEEDITEMS = {
    {name='Ԫ��', num=100},
}

--CheckBoxѡ����Ӧ����
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
}

--��ҵĻ���װ��λ  ��Ӧǿ�������ǣ���ͨ����
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