package com.fsconceicao.open_document

import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.jetbrains.annotations.Nullable

class OpenDocumentImpl(private val doc: OpenDocument) : MethodChannel.MethodCallHandler {
    private val TAG = "OpenDocumentImpl"

    @Nullable
    private var channel: MethodChannel? = null

    fun startListening(messenger: BinaryMessenger?) {
        if (channel != null) {
            Log.wtf(TAG, "Setting a method call handler before the last was disposed.")
            stopListening()
        }

        channel = messenger?.let { MethodChannel(it, "open_document") }
        channel!!.setMethodCallHandler(this)
    }

    fun stopListening() {
        if (channel == null) {
            Log.d(TAG, "Tried to stop listening when no MethodChannel had been initialized.");
            return;
        }

        channel!!.setMethodCallHandler(null);
        channel = null;
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("DART/NATIVE", "onMethodCall ${call.method}")
        //our code
        when (call.method) {
            "getPathDocument" -> Thread(Runnable {
                doc.getPathDocument(call.arguments as String, result)
            }).start()
            "getName" -> Thread(Runnable {
                doc.getName(call.arguments as String, result)
            }).start()
            "getNameFolder" -> Thread(Runnable {
                doc.getNameFolder(result)
            }).start()
            "checkDocument" -> Thread(Runnable {
                doc.checkDocument(call.arguments as String, result)
            }).start()
            "openDocument" -> Thread(Runnable {
                doc.openDocument(call.arguments as String, result)
            }).start()
            else -> result.notImplemented()
        }
    }


    // Thread(Runnable { msal.loadAccounts(result) }).start()
}