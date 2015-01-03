{-# LANGUAGE RankNTypes #-}
module Imports
  ( module Imports
  , module X
  ) where

import           Control.Lens              as X hiding ((.=))

import           Network.HTTP.Conduit      as X
import           Network.HTTP.Types.Header as X
import           Network.HTTP.Types.Method as X

import           Control.Applicative       as X ((<$>), (<*>))
import           Control.Monad             as X (liftM)
import           Data.Aeson                as X
import           Data.Maybe                (fromMaybe)
import           Data.Monoid               as X ((<>))

(?) :: forall a. Maybe a -> a -> a
mba ? def = fromMaybe def mba -- case mba of

--    Just a -> a
--    Nothing -> def
