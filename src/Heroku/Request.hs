{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE OverloadedStrings #-}

module Heroku.Request
  ( module Heroku.Request
  ) where

import           API.Auth
import           API.Prelude
import           API.HTTP

import           Data.ByteString.Lazy as LBS

heroku :: String -> Method -> Auth -> IO Request
heroku = apiWrapper "https://api.heroku.com/"

apiWrapper :: String -> String -> Method -> Auth -> IO Request
apiWrapper baseUrl url verb = apiWrapper' baseUrl url verb Nothing

apiWrapper' :: String -> String -> Method -> Maybe RequestBody -> Auth -> IO Request
apiWrapper' baseUrl url verb mbBody auth = do
  initReq <- parseUrl (baseUrl <> url)
  return $ authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders =
          [ ( hAccept, "application/vnd.heroku+json; version=3" )
          , ( hContentType, "application/json" )
          ] ++ authHeader
        , requestBody = mbBody ? RequestBodyLBS LBS.empty
        }
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])
