#!/usr/bin/env bash
# Horsie's Viewmodel Editor - Linux port
#
# Main entry point. Run ./start.sh from inside the editor folder, which can
# live in <game>/tf/ or <game>/tf/custom/. The helper scripts are in
# _dev/batch, shared code in _dev/lib/common.sh.
#
# Needs Wine (HLExtract, Crowbar), Wine Mono or Mono (CrowbarDecompiler), and
# studiomdl + vpk. See README.md for setup. HLEXTRACT, CROWBAR, STUDIOMDL and
# VPK can be set to override auto-detection.

# Re-exec under bash when started with sh.
if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

# ---------------------------------------------------------------------------
# Colors
#   yellow background / black text   -> 30;43
#   red background / white text      -> 97;41
#   cyan background / black text     -> 30;46
#   green background / black text    -> 30;42
# ---------------------------------------------------------------------------
C_YELLOW=$'\033[30;43m'
C_RED=$'\033[97;41m'
C_CYAN=$'\033[30;46m'
C_GREEN=$'\033[30;42m'
C_RESET=$'\033[0m'

# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------
set_title()  { echo -ne "\033]0;$1\007"; }
pause_key()  { read -n 1 -s -r -p ""; }
any_vpk()    { compgen -G "$1/*.vpk" >/dev/null 2>&1; }
show_horse() {
cat << 'EOF'
                       ~~%%%%%%%%_,_,
                   ~~%%%%%%%%%-"/./
                 ~~%%%%%%%-'   /  `.
               ~~%%%%%%%%'  .     ,__;
             ~~%%%%%%%%'   :       \O\
           ~~%%%%%%%%'    :          `.
        ~~%%%%%%%%'       `. _,        '
     ~~%%%%%%%%'          .'`-._        `.
  ~~%%%%%%%%%'           :     `-.     (,;
 ~~%%%%%%%%'             :         `._\_.'
EOF
}

credit_line() {
    echo " Original editor by a-horsey: github.com/a-horsey/horsies-viewmodel-editor"
    echo " GameBanana: gamebanana.com/tools/10146"
}

wrong_folder() {
    echo -ne "$C_RED"
    echo "Wrong folder!"
    echo "Put the editor folder inside your game's \"tf\" folder (recommended) or \"tf/custom\" folder."
    echo
    echo "Example: .../Team Fortress 2/tf/horsies-viewmodel-editor"
    echo "Then run ./start.sh from inside it.  See README.md if you need help."
    echo
    pause_key
    exit 1
}

vpk_in_use() {
    echo -ne "$C_RED"
    echo "Error! Game is currently running."
    echo "Please close the game and try again."
    echo
    pause_key
    exit 1
}

# ---------------------------------------------------------------------------
# Title / initial color
# ---------------------------------------------------------------------------
set_title "Horsie's Viewmodel Editor"
echo -ne "$C_YELLOW"
clear

# ---------------------------------------------------------------------------
# Locate folders
# ---------------------------------------------------------------------------
vm_customizer_folder="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
cd "$vm_customizer_folder"

base_folder="$(basename "$vm_customizer_folder")"
check_folder="$(basename "$(dirname "$vm_customizer_folder")")"
base_folder="${base_folder// /}"
check_folder="${check_folder// /}"

if [[ "${check_folder,,}" == "custom" ]]; then
    # --- script inside .../tf/custom/<editor> ---
    custom_folder="$(dirname "$vm_customizer_folder")"
    dev_folder="$vm_customizer_folder/_dev"
    batch_folder="$dev_folder/batch"
    animations_folder="$dev_folder/decompiled_animations"
    tf_folder="$(dirname "$custom_folder")"
    bin_folder="$tf_folder/../bin"
    cd "$tf_folder"
    clear
    [[ -f "tf2_misc_dir.vpk" && -f "gameinfo.txt" ]] || wrong_folder
    cd "$vm_customizer_folder"
elif [[ "${check_folder,,}" == "tf" ]]; then
    # --- script inside .../tf/<editor> ---
    dev_folder="$vm_customizer_folder/_dev"
    animations_folder="$dev_folder/decompiled_animations"
    batch_folder="$dev_folder/batch"
    tf_folder="$(dirname "$vm_customizer_folder")"
    custom_folder="$tf_folder/custom"
    bin_folder="$tf_folder/../bin"
    cd "$tf_folder"
    clear
    [[ -f "tf2_misc_dir.vpk" && -f "gameinfo.txt" ]] || wrong_folder
    cd "$vm_customizer_folder"
