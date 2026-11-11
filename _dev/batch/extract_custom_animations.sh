#!/usr/bin/env bash
# Check, decompile and install custom viewmodel animation VPKs.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

classes=(scout soldier pyro demo heavy engineer medic sniper spy)
custom_dir="$vm_customizer_folder/custom animations"
custom_out="$dev_folder/decompiled_custom_animations"
custom_tmp="$dev_folder/decompiled_custom_animations_temp"
incompat_dir="$custom_dir/incompatible animations"
list_file="$custom_dir/last_used_vpks"
saved_list="$custom_out/last_used_vpks"

mkdir -p "$custom_dir" "$custom_out"

mapfile -t vpks < <(find "$custom_dir" -maxdepth 1 -type f -iname '*.vpk' 2>/dev/null | sort)
if (( ${#vpks[@]} == 0 )); then
    exit 0
fi

printf '%s\n' "${vpks[@]}" > "$list_file"
if [[ -f "$saved_list" ]] && ! cmp -s "$list_file" "$saved_list"; then
    rm -rf "$custom_tmp" "$custom_out"
    mkdir -p "$custom_out"
fi

session_time="$(date +%H:%M:%S)"
session_date="$(date +%Y-%m-%d)"

studiomdl_available || die "studiomdl is required to check custom animations."

# Replace every $modelname line with the default one for this class.
fix_modelname() {
    local qc="$1" cls="$2" tmp="$1.modelname.$$"
    {
        printf '$modelname "weapons/c_models/c_%s_animations.mdl"\n' "$cls"
        grep -viF '$modelname' "$qc" || true
    } > "$tmp"
    mv -f "$tmp" "$qc"
}

# Rename duplicate "weights_r_handposes" weight lists (compile fix).
fix_weightlists() {
    local qc="$1" tmp="$1.weightlist.$$"
    awk '
        {
            raw = $0
            line = raw
            gsub(/\r$/, "", line)
            sub(/^[ \t]+/, "", line)
            sub(/[ \t]+$/, "", line)
            if (line == "$weightlist \"weights_r_handposes\" {") {
                if (seen) {
                    print "$weightlist \"weights_r_handposes_BUGGED\" {"
                } else {
                    seen = 1
                    print raw
                }
            } else {
                print raw
            }
        }
    ' "$qc" > "$tmp"
    mv -f "$tmp" "$qc"
}

# Insert the ball-throw activity that Crowbar's decompiler drops.
fix_pyro_ball() {
    local qc="$1" tmp="$1.ball.$$"
    [[ -f "$qc" ]] || return 0
    awk '
        {
            raw = $0
            line = raw
            gsub(/\r$/, "", line)
            sub(/^[ \t]+/, "", line)
            sub(/[ \t]+$/, "", line)
            if (line == "\"c_pyro_animations_anims\\PASSTIME_ball_throw_end.smd\"" ||
                line == "\"c_pyro_animations_anims/PASSTIME_ball_throw_end.smd\"") {
                print raw
                print "activity \"ACT_BALL_VM_THROW_END\" 1"
                skip = 1
                next
            }
            if (skip) {
                skip = 0
                next
            }
            print raw
        }
    ' "$qc" > "$tmp"
    mv -f "$tmp" "$qc"
}

log_incompatible() {
    local name="$1" reason="$2"
    local separator
    separator="$(printf '=%.0s' $(seq 1 200))"

    echo "		 $name is not compatible. Moving to \"incompatible animations\" folder..."
    mkdir -p "$incompat_dir"
    if [[ ! -f "$incompat_dir/_info.txt" ]]; then
        printf 'This folder contains all the incompatible animations.\n' > "$incompat_dir/_info.txt"
        printf 'It is safe to delete.\n' >> "$incompat_dir/_info.txt"
    fi
    mv -f "$custom_dir/$name" "$incompat_dir/$name" 2>/dev/null || true

    if [[ ! -f "$incompat_dir/_error_log.txt" ]]; then
        printf 'This file contains a list of all the errors encountered when trying to apply custom animations.\n' \
            > "$incompat_dir/_error_log.txt"
    fi
    {
        echo
        echo "$separator"
        echo "Package name: $name"
        echo "Session start time: $session_time / $session_date"
        case "$reason" in
        no_files)
            echo "Error: VPK does not contain any viewmodel animation files."
            ;;
        sca)
            echo "Error: Mod uses the Separated C_animations format. Only the default TF2 viewmodel animation format is supported."
            ;;
        compile_error)
            echo "Error: Failed to compile back after decompiling."
            echo "StudioMDL log:"
            cat "$custom_tmp/error_check.txt" 2>/dev/null || true
            ;;
        *)
            echo "Error: unknown"
            ;;
        esac
        echo "$separator"
    } >> "$incompat_dir/_error_log.txt"

    rm -rf "$custom_tmp"
    rm -f "$custom_out/error_check.txt"
}

