# DEBLOAT-LOG — Xiaomi MiTV-MSSP3 (machuca)

**IP:** 192.168.31.201 (ADB 5555) · **SO:** Android 9 (SDK 28) MIUI TV · **RAM:** 1.8 GB · **Almacenamiento:** 4.1 GB
**Método:** `pm disable-user --user 0` — NADA se desinstala, todo reversible.
**Fuente del procedimiento:** https://tv.cobanov.dev/ (adaptado a Xiaomi desde TCL).
**Fecha ejecución:** 2026-09-04

---

## Medidas base (antes)

- `MemTotal`: 1,875,028 kB — `MemFree`: 196,000 kB — `MemAvailable`: 331,104 kB
- `/data`: 4.1G total, 3.7G usado, 280M libres (94%)
- Animaciones: window=1.0, transition=1.0, animator=null
- Paquetes deshabilitados antes: 0

---

## Medidas finales (después, tras reboot)

- `MemFree`: 162,000 kB — `MemAvailable`: **933,592 kB** (antes 331,104 → +602 MB disponibles, ×2.8)
- `/data`: 3.2G usado, **783M libres (81%)** (antes 280M/94% → +503 MB liberados)
- Animaciones: window=0.5, transition=0.5, animator=0.5
- Paquetes deshabilitados: **31** (29 debloat + 2 launchers viejos)
- HOME resolver: `me.efesser.flauncher/.MainActivity` (FLauncher) ✓ tras reboot

---

## Lote 1 (2026-09-04) — 10 paquetes

| Paquete | Qué era | Deshacer |
|---|---|---|
| com.miui.tv.analytics | Telemetría/ads Xiaomi | `pm enable com.miui.tv.analytics` |
| com.xiaomi.statistic | Estadísticas Xiaomi | `pm enable com.xiaomi.statistic` |
| com.google.android.play.games | Play Games (inútil en TV) | `pm enable com.google.android.play.games` |
| com.google.android.backdrop | Fondo/ambient mode | `pm enable com.google.android.backdrop` |
| com.google.android.videos | Google Play Movies | `pm enable com.google.android.videos` |
| com.google.android.music | Play Music (obsoleto) | `pm enable com.google.android.music` |
| com.google.android.marvin.talkback | TalkBack (accesibilidad) | `pm enable com.google.android.marvin.talkback` |
| com.amazon.amazonvideo.livingroom | Prime Video | `pm enable com.amazon.amazonvideo.livingroom` |
| com.android.dreams.basic | Protector de pantalla | `pm enable com.android.dreams.basic` |
| com.google.android.feedback | Feedback de Google | `pm enable com.google.android.feedback` |

**Test usuario:** pendiente → remote OK, HDMI OK, apps OK, sonido OK, teclado OK.

---

## Lote 2 (2026-09-04) — 10 paquetes

| Paquete | Qué era | Deshacer |
|---|---|---|
| com.xiaomi.mitv.tvmanager | Gestor TV Xiaomi | `pm enable com.xiaomi.mitv.tvmanager` |
| com.xiaomi.mitv.updateservice | Actualizaciones Xiaomi | `pm enable com.xiaomi.mitv.updateservice` |
| com.xiaomi.floatingframe | Marco flotante Xiaomi | `pm enable com.xiaomi.floatingframe` |
| com.mitv.gallery | Galería Xiaomi | `pm enable com.mitv.gallery` |
| com.mitv.tvlock | Bloqueo parental Xiaomi | `pm enable com.mitv.tvlock` |
| com.xiaomi.mitv.mediaexplorer | Explorador de medios Xiaomi | `pm enable com.xiaomi.mitv.mediaexplorer` |
| com.xm.webcontent | Contenido web Xiaomi | `pm enable com.xm.webcontent` |
| com.xiaomo.tv.milegal | Verificación legal Xiaomi | `pm enable com.xiaomo.tv.milegal` |
| com.mitv.tvhome.mitvplus | Fila recomendaciones launcher Xiaomi | `pm enable com.mitv.tvhome.mitvplus` |
| com.mediatek.androidbox | Caja de apps MediaTek (demo) | `pm enable com.mediatek.androidbox` |

