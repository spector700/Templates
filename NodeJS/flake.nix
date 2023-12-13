{
  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default =
          pkgs.mkShell {
            # The Nix packages provided in the environment
            packages = with pkgs; [
               # standard toolkit
              pkgs.nodejs # nixpkgs provides a "nodejs" package that corresponds to the current LTS version of nodejs, but you can specify a version (i.e node_20) if necessary
              pkgs.yarn
              pkgs.pnpm # a faster alternative to npm and yarn, with a less adopted toolchain
          
              # optionally required by your code editor to lint and format your code
              pkgs.nodePackages.prettier # formatter
              pkgs.nodePackages.eslint # linter
          
              # example package to serve a static nextjs export
              pkgs.nodePackages.serve

            ];

            shellHook = ''
              echo "welcome to NodeJS" | ${pkgs.lolcat}/bin/lolcat
            '';
          };
      });
    };
}
