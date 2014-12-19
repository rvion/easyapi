{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module API.Rest
    ( Token
    , Auth
    , apiWrapper
    ) where

import           API.Internal.Imports

type Token = LBS
data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: Token }
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
