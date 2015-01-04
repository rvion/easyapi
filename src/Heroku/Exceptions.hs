{-# LANGUAGE DeriveDataTypeable #-}
module Heroku.Exceptions where

import           Control.Monad.Catch
import           Data.Typeable

data AuthException 
    = NotAbleToFetchBearerToken
    | InvalidAuth
    deriving (Show, Typeable)
instance Exception AuthException
