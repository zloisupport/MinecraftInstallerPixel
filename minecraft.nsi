!system '>blank set/p=MSCF<nul'
!packhdr temp.dat 'cmd /c Copy /b temp.dat /b +blank&&del blank'

Var MSG    ; The MSG variable must be defined, and at the forefrone, otherwise, WndProc :: OnCallback does not work, the plugin needs this message variable for recording message information.
Var Dialog  ;Dialog variables also need to be defined, which may be NSIS default dialog variables for saving controls in the form.

Var BGImage  ;Background big picture
Var ImageHandle
Var THImage   ;Exclamation mark
Var BCSJ

Var WarningForm

Var btn_in
Var btn_ins

Var lbl_zhuye
Var lbl_biaoti

Var Txt_Browser
Var btn_Browser

Var Checkbox1
Var Checkbox_State1
Var Checkbox1_State

Var Checkbox2
Var Checkbox_State2
Var Checkbox2_State

Var Checkbox3
Var Checkbox_State3
Var Checkbox3_State

Var Checkbox4
Var Checkbox_State4
Var Checkbox4_State

;---------------------------Global compilation script predefined constant-----------------------------------------------------
!define PRODUCT_NAME "Minecraft"
!define PRODUCT_DIR "Minecraft"
!define PRODUCT_VERSION "1.7.0.0"
!define PRODUCT_PUBLISHER "Minecraft, Inc."
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Minecraft.exe" ;Please modify your own
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define BTN_MINI_POS "449 14 11 11"
!define BTN_CLOSE_POS "481 14 11 11"
!define WINDOW_SIZE ""
!define CUSTOM_FONT "Minecraft"
ShowInstDetails nevershow ;Set whether to display the installation details.
ShowUnInstDetails nevershow ;Set whether to display delete details.

;Application display name
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
;Application output file name
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe"
;Default installation directory
InstallDir "$PROGRAMFILES\${PRODUCT_DIR}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"

; MUI Predefined constant
;!define MUI_ABORTWARNING ;Exit prompt
;Path name of the icon
!define MUI_ICON "Icon\MinecraftIcon.ico"
;Uninstall the path name of the icon
!define MUI_UNICON "Icon\MinecraftUninsIcon.ico"
;UI use
!define MUI_UI "UI\mod.exe"


;---------------------------Set software compression type (can also be controlled by external compilation)------------------------------------
SetCompressor lzma
SetCompress force
; XPStyle on
; ------ MUI Modern interface definition (1.67 Version above is compatible) ------
!include "MUI2.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

;Custom page
;  Page custom Page.1

Page custom Page.2 Page.2leave
; License agreement page
;!define MUI_LICENSEPAGE_CHECKBOX

; Install Directory Selection Page

;!insertmacro MUI_PAGE_DIRECTORY
; Install the process page
;!define MUI_PAGE_CUSTOMFUNCTION_PRO InstFilesPagePRO
!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesPageShow
!insertmacro MUI_PAGE_INSTFILES

Page custom Page.3

Page custom Page.4
; Install completion page
;!insertmacro MUI_PAGE_FINISH
; Install uninstall process page
UninstPage custom un.Page.5

UninstPage instfiles un.InstFiles.PRO un.InstFiles.Show

UninstPage custom un.Page.6

UninstPage custom un.Page.7


; Installing the language settings included
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Russian"




;------------------------------------------------------MUI Modern interface definition and ending function------------------------

