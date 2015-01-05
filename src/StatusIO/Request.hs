{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}

module StatusIO.Request where

import           API.Auth
import           API.HTTP
import           API.Prelude

import           Control.Monad.IO.Class      (MonadIO)
import           Control.Monad.Trans.Control (MonadBaseControl)
import           Data.ByteString.Lazy        as LBS
import qualified Data.CaseInsensitive        as CI

sendToHeroku :: (MonadIO m, MonadBaseControl IO m) => Request -> m LBS
sendToHeroku req = liftM responseBody $ withManager $ httpLbs req

statusIO :: String -> Method -> Auth -> IO Request
statusIO = apiWrapper "https://api.status.io/v2/"

apiWrapper :: String -> String -> Method -> Auth -> IO Request
apiWrapper baseUrl url verb = apiWrapper' baseUrl url verb Nothing

apiWrapper' :: String -> String -> Method -> Maybe RequestBody -> Auth -> IO Request
apiWrapper' baseUrl url verb mbBody auth = do
  initReq <- parseUrl (baseUrl <> url)
  return $ authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders =
          ( hContentType, "application/json" ) : authHeader
        , requestBody = mbBody ? RequestBodyLBS LBS.empty
        }
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> toStrict tok)])
      (Credential user pass) -> (applyStatusIOAuth user pass, [])

applyStatusIOAuth :: BS -> BS -> Request -> Request
applyStatusIOAuth user passwd req = req
    { requestHeaders = apiIdHeader : apiKeyHeader :requestHeaders req
    }
  where
    apiIdHeader = (CI.mk "x-api-id", user)
    apiKeyHeader = (CI.mk "x-api-key", passwd)

