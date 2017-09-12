module Api exposing (..)

import Json.Encode as Encode
import Json.Decode as Json exposing (string, field, list, lazy, map)
import Http
import Model exposing (..)

host : String
host = "http://localhost:5000"

getFileContent : String -> String -> Cmd Msg
getFileContent mode path =
    let 
        url = host ++ "/api/home/getFileContent"
    in
        Http.send
            (GetFileContentResult mode)
            (Http.request
                { method = "POST"
                , headers = [(Http.header "Content-Type" "application/json")]
                , url = url
                , body = encodeRequest path |>  Http.jsonBody
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False })

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
    Json.map3 FileItem
        (field "name" string)
        (field "mode" string)
        (field "fullName" string)

decodeStructure : Json.Decoder Structure
decodeStructure =
     Json.map4 Structure
         (field "name" string)
         (field "fullName" string)
         (field "files"  (list decodeFile))
         (field "folders" (map Folder (list (lazy (\_ -> decodeStructure)))))
