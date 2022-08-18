package com.fsconceicao.open_document

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File


class OpenDocument(context: Context, activity: FlutterActivity?) {
    private val applicationContext = context
    private var activity: FlutterActivity? = activity


    fun setActivity(activity: FlutterActivity) {
        this.activity = activity;
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    internal fun openDocument(url: String, result: MethodChannel.Result) {
        try {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            intent.addCategory("android.intent.category.DEFAULT")
            val type = name(url).split(".")

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val uri = FileProvider.getUriForFile(
                    applicationContext,
                    activity?.context?.packageName + ".fileprovider", File(url)
                )
                intent.setDataAndType(uri, getFileType(type[1]))
            } else {
                intent.setDataAndType(Uri.fromFile(File(url)), getFileType(type[1]))
            }

            this.activity?.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            e.printStackTrace()
            result.error("Error", e.localizedMessage, "Open document failure")
            // Instruct the user to install a PDF reader here, or something
        }
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    internal fun getPathDocument(path: String?, @NonNull result: MethodChannel.Result) {
        val str = path ?: nameFolder()
        val file =
            File(Environment.getExternalStorageDirectory().absolutePath + "/Documents/${str}/")
        try {
            if (!file.exists()) {
                file.mkdirs()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            result.error("Error", e.localizedMessage, "Get path document failure")
        }
        result.success(file.absolutePath)
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    internal fun getName(url: String, @NonNull result: MethodChannel.Result) {
        result.success(name(url))
    }

    internal fun getNameFolder(@NonNull result: MethodChannel.Result) {
        val name = nameFolder();
        if (name.contains("NameFolder:"))
            result.error("Error", name, "Get name app");
        else
            result.success(name)
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    internal fun checkDocument(filePath: String, @NonNull result: MethodChannel.Result) {
        val fileAlreadyExists = File(filePath)
        if (fileAlreadyExists.exists()) {
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun nameFolder(): String {
        return try {
            val app = applicationContext.packageManager?.getApplicationInfo(
                applicationContext.packageName,
                0
            );
            return applicationContext.packageManager?.getApplicationLabel(app).toString();
        } catch (e: Exception) {
            "NameFolder: " + e.localizedMessage;
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