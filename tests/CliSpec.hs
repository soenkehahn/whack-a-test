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
