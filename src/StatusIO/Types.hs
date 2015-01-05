{-# LANGUAGE RecordWildCards #-}
module StatusIO.Types where

import Data.Default
import Data.Aeson

type Component = String
type Container = String

-- | state and status incidents codes. Documentation here:
-- http://kb.status.io/developers/status-codes
data IncidentState
    = Investigating -- 100
    | Identified -- 200
    | Monitoring -- 300

instance ToJSON IncidentState where
    toJSON Investigating = toJSON (100 :: Integer)
    toJSON Identified = toJSON (200 :: Integer)
    toJSON Monitoring = toJSON (300 :: Integer)

data IncidentStatus
    = Operational -- 100
    | DegradedPerformance -- 300
    | PartialServiceDisruption -- 400
    | ServiceDisruption -- 500
    | SecurityEvent -- 600

instance ToJSON IncidentStatus where
    toJSON Operational = toJSON (100 :: Integer)
    toJSON DegradedPerformance = toJSON (200 :: Integer)
    toJSON PartialServiceDisruption = toJSON (300 :: Integer)
    toJSON ServiceDisruption = toJSON (500 :: Integer)
    toJSON SecurityEvent = toJSON (600 :: Integer)

-- | Necessary data to create incidents on statusIO
-- http://docs.statusio.apiary.io/#incidents
data IncidentData = IncidentData
    { statuspageId :: String
    , allInfrastructureAffected :: Int
    , components :: [Component]
    , containers :: [Container]
    , incidentName :: String
    , incidentDetails :: String
    , currentStatus :: IncidentStatus
    , currentState :: IncidentState
    }

-- | manual instance to allow extra fields addition,
-- and easy un-camelcasing
instance ToJSON IncidentData where
    toJSON (IncidentData{..}) = object
        [ "statuspage_id" .= statuspageId
        , "all_infrastructure_affected" .= allInfrastructureAffected
        , "components" .= components
        , "containers" .= containers
        , "incident_name" .= incidentName
        , "incident_details" .= incidentDetails
        , "current_status" .= currentStatus
        , "current_state" .= currentState
        -- Below are required fields we always
        -- want to be the same
        , "notify_email" .= (0 :: Integer)
        , "notify_sms" .= (0 :: Integer)
        , "notify_webhook" .= (0 :: Integer)
        , "social" .= (0 :: Integer)
        ]

instance Default IncidentData where
    def = IncidentData
        { statuspageId = ""
        , allInfrastructureAffected = 0
        , components = []
        , containers = []
        , incidentName = ""
        , incidentDetails = ""
        , currentStatus = Operational
        , currentState = Investigating
        }
