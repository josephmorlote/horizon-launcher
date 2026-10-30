# Horizon — a launcher for Fire TV

A calm, Apple TV–inspired home screen for Amazon Fire TV sticks, with four layouts:

- **Swatch** — your apps as a mosaic of paint-swatch colour blocks, with a clock hero, colour presets and seasons
- **Tile** — the same idea as rounded colour cards with gaps, like a palette sheet

Swatch and Tile also have a **Monochrome** colour theme: every tile becomes a shade of one colour you pick.
- **Theater** — a dark glass window over a blurred wallpaper
- **Classic** — a full-screen photo with a dock of apps

Works on Fire TV devices running **Fire OS** (Fire TV Stick 4K / 4K Max, Lite, Cube and similar).
It does **not** work on Vega OS devices (some 2025 models such as the Fire TV Stick 4K Select).

---

## Install (about 2 minutes, no computer needed)

> **Downloader code: 9379510**

1. On the Fire TV, open the **Appstore**, search for **Downloader** (by AFTVnews) and install it.
2. Go to **Settings → My Fire TV → About** and click the device name 7 times to turn on Developer Options.
3. In **Settings → My Fire TV → Developer Options → Install unknown apps**, turn **Downloader** on.
4. Open Downloader and enter the code **9379510** (or this address, which does the same thing):

   ```
   https://github.com/josephmorlote/horizon-launcher/releases/latest/download/Horizon.apk
   ```

5. Choose **Install**, then **Open**. The code and link always point to the newest version, so use them again to update.

## Make the Home button open Horizon (optional, needs a computer once)

Fire OS doesn't let apps replace the Amazon home screen directly. Horizon uses a small helper
(an accessibility service) that brings Horizon forward whenever the Amazon home screen appears.
Fire OS hides it from the TV's Accessibility menu, so it's switched on with ADB from a computer:

1. On the Fire TV: **Developer Options → ADB Debugging → On**. Note the IP address under
   **Settings → My Fire TV → About → Network**.
2. On a computer, install Google's [Android platform-tools](https://developer.android.com/tools/releases/platform-tools)
   and run (replace `192.168.1.50` with the Fire TV's address, and allow the prompt that appears on the TV):

   ```
   adb connect 192.168.1.50:5555
   adb shell pm grant com.horizon.launcher android.permission.WRITE_SECURE_SETTINGS
   adb shell settings put secure enabled_accessibility_services com.horizon.launcher/com.horizon.launcher.override.HomeOverrideService
   adb shell settings put secure accessibility_enabled 1
   ```

   The first command lets Horizon switch its helper back on by itself if a Fire OS update turns it off.
   (If you use another launcher's helper, such as Projectivy's, this replaces it.)
3. Press Home. Turn **ADB Debugging** back off when you're done if you like.

### Optional: show what Spotify is playing (Swatch and Tile layouts)

```
adb shell cmd notification allow_listener com.horizon.launcher/com.horizon.launcher.media.NowPlayingListener
```

While music plays, the clock tile shows the song, artist and cover art; it goes back to the clock when you pause.
This lets Horizon see the current song and whether it's playing; it doesn't read your notifications.

## Tips

- Hold **Select** (or press **Menu**) on any app for options: favourites, tile colour, hide, app info, uninstall.
- In Swatch and Tile, select the clock for **Settings** (while music plays, it opens Spotify instead; hold Select for Settings). Settings only shows what applies to your layout.
- Horizon returns to its home view after a minute without input, and on every Home press.

## Credits & licences

- Built-in wallpaper photos are from Wikimedia Commons (CC BY-SA / CC0 / Free Art License);
  each photographer is credited on screen and in **Settings → About**.
- Fonts: Instrument Serif by Rodrigo Fuenzalida & Jordan Egstad, SIL Open Font License 1.1.
- Horizon isn't affiliated with Amazon, Apple or any app shown on it.
