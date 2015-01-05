module StatusIO.Class where
import           API.Auth

class StatusIOM (m :: * -> * )where
    statusIOAuth :: m Auth

