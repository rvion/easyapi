{-# LANGUAGE OverloadedStrings #-}

module Heroku.Endpoints where

import           API.HTTP
import           API.Prelude
import           Heroku.Request

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

