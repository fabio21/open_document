//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <open_document/open_document_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <url_launcher_windows/url_launcher_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  OpenDocumentPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("OpenDocumentPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  UrlLauncherPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherPlugin"));
}
