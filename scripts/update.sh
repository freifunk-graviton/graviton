#!/bin/bash

set -e

. "$GRAVITONDIR"/scripts/modules.sh

for module in $GRAVITON_MODULES; do
	echo "--- Updating module '$module' ---"
	var=$(echo "$module" | tr '[:lower:]/' '[:upper:]_')
	eval repo=\${${var}_REPO}
	eval branch=\${${var}_BRANCH}
	eval commit=\${${var}_COMMIT}

	mkdir -p "$GRAVITONDIR/$module"
	cd "$GRAVITONDIR/$module"
	git init

	if ! git branch -f base "$commit" 2>/dev/null; then
		git fetch "$repo" "$branch"
		git branch -f base "$commit" 2>/dev/null
	fi
done
