{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE NoMonomorphismRestriction    #-}

module Heroku.Eval
  ( module Heroku.Eval
  , module X
  ) where

import           API.Auth
import           Control.Monad.Free     (iterM)
import           Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Heroku.Endpoints       as API

import           Heroku.Class
import           Heroku.DSL             as X
import           Heroku.Types           as X

-- import Control.Monad.Catch

run :: (MonadIO m, HerokuM m) =>
    Auth -> HerokuDSL a -> m a
run auth = iterM eval where
    eval action = case action of
        (RestartApp app next)   -> do
            _ <- liftIO $ API.restartApp app auth
            next
        (RestartDyno app dyno next) -> do
            _ <- liftIO $ API.restartDyno app dyno auth
            next
        (GetAppInfo app next) -> do
            _ <- liftIO $ API.fetchDetails app auth
            next (AppInfo "test")
        _ -> error "unimplemented"
