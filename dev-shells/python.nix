{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
  ];

  shellHook = ''
    echo "Python Environment Active ($(python --version))"

    if [ ! -d ".venv" ]; then
      python -m venv .venv
      echo "Created local virtual environment in .venv"
      fi
  '';
}
