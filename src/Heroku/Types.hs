module Heroku.Types where

data Heroku = Heroku deriving (Eq)

type AppName = String
type DynoName = String

data DynoInfo = DynoInfo
  { _dynoInfoJson :: String
  } deriving (Show)

data HerokuAppInfo = AppInfo
  { _herokuAppInfoJson :: String
  } deriving (Show)
