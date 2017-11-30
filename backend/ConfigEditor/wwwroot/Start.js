let container = document.getElementById("tree-view");
let app = Elm.Main.embed(container);

function smooth() {
    // Scroll to specific values
    // scrollTo is the same
    window.scroll({
        top: 2500,
        left: 0,
        behavior: "smooth"
    });

    // Scroll certain amounts from current position 
    window.scrollBy({
        top: 100, // could be negative value
        left: 0,
        behavior: "smooth"
    });

    // Scroll to a certain element
    document.querySelector(".CodeMirror").scrollIntoView({
        behavior: "smooth"
    });

    document.querySelector("#tree-view").scrollIntoView({
        behavior: "smooth"
    });
}

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


smooth();