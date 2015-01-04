{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}

module Heroku.Tutorial where

import           API.Rest

import           Heroku.Internal.Auth

import           Heroku.DSL
import           Imports.Env
import           Imports.Prelude

command :: HerokuDSL (AppInfo,AppInfo)
command = do
    before <- getAppInfo (App "nav-chronos-eu")
    -- restartApp (App "test")
    after <- getAppInfo (App "nav-chronos-eu")
    return (before, after)

test :: IO ()
test = do
    env <- getLocalEnv
    let auth = Credential
          { _user = pack $ env ^. ix "herokulogin"
          , _pass = pack $ env ^. ix "herokupassword"
          }
    mbToken <- fetchBearerToken auth
    case mbToken of
        Nothing -> error "can't login on heroku"
        Just authToken -> do
            infos <- run authToken command
            print infos
            putStrLn "ok"

main = test
