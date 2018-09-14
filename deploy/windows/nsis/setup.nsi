;
; Copyright (c) 2017 Alex Spataru <https://github.com/alex-spataru>
;
; Se concede permiso, libre de cargos, a cualquier persona que obtenga una copia
; de este software y de los archivos de documentación asociados (el "Software"),
; para utilizar el Software sin restricción, incluyendo sin limitación los
; derechos a usar, copiar, modificar, fusionar, publicar, distribuir,
; sublicenciar, y/o vender copias del Software, y a permitir a las personas a
; las que se les proporcione el Software a hacer lo mismo, sujeto a las
;  siguientes condiciones:
;
; El aviso de copyright anterior y este aviso de permiso se incluirán en todas
; las copias o partes sustanciales del Software.
;
; EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O
; IMPLÍCITA, INCLUYENDO PERO NO LIMITADA A GARANTÍAS DE COMERCIALIZACIÓN,
; IDONEIDAD PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN. EN NINGÚN CASO LOS
; AUTORES O PROPIETARIOS DE LOS DERECHOS DE AUTOR SERÁN RESPONSABLES DE NINGUNA
; RECLAMACIÓN, DAÑOS U OTRAS RESPONSABILIDADES, YA SEA EN UNA ACCIÓN DE
; CONTRATO, AGRAVIO O CUALQUIER OTRO MOTIVO, DERIVADAS DE, FUERA DE O EN
; CONEXIÓN CON EL SOFTWARE O SU USO U OTRO TIPO DE ACCIONES EN EL SOFTWARE.
;

!include "MUI2.nsh"
!include "LogicLib.nsh"

!define APPNAME                      "Ground Station Software"
!define UNIXNAME                     "cansat-gss"
!define COMPANYNAME                  "Ka'an Sat"
!define DESCRIPTION                  "Software de la estación terrena"
!define VERSIONMAJOR                 0
!define VERSIONMINOR                 1
!define VERSIONBUILD                 0
!define ESTIMATED_SIZE               60000
!define MUI_ABORTWARNING
!define INSTALL_DIR                  "$PROGRAMFILES\${APPNAME}"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT      "Run ${APPNAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION  "RunApplication"
!define MUI_FINISHPAGE_LINK          "Visitar página web"
!define MUI_FINISHPAGE_LINK_LOCATION "http://unaq.com.mx"
!define MUI_WELCOMEPAGE_TITLE        "Bienvenido/a al instalador del ${APPNAME}!"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Spanish"

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin"
        messageBox mb_iconstop "Se requieren derechos de administrador!"
        setErrorLevel 740
        quit
${EndIf}
!macroend

Name "${APPNAME}"
ManifestDPIAware true
InstallDir "${INSTALL_DIR}"
RequestExecutionLevel admin
OutFile "${UNIXNAME}-${VERSIONMAJOR}.${VERSIONMINOR}${VERSIONBUILD}-setup.exe"

Function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
FunctionEnd

Section "${APPNAME} (required)" SecDummy
  SectionIn RO
  SetOutPath "${INSTALL_DIR}"
  File /r "${APPNAME}\*"
  DeleteRegKey HKCU "Software\${COMPANYNAME}\${APPNAME}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"

  WriteUninstaller "${INSTALL_DIR}\uninstall.exe"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName"     "${APPNAME}"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "${INSTALL_DIR}\uninstall.exe"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "${INSTALL_DIR}"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher"       "${COMPANYNAME}"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon"     "${INSTALL_DIR}\bin\${APPNAME}.exe"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion"   ${VERSIONMAJOR}.${VERSIONMINOR}${VERSIONBUILD}
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor"     ${VERSIONMAJOR}
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor"     ${VERSIONMINOR}
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify"         1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair"         1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize"    ${ESTIMATED_SIZE}

SectionEnd

Section "Start Menu Shortcuts"
  CreateShortCut  "$SMPROGRAMS\${APPNAME}.lnk" "${INSTALL_DIR}\bin\${APPNAME}.exe" "" "${INSTALL_DIR}\bin\${APPNAME}.exe" 0
SectionEnd

Function RunApplication
  ExecShell "" "${INSTALL_DIR}\bin\${APPNAME}.exe"
FunctionEnd

Function un.onInit
	SetShellVarContext all
	MessageBox MB_OKCANCEL|MB_ICONQUESTION "Realmente quiere desinstalar ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
FunctionEnd

Section "Uninstall"
  RMDir /r "${INSTALL_DIR}"
  RMDir /r "$SMPROGRAMS\${APPNAME}.lnk"
  DeleteRegKey HKCU "Software\${COMPANYNAME}\${APPNAME}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
SectionEnd
