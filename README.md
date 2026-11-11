# Horsie's Viewmodel Editor (Linux port)

Linux port of Horsie's Viewmodel Editor for Team Fortress 2.

Original project by a-horsey:
- source: https://github.com/a-horsey/horsies-viewmodel-editor
- releases: https://github.com/a-horsey/horsies-viewmodel-editor/releases
- gamebanana: https://gamebanana.com/tools/10146
- thread: https://www.teamfortress.tv/61858/horsies-viewmodel-editor

All settings, presets, animation data and docs are from the original project.
Only the windows batch files were replaced with bash scripts.

![Thumbnail](https://i.imgur.com/JH5boq4.png)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/H5W12AH5GM)
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
