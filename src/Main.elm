import Html exposing (..)
import Api exposing (..)
import Model exposing (..)
import View exposing (..)
import Editor exposing (..)

main : Program Never Model Msg
main =
    Html.program
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

        GetFileContentRequest editorContent ->
            model
            ! [getFileContent editorContent]

        GetFileContentResult editorContent (Err _) ->
            { model | currentPath = editorContent.path }
            ! [Cmd.none]

        GetFileContentResult mode (Ok content) ->
                model
                ! [ setEditorContent ({ mode | content = content })]

        SaveFileContentRequest request ->
            model
            ! [Cmd.none]

        SaveFileContentResult (Ok str) ->
            model
            ! [Cmd.none]

        SaveFileContentResult (Err str) ->
            model
            ! [Cmd.none]

view : Model -> Html Msg
view model = editorUi model

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
    

emptyModel : Model 
emptyModel = 
    { structure = 
        { name = ""
        , fullName = ""
        , files = []
        , folders = Folder [] }
    , currentPath = "" }

init : (Model, Cmd Msg)
init = 
    emptyModel
    ! [getStructures "/Users/wk/Source/project/alfresco-config-editor"]
