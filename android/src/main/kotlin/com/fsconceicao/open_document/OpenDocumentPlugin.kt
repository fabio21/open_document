package com.fsconceicao.open_document

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** OpenDocumentPlugin */
class OpenDocumentPlugin : FlutterPlugin, ActivityAware {

  private val TAG = "OpenDocumentPlugin"
  private var openDocumentCallHandler: OpenDocumentImpl? = null
  private var doc:OpenDocument? = null


  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    doc = OpenDocument(binding.applicationContext, null)
    openDocumentCallHandler = OpenDocumentImpl(doc!!)
    openDocumentCallHandler.let {
      it?.startListening(binding.binaryMessenger)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    if (openDocumentCallHandler == null) {
      Log.wtf(TAG, "Already detached from the engine.")
      return
    }

    openDocumentCallHandler.let {
      it?.stopListening()
    }
    openDocumentCallHandler = null
    doc = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    if (openDocumentCallHandler == null) {
      Log.wtf(TAG, "urlLauncher was never set.")
      return
    }
    doc.let {
      it?.setActivity(binding.activity as FlutterActivity)
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    if (openDocumentCallHandler == null) {
      Log.wtf(TAG, "urlLauncher was never set.")
      return
    }
  }
}