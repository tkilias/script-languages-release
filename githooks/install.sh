#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
REPO_DIR=$(git rev-parse --show-toplevel)
GIT_DIR="$REPO_DIR/.git"

if [[ ! -d "$GIT_DIR" ]]; then
    echo "$GIT_DIR is not a git directory." >&2
    exit 1
fi

copy_hook() {
    local SCRIPT_PATH="$SCRIPT_DIR/$1"
    local GITHOOKS_PATH="$GIT_DIR/hooks/"
    local GITHOOK_PATH="$GITHOOKS_PATH/$2"
    echo "Link $GITHOOK_PATH to $SCRIPT_PATH" >&2
    local RELATIVE_PATH=$(realpath --relative-to="$GITHOOKS_PATH" "$SCRIPT_PATH")
    echo $RELATIVE_PATH
    pushd "$GITHOOKS_PATH"
    ln -s "$RELATIVE_PATH" "$2"
    chmod +x "$2"
    popd
}

copy_hook pre-commit pre-commit
copy_hook pre-commit post-rewrite
