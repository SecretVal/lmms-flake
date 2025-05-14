{
  description = "Lmms nightly flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        lib,
        system,
        ...
      }: {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "lmms";
            version = "nightly";

            src = pkgs.fetchFromGitHub {
              owner = "LMMS";
              repo = "lmms";
              rev = "e50f31281862ab0d58a6b398d46a757c6727a056";
              sha256 = "sha256-TwIRLsn0d1ato7fxK+B/yvaKgpG64RkWe8Ekhb2zQks=";
              fetchSubmodules = true;
            };

            nativeBuildInputs = with pkgs; [
              cmake
              libsForQt5.qt5.qttools
              pkg-config
            ];

            buildInputs = with pkgs; [
              carla
              alsa-lib
              fftwFloat
              fltk13
              fluidsynth
              lame
              libgig
              libjack2
              libpulseaudio
              libsamplerate
              libsndfile
              libsoundio
              libvorbis
              portaudio
              kdePackages.qtbase
              libsForQt5.qt5.qtx11extras
              SDL2 # TODO: switch to SDL2 in the next version
            ];

            patches = [
              (pkgs.fetchpatch {
                url = "https://raw.githubusercontent.com/archlinux/svntogit-community/cf64acc45e3264c6923885867e2dbf8b7586a36b/trunk/lmms-carla-export.patch";
                sha256 = "sha256-wlSewo93DYBN2PvrcV58dC9kpoo9Y587eCeya5OX+j4=";
              })
            ];

            cmakeFlags = ["-DWANT_QT5=ON"];

            meta = with lib; {
              description = "DAW similar to FL Studio (music production software)";
              mainProgram = "lmms";
              homepage = "https://lmms.io";
              license = licenses.gpl2Plus;
              platforms = [
                "x86_64-linux"
                "i686-linux"
              ];
              maintainers = [];
            };
          };
        };
      };
    };
}
