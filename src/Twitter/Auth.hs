{-# LANGUAGE OverloadedStrings   #-}

module Twitter.Auth where

import           Twitter.Request

-- import           API.Prelude--           hiding ((.=))
import           API.HTTP
import API.Prelude
authenticate :: BS -> BS -> IO ()
authenticate twitterKey pass = do
    -- let reqBody = RequestBodyLBS $ encode $ 
    --       object ["grant_type" .= ("client_credentials" :: String)]
    -- print $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    let reqBody = RequestBodyLBS "grant_type=client_credentials"
    resp <- tweeter "/oauth2/token" methodPost reqBody (Credential twitterKey pass)
    -- let tok = resp ^. undefined
    -- return $ Token tok
    print resp

auth :: Auth
auth = Token "xxx"

