#!/bin/bash

EngineBuildLocation="$1"
CloudStorageBucket="$2"
EngineBuildId="$3"

ScriptRoot=$(dirname "$0")

LongtailLocation="${ScriptRoot}/longtail-linux-x64"
VersionJsonURI="gs://${CloudStorageBucket}/engine-linux/${EngineBuildId}.json"

"${LongtailLocation}" \
    put \
    --source-path \
    $EngineBuildLocation \
    --target-path \
    $VersionJsonURI
