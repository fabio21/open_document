#include "include/open_document/open_document_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

#include <shlobj.h>
#include <string.h>
#include <Shlwapi.h>
#include <stdio.h>
#include <stdlib.h>
#include "include/open_document/filesystem.hpp" 
#include <iostream>               // for std::cout

#pragma comment(lib, "shell32.lib")


namespace {

class OpenDocumentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  OpenDocumentPlugin();

  virtual ~OpenDocumentPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void OpenDocumentPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "open_document",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<OpenDocumentPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

OpenDocumentPlugin::OpenDocumentPlugin() {}

OpenDocumentPlugin::~OpenDocumentPlugin() {}

void OpenDocumentPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    if (method_call.method_name().compare("getPathDocument") == 0) {
        std::ostringstream version_stream;
        std::filesystem::current_path();
        version_stream << filesytem;
        result->Success(flutter::EncodableValue(version_stream.str()));
    }
    else {
        result->NotImplemented();
    }
}


 std::string GetWorkingDirectory()
{
     try {
         char my_documents[MAX_PATH];
         HRESULT h_result = SHGetFolderPath(NULL, CSIDL_PERSONAL, NULL, SHGFP_TYPE_CURRENT, my_documents);

         if (h_result != S_OK) {
            return std::string(my_documents));
         }
         else {
             return std::string(my_documents));
         }
     }cath(e) {
         return "ERORORORORO";
     }
}


}  // namespace

void OpenDocumentPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  OpenDocumentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
