self: super: {
  requireFile = self.callPackage ./package.nix {
    inherit (super) requireFile;
  };
}
