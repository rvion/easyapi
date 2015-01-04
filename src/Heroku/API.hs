{-# LANGUAGE OverloadedStrings #-}

module Heroku.API where

import           Heroku.Auth
import           Heroku.Request

import           API.Rest

import           Imports.HTTP
import           Imports.Prelude

restartDyno :: String -> String -> Auth -> IO LBS
restartDyno app dyno = heroku ("apps/" <> app <>"/dynos/" <> dyno) methodDelete

restartApp :: String -> Auth -> IO LBS
restartApp app = heroku ("apps/" <> app <>"/dynos") methodDelete

fetchDetails :: String -> Auth -> IO LBS
fetchDetails app = heroku ("apps/" <> app) methodGet

fetchDynoList :: String -> Auth -> IO LBS
fetchDynoList app = heroku ("apps/" <> app <> "/dynos") methodGet

fetchAppList :: Auth -> IO LBS
fetchAppList = heroku "apps" methodGet

