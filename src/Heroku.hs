{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Heroku
  ( module Heroku
  --  , module X
  ) where

import           API.Prelude
import           API.Auth

import           Heroku.Class as X
import           Heroku.Auth as X
import           Heroku.Eval as X

import Control.Monad.Trans.State.Lazy
import Control.Monad.IO.Class (liftIO)

-- | Main app dictionary
data App = App
  { _appHkAuth :: Auth
  } deriving (Show)
makeFields ''App

loadApp :: IO App
loadApp = do
    env <- liftIO getEnvfromConfigFile
    bearerToken <- fetchBearerToken Credential
      { _user = pack $ env ^. ix "herokulogin"
      , _pass = pack $ env ^. ix "herokupassword"
      }
    return $ App bearerToken

-- | your DSL code
exampleDSL :: HerokuDSL HerokuAppInfo
exampleDSL = do
    -- connect ["nav-chronos-eu", "nav-bluesky-eu", "test"]
    chronosInfo <- getAppInfo "nav-chronos-eu"
    -- restartApp "test"
    return chronosInfo

type AppM = StateT App IO
instance HerokuM (AppM) where
    herokuAuth = use hkAuth

-- Your main program, running in some monad (here IO)
exampleApp :: AppM ()
exampleApp = do
    infos <- runOnHeroku exampleDSL
    liftIO $ print infos
    liftIO exitSuccess

main :: IO ()
main = do
    initialApp <- loadApp
    runStateT exampleApp initialApp  >>= print
