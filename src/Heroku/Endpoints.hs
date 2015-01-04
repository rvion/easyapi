{-# LANGUAGE OverloadedStrings #-}

module Heroku.Endpoints where

import           API.HTTP
import           API.Prelude
import           API.Auth
import           Heroku.Request

restartDyno :: String -> String -> Auth -> IO Request
restartDyno app dyno = heroku ("apps/" <> app <>"/dynos/" <> dyno) methodDelete

restartApp :: String -> Auth -> IO Request
restartApp app = heroku ("apps/" <> app <>"/dynos") methodDelete

fetchDetails :: String -> Auth -> IO Request
fetchDetails app = heroku ("apps/" <> app) methodGet

fetchDynoList :: String -> Auth -> IO Request
fetchDynoList app = heroku ("apps/" <> app <> "/dynos") methodGet

fetchAppList :: Auth -> IO Request
fetchAppList = heroku "apps" methodGet

