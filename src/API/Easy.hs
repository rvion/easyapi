
module API.Easy where
import           Control.Monad.Trans.State
import qualified Data.Map       as M

import Heroku.Types

data DB = DB
  { _dBInterface :: ()
  }


type API = StateT DB IO
