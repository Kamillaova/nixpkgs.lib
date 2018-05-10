# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!
{ lib }:
let platforms = import ./platforms.nix { inherit lib; }; in

rec {
  #
  # Linux
  #

  sheevaplug = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    platform = platforms.sheevaplug;
  };

  raspberryPi = rec {
    config = "armv6l-unknown-linux-gnueabihf";
    platform = platforms.raspberrypi;
  };

  armv7l-hf-multiplatform = rec {
    config = "armv7a-unknown-linux-gnueabihf";
    platform = platforms.armv7l-hf-multiplatform;
  };

  aarch64-multiplatform = rec {
    config = "aarch64-unknown-linux-gnu";
    platform = platforms.aarch64-multiplatform;
  };

  aarch64-android-prebuilt = rec {
    config = "aarch64-unknown-linux-android";
    platform = platforms.aarch64-multiplatform;
    useAndroidPrebuilt = true;
  };

  scaleway-c1 = armv7l-hf-multiplatform // rec {
    platform = platforms.scaleway-c1;
    inherit (platform.gcc) fpu;
  };

  pogoplug4 = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    platform = platforms.pogoplug4;
  };

  ben-nanonote = rec {
    config = "mipsel-unknown-linux-uclibc";
    platform = {
      name = "ben_nanonote";
      kernelMajor = "2.6";
      kernelArch = "mips";
      gcc = {
        arch = "mips32";
        float = "soft";
      };
    };
  };

  fuloongminipc = rec {
    config = "mipsel-unknown-linux-gnu";
    platform = platforms.fuloong2f_n32;
  };

  muslpi = raspberryPi // {
    config = "armv6l-unknown-linux-musleabihf";
  };

  aarch64-multiplatform-musl = aarch64-multiplatform // {
    config = "aarch64-unknown-linux-musl";
  };

  musl64 = { config = "x86_64-unknown-linux-musl"; };
  musl32  = { config = "i686-unknown-linux-musl"; };

  riscv = bits: {
    config = "riscv${bits}-unknown-linux-gnu";
    platform = platforms.riscv-multiplatform bits;
  };
  riscv64 = riscv "64";
  riscv32 = riscv "32";


  #
  # Darwin
  #

  iphone64 = {
    config = "aarch64-apple-darwin14";
    arch = "arm64";
    libc = "libSystem";
    platform = {};
  };

  iphone32 = {
    config = "arm-apple-darwin10";
    arch = "armv7-a";
    libc = "libSystem";
    platform = {};
  };

  #
  # Windows
  #

  # 32 bit mingw-w64
  mingw32 = {
    config = "i686-pc-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };

  # 64 bit mingw-w64
  mingwW64 = {
    # That's the triplet they use in the mingw-w64 docs.
    config = "x86_64-pc-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };
}
