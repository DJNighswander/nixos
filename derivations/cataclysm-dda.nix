{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "cataclysm-dda";
  version = "0.H";

  src = pkgs.fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    rev = "0.H-RELEASE";
    hash = "sha256-Hda0dVVHNeZ8MV5CaCbSpdOCG2iqQEEmXdh16vwIBXk=";
  };

  postPatch = ''
# Fixes the C++ "read-only member" error
substituteInPlace src/third-party/flatbuffers/stl_emulation.h \
  --replace "count_ = other.count_;" ""

# Fixes the "dangling reference" error by disabling -Werror
substituteInPlace Makefile --replace "-Werror" ""
  '';

  nativeBuildInputs = with pkgs; [
    git
    pkg-config
    gettext
    makeWrapper
  ];

  buildInputs = with pkgs; [
    ncurses
    zlib
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ];

  makeFlags = ["TILES=1" "SOUND=1" ];

  installPhase = ''
# Create the necessary directories
install -d $out/bin
install -d $out/share/cataclysm-dda

# Copy all game data to the share directory
cp -r	data doc gfx lang			$out/share/cataclysm-dda/
cp 	cataclysm-launcher cataclysm-tiles json_formatter.cgi		\
	LICENSE-OFL-Terminus-Font.txt LICENSE.txt README.md VERSION.txt	\
						$out/share/cataclysm-dda/

makeWrapper $out/share/cataclysm-dda/cataclysm-tiles $out/bin/cataclysm-dda 	\
--add-flags "--datadir $out/share/cataclysm-dda/data"				\
--add-flags "--userdir ~/.config/cataclysm-dda"					\
--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}"

runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A post-apocalyptic roguelike game";
    homepage = "https://cataclysmdda.org/";
    licence = licenses.cc-by-sa-30;
    maintainers = [ maintainers.djnighswander ];
    platforms = platforms.linux;
  };
}
