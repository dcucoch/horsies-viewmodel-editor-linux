#!/usr/bin/env bash
# Weight-list and sequence data used by the left-arm removal helper.
# These functions append their data to $qc_file and create the
# layer_and_weights_added_<class> marker used by remove_left_arm().

_remove_left_arm_add_layers_and_weights_scout() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_collar_L" 1
"bip_collar_R" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_collar_L" 0
"bip_collar_R" 0
"bip_upperArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_L" 0
"bip_lowerArm_R" 0
"bip_hand_L" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$weightlist "remove_shell_shortstop" {
"root" 0
"bip_collar_L" 0
"bip_collar_R" 0
"bip_upperArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_L" 0
"bip_lowerArm_R" 0
"bip_hand_L" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 1
"vm_weapon_bone_2" 1
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_scout_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_scout_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell_shortstop" {
"c_scout_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell_shortstop"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_scout
}

_remove_left_arm_add_layers_and_weights_soldier() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_wrist_L" 1
"bip_wrist_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 1
"handle_bone" 0
"rocket" 0
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_meta_0_L" 1
"bip_index_meta_0_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_meta_0_L" 1
"bip_middle_meta_0_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_meta_0_L" 1
"bip_ring_meta_0_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_meta_0_L" 1
"bip_pinky_meta_0_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_upperArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_L" 0
"bip_lowerArm_R" 0
"bip_wrist_L" 0
"bip_wrist_R" 0
"bip_hand_L" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 0
"handle_bone" 0
"rocket" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_meta_0_L" 0
"bip_index_meta_0_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_meta_0_L" 0
"bip_middle_meta_0_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_meta_0_L" 0
"bip_ring_meta_0_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_meta_0_L" 0
"bip_pinky_meta_0_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_soldier_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_soldier_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_soldier
}

_remove_left_arm_add_layers_and_weights_pyro() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_collar_L" 1
"bip_collar_R" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_collar_L" 0
"bip_collar_R" 0
"bip_upperArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_L" 0
"bip_lowerArm_R" 0
"bip_hand_L" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_pyro_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_pyro_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_pyro
}

_remove_left_arm_add_layers_and_weights_demo() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_upperArm_L" 1
"bip_lowerArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_wrist_R" 0
"bip_hand_R" 0
"bip_wrist_L" 1
"bip_hand_L" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 1
"weapon_targe" 0
"weapon_bone_4" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"bip_middle_meta_0_L" 1
"bip_middle_0_L" 1
"bip_middle_1_L" 1
"bip_middle_2_L" 1
"bip_ring_meta_0_L" 1
"bip_ring_0_L" 1
"bip_ring_1_L" 1
"bip_ring_2_L" 1
"bip_pinky_meta_0_L" 1
"bip_pinky_0_L" 1
"bip_pinky_1_L" 1
"bip_pinky_2_L" 1
"bip_index_meta_0_L" 1
"bip_index_0_L" 1
"bip_index_1_L" 1
"bip_index_2_L" 1
"bip_thumb_0_L" 1
"bip_thumb_1_L" 1
"bip_thumb_2_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_R" 0
"bip_thumb_2_R" 0
"bip_index_meta_0_R" 0
"bip_index_0_R" 0
"bip_index_1_R" 0
"bip_index_2_R" 0
"bip_middle_meta_0_R" 0
"bip_middle_0_R" 0
"bip_middle_1_R" 0
"bip_middle_2_R" 0
"bip_ring_meta_0_R" 0
"bip_ring_0_R" 0
"bip_ring_1_R" 0
"bip_ring_2_R" 0
"bip_pinky_meta_0_R" 0
"bip_pinky_0_R" 0
"bip_pinky_1_R" 0
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_upperArm_L" 0
"bip_lowerArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_wrist_R" 0
"bip_hand_R" 0
"bip_wrist_L" 0
"bip_hand_L" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 0
"weapon_targe" 0
"weapon_bone_4" 1
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"bip_middle_meta_0_L" 0
"bip_middle_0_L" 0
"bip_middle_1_L" 0
"bip_middle_2_L" 0
"bip_ring_meta_0_L" 0
"bip_ring_0_L" 0
"bip_ring_1_L" 0
"bip_ring_2_L" 0
"bip_pinky_meta_0_L" 0
"bip_pinky_0_L" 0
"bip_pinky_1_L" 0
"bip_pinky_2_L" 0
"bip_index_meta_0_L" 0
"bip_index_0_L" 0
"bip_index_1_L" 0
"bip_index_2_L" 0
"bip_thumb_0_L" 0
"bip_thumb_1_L" 0
"bip_thumb_2_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_R" 0
"bip_thumb_2_R" 0
"bip_index_meta_0_R" 0
"bip_index_0_R" 0
"bip_index_1_R" 0
"bip_index_2_R" 0
"bip_middle_meta_0_R" 0
"bip_middle_0_R" 0
"bip_middle_1_R" 0
"bip_middle_2_R" 0
"bip_ring_meta_0_R" 0
"bip_ring_0_R" 0
"bip_ring_1_R" 0
"bip_ring_2_R" 0
"bip_pinky_meta_0_R" 0
"bip_pinky_0_R" 0
"bip_pinky_1_R" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_demo_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_demo_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_demo
}

