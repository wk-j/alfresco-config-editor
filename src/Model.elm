module Model exposing (..)
import Http

type alias Model = 
    { structure : Structure
    , currentFile: FileItem }

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

type alias FileContent = 
    { path: String
    , content: String }

type alias EditorContent = 
    { content: String
    , mode: String }

type Msg 
    = GetStructuresRequest String
    | GetStructuresResult (Result Http.Error (Structure))
    | GetFileContentRequest FileItem
    | GetFileContentResult (Result Http.Error (String))
    | SaveFileContentRequest FileContent
    | SaveFileContentResult  (Result Http.Error (String))



