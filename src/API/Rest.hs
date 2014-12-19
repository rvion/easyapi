{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PackageImports    #-}
{-# LANGUAGE TemplateHaskell   #-}

module API.Rest
    ( LBS, BS -- practical aliases reexport
    , Auth(..)           -- authentication wrapper
    , apiWrapper
    ) where


import           "this" Imports
import           Data.ByteString           as BS
import           Data.ByteString.Lazy      as LBS

type LBS = LBS.ByteString
type BS = BS.ByteString

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: LBS }
  deriving (Show)
makeLenses ''Auth


apiWrapper :: String ->  Auth ->  Method -> String -> IO LBS
apiWrapper baseUrl auth verb url = do
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
      (Token tok) -> (id, [(hAuthorization, "Bearer " <> toStrict tok)])
      (Credential user pass) -> (applyBasicAuth user pass, [])
