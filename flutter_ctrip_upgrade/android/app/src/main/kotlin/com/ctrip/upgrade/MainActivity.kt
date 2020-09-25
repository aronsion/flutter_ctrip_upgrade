package com.ctrip.upgrade

import android.os.Bundle
import com.example.plugin.asr.AsrPlugin
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        registerSelfPlugin();
    }

    fun registerSelfPlugin(){
        AsrPlugin.registerWith(registrarFor("com.example.plugin.asr.AsrPlugin"))
    }
}
