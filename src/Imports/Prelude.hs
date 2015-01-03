{-# LANGUAGE RankNTypes #-}
module Imports.Prelude
  ( module Imports.Prelude
  , module X
  ) where

import           Control.Lens              as X hiding ((.=))
import           Data.Aeson.Lens           as X

import           Network.HTTP.Conduit      as X
import           Network.HTTP.Types.Header as X
import           Network.HTTP.Types.Method as X

import           Control.Applicative       as X ((<$>), (<*>))
import           Control.Monad             as X (liftM)
import           Data.Aeson                as X
import           Data.Maybe                (fromMaybe)
import           Data.Monoid               as X ((<>))

import           Data.ByteString.Lazy as LBS
import           Data.Text            (Text)
import           Data.Text.Encoding   as T


(?) :: forall a. Maybe a -> a -> a
mba ? def = fromMaybe def mba

textToLbs :: Text -> LBS.ByteString
textToLbs = LBS.fromStrict . T.encodeUtf8
