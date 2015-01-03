{-# LANGUAGE OverloadedStrings #-}
module Test where

import           API.Rest

import           Imports.HTTP
import           Imports.Prelude

main :: IO ()
main = do
    debugRequest
    print (if all (== True) tests then ("all good" :: String) else "error")

tests :: [Bool]
tests =
  [ Nothing ? (3 :: Integer) == 3
  , Just ("d" :: String) ? "fre" == "d"
  ]

debugRequest :: IO ()
debugRequest = do
    let fakeWebsite = apiWrapper' "https://fakeWebsite.test"
        reqBody = RequestBodyLBS $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    _ <- fakeWebsite "/oauth2/token" methodPost (Just reqBody) NoAuth
    return ()
