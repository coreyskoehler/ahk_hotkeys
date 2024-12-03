#Requires AutoHotkey v2.0
#SingleInstance

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

        ; Block special keys
        special_keys := [
            "Space", "Tab", "Enter", "BS", "Del"
            "Insert", "Home", "End", "PgUp", "PgDn",
            "F1", "F2", "F3", "F4", "F5", "F6",
            "F7", "F8", "F9", "F10", "F11", "F12",
            "[", "]", ";", "'", ",", ".", "/", "\",
            "-", "="
        ]

        for key in special_keys {
            Hotkey key, DoNothing, "On"
        }

        ; Enable our navigation hotkeys
        Hotkey "f", SendUp, "On"
        Hotkey "d", SendDown, "On"
        Hotkey "a", SendLeft, "On"
        Hotkey "s", SendRight, "On"

        ; Selection
        Hotkey "+f", SendShiftUp, "On"
        Hotkey "+d", SendShiftDown, "On"
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


        ToolTip "Navigation Mode: ON"
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

        ; Unblock special keys (removed Del)
        special_keys := [
            "Space", "Tab", "Enter", "BS", "Del"
            "Insert", "Home", "End", "PgUp", "PgDn",
            "F1", "F2", "F3", "F4", "F5", "F6",
            "F7", "F8", "F9", "F10", "F11", "F12",
            "[", "]", ";", "'", ",", ".", "/", "\",
            "-", "="
        ]

        for key in special_keys {
            try Hotkey key, "Off"
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

        ToolTip "Navigation Mode: OFF"
    }
    SetTimer () => ToolTip(), -1000
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
SendCtrlShiftRight(*) => SendInput("^+{Right}")

; Essential shortcuts that need to work in WASD mode
#HotIf isEnabled
^c:: SendInput("^c")  ; Copy
^v:: SendInput("^v")  ; Paste
^x:: SendInput("^x")  ; Cut
^z:: SendInput("^z")  ; Undo
^y:: SendInput("^y")  ; Redo
^+s:: SendInput("^+{Right}")  ; Handle Ctrl+Shift+S explicitly here to override AMD hotkey
#HotIf