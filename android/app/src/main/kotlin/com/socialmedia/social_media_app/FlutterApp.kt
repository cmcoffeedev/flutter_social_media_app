package com.socialmedia.social_media_app

import android.content.Context

import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class FlutterApp : FlutterApplication() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)

    }

}