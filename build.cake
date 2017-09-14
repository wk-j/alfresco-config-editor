Action<string,string, string> ps = (cmd, args, project) => {
    var fullDir = System.IO.Path.GetDirectoryName(project);
    StartProcess(cmd, new ProcessSettings {
        Arguments = args,
        WorkingDirectory = fullDir
    });
};

Task("Watch-Run").Does(() => {
     ps("dotnet", "watch run", "backend/ConfigEditor/ConfigEditor.fsproj");
});

Task("Create-Zip").Does(() => {
    Zip("dist/Windows-10", "dist/Windows-10.zip");
    Zip("dist/Windows-8", "dist/Windows-8.zip");;
    Zip("dist/Mac", "dist/Mac.zip");
    Zip("dist/Linux", "dist/Linux.zip");
});

var target = Argument("target", "default");
RunTarget(target);
