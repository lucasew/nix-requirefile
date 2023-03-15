{ requireFile, fetchurl, stdenvNoCC, nix }:
{ name ? null
, sha256 ? null
, sha1 ? null
, url ? null
, message ? null
, hashMode ? "flat"
}@args:
let
  inherit (builtins) filter isString split readFile length;

  originalRequireFile = requireFile args;

  isFlat = hashMode == "flat";
  hasHash = sha256 != null || sha1 != null;
  hasUrls = length urls > 0;

  hashAlgo = if sha256 != null then "sha256" else "sha1";
  hash = if sha256 != null then sha256 else sha1;

  urlsDrv = stdenvNoCC.mkDerivation {
    name = "urls-${hashAlgo}-${hash}";
    allowSubstitutes = false;
    preferLocalBuild = true;

    nativeBuildInputs = [ nix ];

    src = ./data;

    installPhase = ''
      hash="$(nix --extra-experimental-features nix-command hash to-base16 --type ${hashAlgo} "${hash}")"
      {
        cat "$src/data/http/${hashAlgo}/$hash.txt" || true
      } > $out
    '';
  };
  urls = filter (item: isString item && item != "") (split "\n" (readFile urlsDrv));

  item = fetchurl {
    name = if name == null then baseNameOf (toString url) else name;
    inherit (args) sha256 sha1;
    inherit urls;
    preferLocalBuild = true;
    passthru = {
      inherit urlsDrv urls;
    };
  };

in if !(isFlat && hasHash && hasUrls) then
  originalRequireFile
else
  item
