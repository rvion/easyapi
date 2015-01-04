{-# LANGUAGE DeriveDataTypeable #-}
module Heroku.Exceptions where

import           Control.Monad.Catch
import           Data.Typeable

data HerokuException
    = NotAbleToFetchBearerToken
    | InvalidAuth
    | ErrorInConfigFile
    deriving (Show, Typeable)
instance Exception HerokuException