**Test usuario:** OK tras Lote 1 (reinicio verificado). OK tras Lote 2.

---

## Lote 3 (2026-09-04) — 9 paquetes

| Paquete | Qué era | Deshacer |
|---|---|---|
| com.mediatek.tv.factory | Menú fábrica MediaTek | `pm enable com.mediatek.tv.factory` |
| com.mediatek.wwtv.tvcenter | Centro TV MediaTek | `pm enable com.mediatek.wwtv.tvcenter` |
| com.android.printspooler | Impresión | `pm enable com.android.printspooler` |
| com.android.sharedstoragebackup | Backup almacenamiento compartido | `pm enable com.android.sharedstoragebackup` |
| com.android.backupconfirm | Confirmación de backups | `pm enable com.android.backupconfirm` |
| com.google.android.tv.bugreportsender | Envío bug reports | `pm enable com.google.android.tv.bugreportsender` |
| com.google.android.leanbacklauncher.recommendations | Recomendaciones launcher (ads) | `pm enable com.google.android.leanbacklauncher.recommendations` |
| com.google.android.tvrecommendations | Recomendaciones Google TV (ads) | `pm enable com.google.android.tvrecommendations` |
| com.xiaomi.mimusic2 | Música Xiaomi (usa Spotify) | `pm enable com.xiaomi.mimusic2` |

**Total deshabilitados:** 29 · **Test usuario:** OK Lote 1 + Lote 2, Lote 3 pendiente.

---

## Launcher: FLauncher (2026-09-04)

1. Instalado **FLauncher 0.18.0** (package `me.efesser.flauncher`, NUNCA `app.etiennel.fLauncher`) desde GitLab (el repo GitHub FLauncher/FLauncher da 404; el proyecto vive en https://gitlab.com/flauncher/flauncher). APK: flauncher-0.18.0.apk (~26 MB).
2. Fijado como home con `cmd package set-home-activity me.efesser.flauncher/me.efesser.flauncher.MainActivity` (¡funciona en este Android 9!).
3. Deshabilitados los launchers viejos SOLO DESPUÉS de tener FLauncher instalado y verificado:
   - `com.google.android.tvlauncher` — launcher Google TV (ads/filas recomendaciones) → `pm enable com.google.android.tvlauncher`
   - `com.mitv.tvhome.atv` — PatchWall, launcher Xiaomi que intercepta el botón Home del mando → `pm enable com.mitv.tvhome.atv`

> ⚠️ Nota Xiaomi: el botón Home del mando está atado a PatchWall (com.mitv.tvhome.atv), NO al resolver HOME estándar. Sin deshabilitarlo, el Home siempre volvía al launcher Xiaomi aunque FLauncher fuese el default. Por eso es imprescindible deshabilitar PatchWall (tras instalar el alternativo, nunca antes).

---

## Intocables (equivalentes Xiaomi de la lista del artículo)

| Paquete | Razón |
|---|---|
| com.google.android.tvlauncher | Home actual — solo deshabilitar tras instalar FLauncher |
| com.google.android.tv.remote.service | Mando |
| com.android.bluetooth | Mando BT |
| com.android.location.fused | Boot loop si se deshabilita |
| com.google.android.gms / gsf | Play Services |
| com.android.vending | Play Store |
| com.google.android.inputmethod.latin | Teclado en pantalla |
| com.mediatek.tvinput / tvinputservice.arbitratorservice | Entradas HDMI/antena |
| com.mediatek.hotkey.dispatcher | Teclas del mando |
| com.android.tv.settings | Ajustes |
| com.mitv.tvhome.atv + mitv.service | Capa base Xiaomi |
| com.google.android.katniss / com.google.android.apps.mediashell | Chromecast built-in (¡usuario lo usa!) |
