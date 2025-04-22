#!/usr/bin/env bash
#This will keep the Github Action active, by making periodic empty commits.
#export the variables to set values otehr than defaults before calling the script.
# $ curl -sL https://raw.githubusercontent.com/SubhashBose/install-scripts/refs/heads/main/action-keepalive.sh | bash

if [[ -z "$COMMIT_USERNAME" ]]; then
  COMMIT_USERNAME=KeepAliveBot
fi
if [[ -z "$COMMIT_EMAIL" ]]; then
  COMMIT_EMAIL=keep@alive
fi
if [[ -z "$COMMIT_MESSAGE" ]]; then
  COMMIT_MESSAGE='Keeping alive'
fi
if [[ -z "$DAYS_ELAPSED" ]]; then
  DAYS_ELAPSED='50'
fi

set -o nounset
set -o errexit
set -o pipefail
if [ "${TRACE-0}" -eq 1 ]; then set -o xtrace; fi

git config user.name "$COMMIT_USERNAME"
git config user.email "$COMMIT_EMAIL"

# Get the last commit date for the current branch
LAST_COMMIT_DATE=$(git log -1 --format="%ct")
CURRENT_DATE=$(date "+%s")
TIME_DIFFERENCE=$((CURRENT_DATE - LAST_COMMIT_DATE))
DAYS_AGO=$((TIME_DIFFERENCE / (60 * 60 * 24)))
echo "Last commit is '$DAYS_AGO' days ago"

if [ "$DAYS_AGO" -gt "$DAYS_ELAPSED" ]; then
    echo "$DAYS_AGO > $DAYS_ELAPSED -> add empty commit"
    git commit --allow-empty -m "$COMMIT_MESSAGE"
    git push
    echo "done"
else
    echo "$DAYS_AGO <= $DAYS_ELAPSED -> nothing to do"
fi

