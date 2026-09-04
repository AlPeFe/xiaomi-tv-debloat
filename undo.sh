#!/usr/bin/env bash
# ============================================================
#  UNDO EVERYTHING — Xiaomi TV debloat (MiTV-MSSP3)
#  Re-enables every disabled package and restores animations.
#  Nothing was ever uninstalled, so this fully restores stock.
#
#  Usage:  bash undo.sh [TV_IP]      (default 192.168.31.201)
# ============================================================
set -e
IP="${1:-192.168.31.201}"
ADB="adb"

echo "==> Connecting to $IP ..."
"$ADB" connect "$IP:5555" >/dev/null 2>&1 || true

DISABLED=(
  # Lote 1 — telemetría + peso muerto Google
  com.miui.tv.analytics
  com.xiaomi.statistic
  com.google.android.play.games
  com.google.android.backdrop
  com.google.android.videos
  com.google.android.music
  com.google.android.marvin.talkback
  com.amazon.amazonvideo.livingroom
  com.android.dreams.basic
  com.google.android.feedback
  # Lote 2 — Xiaomi/MediaTek
  com.xiaomi.mitv.tvmanager
  com.xiaomi.mitv.updateservice
  com.xiaomi.floatingframe
  com.mitv.gallery
  com.mitv.tvlock
  com.xiaomi.mitv.mediaexplorer
  com.xm.webcontent
  com.xiaomo.tv.milegal
  com.mitv.tvhome.mitvplus
  com.mediatek.androidbox
  # Lote 3 — resto
  com.mediatek.tv.factory
  com.mediatek.wwtv.tvcenter
  com.android.printspooler
  com.android.sharedstoragebackup
  com.android.backupconfirm
  com.google.android.tv.bugreportsender
  com.google.android.leanbacklauncher.recommendations
  com.google.android.tvrecommendations
  com.xiaomi.mimusic2
  # Lote 4 — launchers (deshabilitados SOLO tras instalar FLauncher)
  com.google.android.tvlauncher
  com.mitv.tvhome.atv
)

echo "==> Re-enabling ${#DISABLED[@]} packages ..."
for p in "${DISABLED[@]}"; do
  echo "  + $p"
  "$ADB" -s "$IP:5555" shell pm enable --user 0 "$p" >/dev/null 2>&1 || true
done

echo "==> Restoring animations to 1.0 ..."
"$ADB" -s "$IP:5555" shell settings put global window_animation_scale 1.0 || true
"$ADB" -s "$IP:5555" shell settings put global transition_animation_scale 1.0 || true
"$ADB" -s "$IP:5555" shell settings put global animator_duration_scale 1.0 || true

echo "==> Done. The TV is back to stock (FLauncher remains installed but is no longer forced)."
echo "    If you want FLauncher to stop being the default, re-enable a stock launcher above."
