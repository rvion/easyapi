module Examples.StatusIODemoB where

import API.Easy
import StatusIO.Easy

import Data.Default

main :: IO ()
main = do
    putStrLn "start"
    env <- getEnvfromConfigFile
    putStrLn "Fetching env from file..."
    let mbAuth = do
            user <- pack <$> env ^. at "STATUS_IO_ID"
            pass <- pack <$> env ^. at "STATUS_IO_KEY"
            return Credential { _user =  user, _pass = pass}
    case mbAuth of
        Nothing -> putStrLn "Impossible to fetch auth"
        Just auth -> do
            createIncidentRequest <- createIncident def auth
            rawResp <- httpSend createIncidentRequest
            print rawResp
    putStrLn "end"
