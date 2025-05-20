@echo off
Echo ============== Copy ScriptConfig To Client =================
xcopy /y E:\Work996Git\work996-game-shenwang\DevVersion_Client\dev\scripts\*.*  E:\Game996_ShenWang\MirClientDebug\dev\scripts\ /I /E
xcopy /y E:\Work996Git\work996-game-shenwang\DevVersion_Client\dev\GUILayout\*.*  E:\Game996_ShenWang\MirClientDebug\dev\GUILayout\ /I /E

Echo ====== Finish=======

