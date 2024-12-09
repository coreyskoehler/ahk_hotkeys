#Requires AutoHotkey v2.0

; Keyboard bug: fix with fn+w

; Get hotkeys.ahk on startup: windows + R -> startup:shell -> copy shortcut (alt + clickdrag)

; EXISTING HOTKEYS
; auto-format: shift + alt + f
; next-tab: cntrl + tab
; previous-ftab: shift + cntrl + tab
; search for application: windows + s

; VSCODE
; cntrl + shift + e = open explorer
; cntrl + b = toggle explorer 

#Requires AutoHotkey v2.0
#SingleInstance
#Warn All, Off  ; Disables all warnings
A_HotkeyInterval := 99999999  ; Makes the interval very long
A_MaxHotkeysPerInterval := 99999999  ; Effectively disables the warning

; HOTKEY MAP

; Initialize toggle state
isEnabled := false

; Toggle hotkey (Ctrl+Shift+F)
^+f:: {
    global isEnabled := !isEnabled
    if isEnabled {
        ; Block letter keys
        loop 26 {
            key := Chr(A_Index + 96)  ; Convert to lowercase letters
            Hotkey key, DoNothing, "On"
        }
        ; Block number keys
        loop 10 {
            Hotkey A_Index - 1, DoNothing, "On"
        }
    } else {
        ; Unblock letter keys
        loop 26 {
            key := Chr(A_Index + 96)
            try Hotkey key, "Off"
        }
        ; Unblock number keys
        loop 10 {
            try Hotkey A_Index - 1, "Off"
        }
    }

}

DoNothing(*) {
    return
}

; SIMPLE REMAPS
#HotIf isEnabled
; Navigation
d:: SendInput("{Up}")
f:: SendInput("{Down}")
a:: SendInput("{Left}")
s:: SendInput("{Right}")
^f:: SendInput("{PgDn}")
^d:: SendInput("{PgUp}")

; Line navigation
q:: SendInput("{Home}")
e:: SendInput("{End}")
+q:: SendInput("+{Home}")
+e:: SendInput("+{End}")

; Selection
+d:: SendInput("+{Up}")
+f:: SendInput("+{Down}")
+a:: SendInput("+{Left}")
+s:: SendInput("+{Right}")

; Word Selection
^+a:: SendInput("^+{Left}")
^+s:: SendInput("^+{Right}")

; Basic commands
^c:: SendInput("^c")  ; Copy
^v:: SendInput("^v")  ; Paste
^x:: SendInput("^x")  ; Cut
^z:: SendInput("^z")  ; Undo
^y:: SendInput("^y")  ; Redo
BS:: SendInput("{BackSpace}")

; Move window to left
1:: {
    if isEnabled {
        Send "#{Left}"
    }
}
; Move window to right
2:: {
    if isEnabled {
        Send "#{Right}"
    }
}
; Move Window to left monitor
3:: {
    if isEnabled {
        Send "#+{Left}"
    }
}
; Move Window to right monitor
4:: {
    if isEnabled {
        Send "#+{Right}"
    }
}

; Go to previous virtual desktop
5:: {
    if isEnabled {
        Send "#^{Left}"
    }
}

; Go to next virtual desktop
6:: {
    if isEnabled {
        Send "#^{Right}"
    }
}

; Maximize Window
7:: {
    if isEnabled {
        Send "#{Up}"
    }
}

; Minimize Window
8:: {
    if isEnabled {
        Send "#{Down}"
    }
}
#HotIf

; STANDALONE HOTKEYS
!^BS:: SendInput("{Home}+{End}{Delete}")  ; Delete entire line
!BS:: SendInput("{Delete}") ; Delete Key
!^e:: SendInput("{End}")  ; Cntrl+Alt+E to end of line
Up:: return  ; Disable up arrow
Down:: return  ; Disable down arrow
Left:: return  ; Disable left arrow
Right:: return  ; Disable right arrow
!^f:: SendInput("{Down}")
!^d:: SendInput("{Up}")
!^s:: SendInput("{Right}")
!^a:: SendInput("{Left}")

!`:: {  ; Alt+`: Focus previous window of same type
    class := WinGetClass("A")
    exe := WinGetProcessName("A")
    WinActivate("ahk_class " class " ahk_exe " exe)
}

!+`:: {  ; Alt+Shift+`: Focus next window of same type
    class := WinGetClass("A")
    exe := WinGetProcessName("A")
    if WinExist("ahk_class " class " ahk_exe " exe)
        WinActivateBottom
}