_remove_left_arm_add_layers_and_weights_heavy() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_collar_L" 1
"bip_upperArm_L" 1
"bip_lowerArm_L" 1
"bip_hand_L" 1
"bip_collar_R" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 1
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_1_L" 1
"vm_weapon_bone_2_L" 1
"vm_weapon_bone_3_L" 1
"vm_weapon_bone_4_L" 1
"effect_hand_L" 1
"effect_hand_R" 0
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_collar_L" 0
"bip_upperArm_L" 0
"bip_lowerArm_L" 0
"bip_hand_L" 0
"bip_collar_R" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_1_L" 0
"vm_weapon_bone_2_L" 0
"vm_weapon_bone_3_L" 0
"vm_weapon_bone_4_L" 0
"effect_hand_L" 0
"effect_hand_R" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_shell" {
"c_heavy_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
$sequence "remove_left_arm" {
"c_heavy_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_heavy
}

_remove_left_arm_add_layers_and_weights_engineer() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_wrist_L" 1
"bip_wrist_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"arm_attach_R" 0
"bip_twist_R" 0
"forearm_twist_01_L" 1
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_meta_0_L" 1
"bip_index_meta_0_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_meta_0_L" 1
"bip_middle_meta_0_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_meta_0_L" 1
"bip_ring_meta_0_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_meta_0_L" 1
"bip_pinky_meta_0_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_wrist_L" 1
"bip_wrist_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"arm_attach_R" 0
"bip_twist_R" 0
"forearm_twist_01_L" 1
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_meta_0_L" 1
"bip_index_meta_0_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_meta_0_L" 1
"bip_middle_meta_0_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_meta_0_L" 1
"bip_ring_meta_0_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_meta_0_L" 1
"bip_pinky_meta_0_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_engineer_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_engineer_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_engineer
}

_remove_left_arm_add_layers_and_weights_medic() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_collar_L" 1
"bip_upperArm_L" 1
"bip_lowerArm_L" 1
"bip_hand_L" 0
"bip_collar_R" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_collar_L" 0
"bip_upperArm_L" 0
"bip_lowerArm_L" 0
"bip_hand_L" 0
"bip_collar_R" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_L" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_medic_animations_anims\PASSTIME_ball_idle.smd"
 frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_medic_animations_anims\PASSTIME_ball_idle.smd"
 frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_medic
}

_remove_left_arm_add_layers_and_weights_sniper() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_collar_L" 1
"bip_collar_R" 0
"bip_upperArm_L" 1
"bip_upperArm_R" 0
"bip_lowerArm_L" 1
"bip_lowerArm_R" 0
"bip_hand_L" 1
"bip_hand_R" 0
"effect_hand_L" 1
"effect_hand_R" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_collar_L" 0
"bip_collar_R" 0
"bip_upperArm_L" 0
"bip_upperArm_R" 0
"bip_lowerArm_L" 0
"bip_lowerArm_R" 0
"bip_hand_L" 0
"bip_hand_R" 0
"effect_hand_L" 0
"effect_hand_R" 0
"vm_weapon_bone" 1
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_L" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
}
$sequence "remove_left_arm" {
"c_sniper_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_sniper_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_sniper
}

