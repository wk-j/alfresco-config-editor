module Model exposing (..)
import Http

type alias Model = 
    { structure : Structure
    , currentPath : String }

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

type alias EMode = String
type alias EContent = String
type alias EPath = String

--type alias ContentMode = 
--    { mode: String
--    , content: String }

type alias EditorContent =
    { mode: EMode 
    , content: EContent 
    , path: EPath }

type Msg 
    = GetStructuresRequest String
    | GetStructuresResult (Result Http.Error (Structure))
    | GetFileContentRequest EditorContent 
    | GetFileContentResult EditorContent (Result Http.Error (String))
    | SaveFileContentRequest FileContent
    | SaveFileContentResult  (Result Http.Error (String))



