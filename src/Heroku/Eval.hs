{-# LANGUAGE ConstraintKinds #-}
module Heroku.Eval
  ( module Heroku.Eval
  ) where

import           API.Auth
import           Control.Monad.Free     (iterM)
import           Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Heroku.Endpoints       as API

import           Heroku.Class
import           Heroku.DSL
import           Heroku.Types
import           Heroku.Request

import Control.Monad.Catch

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
        (RestartApp app next) -> liftIO (API.restartApp app auth >>= sendToHeroku) >> next
        (RestartDyno app dyno next) -> liftIO (API.restartDyno app dyno auth >>= sendToHeroku) >> next
        (GetAppInfo app next) -> liftIO (API.fetchDetails app auth >>= sendToHeroku) >>= \rawTxt -> next (AppInfo rawTxt)
        -- _ -> throwM $ PatternMatchFail "didn't implement full dsl evaluation yet"

debug :: ProductionEnv m => Auth -> HerokuDSL a -> m a
debug auth =
    iterM eval
    where
    eval action = case action of
        (RestartApp app next) -> liftIO (API.restartApp app auth >>= print) >> next
        (RestartDyno app dyno next) -> liftIO (API.restartDyno app dyno auth >>= print) >> next
        (GetAppInfo app next) -> liftIO (API.fetchDetails app auth >>= print) >> next (AppInfo "not disponible in debug mode")
        -- _ -> throwM $ PatternMatchFail "didn't implement full dsl evaluation yet"
