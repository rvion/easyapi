module Examples.StatusIODemo where

import API.Easy
import StatusIO.Easy

import Data.Default

main :: IO ()
main = do
    putStrLn "start"
    env <- getEnvfromConfigFile
    putStrLn "Fetching env from file..."
    let pageID = env ^. ix "STATUS_IO_PAGE_ID"
        chronosComponent = env ^. ix "STATUS_IO_CHRONOS_COMPONENT"
        chronosContainer = env ^. ix "STATUS_IO_HEROKU_EU_CONTAINER"
        mbAuth = do
            user <- pack <$> env ^. at "STATUS_IO_ID"
            pass <- pack <$> env ^. at "STATUS_IO_KEY"
            return Credential { _user =  user, _pass = pass}
    case mbAuth of
        Nothing -> putStrLn "incorrect\
            \STATUS_IO_ID and STATUS_IO_KEY env variables"
        Just auth -> do
            putStrLn "auth loaded"
            let chronosApp = def
                    { statuspageId = pageID
                    , components = [chronosComponent]
                    , containers = [chronosContainer]
                    , incidentName = "zeus alpha test incident"
                    , incidentDetails = "zeus alpha test incident"
                    }
            createIncidentRequest <- createIncident chronosApp auth
            print createIncidentRequest
            putStrLn "sending request"
            rawResp <- httpSend createIncidentRequest
            print rawResp
    putStrLn "end"
