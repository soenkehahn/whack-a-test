{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CliSpec where

import Data.String.Interpolate
import Development.Shake
import System.IO
import System.IO.Silently
import Test.Hspec
import Test.QuickCheck

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
      output `shouldContain` (addOutput 1 2)
    it "can add two arbitrary numbers" $ do
      property $ \ (x :: Int) (y :: Int) -> do
        Stdout (output :: String) <-
          cmd "./dist/whack-a-test --add" (show x) (show y)
        output `shouldContain` (addOutput x y)
    it "can add pairs of numbers from stdin" $ do
      property $ \ (x :: Int) (y :: Int) -> do
        Stdout (output :: String) <-
          cmd (Stdin [i|#{x} #{y}|]) "./dist/whack-a-test --add"
        output `shouldContain` (addOutput x y)
  where
    addOutput x y = [i|#{x} + #{y} = #{x + y}|]
