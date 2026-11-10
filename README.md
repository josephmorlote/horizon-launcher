![Horizon](logo.png)

# Horizon — a launcher for Fire TV

A calm, design-led home screen for Amazon Fire TV sticks, with nine themes:

- **Editorial** — every app a magazine cover: your own photos, a library of cover styles (Masthead, Split, Interview, Quarterly, Monograph, Objects, Plate, Guide…), one typography across every page, and an always-on slideshow
- **Passive** — a quiet page of words over a carousel of photographs that open as you move, with a clock chip that becomes a Now Playing card
- **Swatch** — your apps as a mosaic of paint-swatch colour blocks, with a clock hero, colour presets and seasons
- **Tile** — the same idea as rounded colour cards with gaps, like a palette sheet
- **Tabs** — bright stacked tabs with big bold names that open as you move
- **Scroll** — a quiet list of names beside big grainy gradient art (or your own gradients)
- **Classic** — a full-screen photo with a dock of apps
- **Dots** — a dot-matrix screen where light follows you
- **Onyx** — pure black and hairlines: a ruled grid of names where the one you're on turns white
- **Syntax** — your apps as a file in a code editor, in Tokyo Night, Dracula, Nord, Catppuccin and more
- **Halloween** — one video of your choice, full screen and looping (a party backdrop), with what's playing; Select opens Spotify

Each theme has its own colours, type and options, and **Saved Looks** to keep a setup and switch back to it any time.

Horizon arrives fully set up: it comes with a full set of photos, gradients and the Halloween video built in, and starts with the same themes, colours, pages and favourites as the original setup. Change anything in Settings.

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

## Make Horizon your home screen (one click, no computer)

This makes the **Home button** open Horizon, makes the Fire TV **start on Horizon** whenever it's switched on,
and switches on **Now Playing**, all in one go from the TV:

1. Turn on **Settings → My Fire TV → Developer Options → ADB Debugging**.
   (No Developer Options? Go to **My Fire TV → About** and press Select on the device name 7 times.)
2. In Horizon, open **Settings → Home Button Setup → Set Up Home Button**.
3. A box **"Allow USB debugging?"** appears on the TV: tick **Always allow** and choose **Allow**.
4. It shows each step as it goes and finishes with **Done**. Press Home to try it. You can turn ADB Debugging off again.

If something's not right, the page says what (and the **Check** rows below it show ADB Debugging, the helper and
Now Playing at a glance). If the "Allow" box never appeared or you chose Cancel, turn ADB Debugging off and on, then
choose Set Up Home Button again.

## Updating

**Settings → Check for Updates** finds the newest Horizon and installs it from the TV. Your themes, Saved Looks,
favourites and photos stay as they are. (With **Download Updates Automatically** on, new versions download quietly
and wait there for you.) The Downloader code above always gets the newest version too.

**Or set up the Home button with a computer:**

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

### Optional: show what's playing

```
adb shell cmd notification allow_listener com.horizon.launcher/com.horizon.launcher.media.NowPlayingListener
```

While music plays, every theme shows the song, artist and cover art; it goes back to normal when you pause.
This lets Horizon see the current song and whether it's playing; it doesn't read your notifications.

### Optional: choose what the remote's app buttons open

```
adb shell pm grant com.horizon.launcher android.permission.READ_LOGS
```

Then restart the Fire TV, and pick an app for each button under **Settings → Remote Buttons**.
Fire OS handles those four buttons itself, so Horizon has to watch the system log to see a press;
this permission allows that. The app printed on the button still starts for a moment before yours takes over.

### Optional: tune up the Fire TV itself

**Settings → System → Device Tune-Up** shows which of Amazon's background services are on, frees memory,
and can block Fire OS updates by DNS (with a free NextDNS profile). On older Fire OS versions it can also
turn Amazon's ads, tracking, Live TV, Alexa voice and the system updater off from the TV.

Newer Fire OS versions don't let any app on the TV do that last part. For those, use a Windows PC on the same Wi-Fi once:

1. On the Fire TV, turn on **Developer Options → ADB Debugging**. Device Tune-Up shows the TV's address.
2. Download **Tune Up Fire TV.cmd** and **tune-up-firetv.ps1** from this page into one folder.
3. Double-click **Tune Up Fire TV.cmd**, type the TV's address, and answer the questions. It fetches Google's adb tool by itself.
4. On the TV, choose **Allow** when it asks about USB debugging.

Nothing is uninstalled: running it again and choosing "put everything back" (or a factory reset) restores everything.

## Tips

- Hold **Select** (or press **Menu**) on any app for options: Edit Page / Change Photo, colour, favourites, rearrange, hide, app info, uninstall.
- Press **Left** from the home view to open **Settings** (turn this off in Settings if you prefer). Settings only shows what applies to your theme.
- **Your own pictures:** Editorial, Passive, Scroll and Window use photos and gradients you add yourself (Settings → About explains how). Every image picker has filters at the top (flowers, mountains, sea, warm, dark…).
- **Photos from your phone:** Settings → Look → **Add Photos from Phone** shows a QR code. Scan it with a phone on the same Wi-Fi and choose pictures; they appear under the **Personal** filter in every image picker. The TV only listens while that page is open, and only on your home network.
- **Dark Mode** (top of Settings) gives each theme its own dark design. **Night Mode** just dims the screen.
- Horizon only goes online to check GitHub for updates.
- Horizon returns to its home view on every Home press.

## Credits & licences

- Classic's built-in wallpaper photos are from Wikimedia Commons (CC BY-SA / CC0 / Free Art License);
  each photographer is credited on screen and in **Settings → About**.
- Fonts: Instrument Serif by Rodrigo Fuenzalida & Jordan Egstad, SIL Open Font License 1.1.
- Horizon isn't affiliated with Amazon, Apple or any app shown on it.
