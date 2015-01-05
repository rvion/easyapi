{-# LANGUAGE FlexibleContexts #-}
module API.HTTP
  ( module X
  , httpSend
  ) where

import           Network.HTTP.Conduit      as X
import           Network.HTTP.Types.Header as X
import           Network.HTTP.Types.Method as X

import Data.ByteString.Lazy as LBS
import Control.Monad (liftM)
import           Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans.Control (MonadBaseControl)

httpSend :: (MonadIO m, MonadBaseControl IO m) => Request -> m LBS.ByteString
httpSend req = liftM responseBody $ withManager $ httpLbs req