echo "Checking custom animations:"

for vpk in "${vpks[@]}"; do
    name="$(basename "$vpk")"
    echo "Checking $name:"

    if [[ -f "$custom_out/$name.extracted" ]]; then
        echo "		 $name checked and installed."
        continue
    fi

    mkdir -p "$custom_out"
    rm -rf "$custom_tmp"
    mkdir -p "$custom_tmp"

    found_mdl=0
    for cls in "${classes[@]}"; do
        item="models\\weapons\\c_models\\c_${cls}_animations.mdl"
        hlextract "$vpk" "$custom_tmp" "$item" >/dev/null 2>&1 || true
        [[ -f "$custom_tmp/c_${cls}_animations.mdl" ]] && found_mdl=1
    done
    if (( ! found_mdl )); then
        log_incompatible "$name" no_files
        continue
    fi

    for cls in "${classes[@]}"; do
        mdl="$custom_tmp/c_${cls}_animations.mdl"
        [[ -f "$mdl" ]] || continue
        decompile_mdl "$mdl" "$custom_tmp" >/dev/null 2>&1 || \
            warn "CrowbarDecompiler failed on $(basename "$mdl")"
    done
    rm -f "$custom_tmp"/*.mdl

    for cls in "${classes[@]}"; do
        qc="$custom_tmp/c_${cls}_animations.qc"
        [[ -f "$qc" ]] || continue
        fix_modelname "$qc" "$cls"
        fix_weightlists "$qc"
    done
    fix_pyro_ball "$custom_tmp/c_pyro_animations.qc"

    if ! validate_qc_folder "$custom_tmp" "$custom_tmp/error_check.txt"; then
        log_incompatible "$name" compile_error
        continue
    fi
    if grep -qi 'error' "$custom_tmp/error_check.txt" 2>/dev/null; then
        log_incompatible "$name" compile_error
        continue
    fi

    sca=0
    for qc in "$custom_tmp"/c_*_animations.qc; do
        [[ -f "$qc" ]] || continue
        if grep -qiF '$includemodel' "$qc"; then
            sca=1
            break
        fi
    done
    if (( sca )); then
        log_incompatible "$name" sca
        continue
    fi

    printf 'If this file exists, %s has already been checked and extracted\n' "$name" \
        > "$custom_tmp/$name.extracted"
    echo "		 $name checked and installed."
    cp -a "$custom_tmp"/. "$custom_out"/
    rm -rf "$custom_tmp"
done

echo "All custom mods checked, compatible ones have been installed."
rm -rf "$custom_tmp"

# Rebuild the list of VPKs that remain in the folder.
mapfile -t remaining < <(find "$custom_dir" -maxdepth 1 -type f -iname '*.vpk' 2>/dev/null | sort)
rm -f "$list_file"
if (( ${#remaining[@]} )); then
    printf '%s\n' "${remaining[@]}" > "$list_file"
    mv -f "$list_file" "$saved_list"
fi
rm -f "$custom_out/error_check.txt"
