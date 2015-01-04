{-# LANGUAGE OverloadedStrings #-}

module Heroku.Auth where

import           API.HTTP
import           API.Prelude
import           API.Auth

import           Heroku.Request
import           Control.Monad.Catch

-- | This function transform Auth into bearer token as mention in heroku doc
fetchBearerToken :: Auth -> IO Auth
fetchBearerToken auth = do
  putStrLn "fetching auth token"
  case auth of 
      NoAuth -> return NoAuth
      Token _ -> return auth
      Credential _ _ -> do
          response <- heroku "oauth/authorizations" methodPost auth
          let token = fmap (Token . textToLbs) $
                response ^? key "access_token" . key "token" . _String
          case token of
            Nothing -> throwM NotAbleToFetchBearerToken
            Just tok -> return tok
