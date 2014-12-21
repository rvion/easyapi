{-# LANGUAGE PackageImports #-}
{-# LANGUAGE OverloadedStrings #-}
module Test where

import           API.Rest
import           "this" Imports

main :: IO ()
main = do
    debugRequest
    if all (== True) tests
    then print "all good"
    else print "error"

tests :: [Bool]
tests =
  [ Nothing ? 3 == 3
  , Just "d" ? "fre" == "d"
  ]

debugRequest :: IO ()
debugRequest = do
    let fakeWebsite = apiWrapper "https://fakeWebsite.test"
        reqBody = RequestBodyLBS $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    fakeWebsite "/oauth2/token" methodPost (Just reqBody) (NoAuth)
    return ()
