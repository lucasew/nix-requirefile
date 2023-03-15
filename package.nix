{ requireFile
, fetchurl
, stdenvNoCC
, nix
, requireFileSources ? [ ./data ]
}:
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

  drvName = if name == null then baseNameOf (toString url) else name;
  hashAlgo = if sha256 != null then "sha256" else "sha1";
  hash = if sha256 != null then sha256 else sha1;

  urlsDrv = stdenvNoCC.mkDerivation {
    allowSubstitutes = false;
    preferLocalBuild = true;
    name = "urls-${hashAlgo}-${hash}";

    nativeBuildInputs = [ nix ];

    srcs = requireFileSources;

    installPhase = ''
      hash="$(nix --extra-experimental-features nix-command hash to-base16 --type ${hashAlgo} "${hash}")"
      {
        for src in $srcs; do
          cat "$src/http/${hashAlgo}/$hash.txt" || true
        done
      } > $out
    '';
  };
  urls = filter (item: isString item && item != "") (split "\n" (readFile urlsDrv));

  item = fetchurl {
    name = drvName;
    inherit urls;
    inherit (args) sha256 sha1;
    preferLocalBuild = true;
    passthru = {
      inherit urlsDrv urls;
    };
  };

in if !(isFlat && hasHash && hasUrls) then
  originalRequireFile
else
  builtins.trace "nix-requirefile: found urls for ${drvName}" item
