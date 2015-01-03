{-# LANGUAGE NoMonomorphismRestriction #-}

module Imports.Env where

import           Control.Applicative   as X ((<$>))
import           Control.Arrow         as X ((&&&))
import           Control.Lens          as X
import           Data.ByteString.Char8 as X (pack)
import           Data.Map              as X (Map (..))
import           System.Environment    as X (getEnv)

import qualified Data.Map              as M

atIndex = ix
getLocalEnv = M.fromList . map split . lines <$> readFile "ENV"
split = takeWhile nonEqualChar &&& tail . dropWhile nonEqualChar
  where nonEqualChar x = x /= '='
