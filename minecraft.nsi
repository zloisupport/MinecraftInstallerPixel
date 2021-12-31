!system '>blank set/p=MSCF<nul'
!packhdr temp.dat 'cmd /c Copy /b temp.dat /b +blank&&del blank'

Var MSG     ;MSG变量必须定义，而且在最前面，否则WndProc::onCallback不工作，插件中需要这个消息变量,用于记录消息信息
Var Dialog  ;Dialog变量也需要定义，他可能是NSIS默认的对话框变量用于保存窗体中控件的信息

Var BGImage  ;背景大图
Var ImageHandle
Var THImage   ;叹号
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

;---------------------------全局编译脚本预定义的常量-----------------------------------------------------
!define PRODUCT_NAME "BaiDuYun"
!define PRODUCT_DIR "BaiDuYun"
!define PRODUCT_VERSION "3.7.0.0"
!define PRODUCT_PUBLISHER "baidu.com, Inc."
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\DesktopHook64.exe" ;请自行修改
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

ShowInstDetails nevershow ;设置是否显示安装详细信息。
ShowUnInstDetails nevershow ;设置是否显示删除详细信息。

;应用程序显示名字
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
;应用程序输出文件名
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe"
;默认安装目录
InstallDir "$PROGRAMFILES\${PRODUCT_DIR}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"

; MUI 预定义常量
;!define MUI_ABORTWARNING ;退出提示
;安装图标的路径名字
!define MUI_ICON "Icon\BaiduYun.ico"
;卸载图标的路径名字
!define MUI_UNICON "Icon\BaiduYun.ico"
;使用的UI
!define MUI_UI "UI\mod.exe"


;---------------------------设置软件压缩类型（也可以通过外面编译脚本控制）------------------------------------
SetCompressor lzma
SetCompress force
XPStyle on
; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI2.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

;自定义页面
Page custom Page.1

Page custom Page.2 Page.2leave
; 许可协议页面
;!define MUI_LICENSEPAGE_CHECKBOX

; 安装目录选择页面

;!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
;!define MUI_PAGE_CUSTOMFUNCTION_PRO InstFilesPagePRO
!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesPageShow
!insertmacro MUI_PAGE_INSTFILES

Page custom Page.3

Page custom Page.4
; 安装完成页面
;!insertmacro MUI_PAGE_FINISH
; 安装卸载过程页面
UninstPage custom un.Page.5

UninstPage instfiles un.InstFiles.PRO un.InstFiles.Show

UninstPage custom un.Page.6

UninstPage custom un.Page.7


; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

