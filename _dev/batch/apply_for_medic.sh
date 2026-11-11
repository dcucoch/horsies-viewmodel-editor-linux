#!/usr/bin/env bash
# Apply settings_medic.txt to the medic viewmodel animations.
set -u
_lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
. "$_lib_dir/common.sh"

printf '%s\n' 'Applying Medic Settings...'
settings_file='settings_medic.txt'
smd_folder="$qc_folder_temp/c_medic_animations_anims"
qc_file='c_medic_animations.qc'
replace_snap
(
    reset_settings
    settings_label='&::syringecrossbow'
    draw_sequence='sg_draw'
    draw_smd='sg_draw.smd'
    idle_sequence='sg_idle'
    idle_smd='sg_idle.smd'
    attack_sequence_1='sg_fire'
    attack_smd_1='sg_fire.smd'
    reload_sequence_2_is_alternative_start='false'
    reload_sequence_1='sg_reload'
    reload_smd_1='sg_reload.smd'
    sequence_1='sg_draw'
    sequence_2='sg_idle'
    sequence_3='sg_fire'
    sequence_4='sg_reload'
    apply_settings
)

(
    reset_settings
    settings_label='&::mediguns'
    draw_sequence='draw'
    draw_smd='draw.smd'
    idle_sequence='idle'
    idle_smd='idle.smd'
    attack_sequence_1='fire_on'
    attack_sequence_2='fire_loop'
    attack_sequence_3='fire_off'
    attack_smd_1='fire_on.smd'
    attack_smd_2='fire_loop.smd'
    attack_smd_3='fire_off.smd'
    reload_sequence_2_is_alternative_start='false'
    sequence_1='draw'
    sequence_2='idle'
    sequence_3='fire_on'
    sequence_4='fire_loop'
    sequence_5='fire_off'
    apply_settings
)

(
    reset_settings
    settings_label='&::melee'
    draw_sequence='bs_draw'
    draw_smd='bs_draw.smd'
    idle_sequence='bs_idle'
    idle_smd='bs_idle.smd'
    attack_sequence_1='bs_swing_a'
    attack_sequence_2='bs_swing_b'
    attack_sequence_3='bs_swing_c'
    attack_smd_1='bs_swing_a.smd'
    attack_smd_2='bs_swing_b.smd'
    attack_smd_3='bs_swing_c.smd'
    reload_sequence_2_is_alternative_start='false'
    sequence_1='bs_draw'
    sequence_2='bs_idle'
    sequence_3='bs_swing_a'
    sequence_4='bs_swing_b'
    sequence_5='bs_swing_c'
    apply_settings
)

(
    reset_settings
    settings_label='&::allclassmelee'
    draw_sequence='melee_allclass_draw'
    draw_smd='melee_allclass_draw.smd'
    idle_sequence='melee_allclass_idle'
    idle_smd='melee_allclass_idle.smd'
    attack_sequence_1='melee_allclass_swing'
    attack_smd_1='melee_allclass_swing.smd'
    reload_sequence_2_is_alternative_start='false'
    sequence_1='melee_allclass_draw'
    sequence_2='melee_allclass_idle'
    sequence_3='melee_allclass_swing'
    apply_settings
)

(
    reset_settings
    settings_label='&::grapplehook'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='grapple_draw'
    other_sequence_2='grapple_idle'
    other_sequence_3='grapple_fire_start'
    other_sequence_4='grapple_fire_idle'
    other_sequence_5='grapple_pull_start'
    other_sequence_6='grapple_pull_idle'
    other_sequence_7='grapple_pull_end'
    sequence_1='grapple_draw'
    sequence_2='grapple_idle'
    sequence_3='grapple_fire_start'
    sequence_4='grapple_fire_idle'
    sequence_5='grapple_pull_start'
    sequence_6='grapple_pull_idle'
    sequence_7='grapple_pull_end'
    apply_settings
)

(
    reset_settings
    settings_label='&::passtimeball'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='PASSTIME_ball_pickup'
    other_sequence_2='PASSTIME_ball_idle'
    other_sequence_3='PASSTIME_ball_catch1'
    other_sequence_4='PASSTIME_ball_catch2'
    other_sequence_5='PASSTIME_ball_throw_end'
    other_sequence_6='PASSTIME_ball_throw_start'
    other_sequence_7='PASSTIME_ball_throw_loop'
    sequence_1='PASSTIME_ball_pickup'
    sequence_2='PASSTIME_ball_idle'
    sequence_3='PASSTIME_ball_catch1'
    sequence_4='PASSTIME_ball_catch2'
    sequence_5='PASSTIME_ball_throw_end'
    sequence_6='PASSTIME_ball_throw_start'
    sequence_7='PASSTIME_ball_throw_loop'
    apply_settings
)

(
    reset_settings
    settings_label='&::spellcast'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='spell_draw'
    other_sequence_2='spell_fire'
    sequence_1='spell_draw'
    sequence_2='spell_fire'
    apply_settings
)

(
    reset_settings
    settings_label='&::throw'
    draw_sequence='throw_draw'
    draw_smd='throw_draw.smd'
    idle_sequence='throw_idle'
    idle_smd='throw_idle.smd'
    attack_sequence_1='throw_fire'
    attack_smd_1='throw_fire.smd'
    reload_sequence_2_is_alternative_start='false'
    sequence_1='throw_draw'
    sequence_2='throw_idle'
    sequence_3='throw_fire'
    apply_settings
)

(
    reset_settings
    settings_label='&::syringecrossbowinspect'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='primary_inspect_start'
    other_sequence_2='primary_inspect_idle'
    other_sequence_3='primary_inspect_end'
    sequence_1='primary_inspect_start'
    sequence_2='primary_inspect_idle'
    sequence_3='primary_inspect_end'
    apply_settings
)

(
    reset_settings
    settings_label='&::medigunsinspects'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='secondary_inspect_start'
    other_sequence_2='secondary_inspect_idle'
    other_sequence_3='secondary_inspect_end'
    sequence_1='secondary_inspect_start'
    sequence_2='secondary_inspect_idle'
    sequence_3='secondary_inspect_end'
    apply_settings
)

(
    reset_settings
    settings_label='&::meleeinspects'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='melee_inspect_start'
    other_sequence_2='melee_inspect_idle'
    other_sequence_3='melee_inspect_end'
    sequence_1='melee_inspect_start'
    sequence_2='melee_inspect_idle'
    sequence_3='melee_inspect_end'
    apply_settings
)

(
    reset_settings
    settings_label='&::allclassmeleeinspects'
    reload_sequence_2_is_alternative_start='false'
    other_sequence_1='melee_allclass_inspect_start'
    other_sequence_2='melee_allclass_inspect_idle'
    other_sequence_3='melee_allclass_inspect_end'
    sequence_1='melee_allclass_inspect_start'
    sequence_2='melee_allclass_inspect_idle'
    sequence_3='melee_allclass_inspect_end'
    apply_settings
)


cd "$qc_folder_temp" || exit 1
rm -f "$settings_file"
