; Keyboard bug: fix with fn w

; Get hotkeys.ahk on startup: windows + R -> startup:shell -> copy shortcut (alt + clickdrag)

; In code editor hotkeys
; auto-format: shift + alt + f
; next-tab: cntrl + tab 

#Requires AutoHotkey v2.0
#SingleInstance
#Warn All, Off  ; Disables all warnings
A_HotkeyInterval := 99999999  ; Makes the interval very long
A_MaxHotkeysPerInterval := 99999999  ; Effectively disables the warning

; Initialize toggle state
isEnabled := false

; Toggle hotkey (Ctrl+Shift+F)
^+f:: {
    global isEnabled := !isEnabled
    if isEnabled {
        ; Block letter keys
        loop 26 {
            key := Chr(A_Index + 96)  ; Convert to lowercase letters
            if key != "a" && key != "s" && key != "d" && key != "f" && key != "q" && key != "e" {
                Hotkey key, DoNothing, "On"
            }
        }

        ; Block number keys
        loop 10 {
            Hotkey A_Index - 1, DoNothing, "On"
        }

        ; Enable our navigation hotkeys
        Hotkey "d", SendUp, "On"
        Hotkey "f", SendDown, "On"
        Hotkey "a", SendLeft, "On"
        Hotkey "s", SendRight, "On"

        ; Selection
        Hotkey "+d", SendShiftUp, "On"
        Hotkey "+f", SendShiftDown, "On"
        Hotkey "+a", SendShiftLeft, "On"
        Hotkey "+s", SendShiftRight, "On"

        ; Word selection (changed Ctrl+Shift+S to explicit hotkey)
        Hotkey "^a", SendCtrlShiftLeft, "On"
        ; Remove the normal Ctrl+S binding and handle Ctrl+Shift+S separately

        ; Line navigation
        Hotkey "q", SendHome, "On"
        Hotkey "e", SendEnd, "On"
        Hotkey "+q", SendShiftHome, "On"
        Hotkey "+e", SendShiftEnd, "On"

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

        ; Turn off navigation hotkeys
        try {
            Hotkey "f", "Off"
            Hotkey "s", "Off"
            Hotkey "d", "Off"
            Hotkey "f", "Off"
            Hotkey "+a", "Off"
            Hotkey "+s", "Off"
            Hotkey "+d", "Off"
            Hotkey "+f", "Off"
            Hotkey "^a", "Off"
            Hotkey "q", "Off"
            Hotkey "e", "Off"
            Hotkey "+q", "Off"
            Hotkey "+e", "Off"
        }

    }
}

DoNothing(*) {
    return
}

; Movement functions
SendUp(*) => SendInput("{Up}")
SendDown(*) => SendInput("{Down}")
SendLeft(*) => SendInput("{Left}")
SendRight(*) => SendInput("{Right}")
SendHome(*) => SendInput("{Home}")
SendEnd(*) => SendInput("{End}")

; Selection functions
SendShiftUp(*) => SendInput("+{Up}")
SendShiftDown(*) => SendInput("+{Down}")
SendShiftLeft(*) => SendInput("+{Left}")
SendShiftRight(*) => SendInput("+{Right}")
SendShiftHome(*) => SendInput("+{Home}")
SendShiftEnd(*) => SendInput("+{End}")

; Word selection functions
SendCtrlShiftLeft(*) => SendInput("^+{Left}")

; Essential shortcuts that need to work in WASD mode
#HotIf isEnabled
^c:: SendInput("^c")  ; Copy
^v:: SendInput("^v")  ; Paste
^x:: SendInput("^x")  ; Cut
^z:: SendInput("^z")  ; Undo
^y:: SendInput("^y")  ; Redo
^+a:: SendInput("^+{Left}")  ; Ctrl+Shift+S for select left word
^+s:: SendInput("^+{Right}")  ; Ctrl+Shift+S for select right word
BS:: SendInput("{BackSpace}")  ; Allow Backspace key to work
^f:: SendInput("{PgDn}")  ; Ctrl+F for Page Down
^d:: SendInput("{PgUp}")  ; Ctrl+D for Page Up

#HotIf

; Standalone permanent hotkeys

+BS:: SendInput("{Home}+{End}{Delete}")  ; Delete entire line
!e:: SendInput("{End}")  ; Alt+E to end of line
Up:: return  ; Disable up arrow
Down:: return  ; Disable down arrow
Left:: return  ; Disable left arrow
Right:: return  ; Disable right arrow