;------------------------------------------------------MUI 现代界面定义以及函数结束------------------------

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
    File `/ONAME=$PLUGINSDIR\BeiJing.bmp` `images\BeiJing.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_in.bmp` `images\in.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`
    File `/oname=$PLUGINSDIR\TanHao.bmp` `images\TanHao.bmp`

		;进度条皮肤
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`

    SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_in.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
FunctionEnd

Function onGUIInit

    ;消除边框
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;隐藏一些既有控件
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

    ${NSW_SetWindowSize} $HWNDPARENT 530 250 ;改变主窗体大小
    System::Call User32::GetDesktopWindow()i.R0
    ;圆角
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

;处理无边框移动
Function onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd
;弹出对话框移动
Function onWarningGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $WarningForm ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd


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
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 498 373 ;改变Page大小

		;XXX安装向导
    ${NSD_CreateLabel} 1u 130u 493U 18u "欢迎使用${PRODUCT_NAME}安装向导"
    Pop $lbl_zhuye
    SetCtlColors $lbl_zhuye "" transparent ;背景设成透明
    CreateFont $1 "宋体" "11" "800"
    SendMessage $lbl_zhuye ${WM_SETFONT} $1 0
    ${NSD_AddStyle} $lbl_zhuye ${ES_CENTER}

		;标题文字
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 安装"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;蓝色
    SetCtlColors $lbl_biaoti "666666"  transparent ;背景设成透明

    ;自定义安装按钮
    ${NSD_CreateButton} 120u 185u 136 32 "自定义安装"
    Pop $btn_ins
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_ins
    SetCtlColors $btn_ins "808080"  transparent ;背景设成透明
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_ins $3

    ;快速安装按钮
    ${NSD_CreateButton} 120u 153u 136 32 "快速安装(推荐)"
    Pop $btn_in
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_in
    SetCtlColors $btn_in "808080"  transparent ;背景设成透明
    GetFunctionAddress $3 onClickin
    SkinBtn::onClick $btn_in $3


		;标题文字
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 安装"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;蓝色
    SetCtlColors $lbl_biaoti "666666"  transparent ;背景设成透明
    
    ;最小化按钮
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;关闭按钮
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd

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
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 498 373 ;改变Page大小

    ;安装按钮
    ${NSD_CreateButton} 416U 339U 72U 24U "安装"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_BTN.bmp $0
    GetFunctionAddress $3 onClickinst
    SkinBtn::onClick $0 $3

		;标题文字
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 安装"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;蓝色
    SetCtlColors $lbl_biaoti "666666"  transparent ;背景设成透明


		;路径选择
    ${NSD_CreateLabel} 36 110u 130 13u "选择组件："
    Pop $0
    SetCtlColors $0 ""  transparent ;背景设成透明
;    CreateFont $1 "宋体" "11" "800"
;    SendMessage $0 ${WM_SETFONT} $1 0

		;路径选择
    ${NSD_CreateLabel} 36 90 130u 12u "安装目录："
    Pop $0
    SetCtlColors $0 ""  transparent ;背景设成透明
   ; CreateFont $1 "宋体" "11" "800"
   ; SendMessage $3 ${WM_SETFONT} $1 0

#------------------------------------------
#可选项1
#------------------------------------------    
    ${NSD_CreateCheckbox} 36 130u 12u 12u ""
    Pop $Checkbox1
    SetCtlColors $Checkbox1 "" "f7f7f7"
		;${NSD_SetState} $Checkbox1 ${BST_CHECKED}


		${NSD_CreateLabel} 36u 131u 100u 12u "可选项目一"
		Pop $Checkbox_State1
    SetCtlColors $Checkbox_State1 ""  transparent ;前景色,背景设成透明
    ${NSD_OnClick} $Checkbox_State1 onCheckbox1
#------------------------------------------
#可选项2
#------------------------------------------
    ${NSD_CreateCheckbox} 36 150u 12u 12u ""
    Pop $Checkbox2
		SetCtlColors $Checkbox2 "" "f4f4f4"
		${NSD_SetState} $Checkbox3 ${BST_CHECKED}
		;ShowWindow $Checkbox2 ${SW_HIDE}
		
		${NSD_CreateLabel} 36u 151u 100u 12u "可选项目二"
		Pop $Checkbox_State2
    SetCtlColors $Checkbox_State2 ""  transparent ;前景色,背景设成透明
    ${NSD_OnClick} $Checkbox_State2 onCheckbox2
    ;ShowWindow $Checkbox_State2 ${SW_HIDE}   ;当你不使用该选项时，可以隐藏
#------------------------------------------
#可选项3
#------------------------------------------
    ${NSD_CreateCheckbox} 36 170u 12u 12u ""
    Pop $Checkbox3
		SetCtlColors $Checkbox3 "" "f5f5f5"
		${NSD_SetState} $Checkbox3 ${BST_CHECKED}
		;ShowWindow $Checkbox3 ${SW_HIDE}  ;当你不使用该选项时，可以隐藏

		${NSD_CreateLabel} 36u 171u 100u 12u "可选项目三"
		Pop $Checkbox_State3
    SetCtlColors $Checkbox_State3 ""  transparent ;前景色,背景设成透明
    ${NSD_OnClick} $Checkbox_State3 onCheckbox3
    ;ShowWindow $Checkbox_State3 ${SW_HIDE}  ;当你不使用该选项时，可以隐藏
#------------------------------------------
#可选项4
#------------------------------------------
    ${NSD_CreateCheckbox} 36 190u 12u 12u ""
    Pop $Checkbox4
		SetCtlColors $Checkbox4 "" "f6f6f6"
		${NSD_SetState} $Checkbox4 ${BST_CHECKED}
		;ShowWindow $Checkbox4 ${SW_HIDE}  ;当你不使用该选项时，可以隐藏
		
		${NSD_CreateLabel} 36u 191u 100u 12u "可选项目四"
		Pop $Checkbox_State4
    SetCtlColors $Checkbox_State4 ""  transparent ;前景色,背景设成透明
    ${NSD_OnClick} $Checkbox_State4 onCheckbox4
    ;ShowWindow $Checkbox_State4 ${SW_HIDE}  ;当你不使用该选项时，可以隐藏
    
#可选项完成!
#------------------------------------------

    ;最小化按钮
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;关闭按钮
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3
    
		;创建安装目录输入文本框
  	${NSD_CreateText} 36 120 350 24 $INSTDIR
		Pop $Txt_Browser
    CreateFont $1 "tahoma" "10" "500"
    SendMessage $Txt_Browser ${WM_SETFONT} $1 1
		;ShowWindow $Txt_Browser ${SW_HIDE}


    ;创建更改路径文件夹按钮
    ${NSD_CreateButton} 395U 120U 72U 16u  "浏览"
		Pop $btn_Browser
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $btn_Browser
		GetFunctionAddress $3 onButtonClickSelectPath
    SkinBtn::onClick $btn_Browser $3
		;ShowWindow $btn_Browser ${SW_HIDE}
    
    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd

#----------------------------------------------
#存储4个选项状态
#----------------------------------------------
Function Page.2leave
   ${NSD_GetState} $Checkbox1 $Checkbox1_State
   ${NSD_GetState} $Checkbox2 $Checkbox2_State
   ${NSD_GetState} $Checkbox3 $Checkbox3_State
   ${NSD_GetState} $Checkbox4 $Checkbox4_State
FunctionEnd
#----------------------------------------------
#第2个页面完成
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
		;自定义进度条的颜色样式
		;取消进度条windows 样式主题风格，改为用自已定义的颜色
;		GetDlgItem $2 $R2 1004
;		System::Call UxTheme::SetWindowTheme(i,w,w)i(r2, n, n)
		;SendMessage $2 ${PBM_SETBARCOLOR} 0 0x339a00 ;设置进度条前景色
		;SendMessage $2 ${PBM_SETBKCOLOR} 0 0xa4a4a4  ;设置进度条背景色

    GetDlgItem $R0 $R2 1004  ;设置进度条位置
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $R2 ;改变页面大小,不然贴图不能全页
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $R0 $0 ;处理无边框窗体移动
    
    GetDlgItem $R1 $R2 1006  ;获取1006控件设置颜色并改变位置
    SetCtlColors $R1 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"

    GetDlgItem $R3 $R2 1990  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R3, i 434, i 1, i 31, i 18) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠

    GetDlgItem $R4 $R2 1991  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R4, i 465, i 1, i 31, i 18) i r2" ;改变位置465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;禁止0为禁止
    
    GetDlgItem $R5 $R2 1992  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "安装"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $R2 1993  ;获取1993控件设置颜色并改变位置
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} 安装" ;设置某个控件的 text 文本


    GetDlgItem $R8 $R2 1016  ;获取1006控件设置颜色并改变位置
    SetCtlColors $R8 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"
    
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\beijing.bmp $ImageHandle

		;这里是给进度条贴图
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
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 498 373 ;改变Page大小


    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME}"安装完成！'
    Pop $2
    SetCtlColors $2 ""  transparent ;背景设成透明
    CreateFont $1 "宋体" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME}已安装到您的电脑中，请单击【完成】。"
    Pop $2
    SetCtlColors $2 666666  transparent ;背景设成透明

		;标题文字
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 安装"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;蓝色
    SetCtlColors $lbl_biaoti "666666"  transparent ;背景设成透明


    ;完成按钮
    ${NSD_CreateButton} 416 339 72 24 "完成"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_BTN.bmp $0
    GetFunctionAddress $3 onClickend
    SkinBtn::onClick $0 $3

    ;最小化按钮
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;关闭按钮
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle


    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    nsDialogs::Show

    ${NSD_FreeImage} $ImageHandle

FunctionEnd


Function Page.4

FunctionEnd

Function MessgesboxPage
	IsWindow $WarningForm Create_End
	!define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
	${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018

	;${NSW_SetWindowSize} $WarningForm 382 202
	System::Call "user32::MoveWindow(i $WarningForm, i 0, i 0, i 382, i 202) i r2"
	EnableWindow $hwndparent 0
  ;SetCtlColors $hwndparent ""  transparent ;背景设成透明
	System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`

	${NSW_CreateButton} 225 169 72 24 '确定'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $1
  GetFunctionAddress $3 onClickclos
  SkinBtn::onClick $1 $3

	${NSW_CreateButton} 303 169 72 24 '取消'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $1
  GetFunctionAddress $3 OnClickQuitCancel
  SkinBtn::onClick $1 $3

  ;关闭按钮
  ${NSW_CreateButton} 350 1 31 18 ""
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $1
  GetFunctionAddress $3 OnClickQuitCancel
  SkinBtn::onClick $1 $3

 	;退出提示
  ${NSW_CreateLabel} 17% 95 170u 9u "确定要退出${PRODUCT_NAME}安装吗？"
  Pop $R3
  ;SetCtlColors $R2 "" 0xFFFFFF ;蓝色
  SetCtlColors $R3 "636363"  transparent ;背景设成透明

 	;左上角文字
  ${NSW_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME}"
  Pop $R2
  ;SetCtlColors $R2 "" 0xFFFFFF ;蓝色
  SetCtlColors $R2 "666666"  transparent ;背景设成透明

	;叹号
	${NSW_CreateBitmap} 10% 93 16u 16u ""
  Pop $THImage
  ${NSW_SetImage} $THImage $PLUGINSDIR\TanHao.bmp $ImageHandle

	;背景图
	${NSW_CreateBitmap} 0 0 380u 202u ""
  Pop $BGImage
  ${NSW_SetImage} $BGImage $PLUGINSDIR\mgbg.bmp $ImageHandle

	GetFunctionAddress $0 onWarningGUICallback
	WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
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
DetailPrint "正在安装${PRODUCT_NAME}..."
SetDetailsPrint None ;不显示信息
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
Sleep 50
Sleep 50
Sleep 50
  ;${NSD_GetState} $Checkbox1_State $0
    ${If} $Checkbox1_State == 1
    DetailPrint "选中"
    MessageBox MB_OK '选中'
    ${EndIf}
