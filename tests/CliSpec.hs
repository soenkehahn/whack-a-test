{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CliSpec where

import Data.Char
import Data.String.Interpolate
import Development.Shake
import System.IO
import System.Timeout
import Test.Hspec
import Test.QuickCheck

compileBeforeAll :: Spec -> Spec
compileBeforeAll = beforeAll_ $ do
  unit $ cmd "./compile.sh"

shouldTerminate :: Spec -> Spec
shouldTerminate = around_ $ \ test -> do
  result <- timeout 500000 test
  case result of
    Just () -> return ()
    Nothing -> fail "timeout"

spec :: Spec
spec = compileBeforeAll $ shouldTerminate $ do
  describe "whack-a-test executable" $ do
    it "has a nice help message" $ do
      Stderr (output :: String) <- cmd "./dist/whack-a-test --help"
      output `shouldContain`
        "whack-a-test -- a game that Jon and Sönke are playing"
  describe "addition" $ do
    it "can add two numbers" $ do
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
    it "gives a helpful message when not given numbers (and not closing stdin)" $ do
      Stderr message <- cmd "./dist/whack-a-test --add"
      trim message `shouldBe`
        ("whack-a-test: please provide addition arguments, " ++
        "either through command line arguments or to stdin")
    it "shouldn't care if there's a newline in stdin" $ do
      property $ \ (x :: Int) (y :: Int) -> do
        Stdout output <- cmd (Stdin [i|#{x} #{y}\n|]) "./dist/whack-a-test --add"
        trim output `shouldBe` addOutput x y
  where
    addOutput x y = [i|#{x} + #{y} = #{x + y}|]
    trim = reverse . dropWhile isSpace . reverse . dropWhile isSpace
