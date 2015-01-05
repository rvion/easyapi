{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Examples.StatusIODemo where

import           API.Easy
import           Heroku.Easy

import Control.Monad.Trans.State.Lazy
import Control.Monad.IO.Class (liftIO)

-- | Main app dictionary
data App = App
  { _appHkAuth :: Auth
  } deriving (Show)
makeFields ''App

loadConfig :: IO App
loadConfig = do
    env <- liftIO getEnvfromConfigFile
    putStrLn "Fetching env from file..."
    let mbCredentials = do
            user <- pack <$> env ^. at "HEROKU_LOGIN"
            pass <- pack <$> env ^. at "HEROKU_PASSWORD"
            return Credential { _user =  user, _pass = pass}
    case mbCredentials of 
        Nothing -> do 
            putStrLn "Invalid credentials:"
            throwM ErrorInConfigFile
        Just credentials -> do
            putStrLn $ "Loaded credentilas are "<> show credentials
            putStrLn "Fetching token..."
            bearerToken <- fetchBearerToken credentials
            putStrLn $ "loaded credentilas are "<> show bearerToken
            return $ App bearerToken

-- | your DSL code
exampleDSL :: HerokuDSL (HerokuAppInfo, HerokuAppInfo)
exampleDSL = do
    blueskyInfo <- getAppInfo "nav-bluesky-eu"
    chronosInfo <- getAppInfo "nav-chronos-eu"
    return (chronosInfo, blueskyInfo)

type AppM = StateT App IO
instance HerokuM (AppM) where
    herokuAuth = use hkAuth

exampleApp :: AppM ()
exampleApp = do
    liftIO $ putStrLn "initializing program"
    infos <- runOnHeroku exampleDSL
    liftIO $ do
        print infos
        putStrLn "Doing more stuff"
        exitSuccess

main :: IO ()
main = do
    initialApp <- loadConfig
    runStateT exampleApp initialApp  >>= print
