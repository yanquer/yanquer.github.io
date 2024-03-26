; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there.
;
; example2.nsi expands on this by adding a uninstaller and start menu shortcuts.

;--------------------------------

!include nsDialogs.nsh
!include "FileFunc.nsh"
!insertmacro GetOptions
!insertmacro GetParameters


; The name of the installer
Name "Example1"

; The file to write
OutFile "example1.exe"

; Request application privileges for Windows Vista
RequestExecutionLevel user

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $DESKTOP\tnsis\Example1

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

Function checkUpdate

	${GetParameters} "$1"

	${GetOptions} $1 "--update="  $R0

	MessageBox MB_OK "--update value: $R0"

	${If} $R0 == 0
		MessageBox MB_OK "R0 == 0"
	${EndIf}

	${If} $R0 == '0'
		MessageBox MB_OK "R0 == '0'"
	${EndIf}

	${If} $R0 == "0"
		MessageBox MB_OK "R0 == db 0"
	${EndIf}

	${If} "$R0" == 0
		MessageBox MB_OK " db R0 == 0"
	${EndIf}

	MessageBox MB_OKCANCEL|MB_ICONQUESTION "more message box test, no exit?" /SD IDOK IDOK done IDCANCEL done2

	# 注意定义的先后顺序
	# Abort 表示退出整个程序
	# 一般来说, 为了避免重复执行选项, 会有一个 done 的选项来退出选项判断

	# 注意此中文注释有变吗问题, 正式运行要么转编码, 要么删掉

	done2:
		;MessageBox MB_OK "d2"
		; exit
		Abort
	done:
		MessageBox MB_OK "done"
FunctionEnd

Function .onInit
	Call checkUpdate
FunctionEnd

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File example1.nsi

SectionEnd
