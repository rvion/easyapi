{-# LANGUAGE KindSignatures #-}
module Heroku.DSL
  ( module Heroku.DSL
  , module X
  ) where

import           API.Rest
import           Control.Monad.Free        (Free, MonadFree, iterM, liftF)
import           Control.Monad.IO.Class    (MonadIO, liftIO)
import qualified Heroku.Internal.Endpoints as API

import           Heroku.Internal.Grammar   as X
import           Heroku.Types              as X

class CanHeroku (x :: * -> *) where
instance CanHeroku IO where

run :: (MonadIO m, CanHeroku m) =>
    Auth -> HerokuDSL a -> m a
run auth = iterM eval where
    eval action = case action of
        (RestartApp app next)   -> do
            liftIO $ API.restartApp app auth
            next
        (RestartDyno app dyno next) -> do
            liftIO $ API.restartDyno app dyno auth
            next
        (GetAppInfo dynos next) -> do
            liftIO $ API.fetchDetails "test" auth
            next (AppInfo "test")
