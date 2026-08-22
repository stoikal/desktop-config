# Android Studio Setup Log

History of how Android Studio was installed on this machine for React Native Android development.

## Timeline

1. Downloaded the Linux tarball from https://developer.android.com/studio/install#linux.
2. Extracted to `/opt/android-studio`:
```bash
sudo tar -xzf android-studio-2024.2.1.11-linux.tar.gz -C /opt/
```

3. First run. Launched `/opt/android-studio/bin/studio.sh`.
- Accepted the Terms & Conditions.
- The setup wizard downloaded the SDK (pulled in SDK 37).

4. SDK platform
Went to **Settings → Languages & Frameworks → Android SDK** and on the **SDK Platforms** tab downloaded **Android 16 (API level 36)**.

5. Environment variables
Added to `~/.bashrc`:

```bash
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## What's installed then

| Component | Location / Version |
|---|---|
| Android Studio | `/opt/android-studio` |
| SDK root | `/home/xlwp/Android/Sdk` |
| Platforms | `android-36`, `android-37.0` |
| Build-tools | `36.0.0` |
| Platform-tools (adb) | present |
| Emulator | present |
| System images | `android-30/google_apis_playstore/x86`, `android-37.0/google_apis_playstore/x86_64` |
| AVDs | `Medium_Phone_API_30` |

