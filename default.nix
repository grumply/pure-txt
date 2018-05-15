{ mkDerivation, base, bytestring, pure-default, roles, stdenv, text
}:
mkDerivation {
  pname = "pure-txt";
  version = "0.7.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring pure-default roles text
  ];
  homepage = "github.com/grumply/pure-txt";
  license = stdenv.lib.licenses.bsd3;
}
