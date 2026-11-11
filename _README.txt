Horsie's Viewmodel Editor - Linux port

	Linux port of Horsie's Viewmodel Editor, made by a-horsey.
	All the original design, settings, presets and animation data belong to him.
	The port only swaps the windows batch files for bash scripts.
		https://github.com/a-horsey/horsies-viewmodel-editor
		https://gamebanana.com/tools/10146
		https://www.teamfortress.tv/61858/horsies-viewmodel-editor

	Run ./start.sh to open the menu.
	Wine, Wine Mono, studiomdl and vpk setup is in README.md.

	How to install:
1. Put this folder in your game's "tf" folder. I recommend that one.
      .../Team Fortress 2/tf/horsies-viewmodel-editor
   "tf/custom" works too.
2. Open the settings_class.txt files you care about. settings_scout.txt for
   scout, and so on. Any text editor works.
3. Run ./start.sh, then pick all classes or specific ones.
4. Close tf2 first. It keeps the vpk locked while it's open.

	Preloading, Fixed Viewmodels and custom animations:
1. Preloading lets the viewmodels work on any server, no matter the sv_pure
setting. It can preload at game start. It's recommended but optional, and it
doesn't touch your autoexec.

2. Fixed Viewmodels fixes a lot of default animations
(https://gamebanana.com/mods/206440). Drop the vpk in "fixed viewmodels addon"
and it gets applied next run. Credits go to the author.

3. Custom animation mods go in "custom animations". They get checked and
installed on the next run. Bad ones end up in "incompatible animations" with
an error log. Read "_INSTRUCTIONS.txt" in that folder first.

	Settings:
Positions - moves the weapon on the X, Y and Z axes. See guide_position.jpg.
Rotations - rotates it on the same axes. See guide_rotation.jpg.

Hiding - every weapon has a hide option. You can keep single animations
visible while hiding the rest, like draws, reloads and attacks.

Static - the animation stops moving and acts like the idle. Works on draws,
reloads, attacks and most other animations.

Left arm - "Remove_left_arm" removes it from most weapons. It's there even for
weapons without a visible arm because it helps with glitches at high
viewmodel_fov and with custom animations that put the arm back.

Weapon specific - some options only exist for certain weapons, like shell
ejection or the spy knife stuff.

	The animations you can keep visible or make static:
	- draw: when you switch to the weapon
	- reload
	- attack
	- secondary attack (mouse2)
	- idle: "More_static_idle" also stops the sway while standing still.
	  Moving still sways, that part is hardcoded.
	- special ones: backstabs, backstab detection, shortstop shove, etc

	Weapon specific settings:
	- mediguns: Keep_beam_visible keeps the heal beam when hidden. it's
	  visible anyway if the attack isn't hidden.
	- flamethrowers: Keep_flames_visible does the same for flames.
	- spy knives:
		Keep_backstab_detection_visible - keep the detection when hidden
		Keep_backstab_visible - keep the backstab when hidden
		Instant_backstab_detection - knife goes up as soon as you can stab
		Replace_backstab_with_normal_attack - uses a normal attack instead
		Static_backstab_detection - knife doesn't move while you can stab
		Static_backstab - knife doesn't move while stabbing
	- shotguns, scatterguns, sniper rifles: Remove_shells stops the shells
	- bullet weapons except sniper rifle: Keep_tracers_visible keeps tracers
	  when hidden. turning it off gives harmless console errors.

	Troubleshooting:
	- "Wrong folder!" - move it into tf/ or tf/custom/ and run it there
	- "Game is currently running" - close tf2
	- missing wine, wine mono, studiomdl or vpk - see README.md
	- anything else - README.md, then github issues or gamebanana comments