MessageBox MB_OK '选中项:$\r$\n$Checkbox1_State$\r$\n$Checkbox2_State$\r$\n$Checkbox3_State$\r$\n$Checkbox4_State$\r$\n安装目录：$INSTDIR'
nsisSlideshow::Stop
ExecShell "open" "http://item.taobao.com/item.htm?id=20321929386"
SetAutoClose true
SectionEnd

#----------------------------------------------
#创建控制面板卸载程序信息 ,下面的具体用法卡查看帮助  D.2 添加卸载信息到添加/删除程序面板  或者在帮助里搜索关键词，如：DisplayName
#----------------------------------------------
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe" ;这个是生成卸载程序
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\AppMainExe.exe" ;这些请自行修改成自己的程序
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$INSTDIR\AppMainExe.exe" ;这些请自行修改成自己的程序
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


;处理页面跳转的命令
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
StrCpy $Checkbox1_State 0  ;这里，我直接把第二页的四个选项情况写出来了，请自己修改
StrCpy $Checkbox2_State 0
StrCpy $Checkbox3_State 1
StrCpy $Checkbox4_State 1
  StrCpy $R9 2 ;Goto the next page
  Call RelGotoPage
  Abort
FunctionEnd

Function onClickinst
  ${NSD_GetText} $Txt_Browser  $R0  ;获得设置的安装路径

  ;判断目录是否正确
	ClearErrors
	CreateDirectory "$R0"
	IfErrors 0 +3
  MessageBox MB_ICONINFORMATION|MB_OK "'$R0' 安装目录不存在，请重新设置。"
  Return

	StrCpy $INSTDIR  $R0  ;保存安装路径

	;跳到下一页， $R9是NavigationGotoPage 函数需要的跳转参数变量
  StrCpy $R9 1
  call RelGotoPage
