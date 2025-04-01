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
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 10,
                tasktargdesc = '达到等级10级',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            },
            [102] = {
                nextid = 103, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 60000,
                tasktargdesc = '战力达到60000',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            }, 
            [103] = {
                nextid = 104, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 5,
                tasktargdesc = '新开启5个宝箱',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            },
            [104] = {
                nextid = 105, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_LEVEL,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 20,
                tasktargdesc = '达到等级20级',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            },
            [105] = {
                nextid = 106, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_POWERSCORE,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 70000,
                tasktargdesc = '战力达到70000',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            },
            [106] = {
                nextid = 0, 
                acceptnpcid = 0,      --'接任务NPC',
                submitnpcid = 0,      --'交任务NPC',
                autoaccept=1, 
                autosubmit=1,
                acceptdialogue = '看起来你又成长了！',
                submitdialogue = '常来我这里你会收获更多。',
                tasktype = CommonDefine.TASK_TYPE_OPENBOXNUM,
                --一个子任务最多支持三个目标，扩展另开发
                tasktargparam = 10,
                tasktargdesc = '新开启10个宝箱',
                reward_tab = {{name='经验', num=20000},{name='金币', num=50000}},
            },            
        }
    }
}

return TaskLineConfig