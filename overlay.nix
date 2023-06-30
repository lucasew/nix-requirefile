self: super: {
  requireFile = self.callPackage ./package.nix {
    inherit (super) requireFile;
  };
  requireFile-ingest = self.python3Packages.callPackage ./package-ingest.nix { };
}
