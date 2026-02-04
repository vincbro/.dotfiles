{
  description = "Dotfiles devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.taplo
          pkgs.hyprls
          pkgs.vscode-css-languageserver
          pkgs.vscode-json-languageserver
          pkgs.lua-language-server
          pkgs.kdlfmt
        ];

        shellHook = ''
        '';
      };
    };
}
