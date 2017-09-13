port module Editor exposing (..)

import Model exposing (..)

port setEditorContent : (EditorContent) -> Cmd msg

port receiveEditorContent : (String -> msg) -> Sub msg