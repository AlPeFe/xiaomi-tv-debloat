# Xiaomi Mi TV Debloat & Speed-Up (Android TV)

Clean up your **Xiaomi / Redmi Android TV** over ADB: kill the ads and recommendation
rows, disable the factory bloat you never use, free storage and RAM, and replace the
stock launcher with [FLauncher](https://gitlab.com/flauncher/flauncher) — all **without
rooting and without uninstalling anything**. Every step is **100% reversible** with a
single command.

Adapted from the excellent [tv.cobanov.dev guide](https://tv.cobanov.dev/) (originally
written for TCL TVs) to the Xiaomi `MiTV`/`PatchWall` ecosystem, which behaves
differently in one critical way (see [The Xiaomi Home-button trap](#the-xiaomi-home-button-trap)).

Tested on: **Xiaomi MiTV-MSSP3** ("machuca", Android 9 / SDK 28, MIUI TV, MediaTek).

---

## Results (before → after, verified after reboot)

| Metric | Before | After | Delta |
|---|---|---|---|
| RAM available (`MemAvailable`) | 331 MB | **933 MB** | **+602 MB (×2.8)** |
| Storage free on `/data` | 280 MB (94% used) | **783 MB (81% used)** | **+503 MB** |
| Animation scales | 1.0 / 1.0 / null | 0.5 / 0.5 / 0.5 | snappier UI |
| Disabled packages | 0 | 31 | — |
| Home launcher | Google TV launcher (ads) | **FLauncher** (clean grid) | no ads |

> The free storage came from `pm trim-caches` (caches of old apps) — even if you
> disable nothing else, on a nearly-full TV this alone can free half a GB.

---

## Prerequisites

1. **ADB** — on Windows grab Google's
   [platform-tools](https://developer.android.com/studio/releases/platform-tools);
   on macOS `brew install android-platform-tools`; on Linux `apt install adb`.
2. **On the TV:** Settings → About → press OK on **Build** 7× (developer mode).
   Settings → Developer options → **USB debugging** (and wireless debugging if present).
3. **TV's IP** — Settings → Network → Status. Same network as your computer.
4. Connect: `adb connect <TV_IP>:5555` and **approve the dialog on the TV**.
   (On Android 11+ wireless debugging may need `adb pair` with a code first.)

---

## The golden rules (do not skip)

1. **NEVER `pm uninstall`.** Only `pm disable-user --user 0 <pkg>`.
   Undo: `pm enable <pkg>`. Nothing is ever removed from the device.
2. **Never disable a package you can't identify.** On TCL TVs disabling
   `com.tcl.suspension` killed the Inputs button; each brand has its own traps.
   For Xiaomi, the trap is the launcher — see below.
3. **Don't disable the current home launcher before installing a new one** —
   instant black screen.
4. **Don't root / unlock the bootloader.** Factory-resets the TV and can drop
   Widevine from L1 to L3 (Netflix falls to SD). Disable-user already does all you need.
5. **Measure first.** Capture `dumpsys meminfo`, `pm list packages -s`,
   `pm list packages -d` before and after, and compare.
6. **Work in small batches** (≤10 packages), then test: Inputs/HDMI switch, Netflix,
   YouTube, sound, on-screen keyboard. Re-enable the last batch first if something breaks.

---

## The Xiaomi Home-button trap ⚠️

This is the part that differs from the original guide.

On TCL/stock Android TV, pressing **Home** fires the standard HOME intent and Android
shows a "complete action with…" chooser. **Xiaomi does not.** The physical Home button
is hard-wired to **PatchWall** (`com.mitv.tvhome.atv`) — the Xiaomi launcher with ads.
No matter what you set as default, Home keeps landing on PatchWall. The usual
"install FLauncher → press Home → choose launcher" flow never happens.

**Fix (verified on MiTV-MSSP3):** after installing and opening FLauncher, disable
**both** old launchers — `com.google.android.tvlauncher` (the active default) AND
`com.mitv.tvhome.atv` (PatchWall, which hijacks Home):

```bash
adb shell cmd package set-home-activity me.efesser.flauncher/me.efesser.flauncher.MainActivity   # optional, works on Android 9+
adb shell pm disable-user --user 0 com.google.android.tvlauncher
adb shell pm disable-user --user 0 com.mitv.tvhome.atv
```

Now Home lands on FLauncher. Reversible with `pm enable` on either package.

> FLauncher's package name is **`me.efesser.flauncher`** — the old `app.etiennel.fLauncher`
> is gone. Get it from [GitLab](https://gitlab.com/flauncher/flauncher/-/releases)
> (`flauncher-0.18.0.apk` ≈ 26 MB); the old GitHub repo 404s.

---

## What we disabled (31 packages, 4 batches)

### Batch 1 — telemetry + dead Google weight (10)
| Package | What it was |
|---|---|
| `com.miui.tv.analytics` | Xiaomi telemetry / ad usage |
| `com.xiaomi.statistic` | Xiaomi statistics |
| `com.google.android.play.games` | Play Games (useless on TV) |
| `com.google.android.backdrop` | Ambient wallpaper screensaver |
| `com.google.android.videos` | Google Play Movies |
| `com.google.android.music` | Legacy Play Music |
| `com.google.android.marvin.talkback` | TalkBack accessibility |
| `com.amazon.amazonvideo.livingroom` | Prime Video (if you don't use it) |
| `com.android.dreams.basic` | Basic screensaver |
| `com.google.android.feedback` | Google feedback sender |

### Batch 2 — Xiaomi/MediaTek junk (10)
| Package | What it was |
|---|---|
| `com.xiaomi.mitv.tvmanager` | Xiaomi TV manager |
| `com.xiaomi.mitv.updateservice` | Xiaomi update service |
| `com.xiaomi.floatingframe` | Xiaomi floating frame |
| `com.mitv.gallery` | Xiaomi gallery |
| `com.mitv.tvlock` | Parental lock |
| `com.xiaomi.mitv.mediaexplorer` | Media explorer |
| `com.xm.webcontent` | Web content |
| `com.xiaomo.tv.milegal` | Legal check |
| `com.mitv.tvhome.mitvplus` | Xiaomi launcher's recommendation row (ads) |
| `com.mediatek.androidbox` | MediaTek demo app box |

### Batch 3 — the rest (9)
| Package | What it was |
|---|---|
| `com.mediatek.tv.factory` | MediaTek factory menu |
| `com.mediatek.wwtv.tvcenter` | MediaTek TV center |
| `com.android.printspooler` | Printing (why is this on a TV) |
| `com.android.sharedstoragebackup` | Shared storage backup |
| `com.android.backupconfirm` | Backup confirmation |
| `com.google.android.tv.bugreportsender` | Bug report sender |
| `com.google.android.leanbacklauncher.recommendations` | Launcher ads row |
| `com.google.android.tvrecommendations` | Google TV recommendations (ads) |
| `com.xiaomi.mimusic2` | Xiaomi Music (we use Spotify) |

### Batch 4 — launchers (2) — ONLY after FLauncher is installed & verified
| Package | What it was |
|---|---|
| `com.google.android.tvlauncher` | Google TV home (ads) |
| `com.mitv.tvhome.atv` | PatchWall — Xiaomi home, hijacks Home button |

### Untouchable (map of the original guide's do-not-disable list)
| Package | Why |
|---|---|
| `com.google.android.tv.remote.service` | Remote control |
| `com.android.bluetooth` | BT remote |
| `com.android.location.fused` | Boot loop if disabled |
| `com.google.android.gms` / `com.google.android.gsf` | Play Services |
| `com.android.vending` | Play Store |
| `com.google.android.inputmethod.latin` | On-screen keyboard |
| `com.mediatek.tvinput` / `com.mediatek.tvinputservice.arbitratorservice` | HDMI / antenna inputs |
| `com.mediatek.hotkey.dispatcher` | Remote hotkeys |
| `com.android.tv.settings` | Settings |
| `com.mitv.tvhome.atv` + `mitv.service` | Xiaomi base layer (disable only the launcher part deliberately, see above) |
| `com.google.android.katniss` / `com.google.android.apps.mediashell` | **Chromecast built-in** — keep if you cast! |

---

## Extra speed-ups

```bash
# Halve animation scales (snappier)
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5

# Free storage by trimming caches of all apps
adb shell pm trim-caches 8G
```

---

## Full undo (one command)

`undo.sh` re-enables all 31 packages and restores animations. Run it from this repo:

```bash
bash undo.sh 192.168.31.201
```

Or manually: `adb shell pm enable <package>` per package (see `disabled-packages.txt` for the
complete list) and `adb shell settings put global <scale> 1.0`.

---

## Repo contents

| File | What |
|---|---|
| `README.md` | This guide |
| `DEBLOAT-LOG.md` | Full before/after log with per-package undo commands |
| `disabled-packages.txt` | Machine-readable list of every disabled package |
| `undo.sh` | One-command full revert |

## Credits & sources
- [tv.cobanov.dev — Clean up your Android TV](https://tv.cobanov.dev/)
- [FLauncher](https://gitlab.com/flauncher/flauncher) — free, open-source launcher
