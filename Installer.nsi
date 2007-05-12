; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!ifdef _COMBO_
!define PRODUCT_NAME "Open PCMan Combo"
!define SRC_DIR "Combo\Release\PCMan Combo"
OutFile "PCManCB.exe"
!else
!define PRODUCT_NAME "Open PCMan"
!define SRC_DIR "Lite\Release\PCMan"
OutFile "PCMan.exe"
!endif

!define PRODUCT_DIR "${PRODUCT_NAME}"
!define PRODUCT_VERSION "2007"
!define PRODUCT_PUBLISHER "Open PCMan Team"
!define PRODUCT_WEB_SITE "http://rt.openfoundry.org/Foundry/Project/?Queue=744"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\PCMan.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor /SOLID lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

BGGradient 0000FF 000000 FFFFFF

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "License.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\PCMan.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Story.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
InstallDir "$PROGRAMFILES\${PRODUCT_DIR}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite on
  ;SetOverwrite ifnewer
  File /r /x "Symbols.txt" /x "Config" /x "*.svn" "${SRC_DIR}\*.*"

  StrCmp $LANGUAGE 1028 Chi2 Eng2
  Chi2:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你要從網路上更新 BBS 站台列表嗎？" IDNO +5
    Goto +2
  Eng2:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to update the BBS list from internet?" IDNO +2
  NSISdl::download "http://free.ym.edu.tw/pcman/site_list.big5" "BBSList"
  Pop $R0 ;Get the return value
  StrCmp $R0 "success" +2
    MessageBox MB_OK "Download failed: $R0"

  SetOverwrite off
;  File "${SRC_DIR}\Symbols.txt"

  SetOutPath "$INSTDIR\Config"
  File "${SRC_DIR}\Config\Config.ini"
  File "${SRC_DIR}\Config\BBSFavorites.ini"
  File "${SRC_DIR}\Config\FUS"

  SetOverwrite on
  File "${SRC_DIR}\Config\*.bmp"
  File "${SRC_DIR}\Config\UI"

  CreateDirectory "$SMPROGRAMS\${PRODUCT_DIR}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\Open PCMan 2007.lnk" "$INSTDIR\PCMan.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME} ${PRODUCT_VERSION}.lnk" "$INSTDIR\PCMan.exe"

  StrCmp $LANGUAGE 1028 Chi Eng
  Chi:
    CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\標點符號輸入程式.lnk" "$INSTDIR\Symbols.exe" "$INSTDIR\Symbols.exe"
    Goto +2
  Eng:
    CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\Symbols.lnk" "$INSTDIR\Symbols.exe" "$INSTDIR\Symbols.exe"

SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\PCMan.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\PCMan.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  StrCmp $LANGUAGE 1028 Chi Eng
  Chi:
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地從你的電腦移除。"
    Goto +2
  Eng:
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been removed sucessfully."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  StrCmp $LANGUAGE 1028 Chi Eng
  Chi:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確定要完全移除 $(^Name) ，其及所有的元件？" IDYES +4
    Abort
  Eng:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
    Abort
FunctionEnd

Section Uninstall
  RMDir /r "$INSTDIR\Conv"
  RMDir /r "$INSTDIR\Keyboard"
  RMDir /r "$INSTDIR\SearchPlugins"  ; Should search plugins be preserved?
  Delete "$INSTDIR\PCMan.exe"
  Delete "$INSTDIR\PCMan.exe.manifest"
  Delete "$INSTDIR\B2U"
  Delete "$INSTDIR\U2B"
  Delete "$INSTDIR\Story.txt"
  Delete "$INSTDIR\BBSList"
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"

  StrCmp $LANGUAGE 1028 Chi Eng
  Chi:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "是否連設定檔案一起刪除？" IDNO +6
    Goto +2
  Eng:
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to delete config files?" IDNO +3
  RMDir /r "$INSTDIR\Config"
  Delete "$INSTDIR\Symbols.txt"

  Delete "$SMPROGRAMS\${PRODUCT_DIR}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_DIR}\Website.lnk"
  Delete "$DESKTOP\Open PCMan 2007.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_DIR}\Open PCMan 2007.lnk"
  StrCmp $LANGUAGE 1028 Chi2 Eng2
  Chi2:
    Delete "$SMPROGRAMS\${PRODUCT_DIR}\標點符號輸入程式.lnk"
    Goto +2
  Eng2:
    Delete "$SMPROGRAMS\${PRODUCT_DIR}\Symbols.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_DIR}"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd