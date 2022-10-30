# direnv-nix-action

This action will install nix with the (cachix nix action)[https://github.com/cachix/install-nix-action] and direnv to make nix based workflows easier to setup.

### Example workflow

Assuming you have a nix setup with this flake

```nix
{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells = {
          # other dev shells....
          CI = pkgs.mkShell { buildInputs = [ pkgs.nodejs-16_x ]; };
        };
      });
}
```
and an `.envrc` like
```
if [ -z $DEV_SHELL_NAME ]; then
    use flake
else
    # running in CI
    use flake ".#${DEV_SHELL_NAME}"
fi
```

Then your workflow can look like
```yaml
name: use nix

on: push
env:
    DEV_SHELL_NAME: CI
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: "Setup env"
      uses: JRMurr/direnv-nix-action@v2

    - name: use node
      run: node --version
      shell: bash
```

