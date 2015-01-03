{-# LANGUAGE OverloadedStrings #-}

module Twitter.Request
  ( module X
  , module Twitter.Request
  ) where

import           API.Rest        as X
import           Imports.HTTP
import           Imports.Prelude
import qualified Data.ByteString.Lazy as LBS

tweeter = twitterWrapper "https://api.twitter.com"

twitterWrapper :: String -> String -> Method -> RequestBody -> Auth -> IO LBS
twitterWrapper baseUrl url verb mbBody auth = do
  initReq <- parseUrl (baseUrl <> url)
  let req = authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders = authHeader
        , requestBody = RequestBodyLBS "grant_type=client_credentials"
        , queryString = "grant_type=client_credentials"
        }
  print ("request is:", req)
  liftM responseBody $ withManager $ httpLbs req
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> LBS.toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])

