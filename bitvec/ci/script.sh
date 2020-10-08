#!/usr/bin/env bash

set -ex

# Detect our build command if we are on travis or not (so we can test locally).
if [ ! -z $ENABLE_CROSS ]; then
  CARGO=${HOME}/.cargo/bin/cross
  CARGO_TARGET="--target ${TARGET}"
elif [ -z $CI ] || [ ! -z $DISABLE_CROSS ]; then
  # Not on CI or explicitly disabled cross, use cargo
  CARGO=cargo
else
  # On CI, use cross.
  CARGO=${TRAVIS_HOME:-${HOME}}/.cargo/bin/cross
  CARGO_TARGET="--target ${TARGET}"
fi

if [ ! -z $CI ]; then
  $CARGO clean
fi
$CARGO build $CARGO_TARGET --all-features
if [ -z $DISABLE_TESTS ]; then
  $CARGO test $CARGO_TARGET --all-features
fi
