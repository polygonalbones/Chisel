{
  lib,
  stdenv,
  mkShell,
  dotnetCorePackages,
  zlib,
  openssl,
}:
let
  dotnetPkg =
    (with dotnetCorePackages; combinePackages [
      sdk_8_0
    ]);

  nativeBuildInputs = [
    dotnetPkg
    zlib
    zlib.dev
    openssl
  ];
in
mkShell {
  inherit nativeBuildInputs;

  shellHook = ''
    DOTNET_ROOT="${dotnetPkg}";
  '';

  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath ([
    stdenv.cc.cc
  ] ++ nativeBuildInputs);
  LD_LIBRARY_PATH = lib.makeLibraryPath ([
    stdenv.cc.cc.lib
  ] ++ nativeBuildInputs);
  NIX_LD = "${stdenv.cc.libc_bin}/bin/ld.so";
}
