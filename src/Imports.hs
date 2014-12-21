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
import           Data.Monoid               as X ((<>))

import Data.Aeson as X

mba ? def = case mba of
    Just a -> a
    Nothing -> def