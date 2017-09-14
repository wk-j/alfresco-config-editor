namespace ConfigEditor.Controllers

open System
open System.Collections.Generic
open System.Linq
open System.Threading.Tasks
open Microsoft.AspNetCore.Mvc
open System.IO
open System.Collections.Generic
open System.Linq

type Query = {
    Path: string
}

type File() = 
    member val Name = "" with set,get
    member val FullName = "" with set,get
    member val Mode = "xml" with set,get

type Folder() = 
    member val Name = "" with set,get
    member val FullName = "" with set,get
    member val Folders = Enumerable.Empty<Folder>() with set,get
    member val Files = Enumerable.Empty<File>()  with set,get


type SaveFileRequest = {
    Path: string
    Content: string
}

type Result = {
    Success: bool
    Message: string
}

type HomeController () =
    inherit Controller()

    let errorContent = "-- error --"

    let root = 
            let p = System.Environment.GetEnvironmentVariable("ALFRESCO_HOME")
            if Directory.Exists p then p
            else DirectoryInfo(".").FullName

    let notMatchDir(info: DirectoryInfo) = 
        let names = [
            ".git"
            "node_modules"
            "java"
            "imagemagick"
            "libreoffice"
            "webapps"
            "libreoffice.app"
            "uninstall.app"
            "common"
            "elm-stuff"
            "alf_data"
            "Application Manager.app"
            "solr4"
            // "bin"
            "obj"
        ]
        names.All <| Func<_,_>(info.Name.Contains >> not)

    let matchFileName (info: FileInfo) = 
        let format = [
            ".json"
            //".js"
            //".html"
            ".properties"
            //".ts"
            ".elm"
            //".cs"
            ".bat"
            ".sh"
            ".fs"
            ".md"
            ".ps1"
            ".bat"
            ".xml"
            ".fsproj"
        ]
        format.Any <| Func<_,_>(info.Name.EndsWith)

    let findMode ext = 
        match ext with
        | ".js" | ".jsx" -> "javascript"
        | ".ts" | ".tsx" -> "typescript"
        | ".sh" | ".bat" -> "shell"
        | ".css" -> "css"
        | ".properties" -> "properties"
        | ".csproj" | ".fsproj" | "xml" -> "xml"
        | ".json" -> "json"
        | ".fs" | ".fsx" -> "fsharp"
        | ".cs" | ".csx" -> "csharp"
        | ".html" -> "htmlmixed"
        | ".elm" -> "elm"
        | ".md" -> "markdown"
        | ".ps1" -> "x-powershell"
        | _ -> "xml"
    
    let rec query (str: Folder) path = 
        let dir = DirectoryInfo path
        let dirs = 
            dir.GetDirectories() 
            |> Array.filter(notMatchDir)

        let files  = 
            dir.GetFiles()
            |> Array.filter(matchFileName)

        str.Folders <- 
            [ for item in dirs do
                yield query (Folder()) item.FullName ]
            |> List.filter(fun x -> x.Files.Count() > 0 || x.Folders.Count() > 0)

        str.Name <- dir.Name
        str.FullName <- dir.FullName
        str.Files <- files.Select(fun x -> File(Name = x.Name, FullName = x.FullName, Mode = findMode (Path.GetExtension x.FullName)) ).ToList()
        (str)

    member private this.IsFileUnderRoot(path: string) = 
        let file = FileInfo(path).FullName
        file.Contains root

    member private this.IsFolderUnderRoot(path: string) = 
        let folder = DirectoryInfo(path).FullName
        folder.Contains root

    [<HttpPost>]
    member this.GetStructures([<FromBody>] req: Query) = 
        let path = root
        if req.Path = "/" then
            Folder(Name="</>")
        elif Directory.Exists path then
            let str = Folder()
            query str path
        else
            Folder(Name="<Empty>")

    [<HttpPost>]
    member this.GetFileContent([<FromBody>] req: Query) = 
        if this.IsFileUnderRoot req.Path then
            if File.Exists req.Path then
                File.ReadAllText req.Path
            else
                "-- error --"
        else
            "-- error --"

    [<HttpPost>]
    member this.SaveFileContent([<FromBody>] req: SaveFileRequest) = 
        if this.IsFileUnderRoot req.Path then
            if File.Exists req.Path then
                if req.Content = errorContent then
                    { Success = false; Message = "Invalid content"}
                else
                    File.WriteAllText(req.Path, req.Content) 
                    { Success = true; Message = "" }
            else
                { Success = false; Message = "File not exist" }
        else
            { Success = false; Message = "No way" }