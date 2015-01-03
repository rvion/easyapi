module Heroku.Request
  ( module X
  , module Heroku.Request
  ) where

import           API.Rest        as X

import           Imports.HTTP
import           Imports.Prelude

heroku :: String -> Method -> Auth -> IO LBS
heroku = apiWrapper "https://api.heroku.com/"
