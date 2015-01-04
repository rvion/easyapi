{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings  #-}

module API.Auth where

import           API.Prelude         (BS, LBS)
import           Control.Monad.Catch
import           Data.Typeable

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: LBS }
  | NoAuth
  deriving (Show)
-- makeLenses ''Auth


data AuthException 
    = NotAbleToFetchBearerToken
    | InvalidAuth
    deriving (Show, Typeable)
instance Exception AuthException
