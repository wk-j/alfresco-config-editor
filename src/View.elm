module View exposing (..)

import Model exposing (..)
import Html exposing (..)

import Html.Attributes exposing (..)
import Html.Events exposing (..)


menu : Model -> Html Msg
menu model =
    let 
        style = if model.currentContent == "" || model.saving then "item disabled"
              else "item"
        request = SaveFileContentRequest { path = model.currentFile.fullName, content = model.currentContent }
    in
        div []
            [div [ class "ui vertical icon menu floated right", onClick request ]
                [ a [ class style ]
                    [ i [ class "pencil icon" ]
                        []
                    ]
                ]
            ]

fileItem : FileItem -> Html Msg
fileItem file = 
    div [ class "item c-file-item", onClick (GetFileContentRequest file) ]
        [ i [ class "codepen icon" ] []
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
        [ i [ class "windows icon" ] []
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
                [ i [ class "windows icon" ]
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
        [ menu model
        , editorList model ]