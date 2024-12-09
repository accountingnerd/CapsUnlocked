;=======================================================================================================================
; CAPS-UNLOCKED
;=======================================================================================================================
; This is a complete solution to map the CapsLock key to Control and Escape without losing the ability to toggle CapsLock
;
;  * Use CapsLock as Escape if it's the only key that is pressed and released within 300ms (configurable)
;  * Use CapsLock as LControl when used in conjunction with some other key or if it's held longer than 300ms
;  * Toggle CapsLock by pressing LControl+CapsLock

InstallKeybdHook
#Requires AutoHotkey >=2

SetCapsLockState "AlwaysOff"


*Capslock::{
    StartTime := 0

    ; Toggle Caps Lock by pressing Left Control and CapsLock
    if (GetKeyState("LControl", "P")) {
        KeyWait "CapsLock"
        SetCapsLockState !GetKeyState("CapsLock", "T")
        return
    }

    Send "{LControl Down}"
    State := (GetKeyState("Alt", "P") || GetKeyState("Shift", "P") || GetKeyState("LWin", "P") ||GetKeyState("RWin", "P"))
    if ( !State && (StartTime = 0)) {
        StartTime := A_TickCount
    }

    KeyWait "CapsLock"
    Send "{LControl Up}"
    condEscape := IniRead("%A_ScriptDir%\Settings.ini", "CapsUnlocked", "TapEscape", 1)
    if ( State || !condEscape) {
        return
    }

    elapsedTime := A_TickCount - StartTime
    timeout := IniRead("%A_ScriptDir%\Settings.ini", "CapsUnlocked", "Timeout", 300)
    if ( (A_PriorKey = "CapsLock") &&  (elapsedTime < timeout)) {
        Send "{Esc}"
    } 

    return
}
