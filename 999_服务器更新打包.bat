@echo off
Echo ============== Clear Old Data =================
rd /s /q "E:\TargetVersion996\DirServer\MirServer\Mir200\" 

Echo ============== Copy ScriptConfig To Server =================
xcopy /y .\DevVersion_Server\Envir\Data\*.*  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\Data\ /I /E
xcopy /y .\DevVersion_Server\Envir\MapQuest_Def\*.*  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\MapQuest_Def\ /I /E
xcopy /y .\DevVersion_Server\Envir\Market_Def\*.*  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\Market_Def\ /I /E
xcopy /y .\DevVersion_Server\Envir\MonItems\*.*  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\MonItems\ /I /E
xcopy /y .\DevVersion_Server\Envir\QuestDiary\*.*  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\QuestDiary\ /I /E
xcopy /y .\DevVersion_Server\Envir\MapInfo.txt  E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\ /I /E

rd "E:\TargetVersion996\DirServer\MirServer\Mir200\Envir\.vscode\" /s /q
Echo ====== Finish=======