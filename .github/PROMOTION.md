# Promotion blurbs

Ready-to-paste posts for getting the Linux port in front of people. Keep the
tone as "I ported this and thought it might help" — most communities are fine
with that, but always read the subreddit/server rules before posting.

Repo: https://github.com/dcucoch/horsies-viewmodel-editor-linux
Site: https://dcucoch.github.io/horsies-viewmodel-editor-linux/
Release: https://github.com/dcucoch/horsies-viewmodel-editor-linux/releases/latest

---

## One-liner (profile bio, signatures, Discord status)

> Linux port of Horsie's Viewmodel Editor for TF2 — edit viewmodels on Linux and Steam Deck without Windows: https://github.com/dcucoch/horsies-viewmodel-editor-linux

## Short version (Discord, Matrix, IRC, comments)

> I ported Horsie's Viewmodel Editor to Linux. It's the same editor and the same settings, but the Windows batch files are replaced with bash and the helper tools run through Wine. Works on desktop Linux and on the Steam Deck in Desktop Mode. No Windows or VM needed.
>
> https://github.com/dcucoch/horsies-viewmodel-editor-linux

---

## r/tf2

**Title:** I ported Horsie's Viewmodel Editor to Linux (and Steam Deck)

**Body:**

> Horsie's Viewmodel Editor is one of the best viewmodel tools for TF2, but it only shipped Windows batch files, so Linux users were stuck. I ported it: the settings, presets and animation data are unchanged, but the scripts are bash now and the Windows helper tools run through Wine.
>
> It does the usual stuff — move/rotate viewmodels, hide weapons or individual animations, make animations static, remove the left arm, keep medigun beams/flames/tracers, support Fixed Viewmodels and custom animation packs — and packs everything into a `tf/custom` VPK.
>
> Runs on desktop Linux and on the Steam Deck in Desktop Mode. You need Wine, Wine Mono and the Source SDK tools; setup is in the README.
>
> Repo: https://github.com/dcucoch/horsies-viewmodel-editor-linux
> Site with install steps: https://dcucoch.github.io/horsies-viewmodel-editor-linux/
>
> Original editor by a-horsey: https://github.com/a-horsey/horsies-viewmodel-editor — all credit for the tool, settings and animation data goes to him. I only did the Linux side.

## r/linux_gaming

**Title:** Horsie's Viewmodel Editor for TF2 now has a Linux port (Wine, no VM)

**Body:**

> If you play TF2 on Linux, this is a niche but useful one. Horsie's Viewmodel Editor only had Windows batch files, so I ported it to bash and kept the original settings, presets and animation data. The Windows helper tools (HLExtract, Crowbar, studiomdl, vpk) run through Wine.
>
> It edits viewmodel animations and writes a VPK to `tf/custom` — positions, rotations, hiding, static animations, left-arm removal, custom animation packs, Fixed Viewmodels.
>
> Tested setup is Wine + Wine Mono + Source SDK tools. The README has install commands for Debian/Ubuntu, Arch and Fedora. Steam Deck works in Desktop Mode.
>
> https://github.com/dcucoch/horsies-viewmodel-editor-linux
>
> The original tool is by a-horsey: https://github.com/a-horsey/horsies-viewmodel-editor

## r/SteamDeck

**Title:** TF2 viewmodel editing on Steam Deck — Horsie's Viewmodel Editor Linux port

**Body:**

> For anyone who tweaks TF2 on their Deck: I ported Horsie's Viewmodel Editor to Linux. You run it from Desktop Mode, point it at your `tf` folder and it writes the mod VPK to `tf/custom`.
>
> It supports custom positions/rotations, hiding weapons or animations, static animations, left-arm removal, custom animation packs and the Fixed Viewmodels pack.
>
> Needs Wine, Wine Mono and the Source SDK tools. Full steps: https://dcucoch.github.io/horsies-viewmodel-editor-linux/
>
> Source: https://github.com/dcucoch/horsies-viewmodel-editor-linux

---

## teamfortress.tv thread reply

> For anyone finding this thread on Linux: I made a Linux port of the editor. Same settings, presets and animation data — the batch files are bash and the helper tools run through Wine. Works on desktop Linux and the Steam Deck in Desktop Mode.
>
> https://github.com/dcucoch/horsies-viewmodel-editor-linux
>
> Thanks to a-horsey for the original tool and for keeping the settings/data easy to reuse.

## GameBanana comment (on the original tool page)

> Made a Linux port of this for anyone who doesn't want to deal with Windows batch files: https://github.com/dcucoch/horsies-viewmodel-editor-linux
>
> All credit to a-horsey for the editor, settings, presets and animation data. The port only replaces the Windows scripts with bash and runs the helper tools through Wine.

## Steam Community guide (intro paragraph)

> **How to edit TF2 viewmodels on Linux (and Steam Deck)**
>
> Horsie's Viewmodel Editor is a Windows tool, but there is a Linux port that keeps all of its settings: https://github.com/dcucoch/horsies-viewmodel-editor-linux
>
> This guide covers installing Wine and the Source SDK tools, putting the editor in your `tf` folder, editing `settings_<class>.txt`, and running `./start.sh` to build the viewmodel VPK. Works on desktop Linux and on the Steam Deck in Desktop Mode.
>
> Original editor by a-horsey. Linux port by dcucoch.

## Social post (Bluesky / Mastodon / X)

> Ported Horsie's Viewmodel Editor to Linux. Same TF2 viewmodel settings, presets and animation support — bash instead of Windows batch files, Wine for the helper tools. Desktop Linux and Steam Deck (Desktop Mode), no Windows or VM.
>
> https://github.com/dcucoch/horsies-viewmodel-editor-linux

---

## Posting checklist

- Read the rules of each community first. Some ban self-promotion or require
  moderator approval.
- Flair the post correctly (e.g. "Modding" on r/tf2).
- Answer questions in the comments; that is what keeps the post visible.
- Do not post the same link to five subreddits at once. Space it out.
- Ask people who actually use it to star the repo — stars are a ranking signal
  on GitHub and a trust signal for search engines.
- After the Pages site is live, submit the URL in Google Search Console and
  request indexing.
