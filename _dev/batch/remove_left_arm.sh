#!/usr/bin/env bash
# Remove the left arm from a weapon's animations.
#
# Normally called from apply_settings() in apply_for_<class>.sh, which sets
# qc_file, smd_folder, the sequences and the flags. It also works on its own
# while debugging a weapon.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

remove_left_arm
