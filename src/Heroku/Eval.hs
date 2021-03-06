{-# LANGUAGE ConstraintKinds #-}

module Heroku.Eval
  ( module Heroku.Eval
  ) where

import           API.Easy
import           Control.Monad.Free     (iterM)
import           Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Heroku.Endpoints       as API

import           Heroku.Class
import           Heroku.DSL
import           Heroku.Types

runOnHeroku :: (MonadIO m, HerokuM m, MonadCatch m) => HerokuDSL a -> m a
runOnHeroku expr = do
    auth <- herokuAuth
    run auth expr

type ProductionEnv m = (MonadIO m, HerokuM m, MonadCatch m)
type DebugEnv m = (HerokuM m, MonadCatch m) -- we use trace

run :: ProductionEnv m => Auth -> HerokuDSL a -> m a
run auth =
    iterM eval
    where
    eval action = case action of
        (RestartApp app next) -> do
            restartRequest <- liftIO (API.restartApp app auth)
            _ <- liftIO $ httpSend restartRequest
            next
        (RestartDyno app dyno next) -> do
            restartDynoRequest <- liftIO (API.restartDyno app dyno auth)
            _ <- liftIO $ httpSend restartDynoRequest
            next
        (GetAppInfo app next) -> do
            rawTxt <- liftIO (API.fetchDetails app auth >>= httpSend) 
            next (AppInfo rawTxt)

debug :: ProductionEnv m => HerokuDSL a -> m a
debug =
    iterM eval
    where
    eval action = case action of
        (RestartApp app next) -> 
            liftIO (API.restartApp app NoAuth >>= print) >>next
        (RestartDyno app dyno next) ->
            liftIO (API.restartDyno app dyno NoAuth >>= print) >> next
        (GetAppInfo app next) ->
            liftIO (API.fetchDetails app NoAuth >>= print) >> next (AppInfo "not disponible in debug mode")
