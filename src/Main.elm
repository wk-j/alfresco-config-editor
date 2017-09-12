import Html exposing (..)
import Api exposing (..)
import Model exposing (..)
import View exposing (..)
import Editor exposing (..)
import Debug

main : Program Editor Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetStructuresRequest path ->
            model
            ! [getStructures "/Users/wk/Source/project/alfresco-config-editor"]

        GetStructuresResult (Ok structure) ->
            { model | structure = structure }
            ! [Cmd.none]
        
        GetStructuresResult (Err _) ->
            model
            ! [Cmd.none]

        GetFileContentRequest path ->
            model
            ! [getFileContent path]

        GetFileContentResult (Err _) ->
            model
            ! [Cmd.none]

        GetFileContentResult (Ok content) ->
                model
                ! [setValue content]

view : Model -> Html Msg
view model = editorUi model

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

emptyModel : Editor -> Model 
emptyModel editor = 
    let 
        _ = Debug.log ">> " editor.message 
    in
        { structure = 
            { name = ""
            , fullName = ""
            , files = []
            , folders = Folder [] }
        , editor = editor }

init : Editor -> (Model, Cmd Msg)
init editor = 
    emptyModel editor
    ! [getStructures "/Users/wk/Source/project/alfresco-config-editor"]