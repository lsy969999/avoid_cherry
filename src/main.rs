#[cfg(any(target_os = "android", target_os = "ios"))]
fn main() {}


#[cfg(not(any(target_os = "android", target_os = "ios")))]
fn main() {
    let mut bevy_app = avoid_cherry::create_breakout_app();
    bevy_app.run();
}
