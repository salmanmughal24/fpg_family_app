package com.thejadav.fpg_family_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
        @Override
        fun provideFlutterEngine(context: Context?): FlutterEngine {
            return AudioServicePlugin.getFlutterEngine(context)
        }

}
