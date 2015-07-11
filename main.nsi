# ConVEX Installer installs the Convex library, Yagarto Tools, and Highwayman's New ConVEX Project Plugin
#	Copyright 2015 Jacob Knaup
/*  This file is part of ConVEX Installer.

    ConVEX Installer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    ConVEX Installer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

    The author can be contacted on VEXFORUM.COM as Highwayman
*/

# include modern ui
!include MUI2.nsh

Var WORKSPACE
Var PROSINSTALLFOLDER
Function .onInit
	StrCpy $workspace '$PROFILE\pros'
	StrCpy $PROSINSTALLFOLDER '$PROGRAMFILES\PROS'
 FunctionEnd

!define MUI_PAGE_HEADER_TEXT 'ConVEX Installer'
!define MUI_FINISHPAGE_NOAUTOCLOSE

!define MUI_WELCOMEPAGE_TITLE 'Welcome to the ConVEX Installer'
!define MUI_WELCOMEPAGE_TEXT 'This wizard will guide you through the installation of the Convex library, ConVEX New Project Plugin for PROS, and Yagarto Tools. You must have already installed PROS before installing Convex.'
!insertmacro MUI_PAGE_WELCOME

!define MUI_LICENSEPAGE_TEXT_TOP 'All software included in this installer is licensed under the GNU General Public License.'
!define MUI_LICENSEPAGE_BUTTON 'I Agree'
!insertmacro MUI_PAGE_LICENSE 'data\licenses\GPL License.txt'

!define MUI_COMPONENTSPAGE_TEXT_TOP 'Select the components to install. It is recommended that you install all components.'
!insertmacro MUI_PAGE_COMPONENTS

!define MUI_DIRECTORYPAGE_TEXT_TOP 'Ensure the directory of the PROS workspace is correct. Default is $PROFILE\pros'
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION 'PROS Workspace'
!define MUI_DIRECTORYPAGE_VARIABLE $workspace
!insertmacro MUI_PAGE_DIRECTORY


!define MUI_DIRECTORYPAGE_TEXT_TOP 'Enter the directory of the PROS installation. Default is $PROGRAMFILES\PROS'
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION 'PROS Installation'
!define MUI_DIRECTORYPAGE_VARIABLE $PROSINSTALLFOLDER
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_INSTFILESPAGE_ABORTHEADER_TEXT 'Aborted'
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE 'ConVEX successfully installed'
!define MUI_FINISHPAGE_TEXT 'To complete the installation of the New ConVEX Project Plugin launch PROS as administrator'
!define MUI_FINISHPAGE_RUN '$PROSINSTALLFOLDER\ccide.exe'
!define MUI_FINISHPAGE_RUN_TEXT 'Launch PROS as administrator'
!define MUI_FINISHPAGE_RUN_PARAMETERS 'Run as administrator'
!define MUI_FINISHPAGE_LINK 'Open the Convex documentation'
!define MUI_FINISHPAGE_LINK_LOCATION 'https://jpearman.github.io/convex/doxygen/html/basics.html'
!define MUI_FINISHPAGE_NOREBOOTSUPPORT
!insertmacro MUI_PAGE_FINISH

!define MUI_WELCOMEPAGE_TITLE 'ConVEX Uninstaller'
!define MUI_WELCOMEPAGE_TEXT 'This wizard will uninstall ConVEX.'
!insertMacro MUI_UNPAGE_WELCOME

!insertMacro MUI_UNPAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE 'ConVEX Uninstalled'
!define MUI_FINISHPAGE_TEXT 'ConVEX has been uninstalled'
!insertMacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE 'English'

;ReserveFile folder/license.txt

# define installer name
Name 'ConVEX'
OutFile "ConVEX-Setup.exe"
 
# set desktop as install directory
InstallDir '$workspace'

RequestExecutionLevel highest
 

Section 'Convex library' cvlib
 
# define output path
SetOutPath $workspace
 
# specify extract convex library (& ChibiOS)
File /r data\convex-library\*.*

SectionEnd

Section 'Make Utility' make

# define output path
SetOutPath $workspace

#extract make utility
File /r 'data\make-util\*.*'

SectionEnd

Section 'New ConVEX Project Plugin' plugin

# change output path to PROS plugins folder
SetOutPath '$ProsInstallFolder\plugins'

#copy proper new project plugin
File 'data\New-convex-project-plugin\*.*'

SectionEnd

# default section start
Section
 
# define uninstaller name
WriteUninstaller '$workspace\ConVEX_uninstaller.exe'
 
#-------
# default section end
SectionEnd

LangString DESC_cvlib ${LANG_ENGLISH} "The Convex library is the main component, and is required to program the Cortex using Convex. Only uncheck if already installed."
LangString DESC_make ${LANG_ENGLISH} "The make utility is used to compile Convex projects."
LangString DESC_plugin ${LANG_ENGLISH} "The New ConVEX Project Plugin is used to easily start new Convex projects within PROS. It is not necessary but is recommended."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${cvlib} $(DESC_cvlib)
  !insertmacro MUI_DESCRIPTION_TEXT ${make} $(DESC_make)
  !insertmacro MUI_DESCRIPTION_TEXT ${plugin} $(DESC_plugin)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

 
# create a section to define what the uninstaller does.
# the section will always be named "Uninstall"
Section "Uninstall"

# change path to user folder so we can delete install directory
SetOutPath '$PROFILE'
 
# Always delete uninstaller first
Delete $workspace\uninstaller.exe
 
# now remove install directory
RMDir /r '$workspace\convex\'
RMDir /r '$workspace\chibiOS_2.6.0\'
RMDir /r '$workspace\ChibiOS_2.6.2\'

#remove the make utility
Delete '$workspace\make.exe'

# remove the new project plugin
Delete '$ProsInstallFolder\tk.Knaup.NewConVEXProject_1.0.4.jar'

SectionEnd