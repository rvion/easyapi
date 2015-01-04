{-# LANGUAGE OverloadedStrings #-}

module Twitter.Request
  ( module X
  , module Twitter.Request
  ) where

import           API.Auth        as X
import           API.HTTP
import           API.Prelude
import qualified Data.ByteString.Lazy as LBS

tweeter :: String -> Method -> RequestBody -> Auth -> IO LBS
tweeter = twitterWrapper "https://api.twitter.com"

twitterWrapper :: String -> String -> Method -> RequestBody -> Auth -> IO LBS
twitterWrapper baseUrl url verb _ auth = do
  initReq <- parseUrl (baseUrl <> url)
  let req = authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders = authHeader
        , requestBody = RequestBodyLBS "grant_type=client_credentials"
        , queryString = "grant_type=client_credentials"
        }
  print ("request is:" :: String, req)
  liftM responseBody $ withManager $ httpLbs req
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> LBS.toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])

