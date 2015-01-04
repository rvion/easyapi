{-# LANGUAGE RankNTypes #-}

module API.Prelude
  ( module API.Prelude
  , module X
  ) where

import           Control.Applicative   as X ((<$>), (<*>))
import           Control.Arrow         as X ((&&&))
import           Control.Lens          as X hiding ((.=))
import           Control.Monad         as X (liftM)
import           Data.Aeson            as X
import           Data.Aeson.Lens       as X
import           Data.ByteString.Char8 as X (pack)
import           Data.Maybe            as X (fromMaybe)
import           Data.Monoid           as X ((<>))
import           System.Exit           as X (exitSuccess)
import           Control.Monad.Catch   as X

import qualified Data.ByteString       as BS
import qualified Data.ByteString.Lazy  as LBS
import qualified Data.Map              as M
import           Data.Text             (Text)
import           Data.Text.Encoding    as T

type LBS = LBS.ByteString
type BS = BS.ByteString

(?) :: forall a. Maybe a -> a -> a
mba ? def = fromMaybe def mba

textToLbs :: Text -> LBS.ByteString
textToLbs = LBS.fromStrict . T.encodeUtf8

getEnvfromConfigFile :: IO (M.Map String String)
getEnvfromConfigFile = M.fromList . map split' . lines <$> readFile "ENV"
    where
    split' :: String -> (String, String)
    split' =
        takeWhile nonEqualChar &&&
        tail . dropWhile nonEqualChar
        where nonEqualChar x = x /= '='
