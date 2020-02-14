{ mkDerivation, base, ghcjs-base, bytestring, pure-default, roles, stdenv, template-haskell, text
, useTemplateHaskell ? true
}:
mkDerivation {
  pname = "pure-txt";
  version = "0.8.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base ghcjs-base bytestring pure-default roles text
    ] ++ (if useTemplateHaskell then [ template-haskell ] else []);
  configureFlags = (if useTemplateHaskell then [ ] else [ "-f-use-template-haskell" ]);
  homepage = "github.com/grumply/pure-txt";
  license = stdenv.lib.licenses.bsd3;
}
