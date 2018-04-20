#!/usr/bin/env bash

set -eux

mkdir -p dist
cat "$0" | tail -n+$[LINENO+3] > ./dist/whack-a-test
chmod +x ./dist/whack-a-test
exit 0
#!/usr/bin/env bash
echo "whack-a-test -- a game that Jon and Sönke are playing" >&2
echo "1 + 2 = 3"
