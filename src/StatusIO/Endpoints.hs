{-# LANGUAGE OverloadedStrings #-}

module StatusIO.Endpoints where

import           API.Easy
import           StatusIO.Request

restartDyno :: String -> String -> Auth -> IO Request
restartDyno app dyno = statusIO ("apps/" <> app <>"/dynos/" <> dyno) methodDelete

restartApp :: String -> Auth -> IO Request
restartApp app = statusIO ("apps/" <> app <>"/dynos") methodDelete

fetchDetails :: String -> Auth -> IO Request
fetchDetails app = statusIO ("apps/" <> app) methodGet

fetchDynoList :: String -> Auth -> IO Request
fetchDynoList app = statusIO ("apps/" <> app <> "/dynos") methodGet

fetchAppList :: Auth -> IO Request
fetchAppList = statusIO "apps" methodGet

