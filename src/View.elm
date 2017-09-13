module View exposing (..)

import Model exposing (..)
import Html exposing (..)

import Html.Attributes exposing (..)
import Html.Events exposing (..)

buttons_ : Html msg
buttons_ = 
    div [ class "ui small basic icon buttons" ]
        [ button [ class "ui button active" ]
            [ i [ class "save icon" ] []
            ]
        , button [ class "ui button" ]
            [ i [ class "download icon" ] []
            ]
        ]


fileItem : FileItem -> Html Msg
fileItem file = 
    div [ class "item c-file-item", onClick (GetFileContentRequest { mode = file.mode, path = file.fullName, content = ""}) ]
        [ i [ class "file outline icon" ] []
          , div [ class "content" ]
                [ div [ class "header" ] [ text (file.name) ]
                -- , div [ class "description" ] [ text (file.fullName) ]
                ]
        ]

foldersItem : Folder -> List(Html Msg)
foldersItem (Folder ls) = 
    (ls |> List.map folderItem)

folderItem : Structure -> Html Msg
folderItem str = 
    div [ class "item" ]
        [ i [ class "folder icon" ] []
          , div [ class "content" ]
                [ div [ class "header" ] [ text (str.name) ]
                , div [ class "list"]
                    (List.append
                        (foldersItem str.folders)
                        (str.files |> List.map fileItem)
                    )
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
                        (List.append
                            (foldersItem model.structure.folders)
                            (model.structure.files |> List.map fileItem)
                        )
                    ]
                ]
            ]

editorUi : Model -> Html Msg
editorUi model = 
    div [] 
        [ buttons_
        , editorList model ]