#!/bin/bash

ScriptRoot=$(dirname "$0")

UELocation="${ScriptRoot}/../../../UE"

"${UELocation}/Engine/Build/BatchFiles/RunUAT.sh" BuildGraph -Script="Engine/Build/InstalledEngineBuild.xml" -Target="Make Installed Build Linux" -set:HostPlatformOnly=true -set:WithServer=true -set:WithClient=true -set:WithDDC=false
