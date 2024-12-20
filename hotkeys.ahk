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


; SEARCH ENGINE
; # Navigation
; Ctrl + L           : Focus address bar
; Alt + D            : Focus address bar (alternative)
; Ctrl + K          : Focus search bar
; F6                : Toggle focus between address bar and page content

; # Tab Management
; Ctrl + T          : New tab
; Ctrl + N          : New window
; Ctrl + Shift + N  : New incognito window
; Ctrl + W          : Close current tab
; Ctrl + Shift + T  : Reopen last closed tab
; Ctrl + Tab        : Switch to next tab
; Ctrl + Shift + Tab: Switch to previous tab
; Ctrl + [1-8]      : Switch to specific tab (1-8)
; Ctrl + 9          : Switch to last tab


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
1:: SendInput("#{Left}")
; Move window to right
2:: SendInput("#{Right}")

; Move Window to left monitor
3:: SendInput("#+{Left}")
; Move Window to right monitor
4:: SendInput("#+{Right}")

; Go to previous virtual desktop
5:: SendInput("#^{Left}")
; Go to next virtual desktop
6:: SendInput("#^{Right}")

; Maximize Window
7:: SendInput("#{Up}")
; Minimize Window
8:: SendInput("#{Down}")

!F4:: SendInput("!F4")

; Cursor commands
!^f:: SendInput("^!{Down}") ; Add cursor below 
!^d:: SendInput("^!{Up}") ; Add cursor above
; Esc ; Cancel Multiple curosrs

; # Basic Cursor Commands
; Ctrl + Alt + Up/Down    : Add cursor above/below
; Ctrl + D                : Select next occurrence of current selection
; Ctrl + Shift + L        : Select all occurrences of current selection
; Alt + Shift + I         : Insert cursor at end of each selected line
; Esc                     : Cancel multiple cursors, return to single cursor



#HotIf

; STANDALONE HOTKEYS
!BS:: SendInput("{Home}+{End}{Delete}")  ; Delete entire line
vkFF & BS:: SendInput("{Delete}") ; Delete Key
!^e:: SendInput("{End}")  ; Cntrl+Alt+E to end of line
Up:: return  ; Disable up arrow
Down:: return  ; Disable down arrow
Left:: return  ; Disable left arrow
Right:: return  ; Disable right arrow
!^f:: SendInput("{Down}")
!^d:: SendInput("{Up}")
!^s:: SendInput("{Right}")
!^a:: SendInput("{Left}")


test 
