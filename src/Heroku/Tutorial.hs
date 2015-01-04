{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}

module Heroku.Tutorial where

import           API.Rest
import           Data.ByteString.Char8 (pack)

import           Heroku.Auth
import           Heroku.DSL
import           Heroku.Types

import           Imports.Env
import           Imports.Prelude

command = do
    before <- getAppInfo (App "nav-chronos-eu")
    -- restartApp (App "test")
    after <- getAppInfo (App "nav-chronos-eu")
    return (before, after)

test :: IO ()
test = do
    env <- getLocalEnv
    let auth = Credential
          { _user = pack $ env ^. atIndex "herokulogin"
          , _pass = pack $ env ^. atIndex "herokupassword"
          }
    mbToken <- fetchBearerToken auth
    case mbToken of
        Nothing -> error "can't login on heroku"
        Just authToken -> do
            infos <- run authToken command
            print infos
            print "ok"

main = test
