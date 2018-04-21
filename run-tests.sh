#!/usr/bin/env bash

set -eux

stack setup
stack test --only-dependencies
stack exec -- runhaskell -itests tests/Spec.hs