else
    wrong_folder
fi

# ---------------------------------------------------------------------------
# Check if VPK is in use (game running)
# ---------------------------------------------------------------------------
vpk_name="__Horsie'sViewmodelEditor"

if pgrep -f 'hl2_linux|tf_linux|tf_linux64' >/dev/null 2>&1; then
    vpk_in_use
fi

# ---------------------------------------------------------------------------
# Delete temp dirs, restore default files
# ---------------------------------------------------------------------------
rm -rf "$dev_folder/decompiled_animations_temp"
rm -rf "$dev_folder/decompiled_custom_animations_temp"

if ! any_vpk "$vm_customizer_folder/custom animations" && [[ -d "$dev_folder/decompiled_custom_animations" ]]; then
    rm -rf "$dev_folder/decompiled_custom_animations"
fi
if ! any_vpk "$vm_customizer_folder/fixed viewmodels addon" && [[ -d "$dev_folder/decompiled_fixed_animations" ]]; then
    rm -rf "$dev_folder/decompiled_fixed_animations"
fi

# restore default settings files if missing
cd "$vm_customizer_folder"
for cls in scout soldier pyro demoman heavy engineer medic sniper spy; do
    [[ ! -f "$vm_customizer_folder/settings_$cls.txt" ]] && \
        cp "$dev_folder/default_settings/settings_$cls.txt" "$vm_customizer_folder/settings_$cls.txt"
done

# restore previous settings if possible
[[ -f "$dev_folder/saved_settings.sh" ]] && . "$dev_folder/saved_settings.sh"

# default values if needed
: "${automatic_preloading:=off}"
: "${fixed_vm_addon:=on}"
: "${disable_tracers:=off}"
: "${hide_errors:=on}"
: "${custom_vm:=on}"
: "${apply_for_specific_classes:=false}"

any_vpk "$vm_customizer_folder/fixed viewmodels addon" || fixed_vm_addon=off
any_vpk "$vm_customizer_folder/custom animations"      || custom_vm=off

# Load shared helpers. This also checks that the needed tools exist.
. "$dev_folder/lib/common.sh"

# ---------------------------------------------------------------------------
# Save settings helper
# ---------------------------------------------------------------------------
save_settings() {
    local f="$dev_folder/saved_settings.sh"
    : > "$f"
    echo "automatic_preloading=$automatic_preloading" >> "$f"
    echo "disable_tracers=$disable_tracers"           >> "$f"
    echo "hide_errors=$hide_errors"                   >> "$f"
    if [[ "$fixed_vm_addon" == "on" ]] || any_vpk "$vm_customizer_folder/fixed viewmodels addon"; then
        echo "fixed_vm_addon=$fixed_vm_addon" >> "$f"
    fi
    if [[ "$custom_vm" == "on" ]] || any_vpk "$vm_customizer_folder/custom animations"; then
        echo "custom_vm=$custom_vm" >> "$f"
    fi
}

# ---------------------------------------------------------------------------
# Dev menu
# ---------------------------------------------------------------------------
dev_menu_loop() {
    while true; do
        echo -ne "$C_YELLOW"; clear
        show_horse
        echo " ~~%%%%%%' Welcome to Horsie's Viewmodel Editor!"
        echo
        echo "Dev Options:"
        echo "  1. Remove all extracted animations"
        echo "  2. Restore settings files to default"
        echo "  3. Restore main menu settings to default"
        echo "  0. Go back"
        echo
        read -r -p "Choose dev option: " M
        case "$M" in
        0) return ;;
        1) # remove extracted animations
            clear
            echo "This removes all the files extracted from the game, the fixed viewmodels pack and from custom animations (if present)."
            echo "They will be extracted again when you press start."
            echo "Only recommended if something is really wrong or the game got updated."
            echo
            read -r -p "Do you want to proceed? (Y/N): " M
            case "${M,,}" in
            y)
                echo "Removing all extracted animations..."
                rm -rf "$dev_folder/decompiled_animations"
                rm -rf "$dev_folder/decompiled_fixed_animations"
                rm -rf "$dev_folder/decompiled_custom_animations"
                rm -rf "$dev_folder/decompiled_custom_animations_temp"
                ;;
            n) : ;;
            *) continue ;;
            esac
            ;;
        2) # restore settings files
            clear
            echo "This restores all the settings_class.txt files to default."
            echo "There is no way to recover your previous settings if you do this."
            echo
            read -r -p "Are you sure you want to proceed? (Y/N): " M
            case "${M,,}" in
            y)
                echo "Restoring settings..."
                cp -r "$dev_folder/default_settings/." "$vm_customizer_folder/"
                ;;
            n) : ;;
            *) continue ;;
            esac
            ;;
        3) # restore main menu settings
            clear
            echo "This restores the main menu settings to their default values."
            echo
            read -r -p "Are you sure you want to proceed? (Y/N): " M
            case "${M,,}" in
            y)
                rm -f "$dev_folder/saved_settings.sh"
                automatic_preloading=off
                any_vpk "$vm_customizer_folder/fixed viewmodels addon" && fixed_vm_addon=on
                disable_tracers=off
                hide_errors=on
                any_vpk "$vm_customizer_folder/custom animations" && custom_vm=on
                apply_for_specific_classes=false
                ;;
            n) : ;;
            *) continue ;;
            esac
            ;;
        *) : ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# Install routine (set up temp + apply + compile)