Function .onInit
    InitPluginsDir
    
	;Language selection dialog

	Push ""
	Push ${LANG_ENGLISH}
	Push English

	Push ${LANG_TRADCHINESE}
	Push "Traditional Chinese"
	Push ${LANG_SIMPCHINESE}
	Push "Simplified Chinese"	
  Push ${LANG_RUSSIAN}
	Push "Русский язык"
	Push A ; A means auto count languages
	       ; for the auto count to work the first empty push (Push "") must remain
	LangDLL::LangDialog "Installer Language" "Please select the language of the installer"

	Pop $LANGUAGE
	StrCmp $LANGUAGE "cancel" 0 +2
		Abort
    StrCpy $Checkbox1_State ${BST_CHECKED}
    StrCpy $Checkbox2_State ${BST_CHECKED}
    StrCpy $Checkbox3_State ${BST_CHECKED}
    StrCpy $Checkbox4_State ${BST_CHECKED}
    
    File `/ONAME=$PLUGINSDIR\bg.bmp` `images\bdyun.bmp`
    File `/oname=$PLUGINSDIR\mgbg.bmp` `images\Message.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_install.bmp` `images\btn_install.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_dir.bmp` `images\btn_dir.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`
    File `/oname=$PLUGINSDIR\TanHao.bmp` `images\TanHao.bmp`
    File `/oname=$PLUGINSDIR\TextBox.bmp` `images\TextBox.bmp`
    File `/oname=$PLUGINSDIR\minecraft_font.ttf` `minecraft_font.ttf`

		;Progress strip skin
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`

    SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_install.bmp"
FunctionEnd






Function onGUIInit

    ;Eliminate border
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;Hidden some controls
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    ${NSW_SetWindowSize} $HWNDPARENT 530 450 ;530  250                    Change the main form
    System::Call User32::GetDesktopWindow()i.R0
    ;Rounded
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0
		Call UninstallSoft
FunctionEnd

;Processing boundless box movement
Function onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0

    
  ${EndIf}
FunctionEnd
;Popup dialog movement
Function onWarningGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $WarningForm ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

# Welcome Page
Function Page.1

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}
    
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;Constant background

    ${NSW_SetWindowSize} $0 530 450 ;530  250      Change the size of the PAGE

		;XXX Installation Wizard
    ${NSD_CreateLabel} 1u 130u 493U 18u "Welcome ${PRODUCT_NAME}Setup Wizard"
    Pop $lbl_zhuye
    SetCtlColors $lbl_zhuye "" transparent ;Constant background
    CreateFont $1 "Minecraft" "11" "800"
    SendMessage $lbl_zhuye ${WM_SETFONT} $1 0
    ${NSD_AddStyle} $lbl_zhuye ${ES_CENTER}

		;Title text
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Install"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;blue
    SetCtlColors $lbl_biaoti "666666"  transparent ;Constant background

    ;Custom installation button
    ${NSD_CreateButton} 120u 185u 136 32 "Custom installation"
    Pop $btn_ins
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_ins
    SetCtlColors $btn_ins "808080"  transparent ;Constant background
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_ins $3

    ;Quick installation button
    ${NSD_CreateButton} 120u 153u 136 32 "Quick installation (recommended)"
    Pop $btn_in
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_in
    SetCtlColors $btn_in "808080"  transparent ;Constant background
    GetFunctionAddress $3 onClickin
    SkinBtn::onClick $btn_in $3


		;Title text
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Install"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;blue
    SetCtlColors $lbl_biaoti "666666"  transparent ;Constant background
    
    ;Minimize button
    ${NSD_CreateButton} ${BTN_MINI_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;Close button
    ${NSD_CreateButton} ${BTN_CLOSE_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3

    ;Sticker background big picture
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;Handling borderless form movement
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd
# Directory Page
Function Page.2

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 "f7f7f7"  transparent ;Constant background

   ${NSW_SetWindowSize} $0 530 250 ;530  250 ;Change the size of the PAGE

    ;Install button
    ${NSD_CreateButton} 352 192 162 40 "Install"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_install.bmp $0
    GetFunctionAddress $3 onClickinst
    SkinBtn::onClick $0 $3

		;Title text
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Install  222"
    Pop $lbl_biaoti
    ${NSD_AddStyle} $lbl_biaoti ${ES_CENTER}

		;Path Selection
    ; ${NSD_CreateLabel} 36 110u 130 13u "Select component:"
    ; Pop $0
    ; SetCtlColors $0 ""  transparent ;Constant background
;    CreateFont $1 "Segoe UI" "11" "800"
;    SendMessage $0 ${WM_SETFONT} $1 0

		;Path Selection
    ${NSD_CreateLabel} 19 166 130u 12u "Installation Directory:"
    Pop $0
    SetCtlColors $0 0xffffff  transparent ;Constant background
   ; CreateFont $1 "Segoe UI" "11" "800"
   ; SendMessage $3 ${WM_SETFONT} $1 0

#------------------------------------------
#Option 1
#------------------------------------------    
    ; ${NSD_CreateCheckbox} 19 130u 12u 12u ""
    ; Pop $Checkbox1
    ; SetCtlColors $Checkbox1 "" "f7f7f7"
		; ;${NSD_SetState} $Checkbox1 ${BST_CHECKED}


		; ${NSD_CreateLabel} 19u 131u 100u 12u "Optional 1"
		; Pop $Checkbox_State1
    ; SetCtlColors $Checkbox_State1 ""  transparent ;Foreground,Constant background
    ; ${NSD_OnClick} $Checkbox_State1 onCheckbox1
#------------------------------------------
#Option 2
#------------------------------------------
    ; ${NSD_CreateCheckbox} 36 150u 12u 12u ""
    ; Pop $Checkbox2
		; SetCtlColors $Checkbox2 "" "f4f4f4"
		; ${NSD_SetState} $Checkbox3 ${BST_CHECKED}
		; ;ShowWindow $Checkbox2 ${SW_HIDE}
		
		; ${NSD_CreateLabel} 36u 151u 100u 12u "Optional 2"
		; Pop $Checkbox_State2
    ; SetCtlColors $Checkbox_State2 ""  transparent ;Foreground,Constant background
    ; ${NSD_OnClick} $Checkbox_State2 onCheckbox2
    ;ShowWindow $Checkbox_State2 ${SW_HIDE}   ;When you don't use this option, you can hide
#------------------------------------------
#Option 3
#------------------------------------------
    ; ${NSD_CreateCheckbox} 36 170u 12u 12u ""
    ; Pop $Checkbox3
		; SetCtlColors $Checkbox3 "" "f5f5f5"
		; ${NSD_SetState} $Checkbox3 ${BST_CHECKED}
		; ;ShowWindow $Checkbox3 ${SW_HIDE}  ;When you don't use this option, you can hide

		; ${NSD_CreateLabel} 36u 171u 100u 12u "Optional item three"
		; Pop $Checkbox_State3
    ; SetCtlColors $Checkbox_State3 ""  transparent ;Foreground,Constant background
    ; ${NSD_OnClick} $Checkbox_State3 onCheckbox3
    ; ;ShowWindow $Checkbox_State3 ${SW_HIDE}  ;When you don't use this option, you can hide
#------------------------------------------
#Option 4
#------------------------------------------
    ; ${NSD_CreateCheckbox} 36 190u 12u 12u ""
    ; Pop $Checkbox4
		; SetCtlColors $Checkbox4 "" "f6f6f6"
		; ${NSD_SetState} $Checkbox4 ${BST_CHECKED}
		; ;ShowWindow $Checkbox4 ${SW_HIDE}  ;When you don't use this option, you can hide
		
		; ${NSD_CreateLabel} 36u 191u 100u 12u "Optional item four"
		; Pop $Checkbox_State4
    ; SetCtlColors $Checkbox_State4 ""  transparent ;前景色,Constant background
    ; ${NSD_OnClick} $Checkbox_State4 onCheckbox4
    ; ;ShowWindow $Checkbox_State4 ${SW_HIDE}  ;When you don't use this option, you can hide
    
#Optional!
#------------------------------------------

    ;Minimize button
    ${NSD_CreateButton} ${BTN_MINI_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;Close button
    ${NSD_CreateButton} ${BTN_CLOSE_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3

    ;Create a change path folder button
    ${NSD_CreateButton} 27 201 21 21  "" 
		Pop $btn_Browser
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_dir.bmp $btn_Browser
		GetFunctionAddress $3 onButtonClickSelectPath
    SkinBtn::onClick $btn_Browser $3
		;ShowWindow $btn_Browser ${SW_HIDE}


		;Create an installation directory Enter text box
  	${NSD_CreateText} 53 203 281 20 $INSTDIR ${WS_EX_CLIENTEDGE}|${WS_EX_TRANSPARENT}
		Pop $Txt_Browser
    SetCtlColors $Txt_Browser 0xffffff 0x8b8b8b

		;ShowWindow $Txt_Browser ${SW_HIDE}


    ${NSD_CreateBitmap} 19 192 330 40 ""
    Pop $BGImage
    SetCtlColors  $BGImage 0x006321 0x006321
    ${NSD_SetImage} $BGImage $PLUGINSDIR\TextBox.bmp $ImageHandle

    ;Sticker background big picture
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle



    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;Handling borderless form movement
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd
Function .onGUIEnd
    Push "$PLUGINSDIR\minecraft_font.ttf"
    System::Call 'Gdi32::RemoveFontResourceEx(t"$PLUGINSDIR\minecraft_font.ttf",i 0x30,i0)'
    System::Call "Gdi32::RemoveFontResource(t s) i .s"
    SendMessage ${HWND_BROADcast} ${WM_FONTCHANGE} 0 0

    Delete "$PLUGINSDIR\minecraft_font.ttf"

    ;     SetCtlColors $Txt_Browser 0xffffff 0x8b8b8b
    ; Push "$PLUGINSDIR\minecraft_font.ttf"
    ; System::Call 'GDI32::AddFontResourceEx(t"$PLUGINSDIR\minecraft_font.ttf",i 0x30,i0)'
    ; System::Call "Gdi32::AddFontResource(t s) i .s"
    ; CreateFont $1 "$PLUGINSDIR\minecraft_font.ttf" "10" "0"
FunctionEnd

#----------------------------------------------
#Store 4 option status
#----------------------------------------------
Function Page.2leave
   ${NSD_GetState} $Checkbox1 $Checkbox1_State
   ${NSD_GetState} $Checkbox2 $Checkbox2_State
   ${NSD_GetState} $Checkbox3 $Checkbox3_State
   ${NSD_GetState} $Checkbox4 $Checkbox4_State
FunctionEnd
#----------------------------------------------
#The second page is completed
#----------------------------------------------


Function  InstFilesPageShow

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $R2 1027
    ShowWindow $1 ${SW_HIDE}


  File '/oname=$PLUGINSDIR\Slides.dat' 'nsisSlideShow\Slides.dat'
  File '/oname=$PLUGINSDIR\Play1.png' 'nsisSlideShow\Play1.png'
  File '/oname=$PLUGINSDIR\Play2.png' 'nsisSlideShow\Play2.png'
  File '/oname=$PLUGINSDIR\Play3.png' 'nsisSlideShow\Play3.png'
		;Custom progress bar color style
		;Cancel progress bar Windows Style theme style, changed to the defined colors
;		GetDlgItem $2 $R2 1004
;		System::Call UxTheme::SetWindowTheme(i,w,w)i(r2, n, n)
		;SendMessage $2 ${PBM_SETBARCOLOR} 0 0x339a00 ;Set progress balance color
		;SendMessage $2 ${PBM_SETBKCOLOR} 0 0xa4a4a4  ;Set progress bar background color

    GetDlgItem $R0 $R2 1004  ;Set progress bar position
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $R2 ;Change the page size,Otherwise, the map can not be full
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 530, i 250) i r2"
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $R0 $0 ;Handling borderless form movement
    
    GetDlgItem $R1 $R2 1006  ;Get 1006 controls set color and change position
    ;SetCtlColors $R1 "F6F6F6"  F6F6F6 Background is set to F6F6F6, pay attention to the color cannot be transparent, otherwise overlapping
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"


    GetDlgItem $R3 $R2 1990  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R3, i 449, i 14, i 11, i 11) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;Background is set to F6F6F6, pay attention to the color can not be set to transparent, otherwise overlapping

    GetDlgItem $R4 $R2 1991  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R4, i 481, i 14, i 11, i 11) i r2" ;改变位置465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;No 0 is forbidden
    
    GetDlgItem $R5 $R2 1992  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "Install"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $R2 1993  ;Get 1993 Control Sets Colors and change the location
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} Install" ;Set the text text for a control


    GetDlgItem $R8 $R2 1016  ;Get 1006 controls set color and change position
    SetCtlColors $R8 ""  F6F6F6 ;Background is set to F6F6F6, pay attention to the color can not be set to transparent, otherwise overlapping
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"
    
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 530, i 250) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\bg.bmp $ImageHandle

		;Here is the progress bar map
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
	  SkinProgress::Set $5 "$PLUGINSDIR\Progress.bmp" "$PLUGINSDIR\ProgressBar.bmp"

FunctionEnd

Function Page.3
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}


    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;Constant background

    ${NSW_SetWindowSize} $0 530 250 ;Change the size of the PAGE


    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME}"The installation is complete！'
    Pop $2

    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME}Installed into your computer, please click [Complete]。"
    Pop $2

    SendMessage $2 ${WM_SETFONT} "$1" 0
    SetCtlColors $2 666666  transparent ;Constant background

		;Title text
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Install"
    Pop $lbl_biaoti

    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;blue
    SetCtlColors $lbl_biaoti "666666"  transparent ;Constant background
  

    ;Complete button
    ${NSD_CreateButton} 352 192 162 40 "Finish"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_install.bmp $0

    GetFunctionAddress $3 onClickend
    SkinBtn::onClick $0 $3

    ;Minimize button
    ${NSD_CreateButton} ${BTN_MINI_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;Close button
    ${NSD_CreateButton} ${BTN_CLOSE_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;Sticker background big picture
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle


    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;Handling borderless form movement
    nsDialogs::Show

    ${NSD_FreeImage} $ImageHandle

FunctionEnd


Function Page.4

FunctionEnd

Function MessgesboxPage
	IsWindow $WarningForm Create_End
	!define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
  SetCtlColors $hwndparent "" transparent
	${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018


	;${NSW_SetWindowSize} $WarningForm 382 202
	System::Call "user32::MoveWindow(i $WarningForm, i 0, i 0, i 382, i 202) i r2"
	EnableWindow $hwndparent 0
  ;SetCtlColors $hwndparent ""  transparent ;Constant background
	System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`

	${NSW_CreateButton} 225 169 72 24 'Yes'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_install.bmp $1
  GetFunctionAddress $3 onClickclos
  SkinBtn::onClick $1 $3
  SendMessage $1 ${WM_SETFONT} "$2" 0


	${NSW_CreateButton} 303 169 72 24 'Cancel'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_install.bmp $1
  GetFunctionAddress $3 OnClickQuitCancel
  SkinBtn::onClick $1 $3
  SendMessage $1 ${WM_SETFONT} "$2" 0

  ;Close button
  ; ${NSW_CreateButton} 350 1 31 18 ""
	; Pop $1
  ; SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $1
  ; GetFunctionAddress $3 OnClickQuitCancel
  ; SkinBtn::onClick $1 $3

 	;Exit prompt
  ${NSW_CreateLabel} 17% 95 170u 9u "Determine to exit${PRODUCT_NAME}Is it installed?"
  Pop $R3

  SetCtlColors $R3 "636363"  transparent ;Constant background

 	;Left corner text
  ${NSW_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME}"
  Pop $R2
  SetCtlColors $R2 "666666"  transparent ;Constant background

	;Exclamation mark
	${NSW_CreateBitmap} 10% 93 16u 16u ""
  Pop $THImage
  ${NSW_SetImage} $THImage $PLUGINSDIR\TanHao.bmp $ImageHandle

	;Background diagram
	${NSW_CreateBitmap} 0 0 380u 202u ""
  Pop $BGImage
  ${NSW_SetImage} $BGImage $PLUGINSDIR\mgbg.bmp $ImageHandle

	GetFunctionAddress $0 onWarningGUICallback
	WndProc::onCallback $BGImage $0 ;Handling borderless form movement
