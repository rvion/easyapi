{-# LANGUAGE OverloadedStrings #-}

module Heroku.Auth where

import           Imports.HTTP
import           Imports.Prelude

import           Heroku.Request

fetchBearerToken :: Auth -> IO (Maybe Auth)
fetchBearerToken auth = do
  response <- heroku "oauth/authorizations" methodPost auth
  let token = fmap (Token . textToLbs) $ response ^? key "access_token" . key "token" . _String
  case token of
    Nothing -> print ("can't get token" :: String)
    Just tok -> print $ "new token given by heroku is " <> show tok
  return token
