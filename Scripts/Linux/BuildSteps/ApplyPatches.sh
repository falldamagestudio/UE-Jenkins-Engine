#!/bin/bash

ScriptRoot=$(dirname "$0")

UE_LOCATION="${ScriptRoot}/../../../UE"

############ Patch Engine/Build/BatchFiles/Linux/SetupToolchain.sh ###################

# In UE 4.26.1, the original file is written to assume that UE is a root-level module,
#   and tries to write stuff into the .git folder
# We have UE as a submodule and need to patch that logic

SOURCESTRING='TOOLCHAIN_CACHE=../.git/ue4-sdks/'
# The ampersands need to be escaped because sed treats them as 'replace with whole source string please' markers otehrwise
TARGETSTRING='TOOLCHAIN_CACHE="$([ -d ../.git ] \&\& echo "../.git" || echo "../$(cat ../.git | cut -d " " -f 2)")/ue4-sdks/"'

# When UE is a root-level repo, .git will be a folder and then the TOOLCHAIN_CACHE becomes this:
#   ../.git/ue4-sdks/
#
# However, when UE is a submodule, .git will not be a folder but a file with content looking like this for example:
#	gitdir: ../.git/modules/UE
# and then the TOOLCHAIN_CACHE becomes something like this:
#  ../../.git/modules/UE/ue4-sdks/

sed "s:$SOURCESTRING:$TARGETSTRING:" "${UE_LOCATION}/Engine/Build/BatchFiles/Linux/SetupToolchain.sh" > "${UE_LOCATION}/Engine/Build/BatchFiles/Linux/SetupToolchain2.sh"
mv -f "${UE_LOCATION}/Engine/Build/BatchFiles/Linux/SetupToolchain2.sh" "${UE_LOCATION}/Engine/Build/BatchFiles/Linux/SetupToolchain.sh"
chmod ugo+x "${UE_LOCATION}/Engine/Build/BatchFiles/Linux/SetupToolchain.sh"
