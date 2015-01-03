
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Twitter.Auth where

import           API.Rest
import qualified Data.ByteString.Lazy      as LBS
import           Data.Map                  (Map)
import           Imports.Prelude           hiding ((.=))
-- import Control.Lens hiding ((.=))
import           Control.Monad             (liftM)
import           Data.Aeson
import           Data.Monoid               ((<>))

import           Network.HTTP.Conduit
import           Network.HTTP.Types.Header
import           Network.HTTP.Types.Method




authenticate key pass = do
    -- let reqBody = RequestBodyLBS $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    -- print $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    let reqBody = RequestBodyLBS "grant_type=client_credentials"
    resp <- tweeter "/oauth2/token" methodPost reqBody (Credential key pass)
    -- let tok = resp ^. undefined
    -- return $ Token tok
    print resp

auth = Token "xxx"

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

