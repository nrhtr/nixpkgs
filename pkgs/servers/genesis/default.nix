{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  ninja,
  gdbm,
  perl,
}:
stdenv.mkDerivation rec {
  pname = "genesis";
  version = "unstable-2022-12-28";

  src = fetchFromGitHub {
    owner = "the-cold-dark";
    repo = pname;
    rev = "c9e272af7e6e5742a7e9c534212b849e30e5f5e1";
    hash = "sha256-L5jHzqknQdHGTCJsgJC666uJaQmQfuGsHGKqyUMIzgE=";
  };

  nativeBuildInputs = [
    bison
    cmake
    ninja
    perl
  ];

  buildInputs = [
    gdbm
  ];

  patches = [
    ./fix-darwin-bind-socket.patch
  ];

  postPatch = ''
    patchShebangs --build src/modules/modbuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp coldcc $out/bin
    cp genesis $out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://the-cold-dark.github.io/";
    description = "Dynamic, object-oriented language on top of an object database";
    license = with licenses; [tcltk beerware];
    maintainers = with maintainers; [nrhtr];
    platforms = platforms.unix;
  };
}
