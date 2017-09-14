module Main exposing (..)
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
    , subscriptions = subscriptions
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GetStructuresRequest path ->
      model
        ! [ getStructures "/Users/wk/Source/project/alfresco-config-editor" ]

    GetStructuresResult (Ok structure) ->
      { model | structure = structure }
        ! [ Cmd.none ]

    GetStructuresResult (Err _) ->
      model
        ! [ Cmd.none ]

    GetFileContentRequest item ->
      { model | currentFile = item }
        ! [ getFileContent item.fullName ]

    GetFileContentResult (Err _) ->
      model
        ! [ Cmd.none ]

    GetFileContentResult (Ok content) ->
      { model | currentContent = "" }
        ! [ setEditorContent ({ mode = model.currentFile.mode, content = content, path = model.currentFile.fullName }) ]

    SaveFileContentRequest request ->
      { model | saving = True }
        ! [ showSavingStatus ""
          , saveFileContent request ]

    SaveFileContentResult (Ok str) ->
      { model | saving = False }
        ! [ Cmd.none ]

    SaveFileContentResult (Err str) ->
      { model | saving = False }
        ! [ Cmd.none ]

    ReceiveEditorContent content ->
      { model | currentContent = content }
        ! [ Cmd.none ]

    ReceiveSaveEvent _ ->
      model
      ! [ showSavingStatus ""
        , saveFileContent  { path = model.currentFile.fullName, content = model.currentContent } ]

view : Model -> Html Msg
view model =
  editorUi model

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ receiveEditorContent ReceiveEditorContent
    , receiveSaveEvent ReceiveSaveEvent
    ]


emptyModel : Model
emptyModel =
  { structure =
      { name = ""
      , fullName = ""
      , files = []
      , folders = Folder []
      }
  , currentContent = ""
  , saving = False
  , currentFile = { mode = "", fullName = "", name = "" }
  }


init : ( Model, Cmd Msg )
init =
  emptyModel
    ! [ getStructures "/Users/wk/Source/project/alfresco-config-editor" ]

