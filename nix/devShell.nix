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

  packages = [
    dotnetPkg
    zlib
    zlib.dev
    openssl
  ];
in
mkShell {
  inherit packages;

  shellHook = ''
    DOTNET_ROOT="${dotnetPkg}";
  '';

  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath ([
    stdenv.cc.cc
  ] ++ packages);
  NIX_LD = "${stdenv.cc.libc_bin}/bin/ld.so";
}
