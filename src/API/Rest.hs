{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module API.Rest where

import API.Internal.Imports

type Token = LBS
data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: Token }
  deriving (Show)
makeLenses ''Auth

heroku :: String -> Method -> Auth -> IO LBS
heroku url verb auth = do
  initReq <- parseUrl ("https://api.heroku.com/" <> url)
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