{ stdenvNoCC
, makeWrapper
, python3
}:

stdenvNoCC.mkDerivation {
  name = "nix-requirefile-ingest";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ${./ingest_url} $out/bin/nix-requirefile-ingest
    # patchShebangs $out/bin/*
  '';
}
