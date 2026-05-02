#!/usr/bin/env nu

# A shorthand for an ipython shell

# Creates an ipython nix environment.
#
# The --python-pkgs (-p) flag passes its arguments straight into python3.withPackages
# The --regular-pkgs (-r) flag passes its arguments as extra packages to create a shell
#   with (like any other package passed to nix-shell -p).
# The --python-version (-i) flag sets the python interpreter to use.
def ipython-shell [
  --python-pkgs (-p): list<string> = []
  --regular-pkgs (-r): list<string> = []
  --python-version (-i): string = "python3"
] {
  let python_pkgs_str = ($python_pkgs | str join ' ')

  let nix_expr = ($python_version + '.withPackages (ps: with ps; [ ipython ' + $python_pkgs_str + '])')
  nix-shell -p $nix_expr ...$regular_pkgs uv nushell --run nu
}
