{-# LANGUAGE DeriveFunctor    #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell  #-}

module Heroku.DSL where

import           Control.Monad.Free    (Free, MonadFree, liftF)
import           Control.Monad.Free.TH (makeFree)

import           Heroku.Types

data HerokuF next
    = RestartApp AppName next
    | RestartDyno AppName DynoName next
    | GetAppInfo AppName (HerokuAppInfo -> next)
    deriving (Functor)
makeFree ''HerokuF
type HerokuDSL a = Free HerokuF a

