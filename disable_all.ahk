#Requires AutoHotkey v2.0

#SingleInstance
DetectHiddenWindows true

scripts := WinGetList("ahk_class AutoHotkey")
for hwnd in scripts {
    if hwnd != A_ScriptHwnd  ; Don't suspend this script itself
        PostMessage 0x111, 65305, 1,, hwnd  ; Suspend command with 1 to enable suspension
}

MsgBox "All AutoHotkey scripts have been suspended!`nRun them again to re-enable."

ExitApp