;	WndProc::onCallback $THImage $0
;	WndProc::onCallback $R2 $0
;	WndProc::onCallback $R3 $0

  ${NSW_CenterWindow} $WarningForm $hwndparent
	${NSW_Show}
	Create_End:
  ShowWindow $WarningForm ${SW_SHOW}

FunctionEnd

Section MainSetup
SetDetailsPrint textonly
DetailPrint "Installing${PRODUCT_NAME}..."
SetDetailsPrint None ;Do not display information
nsisSlideshow::Show /NOUNLOAD /auto=$PLUGINSDIR\Slides.dat
SetOutPath $INSTDIR
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
; Sleep 50
; Sleep 50
; Sleep 50
;   ;${NSD_GetState} $Checkbox1_State $0
;     ${If} $Checkbox1_State == 1
;     DetailPrint "Choose"
;     MessageBox MB_OK 'Choose'
;     ${EndIf}
; MessageBox MB_OK 'Select item:$\r$\n$Checkbox1_State$\r$\n$Checkbox2_State$\r$\n$Checkbox3_State$\r$\n$Checkbox4_State$\r$\n安装目录：$INSTDIR'
; nsisSlideshow::Stop
; ExecShell "open" "http://item.taobao.com/item.htm?id=20321929386"
SetAutoClose true
SectionEnd

