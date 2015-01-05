{-# LANGUAGE OverloadedStrings #-}

module StatusIO.Endpoints where

import           API.Easy
import           StatusIO.Request
import           StatusIO.Types

createIncident :: IncidentData -> Auth -> IO Request
createIncident incidentData = statusIO "incident/create" methodPost
    (Just $ RequestBodyLBS $ encode incidentData)
