//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hotkey_manager_linux/hotkey_manager_linux_plugin.h>
#include <objectbox_flutter_libs/objectbox_flutter_libs_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>
#include <wayland_layer_shell/wayland_layer_shell_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) hotkey_manager_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HotkeyManagerLinuxPlugin");
  hotkey_manager_linux_plugin_register_with_registrar(hotkey_manager_linux_registrar);
  g_autoptr(FlPluginRegistrar) objectbox_flutter_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ObjectboxFlutterLibsPlugin");
  objectbox_flutter_libs_plugin_register_with_registrar(objectbox_flutter_libs_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
  g_autoptr(FlPluginRegistrar) wayland_layer_shell_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WaylandLayerShellPlugin");
  wayland_layer_shell_plugin_register_with_registrar(wayland_layer_shell_registrar);
}
