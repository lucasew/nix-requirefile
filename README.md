# nix-requirefile

An overlay to supply alternative locations for `requireFile`s in Nix.

Nixpkgs can't supply direct links for some files so they use placeholder derivations by using the function `requireFile`. This is a workaround to dribble this limitation.

## How to use
- Add this repo to your flake inputs, or fetchurl, you need to be able to import it in Nix.
- In your personal overlay, override the package `requireFileSOurces` to a list of paths. There is a sample of the structure in the branch [`data`](https://github.com/lucasew/nix-requirefile/tree/data).
- You can use the script `ingest_url` to build another source or as many sources as you want.
- [If any source provides the sha256 or the sha1 passed to requireFile, it will convert that requireFile to a fetchurl, otherwise the requireFile call works the same as this repo was never being involved](https://github.com/lucasew/nix-requirefile/blob/a5013d189b38a53e1001ef149b587cec42e1d961/package.nix#L58).
- The code will report if no sources were found (misconfiguration in your side) or if it found the hash in any of the sources.
- All the queries are $O(n)$ being $n$ the amount of data sources. The cost to check each data source is the cost to lookup for a file.
