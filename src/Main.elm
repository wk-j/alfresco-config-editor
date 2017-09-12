import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Api exposing (..)
import Model exposing (..)
import View exposing (..)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetStructuresRequest path ->
            model
            ! [getStructures "/Users/wk/Source/project/alfresco-config-editor"]

        GetStructuresResult (Ok structure) ->
            (model, Cmd.none)
        
        GetStructuresResult (Err _) ->
            (model, Cmd.none)

view : Model -> Html Msg
view model = ui model

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

emptyModel : { structure : { files : List a, fullName : String, name : String } }
emptyModel = 
    { structure = 
        { name = ""
        , fullName = ""
        , files = []
    }}

init : (Model, Cmd Msg)
init = 
    emptyModel
    ! [getStructures "/Users/wk/Source/project/alfresco-config-editor"]
