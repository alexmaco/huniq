#! /bin/bash

cd "$(dirname "$0")"
bin="./target/debug/huniq"

failures=0
count=0

assert() {
  local desc="$1"; shift
  local ref="$1"; shift

  (( count++ ))
  diff <(eval "$@") "$ref" >/dev/null || {
    echo >&2 "Assertion failed \"$desc\": \`$@\`"
    diff <(eval "$@") "$ref" >&2
    (( failures++ ))
  }
}

main() {
  test -e "$huniq2bin" || {
    cargo build
  }

  assert uniq test/expect_uniq.txt "$bin <test/input.txt"
  assert count test/expect_count.txt "$bin -c <test/input.txt | sort -nr"

  echo >&2 "$count tests $failures failures"
  test "$failures" -eq 0
}

main
