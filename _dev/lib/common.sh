#!/usr/bin/env bash
# Horsie's Viewmodel Editor - shared helpers.
#
# Sourced by the helper scripts. It finds the game folders by itself, so each
# script can also be run directly while debugging.

# ---------------------------------------------------------------------------
# Folders
# ---------------------------------------------------------------------------
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_dev_dir="$(dirname "$_lib_dir")"
: "${vm_customizer_folder:=$(dirname "$_dev_dir")}"
: "${dev_folder:=$_dev_dir}"
: "${batch_folder:=$dev_folder/batch}"

if [[ -z ${tf_folder:-} ]]; then
    _parent_name="$(basename "$(dirname "$vm_customizer_folder")")"
    if [[ "${_parent_name,,}" == "custom" ]]; then
        custom_folder="$(dirname "$vm_customizer_folder")"
        tf_folder="$(dirname "$custom_folder")"
    elif [[ "${_parent_name,,}" == "tf" ]]; then
        tf_folder="$(dirname "$vm_customizer_folder")"
        custom_folder="$tf_folder/custom"
    else
        tf_folder="$(dirname "$vm_customizer_folder")"
        custom_folder="$tf_folder/custom"
    fi
fi

: "${custom_folder:=$tf_folder/custom}"
: "${bin_folder:=$tf_folder/../bin}"
: "${animations_folder:=$dev_folder/decompiled_animations}"
: "${qc_folder_temp:=$dev_folder/decompiled_animations_temp}"
: "${custom_vm:=off}"
: "${fixed_vm_addon:=off}"

vpk_name="__Horsie'sViewmodelEditor"

# Weight-list / sequence data for the remove-left-arm feature.
# shellcheck source=remove_left_arm_data.sh
. "$_lib_dir/remove_left_arm_data.sh"

# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------
warn() { printf 'Warning: %s\n' "$*" >&2; }
info() { printf '%s\n' "$*"; }
die()  { printf 'Error: %s\n' "$*" >&2; exit 1; }

is_yes() { [[ "${1,,}" == "y" ]]; }

vpk_count() {
    local n=0 f
    for f in "$1"/*.vpk; do [[ -e "$f" ]] && n=$((n + 1)); done
    printf '%s' "$n"
}

any_vpk() {
    [[ -n "$(find "$1" -maxdepth 1 -type f -iname '*.vpk' -print -quit 2>/dev/null)" ]]
}

game_running() {
    pgrep -f 'tf_linux64|hl2_linux' >/dev/null 2>&1
}

# Append one line to a file.
append_line() {
    printf '%s\n' "$2" >> "$1"
}

# ---------------------------------------------------------------------------
# External tools
# ---------------------------------------------------------------------------
wine_bin="${WINE:-wine}"
have_wine() { command -v "$wine_bin" >/dev/null 2>&1; }

wine_run() {
    WINEDEBUG="${WINEDEBUG--all}" "$wine_bin" "$@"
}

wine_has_mono() {
    local prefix="${WINEPREFIX:-$HOME/.wine}"
    [[ -d "$prefix/drive_c/windows/mono" ]]
}

# Convert a Unix path into the form native Windows tools expect.
wine_path() {
    local p
    p="$(realpath -m -- "$1")"
    if command -v winepath >/dev/null 2>&1; then
        winepath -w "$p"
    else
        printf 'Z:%s\n' "${p//\//\\}"
    fi
}

# Use the bundled HLExtract, or a native build if one is installed.
hlextract() {
    local pkg="$1" dest="$2"
    shift 2
    local -a args=(-s -p "$pkg" -d "$dest")
    local item

    for item in "$@"; do
        args+=(-e "$item")
    done

    if [[ -n ${HLEXTRACT:-} ]]; then
        if [[ "$HLEXTRACT" == *.exe ]]; then
            wine_run "$HLEXTRACT" "${args[@]}"
        else
            "$HLEXTRACT" "${args[@]}"
        fi
    elif command -v HLExtract >/dev/null 2>&1; then
        HLExtract "${args[@]}"
    elif [[ -f "$dev_folder/HLExtract.exe" ]] && have_wine; then
        wine_run "$dev_folder/HLExtract.exe" "${args[@]}"
    else
        die "HLExtract was not found. Install Wine, or set HLEXTRACT=/path/to/HLExtract."
    fi
}

crowbar_mode() {
    if [[ -n ${CROWBAR:-} ]]; then
        echo "custom"
    elif command -v CrowbarDecompiler >/dev/null 2>&1; then
        echo "native"
    elif have_wine && [[ -f "$dev_folder/CrowbarDecompiler.exe" ]] && wine_has_mono; then
        # Wine Mono provides the VisualBasic runtime that distro Mono lacks.
        echo "wine"
    elif command -v mono >/dev/null 2>&1 && [[ -f "$dev_folder/CrowbarDecompiler.exe" ]]; then
        echo "mono"
    else
        echo "none"
    fi
}

decompiler_available() {
    [[ "$(crowbar_mode)" != "none" ]]
}

decompile_mdl() {
    local mdl out mode
    # Crowbar writes nothing with relative paths, so pass absolute ones.
    mdl="$(realpath -m -- "$1")"
    out="$(realpath -m -- "$2")"
    mkdir -p -- "$out"
    mode="$(crowbar_mode)"

    case "$mode" in
    custom)
        if [[ "$CROWBAR" == *.exe ]]; then
            wine_run "$CROWBAR" "$mdl" "$out"
        else
            "$CROWBAR" "$mdl" "$out"
        fi
        ;;
    native)
        CrowbarDecompiler "$mdl" "$out"
        ;;
    mono)
        mono "$dev_folder/CrowbarDecompiler.exe" "$mdl" "$out"
        ;;
    wine)
        wine_run "$dev_folder/CrowbarDecompiler.exe" "$mdl" "$out"
        ;;
    *)
        die "CrowbarDecompiler is unavailable. Install Mono (mono-runtime) or Wine Mono, or set CROWBAR=/path/to/decompiler."
        ;;
    esac
}

steam_common_dirs() {
    local vdf
    printf '%s\n' "$HOME/.local/share/Steam/steamapps/common"
    printf '%s\n' "$HOME/.steam/steam/steamapps/common"
    vdf="$HOME/.local/share/Steam/steamapps/libraryfolders.vdf"
    if [[ -f "$vdf" ]]; then
        awk -F'"' '
            /"path"/ {
                for (i = 1; i < NF; i++) {
                    if ($i != "path") continue
                    for (j = i + 1; j <= NF; j++) {
                        v = $j
                        gsub(/^[ \t]+|[ \t]+$/, "", v)
                        if (v != "") { print v "/steamapps/common"; break }
                    }
                    break
                }
            }
        ' "$vdf" 2>/dev/null
    fi
}

find_tool_in_steam() {
    local name="$1" d p
    while IFS= read -r d; do
        [[ -d "$d" ]] || continue
        for p in "$d"/*/bin/"$name" "$d"/*/bin/linux64/"$name" "$d"/*/bin/"$name.exe"; do
            if [[ -f "$p" ]]; then
                printf '%s\n' "$p"
                return 0
            fi
        done
    done < <(steam_common_dirs | sort -u)
    return 1
}