# ---------------------------------------------------------------------------
install_failed() {
    echo -ne "$C_RED"
    echo
    echo "$1"
    echo "See the messages above for details."
    echo
    pause_key
    return 1
}

run_install() {
    local cls var
    local -a class_order=(scout soldier pyro demoman heavy engineer medic sniper spy)

    clear
    echo -ne "$C_GREEN"

    # The helpers run as separate processes, so state goes through the
    # environment. This keeps classes independent and avoids cd leaks.
    export vm_customizer_folder dev_folder batch_folder tf_folder custom_folder bin_folder
    export animations_folder qc_folder_temp custom_vm fixed_vm_addon
    export automatic_preloading disable_tracers hide_errors
    export apply_for_specific_classes
    for cls in "${class_order[@]}"; do
        export "apply_per_class_$cls"
    done

    if ! check_install_dependencies; then
        install_failed "Required tools are missing."
        return 1
    fi

    echo "Extracting default animations..."
    bash "$batch_folder/extract_default_animations.sh" || {
        install_failed "Could not extract the default animations."
        return 1
    }

    if [[ "$fixed_vm_addon" == "on" ]]; then
        bash "$batch_folder/extract_fixed_animations.sh" || {
            install_failed "Could not extract the fixed viewmodels."
            return 1
        }
    fi

    if [[ "$custom_vm" == "on" ]]; then
        bash "$batch_folder/extract_custom_animations.sh" || {
            install_failed "Could not extract the custom animations."
            return 1
        }
    fi

    # Build the temporary working copy.
    cd "$dev_folder" || return 1
    rm -rf "decompiled_animations_temp"
    mkdir -p "decompiled_animations_temp"
    cp -a "decompiled_animations/." "decompiled_animations_temp/" || {
        install_failed "Could not copy the extracted animations."
        return 1
    }
    if [[ "$fixed_vm_addon" == "on" && -d "decompiled_fixed_animations" ]]; then
        cp -a "decompiled_fixed_animations/." "decompiled_animations_temp/"
    fi
    if [[ "$custom_vm" == "on" && -d "decompiled_custom_animations" ]]; then
        cp -a "decompiled_custom_animations/." "decompiled_animations_temp/"
    fi
    qc_folder_temp="$dev_folder/decompiled_animations_temp"
    export qc_folder_temp

    echo
    echo "Applying the settings:"
    for cls in "${class_order[@]}"; do
        if [[ "$apply_for_specific_classes" == "true" ]]; then
            var="apply_per_class_$cls"
            [[ "${!var:-false}" == "true" ]] || continue
        fi
        bash "$batch_folder/apply_for_$cls.sh" || {
            install_failed "Failed while applying the $cls settings."
            return 1
        }
    done

    echo
    echo "Compiling the animations:"
    bash "$batch_folder/compile_and_pack.sh" || {
        install_failed "Could not compile or package the animations."
        return 1
    }

    rm -rf "$dev_folder/decompiled_animations_temp"

    echo -ne "$C_GREEN"
    set_title "Done!"
    clear
    show_horse
    echo " ~~%%%%%%'              ;  Done! Your edited viewmodels have been installed."
    echo
    credit_line
    echo
    echo "Press any key to exit."
    pause_key
    exit 0
}

