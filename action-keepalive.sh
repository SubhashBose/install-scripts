#!/usr/bin/env bash
#This will keep the GitHub Action active by making periodic empty commits.
#export the variables to set values other than defaults before calling the script.
# $ curl -sL https://raw.githubusercontent.com/SubhashBose/install-scripts/refs/heads/main/action-keepalive.sh | bash

if [[ -z "$DAYS_ELAPSED" ]]; then
  DAYS_ELAPSED='50'
fi
if [[ -z "$USE_API" ]]; then
  USE_API=false   # If false empty commits will be made
fi
if [[ -z "$COMMIT_USERNAME" ]]; then
  COMMIT_USERNAME=KeepAliveBot
fi
if [[ -z "$COMMIT_EMAIL" ]]; then
  COMMIT_EMAIL=keep@alive
fi
if [[ -z "$COMMIT_MESSAGE" ]]; then
  COMMIT_MESSAGE='Keeping alive'
fi

#Example workflow.yml
: <<'EXAMPLE'
name: Keep Alive example
on:
  #push:
  workflow_dispatch:
permissions:
  contents: write  # For non-API, i.e commit mode
  actions: write   # For API use mode

jobs:
  check-expiry:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Keeping alive by Re-enabling workflow using API
        env:
          DAYS_ELAPSED: 55
          USE_API: true
          GH_TOKEN: ${{ github.token }}
        run: curl -sL https://raw.githubusercontent.com/SubhashBose/install-scripts/refs/heads/main/action-keepalive.sh | bash
      
      - name: Keep alive by empty commits
        env:
          DAYS_ELAPSED: 55
        run: curl -sL https://raw.githubusercontent.com/SubhashBose/install-scripts/refs/heads/main/action-keepalive.sh | bash
EXAMPLE

set -o nounset
set -o errexit
set -o pipefail
if [ "${TRACE-0}" -eq 1 ]; then set -o xtrace; fi


# Get the last commit date for the current branch
LAST_COMMIT_DATE=$(git log -1 --format="%ct")
CURRENT_DATE=$(date "+%s")
TIME_DIFFERENCE=$((CURRENT_DATE - LAST_COMMIT_DATE))
DAYS_AGO=$((TIME_DIFFERENCE / (60 * 60 * 24)))
echo "Last commit is '$DAYS_AGO' days ago"

if [ "$DAYS_AGO" -gt "$DAYS_ELAPSED" ]; then
    echo "$DAYS_AGO > $DAYS_ELAPSED -> Keep alive"
    if [ $USE_API = true ]; then
        #Required permission
        #permissions:
        #   actions: write
        #Also set env for the step
        #env:
        #  GH_TOKEN: ${{ github.token }}
        echo "Using API to keep alive"
        case "${GITHUB_WORKFLOW_REF:?}" in
          "${GITHUB_REPOSITORY:?}"/.github/workflows/*.y*ml@*) ;;
          *) false ;;
        esac
        workflow="${GITHUB_WORKFLOW_REF%%@*}"
        workflow="${workflow#${GITHUB_REPOSITORY}/.github/workflows/}"
        gh api -X PUT "repos/${GITHUB_REPOSITORY}/actions/workflows/${workflow}/enable"
    else
        #Required permission
        #permissions:
        #   contents: write
        echo "Adding empty commit"
        git config user.name "$COMMIT_USERNAME"
        git config user.email "$COMMIT_EMAIL"
        git commit --allow-empty -m "$COMMIT_MESSAGE"
        git push
    fi
    echo "done"
else
    echo "$DAYS_AGO <= $DAYS_ELAPSED -> nothing to do"
fi
