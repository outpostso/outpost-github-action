#!/bin/bash
set -euo pipefail

TOKEN="${PLUGIN_OUTPOST_TOKEN}"
VERSION="${PLUGIN_OUTPOST_VERSION:-0.0.0-$GITHUB_RUN_ID}"
VERSION_CMD="${PLUGIN_OUTPOST_VERSION_CMD:-}"
SHA="${PLUGIN_OUTPOST_SHA:-$GITHUB_SHA}"
USER="${PLUGIN_OUTPOST_USER:-$GITHUB_ACTOR}"
BRANCH="${GITHUB_REF_NAME}"

if [[ ${BUILDKITE_COMMAND_EXIT_STATUS:-0} != '0' ]]; then
  echo 'Skipping Outpost notification because the command failed'
  exit 0
fi

# Reads a list from plugin config into a global result array
# Returns success if values were read
plugin_read_list_into_result() {
  result=()

  for prefix in "$@" ; do
    local i=0
    local parameter="${prefix}_${i}"

    if [[ -n "${!prefix:-}" ]] ; then
      echo "🚨 Plugin received a string for $prefix, expected an array" >&2
      exit 1
    fi

    while [[ -n "${!parameter:-}" ]]; do
      result+=("${!parameter}")
      i=$((i+1))
      parameter="${prefix}_${i}"
    done
  done

  [[ ${#result[@]} -gt 0 ]] || return 1
}


# Parse plugin name if provided
NAME_ARRAY="["
comma=""
if plugin_read_list_into_result PLUGIN_OUTPOST_NAME ; then
  for arg in "${result[@]}" ; do
    NAME_ARRAY="${NAME_ARRAY}${comma}\"${arg}\""
    comma=","
  done
fi
NAME_ARRAY="${NAME_ARRAY}]"

if [[ "${NAME_ARRAY}" == "[]" ]]; then
    NAME_ARRAY="[\"$PIPELINE_SLUG\"]"
fi

if [[ -n $VERSION_CMD ]]; then
  VERSION=$($VERSION_CMD | tr -d '\n')
fi

curl --silent --request POST \
    --url https://deploy.outpost.so/v1/track \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/json" \
    --data '{"name": '"${NAME_ARRAY}"', "version": "'"$VERSION"'", "sha": "'"$SHA"'", "user": "'"$USER"'", "url": "'"$BUILDKITE_BUILD_URL"'", "branch": "'"$BRANCH"'"}'