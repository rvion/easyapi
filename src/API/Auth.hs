module API.Auth where

import           API.Prelude         (BS, LBS)

data Auth
  = Credential {_user, _pass :: BS }
  | Token {_token :: LBS }
  | NoAuth
  deriving (Show)
-- makeLenses ''Auth