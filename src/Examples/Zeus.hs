{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE PatternSynonyms #-}

module Examples.Zeus where

import Examples.Zeus.Prelude

------- Status --------------------
data ApplicationStatus = ApplicationStatus
  { alive :: Bool
  } deriving (Show)

allGood :: ApplicationStatus
allGood         = ApplicationStatus { alive = True }
pattern AllGood = ApplicationStatus { alive = True }

------- Applications ----------------
class (Show a) => Application a where
  fetchStatus :: a -> IO ApplicationStatus

data Bluesky = Bluesky
  { _blueskyUrl :: String
  , _blueskyPort :: Int
  } deriving (Show)
makeFields ''Bluesky

instance Application Bluesky where
  fetchStatus _ = do
    putStrLn "send request to Bluesky"
    return allGood

data Chronos = Chronos
  { _chronosUrl :: String
  , _chronosPort :: Int
  } deriving (Show)
makeFields ''Chronos

instance Application Chronos where
  fetchStatus _ = do
    putStrLn "send request to chronos"
    return allGood

------- Core ------------------
run :: IO ()
run = forever $ do
  _ <- monitor blueskyProd (statusIO "bluesky-token")
  _ <- monitor chronosProd (statusIO "chronos-token")
  _ <- monitor chronosStaging debug
  threadDelay (15*seconds)
  where seconds = 1000000

chronosProd :: Chronos
chronosProd = Chronos
  { _chronosUrl="chronos.navendis.com"
  , _chronosPort = 80
  }

blueskyProd :: Bluesky
blueskyProd = Bluesky
  { _blueskyUrl="app.navendis.com"
  , _blueskyPort = 80
  }

chronosStaging :: Chronos
chronosStaging = Chronos
  { _chronosUrl="chronos-stage.navendis.com"
  , _chronosPort = 80
  }

------- Monitoring --------------------
monitor :: (Application a) => a -> NotificationStrategy -> IO ApplicationStatus
monitor app notify = do
  print $ "Checking status of " <> show app
  status <- fetchStatus app
  case status of
    AllGood   -> putStrLn "All good :)"
    _ -> notify status
  return status

-------- Notfification strategy ---------
type NotificationStrategy = ApplicationStatus -> IO ()

statusIO :: String -> NotificationStrategy
statusIO _ = print

debug :: NotificationStrategy
debug = print

