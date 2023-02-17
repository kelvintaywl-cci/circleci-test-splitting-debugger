#!/usr/bin/env bash

if [ ! $(command -v curl) ]; then
  echo "Missing curl"
  exit 1
fi

if [ ! $(command -v jq) ]; then
  echo "Missing jq"
  exit 1
fi

if [ -z "$CIRCLE_TOKEN" ]; then
  echo "CIRCLE_TOKEN env var is not set"
  exit 1
fi

if [ -z "$CIRCLE_PROJECT_NAME" ]; then
  echo "CIRCLE_PROJECT_NAME env var is not set"
  exit 1
fi

if [ -z "$CIRCLE_JOB_NUMBER" ]; then
  echo "CIRCLE_JOB_NUMBER env var is not set"
  exit 1
fi

mkdir -p /tmp

curl -s -H "Circle-Token: ${CIRCLE_TOKEN}" "https://circleci.com/api/v2/project/${CIRCLE_PROJECT_NAME}/${CIRCLE_JOB_NUMBER}/tests" > /tmp/metadata.json

if [ -n "$USE_CLASSNAME" ]; then
  # aggregate by class name
  jq ".items | group_by(.classname) | map({key: .[0].classname, value: map(.run_time) | add}) | sort_by(.value) | reverse | from_entries" /tmp/metadata.json > /tmp/testcases.json
else
  # aggregate by file name
  jq ".items | group_by(.file) | map({key: .[0].file, value: map(.run_time) | add}) | sort_by(.value) | reverse | from_entries" /tmp/metadata.json > /tmp/testcases.json
fi
