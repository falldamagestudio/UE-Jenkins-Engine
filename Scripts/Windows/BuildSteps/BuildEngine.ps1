cd "${PSScriptRoot}\..\..\..\UE"

. Engine\Build\BatchFiles\RunUAT.bat BuildGraph -Script="Engine/Build/InstalledEngineBuild.xml" -Target="Make Installed Build Win64" -set:HostPlatformOnly=true -set:WithServer=true -set:WithClient=true -set:WithDDC=false -set:VS2019=true