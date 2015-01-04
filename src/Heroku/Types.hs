module Heroku.Types where

data Heroku = Heroku deriving (Eq)

type AppName = String
type DynoName = String

data App = App
  { _appName :: AppName
  } deriving (Show)

data DynoInfo = DynoInfo
  { _dynoInfoJson :: String
  } deriving (Show)

data AppInfo = AppInfo
  { _appInfoJson :: String
  } deriving (Show)

data Dyno = Dyno
  { _dynoApp  :: AppName
  , _dynoName :: DynoName
  } deriving (Show)
