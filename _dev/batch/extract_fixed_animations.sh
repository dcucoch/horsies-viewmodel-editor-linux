#!/usr/bin/env bash
# Extract and validate animations from the "fixed viewmodels addon" VPK.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

classes=(scout soldier pyro demo heavy engineer medic sniper spy)
addon_dir="$vm_customizer_folder/fixed viewmodels addon"
fixed_dir="$dev_folder/decompiled_fixed_animations"
list_file="$addon_dir/last_used_vpks"
saved_list="$fixed_dir/last_used_vpks"
error_log="$fixed_dir/error_check.txt"

mkdir -p "$addon_dir"

# Current VPK list, recursive.
mapfile -t vpks < <(find "$addon_dir" -type f -iname '*.vpk' 2>/dev/null | sort)
if (( ${#vpks[@]} )); then
    printf '%s\n' "${vpks[@]}" > "$list_file"
else
    rm -f "$list_file"
fi

# Re-extract when the set of VPKs changed.
if [[ -f "$saved_list" ]] && ! cmp -s "$list_file" "$saved_list"; then
    rm -rf "$fixed_dir"
fi

if (( ${#vpks[@]} == 0 )); then
    echo "No fixed viewmodels VPK detected, skipping..."
    rm -f "$list_file" "$error_log"
    exit 0
fi

need_extract=0
for cls in "${classes[@]}"; do
    [[ -f "$fixed_dir/c_${cls}_animations.qc" ]] || need_extract=1
done
if (( ! need_extract )) && [[ -f "$fixed_dir/animations_already_extracted.txt" ]]; then
    echo "Fixed animations already extracted. Skipping..."
    rm -f "$list_file" "$error_log"
    exit 0
fi

studiomdl_available || die "studiomdl is required to validate fixed viewmodels."

# Use the last VPK found, matching the original tool's behavior.
fixed_vm_vpk="${vpks[${#vpks[@]}-1]}"

extract_fixed_fail() {
    echo "Bad fixed animations VPK detected. Skipping..."
    rm -rf "$fixed_dir"
    rm -f "$list_file"
    exit 0
}

echo "Extracting fixed animations..."
rm -rf "$fixed_dir"
mkdir -p "$fixed_dir"
for cls in "${classes[@]}"; do
    item="models\\weapons\\c_models\\c_${cls}_animations.mdl"
    hlextract "$fixed_vm_vpk" "$fixed_dir" "$item" >/dev/null 2>&1 || true
done

found_mdl=0
for cls in "${classes[@]}"; do
    [[ -f "$fixed_dir/c_${cls}_animations.mdl" ]] && found_mdl=1
done
(( found_mdl )) || extract_fixed_fail

echo "Decompiling fixed animations..."
for cls in "${classes[@]}"; do
    mdl="$fixed_dir/c_${cls}_animations.mdl"
    [[ -f "$mdl" ]] || continue
    decompile_mdl "$mdl" "$fixed_dir" >/dev/null 2>&1 || \
        warn "CrowbarDecompiler failed on $(basename "$mdl")"
done
rm -f "$fixed_dir"/*.mdl

# Round-trip check: compile the decompiled files and look for errors.
if ! validate_qc_folder "$fixed_dir" "$error_log"; then
    extract_fixed_fail
fi
if grep -qi 'error' "$error_log" 2>/dev/null; then
    extract_fixed_fail
fi

for cls in "${classes[@]}"; do
    [[ -f "$fixed_dir/c_${cls}_animations.qc" ]] || extract_fixed_fail
done

printf 'If this file exists, the files have been extracted already.\n' \
    > "$fixed_dir/animations_already_extracted.txt"

for fix in acr_idle eternal_idle; do
    src="$dev_folder/extra_animation_fixes/$fix.smd"
    dst="$fixed_dir/c_spy_animations_anims/$fix.smd"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -f "$src" "$dst"
    fi
done

echo "Fixed animations extracted..."
mv -f "$list_file" "$saved_list"
rm -f "$error_log"
exit 0
