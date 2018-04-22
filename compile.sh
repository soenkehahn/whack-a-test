#!/usr/bin/env bash

set -eux

TMPDIR="$PWD/.tmp"
function cleanup {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT
mkdir -p "$TMPDIR"

rm -rf dist
mkdir -p dist

cp -R adder "$TMPDIR"
docker run --rm -v"$TMPDIR":/src/main ponylang/ponyc:0.21.3 ./adder/build.sh "$(id -u)"
cp "$TMPDIR/adder-bin" dist/adder

cat "$0" | tail -n+$[LINENO+3] > ./dist/whack-a-test
chmod +x ./dist/whack-a-test
exit 0
#!/usr/bin/env bash
case "$1" in
    --help)
        echo "whack-a-test -- a game that Jon and Sönke are playing" >&2
        exit 0
        ;;
    --add)
        shift
        exec "$(dirname $0)/adder" "$@"
        ;;
    *)
        ;;
esac
