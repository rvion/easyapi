{-# LANGUAGE OverloadedStrings #-}
module ZZZ where

import           API.Prelude

main :: IO ()
main = 
    --debugRequest
    print (if all (== True) tests then ("all good" :: String) else "error")

tests :: [Bool]
tests =
  [ Nothing ? (3 :: Integer) == 3
  , Just ("d" :: String) ? "fre" == "d"
  ]
{-
debugRequest :: IO ()
debugRequest = do
    let fakeWebsite = apiWrapper' "https://fakeWebsite.test"
        reqBody = RequestBodyLBS $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    _ <- fakeWebsite "/oauth2/token" methodPost (Just reqBody) NoAuth
    return ()
-}
