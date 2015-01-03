{-# LANGUAGE OverloadedStrings #-}

module Heroku.API where

import           Heroku.Auth
import           Heroku.Protocol

import           API.Rest

import           Data.ByteString.Lazy as LBS
import           Data.Text            as T

import           Imports.Prelude

restartDyno :: String -> String -> Auth -> IO LBS
restartDyno app dyno = heroku ("apps/" <> app <>"/dynos/" <> dyno) methodDelete

herokuRestart :: String -> Auth -> IO LBS
herokuRestart app = heroku ("apps/" <> app <>"/dynos") methodDelete

herokuShowApp :: String -> Auth -> IO LBS
herokuShowApp app = heroku ("apps/" <> app) methodGet

herokuListDynos :: String -> Auth -> IO LBS
herokuListDynos app = heroku ("apps/" <> app <> "/dynos") methodGet

herokuListApps :: Auth -> IO LBS
herokuListApps = heroku "apps" methodGet

