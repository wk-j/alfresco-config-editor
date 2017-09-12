module View exposing (..)

import Model exposing (..)
import Html exposing (..)

import Html.Attributes exposing (..)

ui : Model -> Html Msg
ui model = 
    div [] [text "Hello"]