detect_studiomdl() {
    [[ -n ${STUDIOMDL:-} ]] && return 0
    local p
    for p in "$bin_folder/studiomdl" "$bin_folder/studiomdl.exe" \
             "$tf_folder/bin/studiomdl" "$tf_folder/bin/studiomdl.exe" \
             "$tf_folder/../bin/studiomdl" "$tf_folder/../bin/studiomdl.exe"; do
        if [[ -f "$p" ]]; then
            STUDIOMDL="$p"
            return 0
        fi
    done
    if p="$(find_tool_in_steam studiomdl)"; then
        STUDIOMDL="$p"
        return 0
    fi
    # Standalone Windows SDK installs (SteamCMD, forced platform).
    for p in "$HOME"/*/bin/studiomdl "$HOME"/*/bin/studiomdl.exe \
             "$HOME"/*/bin/linux64/studiomdl; do
        if [[ -f "$p" ]]; then
            STUDIOMDL="$p"
            return 0
        fi
    done
    return 1
}

studiomdl_available() { detect_studiomdl; }

compile_qc() {
    local qc="$1"
    detect_studiomdl || {
        warn "studiomdl was not found; skipping compile."
        return 127
    }

    (
        cd "$bin_folder" || exit 1
        if [[ "$STUDIOMDL" == *.exe ]]; then
            wine_run "$STUDIOMDL" -quiet -fastbuild -nop4 \
                -game "$(wine_path "$tf_folder")" "$(wine_path "$qc")"
        else
            "$STUDIOMDL" -quiet -fastbuild -nop4 -game "$tf_folder" "$qc"
        fi
    )
}

# Move tf/models aside during a test compile. Pair with _restore_models.
_models_backed_up=0
_backup_models() {
    local models_dir="$tf_folder/models"
    local backup="$tf_folder/models_backup"
    _models_backed_up=0
    if [[ -e "$models_dir" ]]; then
        # Remove a stale backup left by an interrupted run.
        rm -rf "$backup"
        mv "$models_dir" "$backup" || return 1
        _models_backed_up=1
    fi
    return 0
}

_restore_models() {
    rm -rf "$tf_folder/models"
    if (( _models_backed_up )); then
        mv "$tf_folder/models_backup" "$tf_folder/models"
        _models_backed_up=0
    fi
}

# Compile every c_*_animations.qc in a folder while checking whether the
# decompiled files survive a round-trip through studiomdl.
validate_qc_folder() {
    local folder="$1" log="$2" qc rc=0
    : > "$log"
    _backup_models || return 1
    for qc in "$folder"/c_*_animations.qc; do
        [[ -f "$qc" ]] || continue
        compile_qc "$qc" >> "$log" 2>&1 || rc=$?
    done
    _restore_models
    return "$rc"
}

detect_vpk_tool() {
    [[ -n ${VPK:-} ]] && return 0
    local p
    if p="$(command -v vpk 2>/dev/null)"; then
        VPK="$p"
        return 0
    fi
    if p="$(find_tool_in_steam vpk)"; then
        VPK="$p"
        return 0
    fi
    return 1
}

pack_vpk() {
    local dir="$1" vpk_dir
    if detect_vpk_tool; then
        if [[ "$VPK" == *.exe ]]; then
            wine_run "$VPK" "$dir" && return 0
        else
            # Valve's Linux vpk loads libs (libmimalloc.so, ...) from its own
            # bin folder, so point the loader there first.
            vpk_dir="$(dirname "$(realpath -m -- "$VPK")")"
            LD_LIBRARY_PATH="$vpk_dir${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
                "$VPK" "$dir" && return 0
        fi
        warn "Native vpk failed; falling back to the built-in packer."
    fi
    command -v python3 >/dev/null 2>&1 || \
        die "python3 is required for the built-in VPK packer."
    python3 "$dev_folder/lib/vpkpack.py" "$dir" "$dir.vpk"
}

check_install_dependencies() {
    local ok=0

    if ! have_wine && [[ -z ${HLEXTRACT:-} ]] && ! command -v HLExtract >/dev/null 2>&1; then
        warn "Wine is required to run the bundled HLExtract/Crowbar tools."
        warn "  Debian/Ubuntu: sudo apt install wine"
        warn "  See README.md for other distros."
        ok=1
    fi

    if ! decompiler_available; then
        warn "CrowbarDecompiler needs Wine Mono (recommended) or Mono."
        warn "  Run 'winecfg' once and accept the Wine Mono install prompt,"
        warn "  or install Mono: sudo apt install mono-runtime"
        ok=1
    fi

    if ! studiomdl_available; then
        warn "studiomdl was not found."
        warn "  Install Source SDK Base 2013 Multiplayer, use a Windows SDK"
        warn "  build via Wine, or set STUDIOMDL=/path/to/studiomdl(.exe)."
        warn "  See README.md for details."
        ok=1
    fi

    if ! command -v python3 >/dev/null 2>&1 && ! detect_vpk_tool; then
        warn "python3 is required for the built-in VPK packer."
        warn "  Debian/Ubuntu: sudo apt install python3"
        ok=1
    fi

    return "$ok"
}

# ---------------------------------------------------------------------------
# Settings
# ---------------------------------------------------------------------------
default_settings() {
    X_position=0; Y_position=0; Z_position=0
    X_rotation=0; Y_rotation=0; Z_rotation=0

    hidden=n
    keep_draw_visible=n
    keep_reload_visible=n
    keep_idle_visible=n
    keep_attack_visible=n
    keep_flames_visible=n
    keep_beam_visible=n
    keep_backstab_detection_visible=n
    keep_backstab_visible=n
    keep_tracers_visible=y
    keep_secondary_attack_visible=n

    static_draw=n
    static_reload=n
    static_attack=n
    more_static_idle=n
    remove_shells=n
    remove_left_arm=n
    remove_right_arm=n
    replace_reload_sound_with_stock=n

    instant_backstab_detection=n
    replace_backstab_with_normal_attack=n
    normal_attack=horizontal_swipe
    static_backstab_detection=n
    static_backstab=n

    static_secondary_attack=n
    turn_beam_into_trail_when_hidden=n
}

reset_settings() {
    draw_sequence=none
    draw_smd=none
    idle_sequence=none
    idle_smd=none

    attack_sequence_1=none; attack_sequence_2=none
    attack_sequence_3=none; attack_sequence_4=none
    attack_sequence_5=none; attack_sequence_6=none
    attack_smd_1=none; attack_smd_2=none
    attack_smd_3=none; attack_smd_4=none
    attack_smd_5=none; attack_smd_6=none

    secondary_attack_sequence_1=none
    secondary_attack_sequence_2=none
    secondary_attack_sequence_3=none
    secondary_attack_sequence_4=none
    secondary_attack_smd_1=none
    secondary_attack_smd_2=none
    secondary_attack_smd_3=none
    secondary_attack_smd_4=none

    reload_sequence_2_is_alternative_start=false
    reload_sequence_1=none; reload_sequence_2=none
    reload_sequence_3=none; reload_sequence_4=none
    reload_sequence_5=none; reload_sequence_6=none
    reload_sequence_7=none; reload_sequence_8=none
    reload_smd_1=none; reload_smd_2=none
    reload_smd_3=none; reload_smd_4=none
    reload_smd_5=none; reload_smd_6=none
    reload_smd_7=none; reload_smd_8=none

    other_sequence_1=none; other_sequence_2=none
    other_sequence_3=none; other_sequence_4=none
    other_sequence_5=none; other_sequence_6=none
    other_sequence_7=none; other_sequence_8=none

    sequence_1=none; sequence_2=none
    sequence_3=none; sequence_4=none
    sequence_5=none; sequence_6=none
    sequence_7=none; sequence_8=none
    sequence_9=none; sequence_10=none

    backstab_attack_sequence=none
    backstab_stun_sequence=none
    backstab_attack_smd=none
    backstab_stun_smd=none
    backstab_detect_sequence_up=none
    backstab_detect_sequence_down=none
    backstab_detect_sequence_idle=none
    backstab_detect_smd_up=none
    backstab_detect_smd_down=none
    backstab_detect_smd_idle=none
    poke_stab_smd=none
    horizontal_stab_smd=none
    diagonal_stab_smd=none
}

_set_setting() {
    local key="$1" value="$2"

    case "$key" in
    X_position|Y_position|Z_position|X_rotation|Y_rotation|Z_rotation)
        [[ "$value" =~ ^[+-]?[0-9]+$ ]] || value=0
        value="${value#+}"
        printf -v "$key" '%s' "$value"
        ;;
    "Hidden(y/n)")                          hidden="${value,,}" ;;
    "Keep_draw_visible(y/n)")               keep_draw_visible="${value,,}" ;;
    "Keep_reload_visible(y/n)")             keep_reload_visible="${value,,}" ;;
    "Keep_idle_visible(y/n)")               keep_idle_visible="${value,,}" ;;
    "Keep_attack_visible(y/n)")             keep_attack_visible="${value,,}" ;;
    "Keep_flames_visible(y/n)")             keep_flames_visible="${value,,}" ;;
    "Keep_beam_visible(y/n)")               keep_beam_visible="${value,,}" ;;
    "Keep_backstab_detection_visible(y/n)") keep_backstab_detection_visible="${value,,}" ;;
    "Keep_backstab_visible(y/n)")           keep_backstab_visible="${value,,}" ;;
    "Keep_tracers_visible(y/n)")            keep_tracers_visible="${value,,}" ;;
    "Keep_secondary_attack_visible(y/n)")   keep_secondary_attack_visible="${value,,}" ;;
    "Static_draw(y/n)")                     static_draw="${value,,}" ;;
    "Static_reload(y/n)")                   static_reload="${value,,}" ;;
    "Static_attack(y/n)")                   static_attack="${value,,}" ;;
    "More_static_idle(y/n)")                more_static_idle="${value,,}" ;;
    "Remove_shells(y/n)")                   remove_shells="${value,,}" ;;
    "Remove_left_arm(y/n)")                 remove_left_arm="${value,,}" ;;
    "Remove_right_arm(y/n)")                remove_right_arm="${value,,}" ;;
    "Replace_reload_sound_with_stock(y/n)") replace_reload_sound_with_stock="${value,,}" ;;
    "Instant_backstab_detection(y/n)")      instant_backstab_detection="${value,,}" ;;
    "Replace_backstab_with_normal_attack(y/n)") replace_backstab_with_normal_attack="${value,,}" ;;
    "Choose_normal_attack(poke/horizontal_swipe/diagonal_swipe)")
        normal_attack="${value,,}"
        ;;
    "Static_backstab_detection(y/n)")       static_backstab_detection="${value,,}" ;;
    "Static_backstab(y/n)")                 static_backstab="${value,,}" ;;
    "Static_secondary_attack(y/n)")         static_secondary_attack="${value,,}" ;;
    "Turn_beam_into_trail_when_hidden(y/n)") turn_beam_into_trail_when_hidden="${value,,}" ;;
    esac
}

extract_settings() {
    default_settings

    local file="$vm_customizer_folder/$settings_file"
    local label="$settings_label"
    local section line key value

    if [[ ! -f "$file" ]]; then
        warn "Settings file not found: $file"
        return 0
    fi

    section="$(
        awk -v want="$label" '
            {
                line = $0
                sub(/\r$/, "", line)
                sub(/^[ \t]+/, "", line)
                sub(/[ \t]+$/, "", line)
            }
            line ~ /^&::/ {
                if (found) exit
                if (line == want) { found = 1; next }
            }
            found { print line }
        ' "$file"
    )"

    if [[ -z "$section" ]]; then
        printf '\t\t%s label missing, skipping weapon...\n' "$label"
        return 0
    fi

    while IFS= read -r line; do
        line="${line%$'\r'}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        while [[ "${line:0:1}" == "•" ]]; do
            line="${line:1}"
        done
        [[ "$line" == *=* ]] || continue

        key="${line%%=*}"
        value="${line#*=}"
        key="${key%"${key##*[![:space:]]}"}"
        value="${value#"${value%%[![:space:]]*}"}"
        value="${value%"${value##*[![:space:]]}"}"

        _set_setting "$key" "$value"
    done <<< "$section"
}

# ---------------------------------------------------------------------------
# QC helpers
# ---------------------------------------------------------------------------
append_qc() {
    printf '%s\n' "$1" >> "$qc_file"
}

snap_to_draws() {
    [[ "$draw_sequence" == "none" ]] && return 0
    cd "$qc_folder_temp" || return 1
    append_qc "\$append $draw_sequence snap fadein 0.0 fadeout 0.1"
}

replace_snap() {
    cd "$qc_folder_temp" || return 1
    local tmp="snap_replaced.$$"
    awk '
        {
            raw = $0
            sub(/\r$/, "", raw)
            line = raw
            sub(/^[ \t]+/, "", line)
            sub(/[ \t]+$/, "", line)
        }
        line == "snap"        { has_snap = 1; next }
        line == "fadein 0.2"  { next }
        line == "fadeout 0.2" { next }
        line == "}" {
            if (has_snap) {
                print "fadein 0.0"
                print "fadeout 0.1"
            }
            has_snap = 0
            print raw
            next
        }
        { print raw }
    ' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
}

# Append/remove lines within the sequences named in $1...$n.
_qc_edit_sequences() {
    local action="$1"
    shift
    local tmp="qc_seq_edit.$$"
    local seqs
    seqs="$(printf '%s\n' "$@" | grep -v '^none$' | paste -sd ' ' -)"

    ACT="$action" SEQS="$seqs" awk '
        BEGIN {
            n = split(ENVIRON["SEQS"], a, " ")
            for (i = 1; i <= n; i++) want[a[i]] = 1
        }
        {
            raw = $0
            check = raw
            gsub(/[ \t\r]/, "", check)
            gsub(/"/, "", check)

            if (check ~ /^\$sequence/) {
                inside = 0
                for (name in want) {
                    if (check == "$sequence" name "{") { inside = 1; break }
                }
            }

            if (inside && ENVIRON["ACT"] == "remove_snap") {
                gsub(/snap/, "////snap", raw)
            } else if (inside && ENVIRON["ACT"] == "remove_blends") {
                gsub(/addlayer/, "////addlayer", raw)
                gsub(/blendlayer/, "////blendlayer", raw)
            }

            print raw

            if (check == "}") inside = 0
        }
    ' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
}

remove_snap_from_sequences() {
    cd "$qc_folder_temp" || return 1
    _qc_edit_sequences remove_snap "$@"
}

remove_blend_from_sequences() {
    cd "$qc_folder_temp" || return 1
    _qc_edit_sequences remove_blends "$@"
}

remove_blend_of_sequence() {
    cd "$qc_folder_temp" || return 1
    local seq tmp="qc_blend_remove.$$"
    local -a seqs=()
    for seq in "$@"; do
        [[ "$seq" == "none" ]] || seqs+=("$seq")
    done
    ((${#seqs[@]})) || return 0

    SEQS="$(printf '%s\n' "${seqs[@]}" | paste -sd ' ' -)" awk '
        BEGIN {
            n = split(ENVIRON["SEQS"], a, " ")
            for (i = 1; i <= n; i++) {
                want[a[i]] = 1
                low[a[i]] = tolower(a[i])
            }
        }
        {
            line = tolower($0)
            drop = 0
            for (name in low) {
                if (line ~ ("blendlayer[ \t]+\"" low[name] "\"") ||
                    line ~ ("addlayer[ \t]+\"" low[name] "\"")) {
                    drop = 1
                    break
                }
            }
            if (!drop) print
        }
    ' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
}

# ---------------------------------------------------------------------------
# Hiding / positioning
# ---------------------------------------------------------------------------
# Origin used for the reload phase of hide_weapon(). Spy backstab hiding
# runs afterwards and inherits it, so the calculation stays here.
_reload_hide_origin() {
    local value="origin 0 -170 5"
    [[ "$attack_sequence_2" == "fire_loop" ]] && value="origin 0 -9999 999"
    [[ "$attack_sequence_1" == "ft_fire" ]] && value="origin 0 -999 -999"
    [[ "$keep_flames_visible" == "y" ]] && value="origin 0 -85 35"
    [[ "$keep_beam_visible" == "y" ]] && value="origin 0 -85 50"
    [[ "$attack_sequence_1" == "db_fire" ]] && value="origin 0 -242 5"
    [[ "$settings_label" == "&::sapper" ]] && value="origin 0 -9999 9999"
    printf '%s' "$value"
}

hide_weapon() {
    [[ "$hidden" == "y" ]] || return 0

    cd "$qc_folder_temp" || return 1

    local hide_origin_value="origin 0 -170 5"
    local seq

    if [[ "$attack_sequence_2" == "fire_loop" ]]; then
        hide_origin_value="origin 0 -9999 9999"
    fi
    if [[ "$attack_sequence_1" == "ft_fire" ]]; then
        hide_origin_value="origin 0 -999 -999"
    fi
    [[ "$keep_flames_visible" == "y" ]] && hide_origin_value="origin 0 -85 35"
    [[ "$keep_beam_visible" == "y" ]] && hide_origin_value="origin 0 -85 50"
    [[ "$attack_sequence_1" == "db_fire" ]] && hide_origin_value="origin 0 -242 5"
    [[ "$settings_label" == "&::sapper" ]] && hide_origin_value="origin 0 -9999 9999"

    _hide_one "$draw_sequence" "$keep_draw_visible" "$hide_origin_value"
    _hide_one "$idle_sequence" "$keep_idle_visible" "$hide_origin_value"

    hide_origin_value="origin 0 -170 5"
    if [[ "$attack_sequence_2" == "fire_loop" ]]; then
        hide_origin_value="origin 0 -9999 9999"
    fi
    if [[ "$attack_sequence_1" == "ft_fire" ]]; then
        hide_origin_value='origin 0 -999 -999 blend "animation_destroyer" 0 0'
    fi
    [[ "$keep_flames_visible" == "y" ]] && hide_origin_value="origin 0 -85 35"
    [[ "$keep_beam_visible" == "y" ]] && hide_origin_value="origin 0 -85 50"
    [[ "$attack_sequence_1" == "db_fire" ]] && hide_origin_value="origin 0 -242 5"
    [[ "$settings_label" == "&::sapper" ]] && hide_origin_value="origin 0 -9999 9999"
    if [[ "$attack_sequence_2" != "fire" && "$attack_sequence_1" != "ft_fire" && "$keep_tracers_visible" == "n" ]]; then
        hide_origin_value='origin 0 -400 0 blend "animation_destroyer" 0 0'
    fi
    if [[ "$turn_beam_into_trail_when_hidden" == "y" && "$attack_sequence_2" == "fire_loop" ]]; then
        hide_origin_value='origin 0 -9999 999 blend "animation_destroyer" 0 0'
    fi

    for seq in "$attack_sequence_1" "$attack_sequence_2" "$attack_sequence_3" \
               "$attack_sequence_4" "$attack_sequence_5" "$attack_sequence_6"; do
        _hide_one "$seq" "$keep_attack_visible" "$hide_origin_value"
    done

    hide_origin_value="$(_reload_hide_origin)"

    for seq in "$reload_sequence_1" "$reload_sequence_2" "$reload_sequence_3" \
               "$reload_sequence_4" "$reload_sequence_5" "$reload_sequence_6" \
               "$reload_sequence_7" "$reload_sequence_8"; do
        _hide_one "$seq" "$keep_reload_visible" "$hide_origin_value"
    done

    for seq in "$other_sequence_1" "$other_sequence_2" "$other_sequence_3" \
               "$other_sequence_4" "$other_sequence_5" "$other_sequence_6" \
               "$other_sequence_7" "$other_sequence_8"; do
        [[ "$seq" == "none" ]] && continue
        append_qc "\$append $seq $hide_origin_value fadein 0.0 fadeout 0.0 snap"
    done

    for seq in "$secondary_attack_sequence_1" "$secondary_attack_sequence_2" \
               "$secondary_attack_sequence_3" "$secondary_attack_sequence_4"; do
        _hide_one "$seq" "$keep_secondary_attack_visible" "$hide_origin_value"
    done

    # Remove blends only when custom animations are in use.
    if [[ "$custom_vm" == "on" && -f "$dev_folder/decompiled_custom_animations/$qc_file" ]]; then
        [[ "$keep_draw_visible" == "y" ]] || remove_blend_of_sequence "$draw_sequence"
        [[ "$keep_idle_visible" == "y" ]] || remove_blend_of_sequence "$idle_sequence"
        [[ "$keep_attack_visible" == "y" ]] || \
            remove_blend_of_sequence "$attack_sequence_1" "$attack_sequence_2" \
                "$attack_sequence_3" "$attack_sequence_4" \
                "$attack_sequence_5" "$attack_sequence_6"
        [[ "$keep_reload_visible" == "y" ]] || \
            remove_blend_of_sequence "$reload_sequence_1" "$reload_sequence_2" \
                "$reload_sequence_3" "$reload_sequence_4" \
                "$reload_sequence_5" "$reload_sequence_6" \
                "$reload_sequence_7" "$reload_sequence_8"
        [[ "$keep_secondary_attack_visible" == "y" ]] || \
            remove_blend_of_sequence "$secondary_attack_sequence_1" \
                "$secondary_attack_sequence_2" \
                "$secondary_attack_sequence_3" \
                "$secondary_attack_sequence_4"
        remove_blend_of_sequence "$other_sequence_1" "$other_sequence_2" \
            "$other_sequence_3" "$other_sequence_4" \
            "$other_sequence_5" "$other_sequence_6" \
            "$other_sequence_7" "$other_sequence_8"
    fi
}

_hide_one() {
    local seq="$1" keep="$2" value="$3"
    [[ "$seq" == "none" ]] && return 0
    if [[ "$keep" == "y" ]]; then
        append_qc "\$append $seq origin $X_position $Y_position $Z_position angles $X_rotation $Y_rotation $Z_rotation"
    else
        append_qc "\$append $seq $value fadein 0.0 fadeout 0.0 snap"
    fi
}

change_position_and_rotation() {
    [[ "$hidden" == "y" ]] && return 0
    [[ "$X_position" == "0" && "$Y_position" == "0" && "$Z_position" == "0" && \
       "$X_rotation" == "0" && "$Y_rotation" == "0" && "$Z_rotation" == "0" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$sequence_1" "$sequence_2" "$sequence_3" "$sequence_4" "$sequence_5" \
               "$sequence_6" "$sequence_7" "$sequence_8" "$sequence_9" "$sequence_10"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq origin $X_position $Y_position $Z_position angles $X_rotation $Y_rotation $Z_rotation"
    done
}

# ---------------------------------------------------------------------------
# SMD operations
# ---------------------------------------------------------------------------
_smd_nodes() {
    local smd="$1" out="$2"
    awk '{ sub(/\r$/, ""); print; if ($0 == "skeleton") exit }' "$smd" > "$out"
}

_smd_first_frame() {
    local smd="$1" out="$2"
    awk '
        { sub(/\r$/, "") }
        $0 == "time 0" { echo_now = 1; next }
        $0 == "time 1" { exit }
        echo_now { print }
    ' "$smd" > "$out"
}

_smd_staticize() {
    local source_first_frame="$1"
    shift
    local smd nodes first frames tmp

    [[ "$idle_smd" == "none" ]] && return 0
    [[ -f "$smd_folder/$idle_smd" ]] || return 0

    nodes="$(mktemp "$smd_folder/.nodes.XXXXXX")"
    first="$(mktemp "$smd_folder/.first.XXXXXX")"
    frames="$(mktemp "$smd_folder/.frames.XXXXXX")"
    tmp="$(mktemp "$smd_folder/.static.XXXXXX")"

    _smd_nodes "$smd_folder/$idle_smd" "$nodes"
    _smd_first_frame "$smd_folder/$source_first_frame" "$first"

    for smd in "$@"; do
        [[ "$smd" == "none" ]] && break
        [[ -f "$smd_folder/$smd" ]] || continue

        : > "$frames"
        while IFS= read -r line; do
            printf '%s\n' "$line" >> "$frames"
            cat "$first" >> "$frames"
        done < <(grep -i 'time' "$smd_folder/$smd")

        cat "$nodes" "$frames" > "$tmp"
        printf 'end\n' >> "$tmp"
        mv -f "$tmp" "$smd_folder/$smd"
    done

    rm -f "$nodes" "$first" "$frames" "$tmp"
}

smd_statinator() {
    _smd_staticize "$idle_smd" "$@"
}

smd_instantinator() {
    local source="$extract_first_frame_from"
    _smd_staticize "$source" "$@"
}

# ---------------------------------------------------------------------------
# Static animations
# ---------------------------------------------------------------------------
static_reload() {
    [[ "$static_reload" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_reload_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$reload_sequence_1" "$reload_sequence_2" "$reload_sequence_3" \
               "$reload_sequence_4" "$reload_sequence_5" "$reload_sequence_6" \
               "$reload_sequence_7" "$reload_sequence_8"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq fadein 0.2 fadeout 0.2"
    done

    smd_statinator "$reload_smd_1" "$reload_smd_2" "$reload_smd_3" "$reload_smd_4" \
        "$reload_smd_5" "$reload_smd_6" "$reload_smd_7" "$reload_smd_8"
}

static_draw() {
    [[ "$static_draw" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_draw_visible" != "y" ]]; then
        return 0
    fi
    [[ "$draw_smd" == "none" || "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    append_qc "\$append $draw_sequence snap fadein 0.0 fadeout 0.2"

    if [[ "$draw_sequence" == "ed_draw" ]]; then
        local tmp="drink_fix.$$"
        grep -iv 'AE_CL_CREATE_PARTICLE_EFFECT' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
    fi

    smd_statinator "$draw_smd"
}

static_idle() {
    [[ "$more_static_idle" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_idle_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    append_qc "\$append $idle_sequence fadein 0.2 fadeout 0.2"
    smd_statinator "$idle_smd"
}

static_attack() {
    [[ "$static_attack" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_attack_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    if [[ "$more_static_idle" != "y" ]]; then
        local seq
        for seq in "$attack_sequence_1" "$attack_sequence_2" "$attack_sequence_3" \
                   "$attack_sequence_4" "$attack_sequence_5" "$attack_sequence_6"; do
            [[ "$seq" == "none" ]] && break
            append_qc "\$append $seq fadein 0.2 fadeout 0.2"
        done
    fi

    smd_statinator "$attack_smd_1" "$attack_smd_2" "$attack_smd_3" \
        "$attack_smd_4" "$attack_smd_5" "$attack_smd_6"
}

static_secondary_attack() {
    [[ "$static_secondary_attack" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_secondary_attack_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$secondary_attack_sequence_1" "$secondary_attack_sequence_2" \
               "$secondary_attack_sequence_3" "$secondary_attack_sequence_4"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq fadein 0.2 fadeout 0.2"
    done

    smd_statinator "$secondary_attack_smd_1" "$secondary_attack_smd_2" \
        "$secondary_attack_smd_3" "$secondary_attack_smd_4"
}

# ---------------------------------------------------------------------------
# Misc. weapon fixes
# ---------------------------------------------------------------------------
remove_shells() {
    [[ "$remove_shells" == "y" ]] || return 0
    cd "$qc_folder_temp" || return 1

    local tmp="remove_shell.$$" seqs
    seqs="$(printf '%s\n' "$sequence_1" "$sequence_2" "$sequence_3" "$sequence_4" \
        "$sequence_5" "$sequence_6" "$sequence_7" "$sequence_8" \
        "$sequence_9" "$sequence_10" | grep -v '^none$' | paste -sd ' ' -)"

    SEQS="$seqs" awk '
        BEGIN {
            n = split(ENVIRON["SEQS"], a, " ")
            for (i = 1; i <= n; i++) want[a[i]] = 1
        }
        {
            raw = $0
            check = raw
            gsub(/[ \t\r]/, "", check)
            gsub(/"/, "", check)

            if (check ~ /^\$sequence/) {
                inside = 0
                for (name in want) {
                    if (check == "$sequence" name "{") { inside = 1; break }
                }
            }

            if (inside) gsub(/\{ event 6002/, "////{ event 6002", raw)
            print raw

            if (check == "}") inside = 0
        }
    ' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
}

original_sound_to_stock() {
    [[ "$replace_reload_sound_with_stock" == "y" && "$settings_label" == "&::original" ]] || return 0
    cd "$qc_folder_temp" || return 1

    local tmp="original_sound.$$" seqs
    seqs="$(printf '%s\n' "$reload_sequence_1" "$reload_sequence_2" "$reload_sequence_3" \
        | grep -v '^none$' | paste -sd ' ' -)"

    SEQS="$seqs" awk '
        BEGIN {
            n = split(ENVIRON["SEQS"], a, " ")
            for (i = 1; i <= n; i++) want[a[i]] = 1
        }
        {
            raw = $0
            check = raw
            gsub(/[ \t\r]/, "", check)
            gsub(/"/, "", check)

            if (check ~ /^\$sequence/) {
                inside = 0
                for (name in want) {
                    if (check == "$sequence" name "{") { inside = 1; break }
                }
            }

            if (inside) {
                gsub(/Weapon_RPG\.Reload/, "Weapon_RPG.WorldReload", raw)
                gsub(/Weapon_QuakeRPG\.Reload/, "Weapon_RPG.WorldReload", raw)
            }
            print raw

            if (check == "}") inside = 0
        }
    ' "$qc_file" > "$tmp" && mv -f "$tmp" "$qc_file"
}

# ---------------------------------------------------------------------------
# Spy-specific fixes
# ---------------------------------------------------------------------------
spy_hide_backstabs() {
    [[ "$hidden" == "y" ]] || return 0
    cd "$qc_folder_temp" || return 1

    local hide_origin_value
    hide_origin_value="$(_reload_hide_origin)"

    _spy_hide_or_keep "$backstab_attack_sequence" "$keep_backstab_visible" "$hide_origin_value"
    _spy_hide_or_keep "$backstab_stun_sequence" "$keep_backstab_visible" "$hide_origin_value"
    _spy_hide_or_keep "$backstab_detect_sequence_up" "$keep_backstab_detection_visible" "$hide_origin_value"

    # Original script has a special case for the "down" detection sequence.
    if [[ "$backstab_detect_sequence_down" != "none" ]]; then
        if [[ "$instant_backstab_detection" == "y" && "$keep_backstab_detection_visible" == "y" ]]; then
            append_qc "\$append $backstab_detect_sequence_down $hide_origin_value fadein 0.0 fadeout 0.0 snap"
        else
            _spy_hide_or_keep "$backstab_detect_sequence_down" "$keep_backstab_detection_visible" "$hide_origin_value"
        fi
    fi

    _spy_hide_or_keep "$backstab_detect_sequence_idle" "$keep_backstab_detection_visible" "$hide_origin_value"

    if [[ "$custom_vm" == "on" && -f "$dev_folder/decompiled_custom_animations/$qc_file" ]]; then
        if [[ "$keep_backstab_visible" != "y" ]]; then
            remove_blend_of_sequence "$backstab_attack_sequence" "$backstab_stun_sequence"
        fi
        if [[ "$keep_backstab_detection_visible" != "y" ]]; then
            remove_blend_of_sequence "$backstab_detect_sequence_up" \
                "$backstab_detect_sequence_down" "$backstab_detect_sequence_idle"
        fi
    fi
}

_spy_hide_or_keep() {
    local seq="$1" keep="$2" value="$3"
    [[ "$seq" == "none" ]] && return 0
    if [[ "$keep" == "y" ]]; then
        append_qc "\$append $seq origin $X_position $Y_position $Z_position angles $X_rotation $Y_rotation $Z_rotation"
    else
        append_qc "\$append $seq $value fadein 0.0 fadeout 0.0 snap"
    fi
}

spy_instant_backstab_detection() {
    [[ "$static_backstab_detection" == "y" ]] && return 0
    [[ "$instant_backstab_detection" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_backstab_detection_visible" != "y" ]]; then
        return 0
    fi
    [[ "$backstab_detect_smd_idle" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$backstab_detect_sequence_up" "$backstab_detect_sequence_down" \
               "$backstab_detect_sequence_idle"; do
        [[ "$seq" == "none" ]] && break
        if [[ "$seq" == "$backstab_detect_sequence_down" ]]; then
            append_qc "\$append $seq snap fadein 0.0 fadeout 0.1"
        else
            append_qc "\$append $seq snap fadein 0.0 fadeout 0.0"
        fi
    done

    extract_first_frame_from="$backstab_detect_smd_idle"
    smd_instantinator "$backstab_detect_smd_up" "$backstab_detect_smd_idle"
    smd_statinator "$backstab_detect_smd_down"
}

spy_static_backstab() {
    [[ "$static_backstab" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_backstab_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$backstab_attack_sequence" "$backstab_stun_sequence"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq fadein 0.2 fadeout 0.2"
    done

    smd_statinator "$backstab_attack_smd" "$backstab_stun_smd"
}

spy_static_backstab_detection() {
    [[ "$static_backstab_detection" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_backstab_detection_visible" != "y" ]]; then
        return 0
    fi
    [[ "$idle_smd" == "none" ]] && return 0

    cd "$qc_folder_temp" || return 1
    local seq
    for seq in "$backstab_detect_sequence_up" "$backstab_detect_sequence_down" \
               "$backstab_detect_sequence_idle"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq fadein 0.2 fadeout 0.2"
    done

    smd_statinator "$backstab_detect_smd_up" "$backstab_detect_smd_down" \
        "$backstab_detect_smd_idle"
}

spy_replace_backstab() {
    [[ "$static_backstab" == "y" ]] && return 0
    [[ "$replace_backstab_with_normal_attack" == "y" ]] || return 0
    if [[ "$hidden" == "y" && "$keep_backstab_visible" != "y" ]]; then
        return 0
    fi

    local normal_attack_smd
    case "$normal_attack" in
    poke)             normal_attack_smd="$poke_stab_smd" ;;
    horizontal_swipe) normal_attack_smd="$horizontal_stab_smd" ;;
    diagonal_swipe)   normal_attack_smd="$diagonal_stab_smd" ;;
    *)                normal_attack_smd="$horizontal_stab_smd" ;;
    esac

    if [[ -f "$smd_folder/$backstab_attack_smd" && -f "$smd_folder/$normal_attack_smd" ]]; then
        cp -f "$smd_folder/$normal_attack_smd" "$smd_folder/$backstab_attack_smd"
    fi
}

# ---------------------------------------------------------------------------
# The per-weapon pipeline
# ---------------------------------------------------------------------------
apply_settings() {
    extract_settings
    snap_to_draws
    hide_weapon

    if [[ "$qc_file" == "c_spy_animations.qc" ]]; then
        spy_hide_backstabs
        spy_instant_backstab_detection
        spy_replace_backstab
        spy_static_backstab
        spy_static_backstab_detection
    fi

    change_position_and_rotation
    static_reload
    static_draw
    static_idle
    static_attack
    static_secondary_attack

    if [[ "$qc_file" != "c_demo_animations.qc" && \
          "$qc_file" != "c_medic_animations.qc" && \
          "$qc_file" != "c_spy_animations.qc" ]]; then
        remove_shells
    fi

    original_sound_to_stock
    remove_left_arm
}

# ---------------------------------------------------------------------------
# Left-arm removal
# ---------------------------------------------------------------------------
# Append "$append <sequence> addlayer "remove_shell"" for each named sequence.
_remove_left_arm_add_shell_layers() {
    local seq
    for seq in "$@"; do
        append_qc "\$append $seq addlayer \"remove_shell\""
    done
}

_remove_left_arm_add_weights() {
    local cls="$1"
    [[ -f "layer_and_weights_added_$cls" ]] && return 0
    "_remove_left_arm_add_layers_and_weights_$cls"
}

_remove_left_arm_fix_static_reloads() {
    [[ "$static_reload" == "y" ]] || return 0
    local seq
    for seq in "$reload_sequence_1" "$reload_sequence_2" "$reload_sequence_3" \
               "$reload_sequence_4" "$reload_sequence_5" "$reload_sequence_6" \
               "$reload_sequence_7" "$reload_sequence_8"; do
        [[ "$seq" == "none" ]] && continue
        append_qc "\$append $seq addlayer \"remove_shell\""
    done
}

_remove_left_arm_default_fixes() {
    if [[ "$settings_label" == "&::shortstop" ]]; then
        append_qc "\$append ss_idle addlayer \"remove_shell_shortstop\""
        append_qc "\$append ss_draw addlayer \"remove_shell_shortstop\""
        append_qc "\$append ss_fire addlayer \"remove_shell_shortstop\""
        append_qc "\$append ss_alt_fire addlayer \"remove_shell_shortstop\""
        append_qc "\$append ss_reload blendlayer \"remove_shell_shortstop\" 27 27 36 36 noblend"
    fi

    if [[ "$settings_label" == "&::shotguns" ]]; then
        case "$qc_file" in
        c_soldier_animations.qc)
            _remove_left_arm_add_shell_layers reload_start reload_end
            ;;
        c_pyro_animations.qc)
            _remove_left_arm_add_shell_layers reload_start reload_end draw idle fire
            ;;
        c_engineer_animations.qc)
            _remove_left_arm_add_shell_layers fj_idle fj_fire fj_reload_start \
                fj_reload_loop fj_reload_end fj_fire_alt fj_draw
            ;;
        esac
    fi

    if [[ "$settings_label" == "&::secondariesinspect" && "$qc_file" == "c_pyro_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers secondary_inspect_start \
            secondary_inspect_idle secondary_inspect_end
    fi

    if [[ "$settings_label" == "&::grenadelaunchers" && "$qc_file" == "c_demo_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers g_draw g_idle g_fire g_auto_fire
    fi

    if [[ "$settings_label" == "&::revolvers" && "$qc_file" == "c_spy_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers reload reload2
        append_qc "\$append reload blendlayer \"remove_shell_fix\" 0 0 8 8 noblend"
        append_qc "\$append reload2 blendlayer \"remove_shell_fix\" 0 0 8 8 noblend"
        _remove_left_arm_add_shell_layers draw idle fire
    fi

    if [[ "$settings_label" == "&::shotgunsinspects" && "$qc_file" == "c_engineer_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers primary_inspect_start \
            primary_inspect_idle primary_inspect_end
    fi
}

_remove_left_arm_custom_fixes() {
    if [[ "$settings_label" == "&::shotguns" ]]; then
        case "$qc_file" in
        c_soldier_animations.qc|c_pyro_animations.qc)
            _remove_left_arm_add_shell_layers reload_start reload_loop reload_end \
                draw idle fire
            ;;
        c_engineer_animations.qc)
            _remove_left_arm_add_shell_layers fj_idle fj_fire fj_reload_start \
                fj_reload_loop fj_reload_end fj_fire_alt fj_draw
            ;;
        esac
    fi

    if [[ "$settings_label" == "&::secondaryinspect" && "$qc_file" == "c_soldier_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers secondary_inspect_start \
            secondary_inspect_idle secondary_inspect_end
    fi

    if [[ "$settings_label" == "&::secondariesinspect" && "$qc_file" == "c_pyro_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers secondary_inspect_start \
            secondary_inspect_idle secondary_inspect_end
    fi

    if [[ "$settings_label" == "&::grenadelaunchers" && "$qc_file" == "c_demo_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers g_draw g_idle g_fire g_auto_fire
    fi

    if [[ "$settings_label" == "&::revolvers" && "$qc_file" == "c_spy_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers reload reload2 draw idle fire
    fi

    if [[ "$settings_label" == "&::shotgunsinspects" && "$qc_file" == "c_engineer_animations.qc" ]]; then
        _remove_left_arm_add_shell_layers primary_inspect_start \
            primary_inspect_idle primary_inspect_end
    fi
}

remove_left_arm() {
    # The sniper's "remove right arm" option is implemented as left-arm removal.
    if [[ "$qc_file" == "c_sniper_animations.qc" && "$remove_right_arm" == "y" ]]; then
        remove_left_arm=y
    fi
    [[ "$remove_left_arm" == "y" ]] || return 0

    # Skip when the weapon is hidden and nothing needs to stay visible.
    if [[ "$hidden" == "y" && "$keep_draw_visible" != "y" && \
          "$keep_attack_visible" != "y" && "$keep_reload_visible" != "y" && \
          "$keep_idle_visible" != "y" && "$keep_secondary_attack_visible" != "y" ]]; then
        return 0
    fi

    cd "$qc_folder_temp" || return 1

    case "$qc_file" in
    c_scout_animations.qc)    _remove_left_arm_add_weights scout ;;
    c_soldier_animations.qc)  _remove_left_arm_add_weights soldier ;;
    c_pyro_animations.qc)     _remove_left_arm_add_weights pyro ;;
    c_demo_animations.qc)     _remove_left_arm_add_weights demo ;;
    c_heavy_animations.qc)    _remove_left_arm_add_weights heavy ;;
    c_engineer_animations.qc) _remove_left_arm_add_weights engineer ;;
    c_medic_animations.qc)    _remove_left_arm_add_weights medic ;;
    c_sniper_animations.qc)   _remove_left_arm_add_weights sniper ;;
    c_spy_animations.qc)      _remove_left_arm_add_weights spy ;;
    esac

    local seq
    for seq in "$sequence_1" "$sequence_2" "$sequence_3" "$sequence_4" "$sequence_5" \
               "$sequence_6" "$sequence_7" "$sequence_8" "$sequence_9" "$sequence_10"; do
        [[ "$seq" == "none" ]] && break
        append_qc "\$append $seq addlayer \"remove_left_arm\""
    done

    _remove_left_arm_fix_static_reloads

    if [[ "$custom_vm" == "on" && -f "$dev_folder/decompiled_custom_animations/$qc_file" ]]; then
        _remove_left_arm_custom_fixes
    else
        _remove_left_arm_default_fixes
    fi
}