_remove_left_arm_add_layers_and_weights_spy() {
    cat >> "$qc_file" <<'REMOVE_LEFT_ARM_DATA_EOF'
$weightlist "remove_left_arm" {
"root" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"bip_upperArm_L" 1
"bip_lowerArm_L" 1
"bip_hand_L" 0
"effect_hand_L" 1
"effect_hand_R" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 0
"weapon_bone_5" 0
"weapon_bone_6" 0
"weapon_bone_7" 0
"weapon_bone_L" 1
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 1
"vm_weapon_bone_L_1" 1
"vm_weapon_bone_L_2" 1
"bip_thumb_0_L" 1
"bip_thumb_0_R" 0
"bip_thumb_1_L" 1
"bip_thumb_1_R" 0
"bip_thumb_2_L" 1
"bip_thumb_2_R" 0
"bip_index_0_L" 1
"bip_index_0_R" 0
"bip_index_1_L" 1
"bip_index_1_R" 0
"bip_index_2_L" 1
"bip_index_2_R" 0
"bip_middle_0_L" 1
"bip_middle_0_R" 0
"bip_middle_1_L" 1
"bip_middle_1_R" 0
"bip_middle_2_L" 1
"bip_middle_2_R" 0
"bip_ring_0_L" 1
"bip_ring_0_R" 0
"bip_ring_1_L" 1
"bip_ring_1_R" 0
"bip_ring_2_L" 1
"bip_ring_2_R" 0
"bip_pinky_0_L" 1
"bip_pinky_0_R" 0
"bip_pinky_1_L" 1
"bip_pinky_1_R" 0
"bip_pinky_2_L" 1
"bip_pinky_2_R" 0
"Sleeve_Control" 0
"Wrist_Control" 0
}
$weightlist "remove_shell" {
"root" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"bip_upperArm_L" 0
"bip_lowerArm_L" 0
"bip_hand_L" 0
"effect_hand_L" 0
"effect_hand_R" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 0
"weapon_bone_4" 1
"weapon_bone_5" 0
"weapon_bone_6" 0
"weapon_bone_7" 0
"weapon_bone_L" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
"Sleeve_Control" 0
"Wrist_Control" 0
}
$weightlist "remove_shell_fix" {
"root" 0
"bip_upperArm_R" 0
"bip_lowerArm_R" 0
"bip_hand_R" 0
"bip_upperArm_L" 0
"bip_lowerArm_L" 0
"bip_hand_L" 0
"effect_hand_L" 0
"effect_hand_R" 0
"weapon_bone" 0
"weapon_bone_1" 0
"weapon_bone_2" 0
"weapon_bone_3" 1
"weapon_bone_4" 1
"weapon_bone_5" 0
"weapon_bone_6" 0
"weapon_bone_7" 0
"weapon_bone_L" 0
"vm_weapon_bone" 0
"vm_weapon_bone_1" 0
"vm_weapon_bone_2" 0
"vm_weapon_bone_3" 0
"vm_weapon_bone_4" 0
"vm_weapon_bone_5" 0
"vm_weapon_bone_6" 0
"vm_weapon_bone_7" 0
"vm_weapon_bone_L" 0
"vm_weapon_bone_L_1" 0
"vm_weapon_bone_L_2" 0
"bip_thumb_0_L" 0
"bip_thumb_0_R" 0
"bip_thumb_1_L" 0
"bip_thumb_1_R" 0
"bip_thumb_2_L" 0
"bip_thumb_2_R" 0
"bip_index_0_L" 0
"bip_index_0_R" 0
"bip_index_1_L" 0
"bip_index_1_R" 0
"bip_index_2_L" 0
"bip_index_2_R" 0
"bip_middle_0_L" 0
"bip_middle_0_R" 0
"bip_middle_1_L" 0
"bip_middle_1_R" 0
"bip_middle_2_L" 0
"bip_middle_2_R" 0
"bip_ring_0_L" 0
"bip_ring_0_R" 0
"bip_ring_1_L" 0
"bip_ring_1_R" 0
"bip_ring_2_L" 0
"bip_ring_2_R" 0
"bip_pinky_0_L" 0
"bip_pinky_0_R" 0
"bip_pinky_1_L" 0
"bip_pinky_1_R" 0
"bip_pinky_2_L" 0
"bip_pinky_2_R" 0
"Sleeve_Control" 0
"Wrist_Control" 0
}
$sequence "remove_left_arm" {
"c_spy_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_left_arm"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell" {
"c_spy_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell"
blend "bone_destroyer" 0 0
}
$sequence "remove_shell_fix" {
"c_spy_animations_anims\PASSTIME_ball_idle.smd"
frame 0 0
fps 1
hidden
realtime
loop
weightlist "remove_shell_fix"
blend "bone_destroyer" 0 0
}
REMOVE_LEFT_ARM_DATA_EOF
    printf 'added_weights_and_layers\n' > layer_and_weights_added_spy
}
