{
  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  # Flake outputs
  outputs =
    { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems =
        f: nixpkgs.lib.genAttrs allSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      # Development environment output
      devShells = forAllSystems (
        { pkgs }:
        {
          default = pkgs.mkShell {
            # The Nix packages provided in the environment
            packages = with pkgs; [
              # Choose the build tools that you need
              cmake
              pkg-config
              meson
              ninja

              # Add some libraries
              boost
              fmt
            ];

            # Workaround: make vscode's python extension read the .venv
            shellHook = ''
              echo "welcome to python" | ${pkgs.lolcat}/bin/lolcat
              venv="$(cd $(dirname $(which python)); cd ..; pwd)"
              ln -Tsf "$venv" .venv
            '';
          };
        }
      );
    };
}