FunctionEnd
#------------------------------------------
#最小化代码
#------------------------------------------
Function onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;最小化
FunctionEnd

#------------------------------------------
#关闭代码
#------------------------------------------
Function onClickclos
SendMessage $hwndparent ${WM_CLOSE} 0 0  ;关闭
FunctionEnd

Function OnClickQuitCancel
  ${NSW_DestroyWindow} $WarningForm
  EnableWindow $hwndparent 1
  BringToFront
FunctionEnd

#--------------------------------------------------------
# 路径选择按钮事件，打开Windows系统自带的目录选择对话框
#--------------------------------------------------------
Function onButtonClickSelectPath


	 ${NSD_GetText} $Txt_Browser  $0
   nsDialogs::SelectFolderDialog  "请选择 ${PRODUCT_NAME} 安装目录："  "$0"
   Pop $0
   ${IfNot} $0 == error
			${NSD_SetText} $Txt_Browser  $0
	${EndIf}

FunctionEnd

#-------------------------------------------------
# 第一个Lable点击，同步CheckBox状态处理函数
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
# 第二个Lable点击，同步CheckBox状态处理函数
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
# 第三个Lable点击，同步CheckBox状态处理函数
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
# 第四个Lable点击，同步CheckBox状态处理函数
#-------------------------------------------------
Function onCheckbox4

	 ${NSD_GetState} $Checkbox4 $0

   ${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox4 ${BST_UNCHECKED}
	 ${Else}
			 ${NSD_SetState} $Checkbox4 ${BST_CHECKED}
	 ${EndIf}

FunctionEnd


;完成页面完成按钮
Function onClickend
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

#----------------------------------------------
#执行卸载任务
#----------------------------------------------
Function UninstallSoft
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "UninstallString"
  ${GetParent} "$R0" $R1
  StrCmp $R0 "" done
  IfFileExists $R0 uninst
	Goto done
;运行卸载程序
uninst:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_TOPMOST "系统已存在${PRODUCT_NAME}，是否卸载？" IDYES +2
  Goto done
  ExecWait "$R0 /S _?=$R1" ;这里$R0为读取到的卸载程序名称， /S是静默卸载参数使用NSIS生成的卸载程序必须要加上 _? 才能等待卸载。$R1是软件位置
  IfFileExists "$R1" dir ;如果 $R1软件位置 还有文件则跳转到 DIR: 删除里面的所有文件
  Goto done
dir: ;如果文件夹存在
	;Delete "$R1\*.*" ;即删除里面所有文件,请谨慎使用

done:

FunctionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
SetDetailsPrint textonly
DetailPrint "正在卸载${PRODUCT_NAME}..."
  Sleep 5000
  Delete "$INSTDIR\uninst.exe"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

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
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 498 373 ;改变窗体大小


    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 卸载"
    Pop $2
    SetCtlColors $2 666666  transparent ;背景设成透明

    ${NSD_CreateLabel} 10% 25% 250u 15u '"欢迎使用${PRODUCT_NAME}"卸载向导！'
    Pop $2
    SetCtlColors $2 ""  transparent ;背景设成透明
    CreateFont $1 "宋体" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 280u 25u "这个向导将指引你从计算机移除${PRODUCT_NAME}。单击【卸载】按钮开始卸载。"
    Pop $2
    SetCtlColors $2 "666666"  transparent ;背景设成透明

    ;创建取消按钮
    ${NSD_CreateButton} 416 339 72 24 "取消"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

    ${NSD_CreateButton} 338 339 72 24 "卸载"
    Pop $R0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R0
    GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R0 $3

    ;最小化按钮
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;关闭按钮
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle


    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
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

    GetDlgItem $R0 $BCSJ 1004  ;设置进度条位置
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $BCSJ ;改变页面大小,不然贴图不能全页
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $R0 $0 ;处理无边框窗体移动

    GetDlgItem $R1 $BCSJ 1006  ;获取1006控件设置颜色并改变位置
    SetCtlColors $R1 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"

    GetDlgItem $R3 $BCSJ 1990  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R3, i 434, i 1, i 31, i 18) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠

    GetDlgItem $R4 $BCSJ 1991  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R4, i 465, i 1, i 31, i 18) i r2" ;改变位置465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;禁止0为禁止

    GetDlgItem $R5 $BCSJ 1992  ;获取1006控件设置颜色并改变位置
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "安装"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $BCSJ 1993  ;获取1993控件设置颜色并改变位置
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} 安装" ;设置某个控件的 text 文本


    GetDlgItem $R8 $BCSJ 1016  ;获取1006控件设置颜色并改变位置
    SetCtlColors $R8 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\beijing.bmp $ImageHandle

		;这里是给进度条贴图
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
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 498 373 ;改变窗体大小

    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} 卸载"
    Pop $2
    SetCtlColors $2 666666  transparent ;背景设成透明

    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME}"卸载完成！'
    Pop $2
    SetCtlColors $2 ""  transparent ;背景设成透明
    CreateFont $1 "宋体" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME}已从您的电脑中成功移除，请单击【完成】。"
    Pop $2
    SetCtlColors $2 666666  transparent ;背景设成透明

    ;完成按钮
    ${NSD_CreateButton} 416 339 72 24 "完成"
    Pop $2
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $2
    GetFunctionAddress $3 un.onClickend
    SkinBtn::onClick $2 $3

    ;最小化按钮
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;关闭按钮
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    nsDialogs::Show

FunctionEnd


Function un.Page.7

FunctionEnd


Function un.onInit
    InitPluginsDir
    File `/ONAME=$PLUGINSDIR\BeiJing.bmp` `images\BeiJing.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_in.bmp` `images\in.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`

		;进度条皮肤
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`

    SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_in.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
FunctionEnd

Function un.onGUIInit
    ;消除边框
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;隐藏一些既有控件
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

    ${NSW_SetWindowSize} $HWNDPARENT 498 373 ;改变主窗体大小
    System::Call User32::GetDesktopWindow()i.R0
    ;圆角
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0

FunctionEnd

;处理无边框移动
Function un.onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

#------------------------------------------
#最小化代码
#------------------------------------------
Function un.onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;最小化
FunctionEnd

#------------------------------------------
#关闭代码
#------------------------------------------
Function un.onClickclos
SendMessage $hwndparent ${WM_CLOSE} 0 0  ;关闭
FunctionEnd

#------------------------------------------
#卸载完成页使用独立区段方便操作，如打开某个网页
#------------------------------------------
Function un.onClickend
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

;处理页面跳转的命令
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

