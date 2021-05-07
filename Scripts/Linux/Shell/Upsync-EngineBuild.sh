#!/bin/bash

EngineBuildLocation="$1"
CloudStorageBucket="$2"
EngineBuildId="$3"

ScriptRoot=$(dirname "$0")

LongtailLocation="${ScriptRoot}/longtail-linux-x64"
VersionIndexURI="gs://${CloudStorageBucket}/engine-linux/index/${EngineBuildId}.lvi"
StorageURI="gs://${CloudStorageBucket}/engine-linux/storage"

# "${LongtailLocation}" \
#     upsync \
#     --source-path \
#     $EngineBuildLocation \
#     --target-path \
#     $VersionIndexURI \
#     --storage-uri \
#     $StorageURI
