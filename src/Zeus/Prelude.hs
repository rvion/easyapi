module Zeus.Prelude
  ( module Zeus.Prelude
  , module X
  ) where

import           Data.Foldable              as X (forM_)
import           Data.Maybe                 as X (fromMaybe)
import           Data.Monoid                as X ((<>))

import           Control.Lens               as X

import           System.Directory           as X (getCurrentDirectory)
import           System.Environment         as X (lookupEnv)

import           Control.Applicative        as X ((<$>), (<*>))
import           Control.Concurrent         as X (threadDelay)
import           Control.Monad              as X (forever, liftM)
import           Control.Monad.State.Lazy   as X (lift)

import qualified Data.ByteString            as BS
import qualified Data.ByteString.Lazy       as LBS
import qualified Data.ByteString.Lazy.Char8 as LBS8
import           Data.Text                  as X (Text)
import qualified Data.Text.Encoding         as T

type LBS = LBS.ByteString
type BS = BS.ByteString

waitForever :: IO ()
waitForever = forever $ threadDelay maxBound

textToLbs :: Text -> LBS
textToLbs = LBS.fromStrict . T.encodeUtf8

lbsToText :: LBS -> Text
lbsToText = T.decodeUtf8 . LBS.toStrict

strToLbs :: String -> LBS
strToLbs = LBS8.pack
