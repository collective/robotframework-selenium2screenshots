{ pkgs ? import <nixpkgs> {}
, python ? "python2"
, pythonPackages ? builtins.getAttr (python + "Packages") pkgs
, setup ? import (pkgs.fetchFromGitHub {
    owner = "datakurre";
    repo = "setup.nix";
    rev = "372cdaa3bbe7667d692421d987ad7161f95191ad";
    sha256 = "15np8gsd53zdwi3kk1hskp7099h2b32im0qaps93f1j04sxyj1bq";
  })
}:

let overrides = self: super: {
# isort = super.isort.overridePythonAttrs(old: {
#   propagatedBuildInputs = [ self.futures ];
# });
};

in setup {
  inherit pkgs pythonPackages overrides;
  src = ./.;
  buildInputs = with pkgs; [ geckodriver ];
}
