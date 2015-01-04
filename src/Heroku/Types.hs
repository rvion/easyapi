module Heroku.Types where

data App = App
  { appName :: String
  } deriving (Show)

data AppInfo = AppInfo
  { appInfoJson :: String
  } deriving (Show)

data Dyno = Dyno
  { dynoApp
  , dynoName :: String
  } deriving (Show)