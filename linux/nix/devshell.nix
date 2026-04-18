{ pkgs, lib }:
pkgs.mkShell {
  packages = with pkgs; [
    # Rust Bridge
    cargo
    cairo
    dbus.dev
    pkg-config
    flutter_rust_bridge_codegen

    # Runtime
    gtk-layer-shell
    (pkgs.writeShellScriptBin "rustup" (builtins.readFile ./fake-rustup.sh))
    (flutter.override {
      extraPkgConfigPackages = [
        gtk-layer-shell
      ];
    })
  ];

  env = {
    LIBCLANG_PATH = lib.makeLibraryPath [ pkgs.libclang ];
    LD_LIBRARY_PATH = "./build/linux/x64/debug/plugins/rust_lib_kitshell:./build/linux/x64/debug/plugins/wayland_layer_shell:${
      lib.makeLibraryPath [ pkgs.zlib ]
    }";
    #   # CPATH = lib.makeSearchPath "include" [ pkgs.glibc.dev ];
  };
}
