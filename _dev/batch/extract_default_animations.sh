#!/usr/bin/env bash
# Extract and decompile TF2's default viewmodel animations.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

classes=(scout soldier pyro demo heavy engineer medic sniper spy)
mdl_pkg="$tf_folder/tf2_misc_dir.vpk"

mkdir -p "$animations_folder"

need_extract=0
for cls in "${classes[@]}"; do
    [[ -f "$animations_folder/c_${cls}_animations.qc" ]] || need_extract=1
done

if (( ! need_extract )) && [[ -f "$animations_folder/animations_already_extracted.txt" ]]; then
    echo "Animations already extracted. Skipping extraction..."
    exit 0
fi

echo "First script run detected..."
echo "Extracting animations..."
[[ -f "$mdl_pkg" ]] || die "Could not find $mdl_pkg"

rm -rf "$animations_folder"
mkdir -p "$animations_folder"

for cls in "${classes[@]}"; do
    item="models\\weapons\\c_models\\c_${cls}_animations.mdl"
    hlextract "$mdl_pkg" "$animations_folder" "$item" >/dev/null 2>&1 || true
    [[ -f "$animations_folder/c_${cls}_animations.mdl" ]] || \
        die "Failed to extract $item from tf2_misc_dir.vpk"
done

echo "Decompiling animations..."
for cls in "${classes[@]}"; do
    mdl="$animations_folder/c_${cls}_animations.mdl"
    decompile_mdl "$mdl" "$animations_folder" >/dev/null 2>&1 || \
        warn "CrowbarDecompiler failed on $(basename "$mdl")"
done

rm -f "$animations_folder"/*.mdl

for cls in "${classes[@]}"; do
    [[ -f "$animations_folder/c_${cls}_animations.qc" ]] || \
        die "Animation extraction failed: c_${cls}_animations.qc was not created."
done

printf 'If this file exists, the files have been extracted already.\n' \
    > "$animations_folder/animations_already_extracted.txt"

# Fix jittery idles on kunai-type knives and the Sharp Dresser.
for fix in acr_idle eternal_idle; do
    src="$dev_folder/extra_animation_fixes/$fix.smd"
    dst="$animations_folder/c_spy_animations_anims/$fix.smd"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -f "$src" "$dst"
    fi
done

echo "All animations have been extracted."
