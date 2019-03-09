#!/bin/bash
#
# Basic shell script to merge specified CAF tag in repos tracked by Google's repo tool
#
# Usage (in root of ROM source):
#       repo forall -c bash $(pwd)/vendor/fred/scripts/merge-caf-tag.sh <tag_name>
#

TAG=$1
GIT_LINK="https://source.codeaurora.org/quic/la/"

if [[ $REPO_REMOTE != "caf" ]] && [[ $REPO_PATH != "manifest" ]]; then

        # Workaround for build/make as it lies in "platform/build" repo in AOSP/CAF
        if [[ $REPO_PATH = "build/make" ]]; then REPO_PATH="build"; fi

        # Check if it is a repo which is forked from AOSP
        wget -q --spider $GIT_LINK/platform/$REPO_PATH

        if [ $? -eq 0 ]; then
                # Find branch name from manifest & checkout
                branch=$(sed 's|refs\/heads\/||' <<< $REPO_RREV)
                git checkout -q $branch

                # Fetch the tag from AOSP
                git fetch -q $GIT_LINK/platform/$REPO_PATH $TAG

                # Store the current hash value of HEAD
                hash=$(git rev-parse HEAD)

                # Merge and inform user on succesful merge, by comparing hash
                git merge -q -m "Merge tag '$TAG' into $branch" FETCH_HEAD 
                if [ $? -eq 0 ]; then
                        if [[ $(git rev-parse HEAD) != $hash ]] && [[ $(git diff HEAD $REPO_REMOTE/$branch) ]]; then
                                echo -e "\n\e[34m$REPO_PATH merged succesfully\e[0m\n"
                        fi
                else
                        echo -e "\n\e[31m$REPO_PATH has merge errors\e[0m\n"
                fi
        fi
fi
