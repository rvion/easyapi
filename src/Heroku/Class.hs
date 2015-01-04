module Heroku.Class where

class CanHeroku m where
    loginM :: String -> String -> m ()
    
instance CanHeroku IO where
    loginM _ _ = print "unimplemented loginM"

