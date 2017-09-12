module Model exposing (..)
import Http

type alias Editor = 
    { message : String }

type alias Model = 
    { structure : Structure
    , editor: Editor }

type alias FileItem = 
    { name: String
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
    | GetFileContentRequest String
    | GetFileContentResult (Result Http.Error (String))

