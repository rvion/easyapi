{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE RankNTypes                #-}

module Imports.Env where

import           Control.Applicative as X ((<$>))
import           Control.Arrow       as X ((&&&))
import qualified Data.Map            as M

getLocalEnv :: IO (M.Map String String)
getLocalEnv = M.fromList . map split' . lines <$> readFile "ENV"

split' :: String -> (String, String)
split' =
    takeWhile nonEqualChar &&&
    tail . dropWhile nonEqualChar
    where nonEqualChar x = x /= '='
