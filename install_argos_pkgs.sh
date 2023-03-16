#!/usr/bin/env bash
set -e

argospm update
for pkg in $((argospm search -f en -t uk && argospm search -f uk -t en) | cut -d: -f1); do
    echo -n "Installing $pkg..."
    argospm install $pkg
    echo "done"
done
