#!/usr/bin/env bash
# termux-rtl installer
#
#   curl -fsSL https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/install.sh | bash -s -- --uninstall

set -euo pipefail

REPO_RAW="${REPO_RAW:-https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/bin}"
FILES="termux-rtl rtl-exec rtl-clip"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
BIN="$PREFIX/bin"

say() { printf '%s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[ "${1:-}" = "--uninstall" ] && {
  for f in $FILES rtl; do rm -f "$BIN/$f"; done
  say "termux-rtl removed (packages fribidi/python left in place)."
  exit 0
}

[ -d "$PREFIX" ] || die "not Termux (PREFIX=$PREFIX not found). Run this inside Termux."
command -v pkg >/dev/null 2>&1 || die "'pkg' not found. Run this inside Termux."

say "==> installing fribidi + python"
pkg install -y fribidi python >/dev/null

# Termux ships python3.x + a 'python' alias but no 'python3'; the scripts use python3.
command -v python3 >/dev/null 2>&1 || ln -sf python "$BIN/python3"

if ! python3 -c "import arabic_reshaper" >/dev/null 2>&1; then
  say "==> installing arabic-reshaper (Arabic letter joining)"
  python3 -m pip install --quiet --disable-pip-version-check --no-input arabic-reshaper \
    || say "   pip failed - Arabic joins stay unjoined, Hebrew is still fine."
fi

say "==> installing commands into $BIN"
for f in $FILES; do
  curl -fsSL "$REPO_RAW/$f" -o "$BIN/$f" || die "download failed: $f"
  chmod 755 "$BIN/$f"
done
ln -sf termux-rtl "$BIN/rtl"

say "==> selftest"
"$BIN/termux-rtl" --selftest || true

cat <<'EOF'

Done:

  cmd | rtl                 filter any command output
  rtl-exec claude           run a command (colors kept) with RTL fixed
  echo "שלום" | rtl-clip    copy RTL text to the clipboard
EOF
