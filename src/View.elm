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
        div [ class "h-tree-menu" ]
            [ div [ class "ui vertical icon menu", onClick request ]
                [ a [ class style ]
                    [ i [ class "save icon" ]
                        []
                    ]
                ]
            ]

fileItem : Model -> FileItem -> Html Msg
fileItem model file = 
    let 
        style = if model.currentFile.fullName == file.fullName then "item h-file-item h-selected-file"
                else "item h-file-item"
    in
        div [ class style, onClick (GetFileContentRequest file) ]
            [ i [ class "codepen icon" ] []
            , div [ class "content" ]
                    [ div [ class "header" ] [ text (file.name) ]
                    -- , div [ class "description" ] [ text (file.fullName) ]
                    ]
            ]

foldersItem : Model -> Folder -> List(Html Msg)
foldersItem model (Folder ls) = 
    (ls |> List.map (folderItem model))

folderItem : Model -> Structure -> Html Msg
folderItem model str = 
    div [ class "item" ]
        [ i [ class "windows icon" ] []
          , div [ class "content" ]
                [ div [ class "header" ] [ text (str.name) ]
                , div [ class "list"]
                    (List.append
                        (foldersItem model str.folders)
                        (str.files |> List.map (fileItem model))
                    )
                ]
        ]

editorList : Model -> Html Msg
editorList model = 
    let 
        str = model.structure
    in
        div [ class "ui list h-tree" ]
            [ div [ class "item" ]
                [ i [ class "pocket icon" ]
                    []
                , div [ class "content" ]
                    [ div [ class "header" ]
                        [ text (str.name) ]
                    , div [ class "description" ]
                        [ text (str.fullName) ]
                    , div [ class "list" ]
                        (List.append
                            (foldersItem model model.structure.folders)
                            (model.structure.files |> List.map (fileItem model))
                        )
                    ]
                ]
            ]

editorUi : Model -> Html Msg
editorUi model = 
    div [ class "h-tree-wrapper"] 
        [ menu model
        , editorList model ]