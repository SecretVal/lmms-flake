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
              libsForQt5.qt5.wrapQtAppsHook
              libsForQt5.qt5.qttools
              pkg-config
            ];

            buildInputs = with pkgs; [
              libsForQt5.qt5.qtbase
              libsForQt5.qt5.qtx11extras
              libsamplerate
              libsndfile
              libvorbis
              libogg
              wine
              # libstk
              fluidsynth
              fltk13
              libjack2
              SDL2
              alsa-lib
              portaudio
              libsoundio

              carla
              fftwFloat
              lame
              libpulseaudio
              libgig
            ];

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
