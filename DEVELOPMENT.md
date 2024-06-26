# Documentation for developers

# Setup

1. [Install latest Flutter and Dart version](https://docs.flutter.dev/get-started/install).

2. [Install fvm](https://fvm.app/docs/getting_started/installation/)

3. `git clone` this repo

4. Run `fvm use` in the git repo directory which will install and set the correct version of Flutter for the project.

5. Run `make setup` (run it whenever you pull from upstream.)

- `make setup` pulls all the dependencies configured in `pubspec.yaml` as well as pre-built binaries for GDK as well as `boltz-rust`.
- We use a forked version of GDK which can be found in https://github.com/sideswap-io/gdk/tree/pset_stable . Instead of using the pre-built binaries you can build it form source and use it as well.
- The source for `boltz-rust` can be found in https://github.com/AquaWallet/boltz-rust which can also be built from source.

# Run the app from source

## Install Android emulator

To develop with Android emulator, you need `Android Studio` with `Cmake` and `NDK`.

```bash
sdkmanager --install "ndk;21.4.7075529"
sdkmanager --install "cmake;3.10.2.4988404"
```

Check which Java version Flutter uses with `fvm flutter doctor -v`. Make sure the same version is configured in `gradle-wrapper.properties`.

## Run the emulator

`~/Library/Android/sdk/emulator/emulator -avd Pixel_3a_API_34_extension_level_7_arm64-v8a -netdelay none -netspeed full`

(adjust this command for whatever operating system you are on. The above command is for macOS)

```bash
fvm flutter run
```

# Troubleshooting

- Always run `make` commands from `Makefile` unless a dedicated command is not available there.
- Don't forget to add `fvm` in front of `flutter` and `dart` commands. eg: `fvm flutter {command}` or `fvm dart {command}`
- Changing Flutter version might require `fvm flutter clean` and `vscode` restart to pick-up the correct version.

## Testing on various screen sizes

Add Device Preview dependency

Device Preview dependency can be enabled with an environment variable named `DEVICE_PREVIEW` using `--dart-define` flag with the `flutter run` command. The same can be acheive in VS Code by adding `toolArgs` in the `launch.json` file:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "aqua",
      "request": "launch",
      "type": "dart",
      "toolArgs": ["--dart-define", "DEVICE_PREVIEW=true"]
    }
  ]
}
```
