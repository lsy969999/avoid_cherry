## ./.vscode/settings.json
```json
{
  "rust-analyzer.cargo.target": "aarch64-apple-ios",
}

{
  "rust-analyzer.cargo.target": "aarch64-linux-android",
}
```

## **iOS**
```sh
# Add iOS target
rustup target add aarch64-apple-ios

# Build for iOS target
sh ./ios_build.sh --release
```


## **AOS**
```
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
# Replace the NDK version number with the version you installed
export NDK_HOME=$ANDROID_SDK_ROOT/ndk/23.1.7779620

# Since simulator and virtual devices only support GLES,
# `x86_64-linux-android` and `i686-linux-android` targets are not necessary
rustup target add aarch64-linux-android

# Install cargo-so subcommand
cargo install cargo-so
```


```sh
rustup target add aarch64-linux-android
sh ./android_build.sh --release
```