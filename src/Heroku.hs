module Heroku
  ( module Heroku
  , module X
  ) where

import           API.Prelude
import           API.Rest
import           Heroku.Auth
import           Heroku.Eval as X

example :: HerokuDSL AppInfo
example = do
    login "user" "pass"
    connect ["nav-chronos-eu", "nav-bluesky-eu", "test"]
    chronosInfo <- getAppInfo "nav-chronos-eu"
    restartApp "test"
    return chronosInfo

test :: IO ()
test = do
    env <- getLocalEnv
    let auth = Credential
          { _user = pack $ env ^. ix "herokulogin"
          , _pass = pack $ env ^. ix "herokupassword"
          }
    mbToken <- fetchBearerToken auth
    case mbToken of
        Nothing -> error "can't login on heroku"
        Just authToken -> do
            infos <- run authToken example
            print infos
            putStrLn "ok"

main :: IO ()
main = test
