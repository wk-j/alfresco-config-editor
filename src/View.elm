module View exposing (..)

import Model exposing (..)
import Html exposing (..)

import Html.Attributes exposing (..)

editorFileItem : FileItem -> Html Msg
editorFileItem file = 
    div [ class "item" ]
        [ i [ class "file outline icon" ] []
          , div [ class "content" ]
                [ div [ class "header" ] [ text (file.name) ]
                , div [ class "description" ] [ text (file.fullName) ]
                ]
        ]

editorList : Model -> Html Msg
editorList model = 
    let 
        str = model.structure
    in
        div [ class "ui list" ]
            [ div [ class "item" ]
                [ i [ class "folder icon" ]
                    []
                , div [ class "content" ]
                    [ div [ class "header" ]
                        [ text (str.name) ]
                    , div [ class "description" ]
                        [ text (str.fullName) ]
                    , div [ class "list" ]
                        (model.structure.files |> List.map editorFileItem)
                    ]
                ]
            ]

editorUi : Model -> Html Msg
editorUi model = 
    div [] [ editorList model ]