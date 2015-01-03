module Heroku.Protocol where

import API.Rest
import Imports.Prelude


heroku :: String -> Method -> Auth -> IO LBS
heroku = apiWrapper "https://api.heroku.com/"
