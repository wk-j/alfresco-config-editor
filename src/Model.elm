module Model exposing (..)
import Http

type alias Model = 
    { structure : Structure }

type alias FileItem = 
    { name: String
    , fullName: String }

type alias Structure  =
    { name: String
    , fullName: String
    , files: List FileItem
    -- , folders: List Structure
    }

type Msg 
    = GetStructuresResult (Result Http.Error (Structure))
    | GetStructuresRequest String

