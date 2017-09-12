module Model exposing (..)
import Http

type alias Model = 
    { structure : Structure }

type alias FileItem = 
    { name: String
    , mode: String
    , fullName: String }

type alias Structure =
        { name: String
        , fullName: String
        , files: List FileItem
        , folders: Folder }

type Folder = Folder (List Structure)

type Msg 
    = GetStructuresRequest String
    | GetStructuresResult (Result Http.Error (Structure))
    | GetFileContentRequest String String
    | GetFileContentResult String (Result Http.Error (String))

