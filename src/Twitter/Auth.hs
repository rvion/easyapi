{-# LANGUAGE OverloadedStrings   #-}

module Twitter.Auth where

import           Twitter.Request

import           Imports.Prelude--           hiding ((.=))
import           Imports.HTTP

authenticate key pass = do
    -- let reqBody = RequestBodyLBS $ encode $ 
    --       object ["grant_type" .= ("client_credentials" :: String)]
    -- print $ encode $ object ["grant_type" .= ("client_credentials" :: String)]
    let reqBody = RequestBodyLBS "grant_type=client_credentials"
    resp <- tweeter "/oauth2/token" methodPost reqBody (Credential key pass)
    -- let tok = resp ^. undefined
    -- return $ Token tok
    print resp

auth = Token "xxx"
