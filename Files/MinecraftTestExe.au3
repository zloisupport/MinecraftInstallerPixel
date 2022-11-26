#pragma compile(Out, Minecraft.exe)
; Uncomment to use the following icon. Make sure the file path is correct and matches the installation of your AutoIt install path.
#pragma compile(Icon, MinecraftUninsIcon.ico)
#pragma compile(ExecLevel, user)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Minecraft - a description of the application)
#pragma compile(ProductName, Minecraft)
#pragma compile(ProductVersion, 3.7)
#pragma compile(FileVersion, 3.7.0.0, 3.7.100.201) ; The last parameter is optional.
#pragma compile(LegalCopyright, © Mojang)
#pragma compile(LegalTrademarks, '"Trademark something, and some text in "quotes" etc...')
#pragma compile(CompanyName, '© Mojang')
#NoTrayIcon

#include <GUIConstantsEx.au3>
HotKeySet("{ESC}","ExitApp")
HotKeySet("{ENTER}","ExitApp")
FileInstall("MinecraftUninsIcon.ico", @TempDir & "\MinecraftUninsIcon.ico")
Local $iFileExists =FileExists(@TempDir & "\MinecraftUninsIcon.ico")

Example()

Func ExitApp()
	IF $iFileExists  Then 
		FileDelete(@TempDir & "\MinecraftUninsIcon.ico")
	EndIf
	Exit
EndFunc  

Func Example()
    ; Create a GUI with various controls.
    Local $hGUI = GUICreate("Minecraft",121, 177, 192, 164)
    Local $idOK = GUICtrlCreateButton("EXIT",  24, 149, 75, 25)
	Beep(290, 10)
    Local $con1 = GUICtrlCreateIcon(@TempDir & "\MinecraftUninsIcon.ico", -1, -8, 0, 128, 128)
	Local $lblMessage = GUICtrlCreateLabel('Press "ENTER" or "ESC" to EXIT',  10, 120, 120,26)
    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $idOK
                ExitLoop

        EndSwitch
    WEnd
6
    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)
	ExitApp()
EndFunc   ;==>Example
