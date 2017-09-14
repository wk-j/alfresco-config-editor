port module Editor exposing (..)

import Model exposing (..)

-- go outside
port setEditorContent : (EditorContent) -> Cmd msg
port showSavingStatus : (String) -> Cmd msg

-- come back
port receiveEditorContent : (String -> msg) -> Sub msg
port receiveSaveEvent : (String -> msg) -> Sub msg