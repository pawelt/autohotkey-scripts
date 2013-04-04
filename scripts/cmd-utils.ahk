;; ========================================================================================================
;; Bindings
;; ========================================================================================================

^`::cmd_prompt_here(CMD_EXE, "cmd-user")
!`::cmd_prompt_here(CMD_EXE_ADMIN, "cmd-admin")
^+`::cmd_prompt_here(CMD_GIT_BASH, "cmd-git")

#IfWinActive ahk_class ConsoleWindowClass
    ^+V::SendInput {Raw}%clipboard%
    return
#IfWinActive

;; ========================================================================================================
;; Functions
;; ========================================================================================================

; requires "Folder Options" -> "Display the full path in the title bar" to be set
cmd_prompt_here(cmd_path, win_title)
{
    WinGet, HWND, ID, A
    WinGetClass, win_class, ahk_id %HWND%

    if (win_class ~= "CabinetWClass")
        WinGetTitle, path, ahk_id %HWND%
    else if (win_is_desktop(HWND))
        path = %A_Desktop%
    else
        path = C:\

    SetWorkingDir %path%
    Run %cmd_path% /K cd /d `"%path%"`
    WinWait %win_title%
    WinActivate
}
