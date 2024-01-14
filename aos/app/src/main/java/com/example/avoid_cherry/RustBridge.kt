package com.example.avoid_cherry

import android.content.Context
import android.content.res.AssetManager
import android.view.Surface

class RustBridge {
    init {
        System.loadLibrary("avoid_cherry")
    }

    external fun init_ndk_context(ctx: Context,)
    external fun create_bevy_app(asset_manager: AssetManager, surface: Surface, scale_factor: Float): Long
    external fun enter_frame(bevy_app: Long)
    external fun device_motion(bevy_app: Long, x: Float, y: Float, z: Float)
    external fun release_bevy_app(bevy_app: Long)
}