# ---------------------------------------------------------------------------
# Main menu loop
# ---------------------------------------------------------------------------
while true; do
    # --- refresh toggle status / save settings ---
    [[ "$automatic_preloading" == "on" ]] && automatic_preloading_status="X" || automatic_preloading_status="_"
    [[ "$disable_tracers"      == "on" ]] && disable_tracers_status="X"      || disable_tracers_status="_"
    [[ "$hide_errors"          == "on" ]] && hide_errors_status="X"          || hide_errors_status="_"
    [[ "$fixed_vm_addon"       == "on" ]] && fixed_vm_addon_status="X"       || fixed_vm_addon_status="_"
    [[ "$custom_vm"            == "on" ]] && custom_vm_status="X"            || custom_vm_status="_"

    # reset per-class install settings
    apply_for_specific_classes=false
    apply_per_class_scout=false;    apply_per_class_soldier=false
    apply_per_class_pyro=false;     apply_per_class_demoman=false
    apply_per_class_heavy=false;    apply_per_class_engineer=false
    apply_per_class_medic=false;    apply_per_class_sniper=false
    apply_per_class_spy=false

    save_settings

    clear
    show_horse
    echo " ~~%%%%%%' Welcome to Horsie's Viewmodel Editor!"
    echo
    credit_line
    echo
    echo "Install:"
    echo "	1. Install for all classes"
    echo "	2. Install for specific classes"
    [[ -f "$custom_folder/$vpk_name.vpk" ]] && echo "	0. Uninstall"
    echo
    echo "Options:"
    echo " 	3. [$automatic_preloading_status] Include automatic preloading (recommended)"
    echo " 	4. [$disable_tracers_status] Remove 1st person bullet tracers"
    echo "	5. [$hide_errors_status] Hide console errors"
    echo " 	6. Developer settings"

    has_fixed=false;  any_vpk "$vm_customizer_folder/fixed viewmodels addon" && has_fixed=true
    has_custom=false; any_vpk "$vm_customizer_folder/custom animations"      && has_custom=true

    if $has_fixed && ! $has_custom; then
        echo
        echo "Toggle animations:"
        echo " 	7. [$fixed_vm_addon_status] Include Fixed Viewmodels"
    elif ! $has_fixed && $has_custom; then
        echo
        echo "Toggle animations:"
        echo " 	7. [$custom_vm_status] Include Custom Animations"
    elif $has_fixed && $has_custom; then
        echo
        echo "Toggle animations:"
        echo " 	7. [$fixed_vm_addon_status] Include Fixed Viewmodels"
        echo " 	8. [$custom_vm_status] Include Custom Animations"
    fi
    echo

    read -r -p "Choose an option: " M

    case "$M" in
    0)
        [[ ! -f "$custom_folder/$vpk_name.vpk" ]] && continue
        clear
        show_horse
        echo " ~~%%%%%%' Warning:"
        echo
        echo " This will remove the generated VPK mod from your custom folder."
        echo " You don't have to do this before applying new settings, only if you just want to uninstall the mod."
        echo
        read -r -p "Do you want to proceed? (Y/N): " M2
        case "${M2,,}" in
        y)
            echo "Removing VPK..."
            rm -f "$custom_folder/$vpk_name.vpk"
            rm -f "$custom_folder/$vpk_name.vpk.sound.cache"
            ;;
        n) : ;;
        *) : ;;
        esac
        ;;
    1)
        clear
        show_horse
        echo " ~~%%%%%%' Welcome to Horsie's Viewmodel Editor!"
        echo
        echo "You're about to install the mod for all the classes."
        echo
        read -r -p "Proceed? (Y/N): " M2
        case "${M2,,}" in
        y)
            apply_for_specific_classes=false
            run_install
            ;;
        n) : ;;
        *) : ;;
        esac
        ;;
    2)
        # ----- pick classes menu -----
        declare -A cls_status=(
            [scout]=_ [soldier]=_ [pyro]=_ [demoman]=_ [heavy]=_
            [engineer]=_ [medic]=_ [sniper]=_ [spy]=_
        )
        declare -A cls_on=(
            [scout]=false [soldier]=false [pyro]=false [demoman]=false [heavy]=false
            [engineer]=false [medic]=false [sniper]=false [spy]=false
        )
        class_order=(scout soldier pyro demoman heavy engineer medic sniper spy)
        while true; do
            clear
            show_horse
            echo " ~~%%%%%%' Welcome to Horsie's Viewmodel Editor!"
            echo
            echo "Toggle classes:"
            i=1
            for c in "${class_order[@]}"; do
                label="$(tr '[:lower:]' '[:upper:]' <<< "${c:0:1}")${c:1}"
                echo " 	$i. [${cls_status[$c]}] $label"
                i=$((i+1))
            done
            echo
            echo "Options:"
            echo "	10. Install for selected classes"
            echo "	0.  Go back"
            echo
            read -r -p "Choose an option: " M2
            case "$M2" in
            0) break ;;
            1) c=scout ;; 2) c=soldier ;; 3) c=pyro ;; 4) c=demoman ;;
            5) c=heavy ;; 6) c=engineer ;; 7) c=medic ;; 8) c=sniper ;; 9) c=spy ;;
            esac
            if [[ -n "${c:-}" && "$M2" =~ ^[1-9]$ ]]; then
                if [[ "${cls_status[$c]}" == "_" ]]; then
                    cls_status[$c]=X;  cls_on[$c]=true
                else
                    cls_status[$c]=_;  cls_on[$c]=false
                fi
                c=""
                continue
            fi
            if [[ "$M2" == "10" ]]; then
                # any selected?
                all_off=true
                for c in "${class_order[@]}"; do [[ "${cls_status[$c]}" == "X" ]] && all_off=false; done
                if $all_off; then continue; fi
                clear
                show_horse
                echo " ~~%%%%%%' Welcome to Horsie's Viewmodel Editor!"
                echo
                echo "You're about install the mod for:"
                for c in "${class_order[@]}"; do
                    [[ "${cls_status[$c]}" == "X" ]] && \
                        echo "  - $(tr '[:lower:]' '[:upper:]' <<< "${c:0:1}")${c:1}"
                done
                echo
                read -r -p "Proceed? (Y/N): " M3
                case "${M3,,}" in
                y)
                    apply_for_specific_classes=true
                    for c in "${class_order[@]}"; do
                        v="apply_per_class_$c"
                        if [[ "${cls_on[$c]}" == "true" ]]; then
                            printf -v "$v" '%s' "true"
                        else
                            printf -v "$v" '%s' "false"
                        fi
                    done
                    unset c
                    run_install
                    ;;
                n) : ;;
                *) : ;;
                esac
            fi
        done
        ;;
    3)  # toggle preloading
        if [[ "$automatic_preloading" == "off" ]]; then
            clear
            show_horse
            echo " ~~%%%%%%' Warning:"
            echo
            echo "Automatic preloading will allow you to use the custom viewmodels in any server."
            echo "It's highly recommended to enable it."
            echo "But it can cause crashes in casual if you are using mods that include custom models."
            echo "Only enable it if you are not using such mods."
            echo
            read -r -p "Are you sure that you want to enable it? (Y/N): " M2
            case "${M2,,}" in
            y) automatic_preloading=on ;;
            *) : ;;
            esac
        else
            automatic_preloading=off
        fi
        ;;
    4)  # toggle tracers
        [[ "$disable_tracers" == "off" ]] && disable_tracers=on || disable_tracers=off
        ;;
    5)  # toggle hide_errors
        if [[ "$hide_errors" == "on" ]]; then
            clear
            show_horse
            echo " ~~%%%%%%' Warning:"
            echo
            echo "This option hides the console errors caused by some of the mod's options."
            echo "Without this, the console might be hard to read due to spam."
            echo
            read -r -p "Are you sure that you want to disable it? (Y/N): " M2
            case "${M2,,}" in
            y) hide_errors=off ;;
            *) : ;;
            esac
        else
            hide_errors=on
        fi
        ;;
    6)  # dev menu
        dev_menu_loop
        ;;
    7)
        if $has_fixed && ! $has_custom; then
            [[ "$fixed_vm_addon" == "off" ]] && fixed_vm_addon=on || fixed_vm_addon=off
        elif ! $has_fixed && $has_custom; then
            [[ "$custom_vm" == "off" ]] && custom_vm=on || custom_vm=off
        elif $has_fixed && $has_custom; then
            [[ "$fixed_vm_addon" == "off" ]] && fixed_vm_addon=on || fixed_vm_addon=off
        fi
        ;;
    8)
        if $has_fixed && $has_custom; then
            [[ "$custom_vm" == "off" ]] && custom_vm=on || custom_vm=off
        fi
        ;;
    *) : ;;
    esac
done