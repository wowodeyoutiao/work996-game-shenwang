OpenSuperBoxManager = {}

--Íæ¼ÒµÇÂ¼Ê±´¥·¢
function OpenSuperBoxManager.OnPlayerEnterGame(actor)
    release_print('OpenSuperBoxManager.OnLogin')
end

GameEventManager.AddListener(CommonDefine.EVENT_NAME_PLAYER_ENTERGAME, OpenSuperBoxManager.OnPlayerEnterGame, CommonDefine.FUNC_ID_FREEVIP)

return OpenSuperBoxManager