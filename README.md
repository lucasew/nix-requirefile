# nix-requirefile

An overlay to supply alternative locations for `requireFile`s in Nix.

Nixpkgs can't supply direct links for some files so they use placeholder derivations by using the function `requireFile`. This is a workaround to dribble this limitation.
