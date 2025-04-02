--任务线配置
TaskLineConfig = {
    [CommonDefine.TASK_LINE_ID_MAIN] = {
        taskIDVar = CommonDefine.VAR_U_ID_TASKLINE1,
        taskStatusVar = CommonDefine.VAR_U_STATUS_TASKLINE1,
        taskCounterVar = CommonDefine.VAR_T_COUNTERDATA_TASKLINE1,
        taskSingleCounterVar = CommonDefine.VAR_U_COUNTER_TASKLINE1,
        firstTaskID = 101,
        taskDataList = { 
            [101] = {
                nextid = 102, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 10,
                tasktargdesc = '等级达到10级',
                reward_tab = {{name='开箱次数', num=10},{name='金币', num=100000}},
            },
            [102] = {
                nextid = 103, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 10,
                tasktargdesc = '累计开箱10次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=200000}},
            }, 
            [103] = {
                nextid = 104, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 20000,
                tasktargdesc = '战力达到2万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=300000}},
            },
            [104] = {
                nextid = 105, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 20,
                tasktargdesc = '等级达到20级',
                reward_tab = {{name='开箱次数', num=20},{name='金币', num=400000}},

            },
            [105] = {
                nextid = 106, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 20,
                tasktargdesc = '累计开箱20次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=500000}},

            },
            [106] = {
                nextid = 107, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 40000,
                tasktargdesc = '战力达到4万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=600000}},

            },         
           
            [107] = {
                nextid = 108, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 30,
                tasktargdesc = '等级达到30级',
                reward_tab = {{name='开箱次数', num=30},{name='金币', num=700000}},

            },
            [108] = {
                nextid = 109, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 30,
                tasktargdesc = '累计开箱30次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=800000}},

            },
            [109] = {
                nextid = 110, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 50000,
                tasktargdesc = '战力达到5万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=900000}},

            },            
   
            [110] = {
                nextid = 111, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 40,
                tasktargdesc = '等级达到40级',
                reward_tab = {{name='开箱次数', num=40},{name='金币', num=1000000}},

            },
            [111] = {
                nextid = 112, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 40,
                tasktargdesc = '累计开箱40次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [112] = {
                nextid = 113, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 70000,
                tasktargdesc = '战力达到7万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [113] = {
                nextid = 114, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 50,
                tasktargdesc = '等级达到50级',
                reward_tab = {{name='开箱次数', num=50},{name='金币', num=1000000}},

            },
            [114] = {
                nextid = 115, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 50,
                tasktargdesc = '累计开箱50次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [115] = {
                nextid = 116, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 100000,
                tasktargdesc = '战力达到10万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [116] = {
                nextid = 117, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 60,
                tasktargdesc = '等级达到60级',
                reward_tab = {{name='开箱次数', num=60},{name='金币', num=1000000}},

            },
            [117] = {
                nextid = 118, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 60,
                tasktargdesc = '累计开箱60次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [118] = {
                nextid = 119, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 150000,
                tasktargdesc = '战力达到15万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [119] = {
                nextid = 120, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 70,
                tasktargdesc = '等级达到70级',
                reward_tab = {{name='开箱次数', num=70},{name='金币', num=1000000}},

            },
            [120] = {
                nextid = 121, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 70,
                tasktargdesc = '累计开箱70次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [121] = {
                nextid = 122, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 200000,
                tasktargdesc = '战力达到20万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [122] = {
                nextid = 123, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 80,
                tasktargdesc = '等级达到80级',
                reward_tab = {{name='开箱次数', num=80},{name='金币', num=1000000}},

            },
            [123] = {
                nextid = 124, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 80,
                tasktargdesc = '累计开箱80次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [124] = {
                nextid = 125, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 300000,
                tasktargdesc = '战力达到30万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [125] = {
                nextid = 126, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 85,
                tasktargdesc = '等级达到85级',
                reward_tab = {{name='开箱次数', num=90},{name='金币', num=1000000}},

            },
            [126] = {
                nextid = 127, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 90,
                tasktargdesc = '累计开箱90次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [127] = {
                nextid = 128, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 500000,
                tasktargdesc = '战力达到50万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [128] = {
                nextid = 129, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 90,
                tasktargdesc = '等级达到90级',
                reward_tab = {{name='开箱次数', num=100},{name='金币', num=1000000}},

            },
            [129] = {
                nextid = 130, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 100,
                tasktargdesc = '累计开箱100次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [130] = {
                nextid = 131, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 1000000,
                tasktargdesc = '战力达到100万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [131] = {
                nextid = 132, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 95,
                tasktargdesc = '等级达到95级',
                reward_tab = {{name='开箱次数', num=110},{name='金币', num=1000000}},

            },
            [132] = {
                nextid = 133, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 110,
                tasktargdesc = '累计开箱110次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [133] = {
                nextid = 134, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 2000000,
                tasktargdesc = '战力达到200万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [134] = {
                nextid = 135, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 100,
                tasktargdesc = '等级达到100级',
                reward_tab = {{name='开箱次数', num=120},{name='金币', num=1000000}},

            },
            [135] = {
                nextid = 136, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 120,
                tasktargdesc = '累计开箱120次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [136] = {
                nextid = 137, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 3000000,
                tasktargdesc = '战力达到300万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [137] = {
                nextid = 138, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 105,
                tasktargdesc = '等级达到105级',
                reward_tab = {{name='开箱次数', num=120},{name='金币', num=1000000}},

            },
            [138] = {
                nextid = 139, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 150,
                tasktargdesc = '累计开箱150次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [139] = {
                nextid = 140, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 4000000,
                tasktargdesc = '战力达到400万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [140] = {
                nextid = 141, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 110,
                tasktargdesc = '等级达到110级',
                reward_tab = {{name='开箱次数', num=130},{name='金币', num=1000000}},

            },
            [141] = {
                nextid = 142, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 170,
                tasktargdesc = '累计开箱170次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [142] = {
                nextid = 143, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 5000000,
                tasktargdesc = '战力达到500万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [143] = {
                nextid = 144, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 115,
                tasktargdesc = '等级达到115级',
                reward_tab = {{name='开箱次数', num=140},{name='金币', num=1000000}},

            },
            [144] = {
                nextid = 145, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 190,
                tasktargdesc = '累计开箱190次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [145] = {
                nextid = 146, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 6000000,
                tasktargdesc = '战力达到600万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [146] = {
                nextid = 147, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 120,
                tasktargdesc = '等级达到120级',
                reward_tab = {{name='开箱次数', num=150},{name='金币', num=1000000}},

            },
            [147] = {
                nextid = 148, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 220,
                tasktargdesc = '累计开箱220次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [148] = {
                nextid = 149, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 7000000,
                tasktargdesc = '战力达到700万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [149] = {
                nextid = 150, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 125,
                tasktargdesc = '等级达到125级',
                reward_tab = {{name='开箱次数', num=160},{name='金币', num=1000000}},

            },
            [150] = {
                nextid = 151, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 250,
                tasktargdesc = '累计开箱250次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [151] = {
                nextid = 152, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 9000000,
                tasktargdesc = '战力达到900万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            

            [152] = {
                nextid = 153, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
               acceptdialogue = '在对应等级地图挂机是快速成长的捷径！',
                submitdialogue = '付出才会得到回报，这是个真理！',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 130,
                tasktargdesc = '等级达到130级',
                reward_tab = {{name='开箱次数', num=170},{name='金币', num=1000000}},

            },
            [153] = {
                nextid = 154, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '只管开箱，剩下的交给运气！',
                submitdialogue = '开到自己心仪的装备了吗？',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 300,
                tasktargdesc = '累计开箱300次',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },
            [154] = {
                nextid = 0, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                 acceptdialogue = '每一次战力的提升都会让你更加自信！',
                submitdialogue = '你现在真的强的可怕！',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 12000000,
                tasktargdesc = '战力达到1200万',
                reward_tab = {{name='强化石', num=200},{name='金币', num=1000000}},

            },            



        }
    }
}

return TaskLineConfig