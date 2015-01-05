module Heroku.Auth where

import           API.Easy
import           Heroku.Request
import           Heroku.Exceptions

-- | This function transform Auth into bearer token as mention in heroku doc
fetchBearerToken :: Auth -> IO Auth
fetchBearerToken auth = do
  putStrLn "fetching auth token"
  case auth of
      NoAuth -> return NoAuth
      Token _ -> return auth
      Credential _ _ -> do
          response <- heroku "oauth/authorizations" methodPost auth >>= httpSend
          let token = fmap (Token . textToLbs) $
                response ^? key "access_token" . key "token" . _String
          case token of
            Nothing -> throwM NotAbleToFetchBearerToken
            Just tok -> return tok
