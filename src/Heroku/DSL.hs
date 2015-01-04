{-# LANGUAGE DeriveFunctor    #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell  #-}

module Heroku.DSL where

import           Control.Monad.Free    (Free, MonadFree, iterM, liftF)
import           Control.Monad.Free.TH (makeFree)

import           API.Rest
import qualified Heroku.Endpoints      as API
import           Heroku.Types

data HerokuF next
    = Connect String String next
    | Target [AppName] next
    | RestartApp AppName next
    | RestartDyno AppName DynoName next
    | GetAppInfo App (AppInfo -> next)
    deriving (Functor)
makeFree ''HerokuF
type HerokuDSL a = Free HerokuF a

