{-# LANGUAGE OverloadedStrings #-}

module Heroku.Auth where

import           Heroku.Protocol
import           API.Rest
import           Imports.Prelude

updateToken :: IO (Maybe Auth)
updateToken = case hardCodedToken of
  Just _ -> return hardCodedToken
  Nothing -> fetchHerokuToken hardCodedCredentials
  where
    hardCodedToken = Nothing -- Just $ Token "secret"
    hardCodedCredentials = Credential
      { _user = "vion.remi@gmail.com"
      , _pass = "secret"
      } :: Auth

fetchHerokuToken :: Auth -> IO (Maybe Auth)
fetchHerokuToken auth = do
  response <- heroku "oauth/authorizations" methodPost auth
  let token = fmap (Token . textToLbs) $ response ^? key "access_token" . key "token" . _String
  case token of
    Nothing -> print ("can't get token" :: String)
    Just tok -> print $ "new token given by heroku is " <> show tok
  return token
