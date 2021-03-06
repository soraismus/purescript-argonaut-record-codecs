module Test.Suites.XDecodeJsonWith.Maybe
  ( suitex
  ) where

import Prelude (discard, mod, show, ($), (==), (<$>))

import Data.Argonaut.Decode.X (xDecodeJsonWith)
import Data.Argonaut.Encode (encodeJson)
import Data.Either (Either(Right))
import Data.Maybe (Maybe(Just))
import Test.Unit (TestSuite, suite, test)
import Test.Utils (assert, check, withErrorMsg)

suitex :: TestSuite
suitex =
  suite "Maybe" do
    suite "{ a0 :: Int, a1 :: Int, a2 :: Maybe Int, a3 :: Maybe String, a4 :: Maybe Boolean }" do
      suite "{ a0: 0, a1: 1, a2: Just 2, a3: Just \"hello\", a4: Just true }" do
        test "#0" do
          let
            result
              :: Either
                  String
                  { a0 :: Int
                  , a1 :: Int
                  , a2 :: Maybe Int
                  , a3 :: Maybe String
                  , a4 :: Maybe Boolean
                  }
            result =
              xDecodeJsonWith
                { a2: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just 1002
                , a3: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just "bye"
                , a4: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just false
                }
                (encodeJson { a0: 0
                            , a1: 1
                            , a2: Just 2
                            , a3: Just "hello"
                            , a4: Just true
                            })
          assert $ check result withErrorMsg
            (_ == { a0: 0
                  , a1: 1
                  , a2: Just 1002
                  , a3: Just "bye"
                  , a4: Just false
                  })
        test "#1" do
          let
            result
              :: Either
                  String
                  { a0 :: Int
                  , a1 :: Int
                  , a2 :: Maybe Int
                  , a3 :: Maybe String
                  , a4 :: Maybe Boolean
                  }
            result =
              xDecodeJsonWith
                { a2: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just rest.a0
                , a3: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just "bye"
                , a4: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just false
                }
                (encodeJson { a0: 0
                            , a1: 1
                            , a2: Just 2
                            , a3: Just "hello"
                            , a4: Just true
                            })
          assert $ check result withErrorMsg
            (_ == { a0: 0
                  , a1: 1
                  , a2: Just 0
                  , a3: Just "bye"
                  , a4: Just false
                  })
        test "#2" do
          let
            result
              :: Either
                  String
                  { a0 :: Int
                  , a1 :: Int
                  , a2 :: Maybe Int
                  , a3 :: Maybe String
                  , a4 :: Maybe Boolean
                  }
            result =
              xDecodeJsonWith
                { a2: \json (rest :: { a0 :: Int, a1 :: Int }) -> Right $ Just rest.a0
                , a3: \json rest -> Right $ Just $ show rest.a0
                , a4: \json rest -> Right $ Just $ (rest.a1 `mod` 2 == 0)
                }
                (encodeJson { a0: 0
                            , a1: 1
                            , a2: Just 2
                            , a3: Just "hello"
                            , a4: Just true
                            })
          assert $ check result withErrorMsg
            (_ == { a0: 0
                  , a1: 1
                  , a2: Just 0
                  , a3: Just $ show 0
                  , a4: Just (1 `mod` 2 == 0)
                      })
        test "#3" do
          let
            isEven :: Int -> Boolean
            isEven i = (i `mod` 2) == 0
            result
              :: Either
                  String
                  { a0 :: Int
                  , a1 :: Int
                  , a2 :: Maybe Int
                  , a3 :: Maybe String
                  , a4 :: Maybe Boolean
                  }
            result =
              xDecodeJsonWith
                { a4: \json rest -> Right $ isEven <$> rest.a2 }
                (encodeJson { a0: 0
                            , a1: 1
                            , a2: Just 2
                            , a3: Just "hello"
                            , a4: Just true
                            })
          assert $ check result withErrorMsg
            (_ == { a0: 0
                  , a1: 1
                  , a2: Just 2
                  , a3: Just "hello"
                  , a4: isEven <$> Just 2
                  })
