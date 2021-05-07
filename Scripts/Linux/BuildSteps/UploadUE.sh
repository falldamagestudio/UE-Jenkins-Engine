#!/bin/bash

CloudStorageBucket="$1"
BuildId="$2"

ScriptRoot=$(dirname "$0")

UELocation="${ScriptRoot}/../../../UE"
EngineBuildLocation="${UELocation}/LocalBuilds/Engine/Linux"
EngineBuildId="engine-${BuildId}-linux"

"${ScriptRoot}/../Shell/Upsync-EngineBuild.sh" "$EngineBuildLocation" "$CloudStorageBucket" "$EngineBuildId"
