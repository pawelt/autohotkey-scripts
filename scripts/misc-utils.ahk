;; ========================================================================================================
;; Bindings
;; ========================================================================================================

F8::open_in_text_editor(CMD_TEXT_EDITOR)

; SysInternals task manager
^#Delete::Run %CMD_TASK_MANAGER%

; EasyRefresh: run on save action in a Netbeans
#IfWinActive ahk_class SunAwtFrame
    $^s::
        easy_refresh("EasyRefresh", "F5")
        Send ^s ; forward ctrl+s so it still saves the file being edited
        return
    return
#IfWinActive

; EasyRefresh: global shortcut
$^+F12::easy_refresh("EasyRefresh", "F5")

; Web player controls
$Media_Play_Pause::web_media_player_control("YouTube|Grooveshark", "Media_Play_Pause")
$Media_Stop::web_media_player_control("YouTube|Grooveshark", "Media_Stop")
$Media_Prev::web_media_player_control("YouTube|Grooveshark", "Media_Prev")
$Media_Next::web_media_player_control("YouTube|Grooveshark", "Media_Next")

; send monitor to sleep when locking windows
; $#l::
;     Send #l
;     Sleep 1000
;     SendMessage 0x112, 0xF170, 2,, Program Manager
; return


;; ========================================================================================================
;; Functions
;; ========================================================================================================

; Copy selected file names to clipboard
; and open those files in a text editor
open_in_text_editor(editor_exec)
{
    WinGet, HWND, ID, A
	WinGetClass, win_class, ahk_id %HWND%

	if (win_class ~= "CabinetWClass")
        WinGetTitle, path, ahk_id %HWND%
	else if (win_is_desktop(HWND))
        path = %A_Desktop%
    else
        return

    Clipboard =
    Send, ^c
    ClipWait, 2
    Sort, Clipboard
    ; MsgBox 64, Copied to clipboard: , %Clipboard%

    file_paths := ""
    Loop parse, Clipboard, `n, `r
    {
        ; SplitPath A_LoopField, file_name
        ; MsgBox, 16, Error, %file_name%

        FileGetAttrib attr, %A_LoopField%
        IfNotInString, attr, D
        {
            file_paths =  %file_paths% "%A_LoopField%"
        }
    }
    
    If (file_paths == "") 
        return

    ; MsgBox, 16, Will run this: , %editor_exec% %file_paths%
    Run %editor_exec% %file_paths%
}

easy_refresh(win_title, key)
{
    WinGet, id, list, %win_title%
    Loop, %id%
    {
        this_id := id%A_Index%
        WinGetTitle, this_title, ahk_id %this_id%
        ;MsgBox, 4, okej, %this_title%

        ControlSend,, {%key%}, ahk_id %this_id%
    }
}

; For Grooveshark:
;       $('html').off('keyup.player');
;       $('html').on('keyup.player', function (event) { event.keyCode == 179 && $('#play-pause').click(); event.keyCode == 177 && $('#play-prev').click(); event.keyCode == 176 && $('#play-next').click(); });
web_media_player_control(win_title, key)
{
    ; win_hwnd := WinExist(win_title)
    ; WinGetTitle, win_title, ahk_id %win_hwnd%
    ; MsgBox 64, okej, %win_title%

    Send, {%key%}
    
    Loop, parse, win_title, `|
    {
        ; MsgBox Title %A_Index% is %A_LoopField%
        IfWinNotActive, %A_LoopField%
        {
            ; sometimes it's 1 at the end, sometimes it's 2, so...
            ControlSend, Chrome_RenderWidgetHostHWND1, {%key%}, %A_LoopField%
            ControlSend, Chrome_RenderWidgetHostHWND2, {%key%}, %A_LoopField%
            ; MsgBox 64, okej, %A_LoopField%
        }
    }   
}
