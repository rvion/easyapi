module API.Internal.Imports
  ( module API.Internal.Imports
  , module X
  , LBS.toStrict
  ) where

import           Control.Lens              as X

import           Network.HTTP.Conduit      as X
import           Network.HTTP.Types.Header as X
import           Network.HTTP.Types.Method as X

import           Control.Applicative       as X ((<$>), (<*>))
import           Control.Monad             as X (liftM)
import           Data.Monoid               as X ((<>))


-- import   Data.ByteString.Lazy as X (toStrict)
import           Data.ByteString.Lazy      as LBS
import           Data.ByteString      as BS

type LBS = LBS.ByteString
type BS = BS.ByteString
