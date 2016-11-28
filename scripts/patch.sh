#!/bin/bash

set -e
shopt -s nullglob

. "$GRAVITONDIR"/scripts/modules.sh

TMPDIR="$GRAVITON_BUILDDIR"/tmp

mkdir -p "$TMPDIR"

PATCHDIR="$TMPDIR"/patching
trap 'rm -rf "$PATCHDIR"' EXIT

for module in $GRAVITON_MODULES; do
	echo "--- Patching module '$module' ---"

	git clone -s -b base --single-branch "$GRAVITONDIR/$module" "$PATCHDIR" 2>/dev/null

	cd "$PATCHDIR"
	for patch in "$GRAVITONDIR/patches/$module"/*.patch; do
		git -c user.name='Graviton Patch Manager' -c user.email='graviton@void.example.com' -c commit.gpgsign=false am --whitespace=nowarn --committer-date-is-author-date "$patch"
	done

	cd "$GRAVITONDIR/$module"
	git fetch "$PATCHDIR" 2>/dev/null
	git checkout -B patched FETCH_HEAD
	git submodule update --init --recursive

	rm -rf "$PATCHDIR"
done
