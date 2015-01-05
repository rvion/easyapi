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
    { statuspage_id :: String
    , all_infrastructure_affected :: Int
    , components :: [Component]
    , containers :: [Container]
    , incident_name :: String
    , incident_details :: String
    , current_status :: IncidentStatus
    , current_state :: IncidentState
    }

instance ToJSON IncidentData where
    toJSON (IncidentData{..}) = object
        [ "statuspage_id" .= statuspage_id
        , "all_infrastructure_affected" .= all_infrastructure_affected
        , "components" .= components
        , "containers" .= containers
        , "incident_name" .= incident_name
        , "incident_details" .= incident_details
        , "current_status" .= current_status
        , "current_state" .= current_state
        -- Below are required fields we always
        -- want to be the same
        , "notify_email" .= (0 :: Integer)
        , "notify_sms" .= (0 :: Integer)
        , "notify_webhook" .= (0 :: Integer)
        , "social" .= (0 :: Integer)
        ]

instance Default IncidentData where
    def = IncidentData
        { statuspage_id = ""
        , all_infrastructure_affected = 0
        , components = []
        , containers = []
        , incident_name = ""
        , incident_details = ""
        , current_status = Operational
        , current_state = Investigating
        }
