#!/bin/bash

ScriptRoot=$(dirname "$0")

UELocation="${ScriptRoot}/../../../UE"

cd ${UELocation}

# Run GitDependencies once, in a mode where diffs are force-overwritten
# GitDepedencies will be invoked again by Setup.sh, but then in 'prompt for any changes'
#   mode; Jenkins will hang when any user input is requested; by running it once in
#   force-overwrite mode first we ensure that there will be no conflicts during the second run
#./Engine/Build/BatchFiles/Linux/GitDependencies.sh --force

#./Setup.sh
