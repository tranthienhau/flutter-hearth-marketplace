# Screenshot & demo capture flow

Real screenshots and the demo GIF are captured by driving the running app on the iOS
simulator with `integration_test` + `flutter drive` - not mocked.

## How it works

- `integration_test/screenshot_test.dart` pumps the real `HearthApp`, walks the full
  journey (onboarding -> verification -> discover -> search -> filters -> messaging ->
  profile -> admin -> listing -> booking -> payment) and, on each key screen, calls
  `binding.convertFlutterSurfaceToImage()` then `binding.takeScreenshot('NN-name')`.
- `test_driver/integration_test.dart` uses `integrationDriver(onScreenshot:)` to write
  each PNG into `screenshots/`.
- Screens are reached purely by tapping real widgets; flows that would need
  hardware (ID scan, selfie, Face ID payment) are simulated behind a tap.

## Regenerate screenshots

```bash
# 1. Boot the simulator
xcrun simctl boot "iPhone 17 Pro"   # ignore "already booted"

# 2. Resolve packages
flutter pub get

# 3. Drive the app and capture PNGs into screenshots/
flutter drive \
  --driver test_driver/integration_test.dart \
  --target integration_test/screenshot_test.dart \
  -d "iPhone 17 Pro"
```

## Regenerate the demo GIF

Record the simulator while the drive runs, then convert with ffmpeg:

```bash
xcrun simctl io booted recordVideo --codec=h264 screenshots/demo.mov &
REC=$!
flutter drive \
  --driver test_driver/integration_test.dart \
  --target integration_test/screenshot_test.dart \
  -d "iPhone 17 Pro"
kill -INT $REC

ffmpeg -y -i screenshots/demo.mov \
  -vf "setpts=PTS/1.7,fps=12,scale=300:-1:flags=lanczos,palettegen=stats_mode=diff" /tmp/pal.png
ffmpeg -y -i screenshots/demo.mov -i /tmp/pal.png \
  -lavfi "setpts=PTS/1.7,fps=12,scale=300:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" \
  screenshots/demo.gif
rm screenshots/demo.mov
```
