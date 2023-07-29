{
  description = "Installs all necessary dependencies to use TwirPHP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: rec {
        devenv.shells = {
          default = {
            languages = {
              php = {
                enable = true;
              };
            };

            pre-commit.hooks = {
              nixpkgs-fmt.enable = true;
              yamllint.enable = true;
            };

            packages = with pkgs; [
              yamllint
            ];

            enterShell = ''
              export PATH="$PWD/$(composer config vendor-dir)/bin:$PATH"
            '';

            # https://github.com/cachix/devenv/issues/528#issuecomment-1556108767
            containers = pkgs.lib.mkForce { };
          };

          ci = devenv.shells.default;

          ci_7_3 = {
            imports = [ devenv.shells.default ];

            languages = {
              php = {
                version = "7.3";
              };
            };
          };

          ci_7_4 = {
            imports = [ devenv.shells.default ];

            languages = {
              php = {
                version = "7.4";
              };
            };
          };

          ci_8_0 = {
            imports = [ devenv.shells.default ];

            languages = {
              php = {
                version = "8.0";
              };
            };
          };

          ci_8_1 = {
            imports = [ devenv.shells.default ];

            languages = {
              php = {
                version = "8.1";
              };
            };
          };

          ci_8_2 = {
            imports = [ devenv.shells.default ];

            languages = {
              php = {
                version = "8.2";
              };
            };
          };
        };
      };
    };
}
