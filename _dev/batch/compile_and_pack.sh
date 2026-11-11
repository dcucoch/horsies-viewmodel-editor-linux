#!/usr/bin/env bash
# Compile the edited animations and package them into a VPK.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

classes=(scout soldier pyro demo heavy engineer medic sniper spy)
qcs=(c_scout_animations.qc c_soldier_animations.qc c_pyro_animations.qc \
     c_demo_animations.qc c_heavy_animations.qc c_engineer_animations.qc \
     c_medic_animations.qc c_sniper_animations.qc c_spy_animations.qc)

if game_running; then
    echo "Error! Game is currently running." >&2
    echo "Please close the game and try again." >&2
    exit 1
fi

studiomdl_available || die "studiomdl was not found; cannot compile the animations."

_backup_models || die "Could not move the game's models folder out of the way."

compile_one() {
    local qc="$1" label="$2"
    echo "		 Compiling $label Animations..."
    compile_qc "$qc_folder_temp/$qc" || {
        _restore_models
        die "Compilation failed for $qc"
    }
}

if [[ "${apply_for_specific_classes:-false}" == "true" ]]; then
    for i in "${!classes[@]}"; do
        cls="${classes[$i]}"
        var="apply_per_class_$cls"
        [[ "${!var:-false}" == "true" ]] || continue
        compile_one "${qcs[$i]}" "$(tr '[:lower:]' '[:upper:]' <<< "${cls:0:1}")${cls:1}"
    done
else
    for i in "${!classes[@]}"; do
        cls="${classes[$i]}"
        compile_one "${qcs[$i]}" "$(tr '[:lower:]' '[:upper:]' <<< "${cls:0:1}")${cls:1}"
    done
fi

if [[ ! -d "$tf_folder/models" ]]; then
    _restore_models
    die "Compilation produced no models folder."
fi

rm -rf "$dev_folder/create_vpk_temp"
mkdir -p "$dev_folder/create_vpk_temp"
mv "$tf_folder/models" "$dev_folder/create_vpk_temp/models" || {
    _restore_models
    die "Could not move the compiled models into the VPK staging folder."
}
_restore_models

rm -rf "$dev_folder/$vpk_name"
mv "$dev_folder/create_vpk_temp" "$dev_folder/$vpk_name"

# Remove old output and stale caches.
rm -f "$dev_folder/$vpk_name.vpk"
rm -f "$custom_folder/$vpk_name.vpk.sound.cache"
rm -f "$custom_folder/$vpk_name.vpk"

# Preload files and the cfg directory.
cp -a "$dev_folder/preload_files/." "$dev_folder/$vpk_name/"
mkdir -p "$dev_folder/$vpk_name/cfg"

if [[ "${automatic_preloading:-off}" == "on" || \
      "${disable_tracers:-off}" == "on" || \
      "${hide_errors:-off}" == "on" ]]; then
    hlextract "$tf_folder/tf2_misc_dir.vpk" "$dev_folder/$vpk_name/cfg" \
        "cfg\\valve.rc" >/dev/null 2>&1 || \
        warn "Could not extract cfg/valve.rc from tf2_misc_dir.vpk."

    cd "$dev_folder/$vpk_name/cfg" || exit 1
    [[ -f valve.rc ]] && mv -f valve.rc valve_rc_temp

    custom_valve_rc="$(find "$custom_folder" -type f -name valve.rc -print -quit 2>/dev/null)"
    if [[ -n "$custom_valve_rc" && -f "$custom_valve_rc" ]]; then
        cp -f "$custom_valve_rc" valve_rc_temp
    fi
    [[ -f valve_rc_temp ]] && mv -f valve_rc_temp valve.rc

    printf '\n' >> valve.rc
    [[ "${automatic_preloading:-off}" == "on" ]] && \
        echo 'exec horsies_viewmodel_editor/preloading.cfg' >> valve.rc
    [[ "${disable_tracers:-off}" == "on" ]] && \
        echo 'r_drawtracers_firstperson 0' >> valve.rc
    [[ "${hide_errors:-off}" == "on" ]] && \
        echo 'con_filter_enable 1; con_filter_text_out "particle"' >> valve.rc
fi

# Create the VPK.
pack_vpk "$dev_folder/$vpk_name" || die "VPK packaging failed."
if [[ ! -f "$dev_folder/$vpk_name.vpk" ]]; then
    # Some native vpk builds write the archive in the current directory.
    if [[ -f "$PWD/$vpk_name.vpk" ]]; then
        mv -f "$PWD/$vpk_name.vpk" "$dev_folder/$vpk_name.vpk"
    fi
fi
[[ -f "$dev_folder/$vpk_name.vpk" ]] || die "VPK packaging did not produce $vpk_name.vpk."

rm -rf "$dev_folder/$vpk_name"

# Remove VPKs made by older versions of the editor.
rm -f "$custom_folder/_Horsie'sViewmodelEditor.vpk.sound.cache"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_dir.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_000.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_001.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_002.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_003.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor_004.vpk"
rm -f "$custom_folder/_Horsie'sViewmodelEditor.vpk"

mkdir -p "$custom_folder"
mv -f "$dev_folder/$vpk_name.vpk" "$custom_folder/$vpk_name.vpk" || \
    die "Could not move the generated VPK into $custom_folder."

echo "Done! Installed $vpk_name.vpk."