#----------------------------------------------
# Create a control panel uninstaller information, the following specific Law Card View Help D.2
# Add uninstall information to the Add / Remove Program Panel or search for keywords in the help, such as: DisplayName
#----------------------------------------------
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe" ;This is generating uninstaller
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\AppMainExe.exe" ;These please modify your own procedure.
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$INSTDIR\AppMainExe.exe" ;这些请自行修改成自己的程序
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


;Processing page jump command
Function RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function onClickins
  StrCpy $R9 1 ;Goto the next page
  Call RelGotoPage
  Abort
FunctionEnd

Function onClickin
StrCpy $Checkbox1_State 0  ;Here, I wrote directly of the four options in the second page, please modify it
StrCpy $Checkbox2_State 0
StrCpy $Checkbox3_State 1
StrCpy $Checkbox4_State 1
  StrCpy $R9 2 ;Goto the next page
  Call RelGotoPage
  Abort
FunctionEnd

Function onClickinst
  ${NSD_GetText} $Txt_Browser  $R0  ;Get the installation path

  ;Determine whether the directory is correct
	ClearErrors
	CreateDirectory "$R0"
	IfErrors 0 +3
  MessageBox MB_ICONINFORMATION|MB_OK "'$R0' The installation directory does not exist, please reset."
  Return

	StrCpy $INSTDIR  $R0  ;Save installation path

	;Jump to the next page, $R9是NavigationGotoPage Jump parameter variable required for function
  StrCpy $R9 1
  call RelGotoPage
