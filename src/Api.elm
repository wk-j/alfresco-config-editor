module Api exposing (..)

import Json.Encode as Encode
import Json.Decode as Json exposing (string, field, list, lazy, map)
import Http
import Model exposing (..)

host : String
host = ""

headers : List Http.Header
headers = [(Http.header "Content-Type" "application/json")]

saveFileContent : FileContent -> Cmd Msg
saveFileContent fileContent = 
    let 
        url = host ++ "/api/home/saveFileContent"
    in
        Http.send
           SaveFileContentResult
           (Http.request
                { method = "POST" 
                , headers = headers
                , url = url
                , body = encodeSaveRequest fileContent |> Http.jsonBody
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False })

getFileContent : String -> Cmd Msg
getFileContent path =
    let 
        url = host ++ "/api/home/getFileContent"
    in
        Http.send
            GetFileContentResult 
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


encodeSaveRequest : FileContent -> Encode.Value
encodeSaveRequest content = 
    [ ("path", Encode.string content.path)
    , ("content", Encode.string content.content)
    ]
    |> Encode.object


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
