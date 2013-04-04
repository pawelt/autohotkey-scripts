;; ========================================================================================================
;; Paths
;; ========================================================================================================

CMD_EXE             = %A_ScriptDir%\cmd-user.lnk
CMD_GIT_BASH        = %A_ScriptDir%\cmd-git.lnk
CMD_EXE_ADMIN       = %A_ScriptDir%\cmd-admin.lnk

CMD_TEXT_EDITOR     = D:\pawel\Dropbox\Programs\SublimeText\sublime_text.exe
CMD_TASK_MANAGER    = D:\pawel\Dropbox\Programs\ProcExpl\procexp.exe

;; ========================================================================================================
;; AHK Settings
;; ========================================================================================================

SetWinDelay, 10         ; for smoother windows resizing
SetTitleMatchMode, 2    ; match title substring
CoordMode, Mouse

;; ========================================================================================================
;; Functions
;; ========================================================================================================

is_equal(a, b, delta = 10)
{
    return Abs(a - b) <= delta
}

win_is_desktop(HWND)
{
	WinGetClass, win_class, ahk_id %HWND%
	return (win_class ~= "WorkerW"                  ; desktop window class could be WorkerW or Progman
         or win_class ~= "Progman"
         or win_class ~= "SideBar_HTMLHostWindow")  ; sidebar widgets
}
