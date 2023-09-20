final: prev: {
  requireFile = final.callPackage ./package.nix {
    inherit (prev) requireFile;
  };
  requireFile-ingest = prev.python3Packages.callPackage ./package-ingest.nix { };
}
