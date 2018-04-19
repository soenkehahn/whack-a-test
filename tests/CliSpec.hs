{-# LANGUAGE ScopedTypeVariables #-}

module CliSpec where

import Development.Shake
import System.IO
import System.IO.Silently
import Test.Hspec

spec :: Spec
spec = around_ (hSilence [stdout, stderr]) $ do
  describe "whack-a-test executable" $ do
    it "has a nice help message" $ do
      unit $ cmd "./compile.sh"
      Stderr (output :: String) <- cmd "./dist/whack-a-test --help"
      output `shouldContain`
        "whack-a-test -- a game that Jon and Sönke are playing"
  describe "addition" $ do
    it "can add two numbers" $ do
      unit $ cmd "./compile.sh"
      Stdout (output :: String) <- cmd "./dist/whack-a-test --add 1 2"
      output `shouldContain` "1 + 2 = 3"
