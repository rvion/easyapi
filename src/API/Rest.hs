{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module API.Rest
    ( LBS, BS, Auth(..)
    , apiWrapper
    , apiWrapper'
    ) where


import           Data.ByteString.Lazy as LBS

import           API.Prelude
import           API.HTTP

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: LBS }
  | NoAuth
  deriving (Show)
makeLenses ''Auth

apiWrapper :: String -> String -> Method -> Auth -> IO LBS
apiWrapper baseUrl url verb = apiWrapper' baseUrl url verb Nothing

apiWrapper' :: String -> String -> Method -> Maybe RequestBody -> Auth -> IO LBS
apiWrapper' baseUrl url verb mbBody auth = do
  initReq <- parseUrl (baseUrl <> url)
  let req = authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders =
          [ ( hAccept, "application/vnd.heroku+json; version=3" )
          , ( hContentType, "application/json" )
          ] ++ authHeader
        , requestBody = mbBody ? RequestBodyLBS LBS.empty
        }
  print ("request is:" :: String, req)
  liftM responseBody $ withManager $ httpLbs req
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])