FunctionEnd
#------------------------------------------
#Minimize code
#------------------------------------------
Function onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;Minimization
FunctionEnd

#------------------------------------------
#Turn off code
#------------------------------------------
Function onClickclos
    Delete "$PLUGINSDIR\minecraft_font.ttf"
    SendMessage $hwndparent ${WM_CLOSE} 0 0  ;closure
FunctionEnd

Function OnClickQuitCancel
  ${NSW_DestroyWindow} $WarningForm
  EnableWindow $hwndparent 1
  BringToFront
FunctionEnd

#--------------------------------------------------------
# Path Select button event, open the directory selection dialog that comes with the Windows system
#--------------------------------------------------------
Function onButtonClickSelectPath


	 ${NSD_GetText} $Txt_Browser  $0
   nsDialogs::SelectFolderDialog  "Рlease choose ${PRODUCT_NAME} installation manual:"  "$0"
   Pop $0
   ${IfNot} $0 == error
			${NSD_SetText} $Txt_Browser  $0
	${EndIf}

FunctionEnd

#-------------------------------------------------
# First Lable click, synchronous checkbox status processing function
#-------------------------------------------------
Function onCheckbox1

	 ${NSD_GetState} $Checkbox1 $0

   ${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox1 ${BST_UNCHECKED}
	 ${Else}
			 ${NSD_SetState} $Checkbox1 ${BST_CHECKED}
	 ${EndIf}

FunctionEnd

#-------------------------------------------------
# Second Lable Click, Synchronize Checkbox Status Processing Function
#-------------------------------------------------
Function onCheckbox2

	 ${NSD_GetState} $Checkbox2 $0

   ${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox2 ${BST_UNCHECKED}
	 ${Else}
			 ${NSD_SetState} $Checkbox2 ${BST_CHECKED}
	 ${EndIf}

FunctionEnd

#-------------------------------------------------
# Third Lable Click, Synchronize Checkbox Status Processing Function
#-------------------------------------------------
Function onCheckbox3

	 ${NSD_GetState} $Checkbox3 $0

   ${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox3 ${BST_UNCHECKED}
	 ${Else}
			 ${NSD_SetState} $Checkbox3 ${BST_CHECKED}
	 ${EndIf}

FunctionEnd

#-------------------------------------------------
# Fourth Lable Click, Synchronize Checkbox Status Processing Function
#-------------------------------------------------
Function onCheckbox4

	 ${NSD_GetState} $Checkbox4 $0

   ${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox4 ${BST_UNCHECKED}
	 ${Else}
			 ${NSD_SetState} $Checkbox4 ${BST_CHECKED}
	 ${EndIf}

FunctionEnd


;Complete page completion button
Function onClickend
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

#----------------------------------------------
#Execute uninstall task
#----------------------------------------------
Function UninstallSoft
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "UninstallString"
  ${GetParent} "$R0" $R1
  StrCmp $R0 "" done
  IfFileExists $R0 uninst
	Goto done
;Running uninstaller
uninst:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_TOPMOST "System already exists${PRODUCT_NAME}Is it uninstalled?" IDYES +2
  Goto done
  ExecWait "$R0 /S _?=$R1" ;Here $ r0 is the name of the uninstaller read, / s is a silent uninstall parameter using the NSIS generated uninstaller must be added _? Can you wait to uninstall.$ R1 is the software location
  IfFileExists "$R1" dir ;If the $ r1 software location also has files to Dir: Delete all files
  Goto done
dir: ;If the folder exists
	;Delete "$R1\*.*" , Delete all files, please use with caution

done:

FunctionEnd

/******************************
 *  The following is the uninstall portion of the installer  *
 ******************************/

Section Uninstall
SetDetailsPrint textonly
DetailPrint "Uninstall${PRODUCT_NAME}..."
  Sleep 5000
  Delete "$INSTDIR\uninst.exe"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- According to the NSIS script editing rules, all Function sections must be placed after the section section to avoid unpredictable issues in the installer.--#

Function un.Page.5
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;Constant background

    ${NSW_SetWindowSize} $0 530 250 ;Change the form of form


    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Uninstall"
    Pop $2
    SetCtlColors $2 666666  transparent ;Constant background

    ${NSD_CreateLabel} 10% 25% 250u 15u '"welcome${PRODUCT_NAME}"Uninstall the wizard!'
    Pop $2
    SetCtlColors $2 ""  transparent ;Constant background
    CreateFont $1 "Segoe UI" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 280u 25u "This wizard will guide you from your computer.${PRODUCT_NAME}。Click the [Uninstall] button to start uninstall."
    Pop $2
    SetCtlColors $2 "666666"  transparent ;Constant background

    ;Create a cancel button
    ${NSD_CreateButton} 65 192 160 40 "Cancel"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

    ${NSD_CreateButton} 319 192 160 40 "Uninstall"
    Pop $R0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R0
    GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R0 $3

    ;Minimize button
    ${NSD_CreateButton}  ${BTN_MINI_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;Close button
    ${NSD_CreateButton} ${BTN_CLOSE_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

    ;Sticker background big picture
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle


    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;Handling borderless form movement
    nsDialogs::Show

    ${NSD_FreeImage} $ImageHandle
FunctionEnd

Function un.InstFiles.PRO

FunctionEnd

Function un.InstFiles.Show
    FindWindow $BCSJ "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $BCSJ 1027
    ShowWindow $1 ${SW_HIDE}

    GetDlgItem $R0 $BCSJ 1004  ;Set progress bar position
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $BCSJ ;Change the page size,Otherwise, the map can not be full
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $R0 $0 ;Handling borderless form movement

    GetDlgItem $R1 $BCSJ 1006  ;Get 1006 controls set color and change position
    SetCtlColors $R1 ""  F6F6F6 ;Background f6f6f6,Note that the color cannot be set to transparent, otherwise overlapping
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"

    GetDlgItem $R3 $BCSJ 1990  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R3, i 434, i 1, i 31, i 18) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;Background f6f6f6,Note that the color cannot be set to transparent, otherwise overlapping

    GetDlgItem $R4 $BCSJ 1991  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R4, i 465, i 1, i 31, i 18) i r2" ;Change location 465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;No 0 is forbidden

    GetDlgItem $R5 $BCSJ 1992  ;Get 1006 controls set color and change position
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "Install"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $BCSJ 1993  ;Get 1993 Control Sets Colors and change the location
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} Install" ;Set the text text for a control


    GetDlgItem $R8 $BCSJ 1016  ;Get 1006 controls set color and change position
    SetCtlColors $R8 ""  F6F6F6 ;Background f6f6f6,Note that the color cannot be set to transparent, otherwise overlapping
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\beijing.bmp $ImageHandle

		;Here is the progress bar map
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
	  SkinProgress::Set $5 "$PLUGINSDIR\Progress.bmp" "$PLUGINSDIR\ProgressBar.bmp"

FunctionEnd

Function un.Page.6
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;Constant background

    ${NSW_SetWindowSize} $0 530 250 ;Change the form of form

    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} Uninstall"
    Pop $2
    SetCtlColors $2 666666  transparent ;Constant background

    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME}"Uninstall complete!'
    Pop $2
    SetCtlColors $2 ""  transparent ;Constant background
    CreateFont $1 "Segoe UI" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME}Successfully removed from your computer, click [Complete]."
    Pop $2
    SetCtlColors $2 666666  transparent ;Constant background

    ;Complete button
    ${NSD_CreateButton} 352 192 162 40 "Finish"
    Pop $2
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $2
    GetFunctionAddress $3 un.onClickend
    SkinBtn::onClick $2 $3

    ;Minimize button
    ${NSD_CreateButton} ${BTN_MINI_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;Close button
    ${NSD_CreateButton} ${BTN_CLOSE_POS} ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;Sticker background big picture
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;Handling borderless form movement
    nsDialogs::Show

FunctionEnd


Function un.Page.7

FunctionEnd


Function un.onInit
    InitPluginsDir
    File `/ONAME=$PLUGINSDIR\bg.bmp` `images\bdyun.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`

		;Progress strip skin
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`

    SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_in.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
FunctionEnd

Function un.onGUIInit
    ;Eliminate border
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;Hidden some controls
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    ${NSW_SetWindowSize} $HWNDPARENT 498 373 ;Change the main form
    System::Call User32::GetDesktopWindow()i.R0
    ;Rounded
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0

FunctionEnd

;Processing boundless box movement
Function un.onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

#------------------------------------------
#Minimize code
#------------------------------------------
Function un.onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;Minimization
FunctionEnd

#------------------------------------------
#Turn off code
#------------------------------------------
Function un.onClickclos
SendMessage $hwndparent ${WM_CLOSE} 0 0  ;closure
FunctionEnd

#------------------------------------------
#Uninstall completion page Use a separate section to make it easy to operate, if you open a web page
#------------------------------------------
Function un.onClickend
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

;Processing page jump command
Function un.RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function un.onClickins
  StrCpy $R9 1 ;Goto the next page
  Call un.RelGotoPage
  Abort
FunctionEnd

