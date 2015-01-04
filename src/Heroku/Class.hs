module Heroku.Class where

import           API.Auth

class HerokuM (m :: * -> * )where
    herokuAuth :: m Auth

