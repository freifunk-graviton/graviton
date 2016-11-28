#!/bin/bash

set -e
shopt -s nullglob

. "$GRAVITONDIR"/scripts/modules.sh

for module in $GRAVITON_MODULES; do
	echo "--- Updating patches for module '$module' ---"

	rm -f "$GRAVITONDIR"/patches/"$module"/*.patch
	mkdir -p "$GRAVITONDIR"/patches/"$module"

	cd "$GRAVITONDIR"/"$module"

	n=0
	for commit in $(git rev-list --reverse --no-merges base..patched); do
		let n=n+1
		git show --pretty=format:'From: %an <%ae>%nDate: %aD%nSubject: %B' --no-renames "$commit" > "$GRAVITONDIR/patches/$module/$(printf '%04u' $n)-$(git show -s --pretty=format:%f "$commit").patch"
	done
done
