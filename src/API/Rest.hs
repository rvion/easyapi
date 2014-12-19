{-# LANGUAGE TemplateHaskell #-}
module API.Rest where

import Data.ByteString.Lazy as LBS
import Data.ByteString.Lazy as BS
import Control.Lens

type LBS = LBS.ByteString
type BS = BS.ByteString

type Token = LBS

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: Token }
  deriving (Show)
makeLenses ''Auth