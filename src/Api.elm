module Api exposing (..)

import Json.Encode as Encode
import Json.Decode as Json exposing (string, field, list)
import Http

host : String
host = "http://localhost:"

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

getStructures : String -> Cmd Msg
getStructures path = 
    let 
        url = host ++ "/api/home/getStructures"
    in
        Http.send
            GetStructuresResult
            (Http.request
                { method = "POST"
                , headers = [(Http.header "Content-Type" "application/json")]
                , url = url
                , body = encodeRequest path |>  Http.jsonBody
                , expect = Http.expectJson decodeStructure
                , timeout = Nothing
                , withCredentials = False })

encodeRequest : String -> Encode.Value
encodeRequest path = 
    [("path", Encode.string path)]
    |> Encode.object

decodeFile : Json.Decoder FileItem
decodeFile = 
    Json.map2 FileItem
        (field "name" string)
        (field "fullName" string)

decodeStructure : Json.Decoder Structure
decodeStructure =
    Json.map3 Structure
        (field "name" string)
        (field "fullName" string)
        (field "files"  (list decodeFile))
        -- (field "folders" (list ))

