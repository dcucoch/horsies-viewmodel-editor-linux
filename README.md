# Horsie's Viewmodel Editor — Linux Port

[![Platform: Linux](https://img.shields.io/badge/platform-Linux-2ea44f?logo=linux&logoColor=white)](#)
[![Steam Deck](https://img.shields.io/badge/Steam%20Deck-Desktop%20Mode-1a9fff?logo=steamdeck&logoColor=white)](#)
[![TF2](https://img.shields.io/badge/game-Team%20Fortress%202-b8382e)](#)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Horsie's Viewmodel Editor for Linux.** This is a Linux port of the TF2
viewmodel editor by [a-horsey](https://github.com/a-horsey), so you can edit
Team Fortress 2 viewmodels and animations on Linux — no Windows install and no
virtual machine. It runs under Wine with the Source SDK tools and also works on
the Steam Deck in Desktop Mode.

All settings, presets, animation data and docs are from the original project.
Only the Windows batch files were replaced with bash scripts.

Original project by a-horsey:
- source: https://github.com/a-horsey/horsies-viewmodel-editor
- releases: https://github.com/a-horsey/horsies-viewmodel-editor/releases
- gamebanana: https://gamebanana.com/tools/10146
- thread: https://www.teamfortress.tv/61858/horsies-viewmodel-editor

Website and install guide: https://dcucoch.github.io/horsies-viewmodel-editor-linux/

![Horsie's Viewmodel Editor menu](https://i.imgur.com/JH5boq4.png)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/H5W12AH5GM)

## What is this?

Horsie's Viewmodel Editor is a TF2 modding tool that changes how your
viewmodels look and animate. You pick the settings you want, and it edits the
animations and packs them into a VPK in your `tf/custom` folder.

Common things people use it for:

- moving and rotating viewmodels (centered guns, custom positions)
- hiding weapons, draws, reloads or attacks
- making animations static
- removing the left arm
- keeping medigun beams, flamethrower flames or tracers visible while hidden
- applying custom viewmodel animations and the Fixed Viewmodels pack

If you searched for **Horsie's Viewmodel Editor Linux**, **TF2 viewmodel editor
Linux**, **how to edit TF2 viewmodels on Linux** or **TF2 viewmodel mods on
Steam Deck**, this is the project you want.

## Features

- Edit your viewmodels however you want. Includes many possible settings for every weapon
- Automatic preloading. Preloads the animations at game start without you having to do anything. Preloading allows you to use these in any server, no matter the sv_pure setting. Can be enabled in the menu. Does not touch your autoexec
- Fully supports the [Fixed Viewmodels](https://gamebanana.com/mods/206440) pack. All credits for creating the pack go to the author. This fixes hundreds of default animations, such as the extra hands when using the original or sapper
- Supports custom viewmodel animation mods. Automatically checks if they're compatible and applies your own settings to them.
- Everything is automatic, just pick your settings and the tool will edit the animations and place them in a VPK in your custom folder

## Setup

Needed tools: wine, wine mono (or mono), studiomdl, and vpk or python3.

```bash
# debian/ubuntu/mint
sudo apt install wine python3

# arch
sudo pacman -S wine python3

# fedora
sudo dnf install wine python3
```

Wine mono: run `winecfg` once and accept the mono prompt. If
`~/.wine/drive_c/windows/mono` exists it worked. The mono in ubuntu/mint is
missing Microsoft.VisualBasic, which crowbar needs, so use wine mono there.

studiomdl: the linux sdk depot has vpk but no studiomdl. use a windows sdk 2013
build and point STUDIOMDL at the exe:

```bash
STUDIOMDL=~/sdk2013mp-win/bin/studiomdl.exe ./start.sh
```

or download the windows depot with an account that owns the sdk:

```bash
steamcmd +@sSteamCmdForcePlatformType windows \
         +login <account> \
         +app_update 243750 validate \
         +quit
```

vpk comes with the sdk. without it the bundled python packer is used, so
python3 alone is enough.

Every tool can be overridden:

```bash
HLEXTRACT=... CROWBAR=... STUDIOMDL=... VPK=... ./start.sh
```

## Usage

1. put the folder in `.../Team Fortress 2/tf/` (recommended) or `tf/custom/`
2. `chmod +x start.sh`
3. edit `settings_<class>.txt`
4. `./start.sh`

Close tf2 before installing, it locks the vpk. Output goes to
`tf/custom/__Horsie'sViewmodelEditor.vpk`. Uninstall is in the menu.

## Fixed viewmodels

Download https://gamebanana.com/dl/469246, drop the vpk in
`fixed viewmodels addon/`, run start.sh again.

## Custom animations

Put the vpks in `custom animations/` and run start.sh. Bad ones are moved to
`custom animations/incompatible animations/` with an error_log.txt saying why.
Read `_INSTRUCTIONS.txt` in there first.

## Presets

`presets/centered guns/` has settings files. Copy the ones you want into the
main folder and run start.sh.

## Notes

- `_dev/decompiled_animations/` is a cache. Delete it anytime.
- game running = it won't install.
- wrong folder = it has to be in tf or tf/custom.
- libmimalloc.so or gameinfo.txt errors should be handled already. if they
  still show up, update the port.
- studiomdl not found = set STUDIOMDL.
- no vpk = install python3.
- more settings info is in `_README.txt`.

## FAQ

**Does Horsie's Viewmodel Editor work on Linux?**
Yes. This repository is the Linux port. The original tool only shipped Windows
batch files, so this port replaces them with bash scripts and runs the Windows
helper tools through Wine.

**Does it work on the Steam Deck?**
Yes, in Desktop Mode. The requirements are the same as any other Linux
machine: Wine, Wine Mono, and the Source SDK tools.

**Do I need Windows or a VM?**
No. You need Wine and the Source SDK tools listed in [Setup](#setup).

**Will this get me VAC banned?**
It only changes client-side viewmodel animations and packs them into a
`tf/custom` VPK, the same way any viewmodel mod works. It does not touch the
game executable or how you connect to servers. Servers with `sv_pure` can
reject custom content, but that is not a ban.

**Where do I download it?**
Use the [Releases](https://github.com/dcucoch/horsies-viewmodel-editor-linux/releases)
page, or the green Code button on this repository.

## Credits

- [a-horsey](https://github.com/a-horsey) - made the original editor, its settings, presets, animation data and docs. Also on [gamebanana](https://gamebanana.com/tools/10146) and [teamfortress.tv](https://www.teamfortress.tv/61858/horsies-viewmodel-editor)
- [mrglaster](https://github.com/mrglaster) for [CrowbarDecompiler](https://github.com/mrglaster/Source-models-decompiler-cmd)
- [UltraTechX](https://github.com/UltraTechX/) for [CrowbarCommandLine](https://github.com/UltraTechX/Crowbar-Command-Line) (not used anymore)
- [Ryan "Nemesis" Gregg](https://developer.valvesoftware.com/wiki/User:Nem) for [HLLib](https://developer.valvesoftware.com/wiki/HLLib)
- [yttrium](https://github.com/Yttrium-tYcLief), [JarateKing](https://github.com/JarateKing), [mastercoms](https://github.com/mastercoms) and others in the mastercomfig discord for all the viewmodel info
- [Flewvar](https://gamebanana.com/members/1764119) for some left-arm removal assets (not used anymore)
- [newguy111](https://gamebanana.com/members/1609859) for the kunai/eternal reward/sharp dresser idle fix, and [N-Cognito](https://github.com/N-Cognito) for the files
- Discord user Arlwiss - testing and bug reports
- [Peaches](https://github.com/PapaPeach) - let me use his discord for debugging
- [Valve Developer Community](https://developer.valvesoftware.com/wiki/Main_Page)

## License

MIT. Original copyright (c) 2022 a-horsey, kept in [LICENSE](LICENSE). This
port is a derivative work and isn't endorsed by the original author.
