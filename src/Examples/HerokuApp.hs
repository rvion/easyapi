{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Examples.HerokuApp where

import           API.Easy
import           Heroku.Easy

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
    blueskyInfo <- getAppInfo "nav-bluesky-eu"
    -- restartApp "test"
    _ <- getAppInfo "nav-chronos-eu"
    return blueskyInfo

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