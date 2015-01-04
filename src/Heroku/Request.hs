module Heroku.Request
  ( module Heroku.Request
  ) where

import           API.Rest        as X
import           API.HTTP

heroku :: String -> Method -> Auth -> IO LBS
heroku = apiWrapper "https://api.heroku.com/"
