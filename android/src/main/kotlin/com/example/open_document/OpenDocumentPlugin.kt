package com.example.open_document

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File


/** OpenDocumentPlugin */
class OpenDocumentPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private var channel: MethodChannel? = null
  private lateinit var activity: Activity
  private lateinit var context: Context

  @Nullable
  private var flutterPluginBinding: FlutterPluginBinding? = null


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "open_document")
    channel?.setMethodCallHandler(this)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val plugin = OpenDocumentPlugin()
      plugin.activity = registrar.activity()
      plugin.context = registrar.context()
      val channel = MethodChannel(registrar.messenger(), "open_document")
      channel.setMethodCallHandler(plugin)
    }
  }

  @RequiresApi(Build.VERSION_CODES.KITKAT)
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPathDocument" -> {
        getPathDocument(call.arguments as String, result)
      }
      "getName" -> {
        getName(call.arguments as String, result)
      }
      "checkDocument" -> {
        checkDocument(call.arguments as String, result)
      }
      "openDocument" -> {
        openDocument(call.arguments as String)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
  }

  @RequiresApi(Build.VERSION_CODES.KITKAT)
  fun openDocument(url: String) {
    try {
      val intent = Intent(Intent.ACTION_VIEW)
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
      intent.addCategory("android.intent.category.DEFAULT")
      val type = name(url).split(".")

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        val uri = FileProvider.getUriForFile(context,
                context.packageName + ".fileprovider", File(url))
        intent.setDataAndType(uri, getFileType(type[1]))
      } else {
        intent.setDataAndType(Uri.fromFile(File(url)), getFileType(type[1]))
      }

      this.activity.startActivity(intent)
    } catch (e: ActivityNotFoundException) {
      Log.d("RAQ_TESTE", "${e.message}")
      // Instruct the user to install a PDF reader here, or something
    }
  }

  @RequiresApi(Build.VERSION_CODES.KITKAT)
  fun getPathDocument(folderName: String, @NonNull result: Result) {
    val file = File(Environment.getExternalStorageDirectory().absolutePath + "/Documents/$folderName/")
    try {
      if (!file.exists()) {
        file.mkdirs()
      }
    } catch (e: Exception) {
      e.printStackTrace()
    }
    result.success(file.absolutePath)
  }

  @RequiresApi(Build.VERSION_CODES.KITKAT)
  fun getName(url: String, @NonNull result: Result) {
    result.success(name(url))
  }

  @RequiresApi(Build.VERSION_CODES.KITKAT)
  fun checkDocument(filePath: String, @NonNull result: Result) {
    val fileAlreadyExists = File(filePath)
    if (fileAlreadyExists.exists()) {
      result.success(true)
    } else {
      result.success(false)
    }
  }

  private fun name(url: String): String {
    var fileNameToDelete = ""
    val value = url.split("/")
    value.forEach {
      fileNameToDelete = it
    }
    return fileNameToDelete
  }

  override fun onDetachedFromActivity() {
    this.flutterPluginBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    if (channel == null) {
      // Could be on too low of an SDK to have started listening originally.
      return
    }

    channel?.setMethodCallHandler(null)
    channel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    channel = MethodChannel(
            flutterPluginBinding?.binaryMessenger, "open_document")
    context = flutterPluginBinding?.applicationContext!!
    activity = binding.activity
    channel?.setMethodCallHandler(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  private fun getFileType(type: String): String? {
    return when (type) {
      "3gp" -> "video/3gpp"
      "apk" -> "application/vnd.android.package-archive"
      "asf" -> "video/x-ms-asf"
      "avi" -> "video/x-msvideo"
      "bin" -> "application/octet-stream"
      "bmp" -> "image/bmp"
      "c" -> "text/plain"
      "class" -> "application/octet-stream"
      "conf" -> "text/plain"
      "cpp" -> "text/plain"
      "doc" -> "application/msword"
      "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "xls" -> "application/vnd.ms-excel"
      "xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "exe" -> "application/octet-stream"
      "gif" -> "image/gif"
      "gtar" -> "application/x-gtar"
      "gz" -> "application/x-gzip"
      "h" -> "text/plain"
      "htm" -> "text/html"
      "html" -> "text/html"
      "jar" -> "application/java-archive"
      "java" -> "text/plain"
      "jpeg" -> "image/jpeg"
      "jpg" -> "image/jpeg"
      "js" -> "application/x-javaScript"
      "log" -> "text/plain"
      "m3u" -> "audio/x-mpegurl"
      "m4a" -> "audio/mp4a-latm"
      "m4b" -> "audio/mp4a-latm"
      "m4p" -> "audio/mp4a-latm"
      "m4u" -> "video/vnd.mpegurl"
      "m4v" -> "video/x-m4v"
      "mov" -> "video/quicktime"
      "mp2" -> "audio/x-mpeg"
      "mp3" -> "audio/x-mpeg"
      "mp4" -> "video/mp4"
      "mpc" -> "application/vnd.mpohun.certificate"
      "mpe" -> "video/mpeg"
      "mpeg" -> "video/mpeg"
      "mpg" -> "video/mpeg"
      "mpg4" -> "video/mp4"
      "mpga" -> "audio/mpeg"
      "msg" -> "application/vnd.ms-outlook"
      "ogg" -> "audio/ogg"
      "pdf" -> "application/pdf"
      "png" -> "image/png"
      "pps" -> "application/vnd.ms-powerpoint"
      "ppt" -> "application/vnd.ms-powerpoint"
      "pptx" -> "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "prop" -> "text/plain"
      "rc" -> "text/plain"
      "rmvb" -> "audio/x-pn-realaudio"
      "rtf" -> "application/rtf"
      "sh" -> "text/plain"
      "tar" -> "application/x-tar"
      "tgz" -> "application/x-compressed"
      "txt" -> "text/plain"
      "wav" -> "audio/x-wav"
      "wma" -> "audio/x-ms-wma"
      "wmv" -> "audio/x-ms-wmv"
      "wps" -> "application/vnd.ms-works"
      "xml" -> "text/plain"
      "z" -> "application/x-compress"
      "zip" -> "application/x-zip-compressed"
      else -> "*/*"
    }
  }

}
