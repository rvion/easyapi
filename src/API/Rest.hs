{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports    #-}
{-# LANGUAGE TemplateHaskell   #-}

module API.Rest
    ( LBS, BS, Auth(..)
    , apiWrapper
    ) where

import           Data.ByteString         as BS
import           Data.ByteString.Lazy    as LBS
import           "this" Imports

type LBS = LBS.ByteString
type BS = BS.ByteString

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: LBS }
  | NoAuth
  deriving (Show)
makeLenses ''Auth


apiWrapper :: String -> String -> Method -> Auth -> IO LBS
apiWrapper baseUrl url verb auth = do
  initReq <- parseUrl (baseUrl <> url)
  let req = authFunction $ initReq
        { secure = True
        , method = verb
        , requestHeaders =
          [ ( hAccept, "application/vnd.heroku+json; version=3" )
          , ( hContentType, "application/json" )
          ] ++ authHeader
        }
  liftM responseBody $ withManager $ httpLbs req
  where
    (authFunction, authHeader) = case auth of
      NoAuth -> (id, [])
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])
