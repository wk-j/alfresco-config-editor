let container = document.getElementById("tree-view");
let app = Elm.Main.embed(container);

function sendSaveEvent() {
    app.ports.receiveSaveEvent.send("")
}

function showSavingStatus() {
    let el = document.getElementById("code-title");
    let title = el.innerText;
    el.innerText = "Saving ..."
    setTimeout(() => {
        el.innerText = title;
    }, 1000);
}

let editor = CodeMirror(document.getElementById("code-editor"), {
    mode: "javascript",
    theme: "seti",
    lineNumbers: true,
    tabSize: 2,
    extraKeys: {
        "Ctrl-S": (cm) => {
            sendSaveEvent()
        },
        "Cmd-S": (cm) => {
            sendSaveEvent()
        }
    }
});

app.ports.showSavingStatus.subscribe((x) => {
    showSavingStatus();
});

app.ports.setEditorContent.subscribe((x) => {
    let content = x.content;
    let mode = x.mode;
    let path = x.path;

    editor.setValue(content);
    editor.setOption("mode", mode);

    document.getElementById("code-title").innerText = path;
});

editor.on('change', function (cMirror) {
    let value = cMirror.getValue();
    app.ports.receiveEditorContent.send(value);
});
