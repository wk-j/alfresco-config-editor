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

    let notMatchDir(info: DirectoryInfo) = 
        let names = [
            ".git"
            "node_modules"
            "java"
            "webapps"
            "libreoffice.app"
            "common"
            "elm-stuff"
            "bin"
            "obj"
        ]
        names.All <| Func<_,_>(info.Name.Contains >> not)

    let matchFileName (info: FileInfo) = 
        let format = [
            ".json"
            //".js"
            //".html"
            ".properties"
            ".ts"
            ".elm"
            ".cs"
            ".fs"
            ".md"
            ".xml"
            ".fsproj"
            ".css"
        ]
        format.Any <| Func<_,_>(info.Name.EndsWith)


    let findMode ext = 
        match ext with
        | ".js" | ".jsx" -> "javascript"
        | ".ts" | ".tsx" -> "typescript"
        | ".css" -> "css"
        | ".properties" -> "properties"
        | ".csproj" | ".fsproj" | "xml" -> "xml"
        | ".json" -> "json"
        | ".fs" | ".fsx" -> "fsharp"
        | ".cs" | ".csx" -> "csharp"
        | ".html" -> "htmlmixed"
        | ".elm" -> "elm"
        | ".md" -> "markdown"
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

    [<HttpPost>]
    member this.GetStructures([<FromBody>] req: Query) = 
        let path = 
            let p = System.Environment.GetEnvironmentVariable("ALFRESCO_HOME")
            if Directory.Exists p then p
            else req.Path

        if req.Path = "/" then
            Folder(Name="</>")
        elif Directory.Exists path then
            let str = Folder()
            query str path
        else
            Folder(Name="<Empty>")

    [<HttpPost>]
    member this.GetFileContent([<FromBody>] req: Query) = 
        if File.Exists req.Path then
            File.ReadAllText req.Path
        else
            "-- error --"

    [<HttpPost>]
    member this.SaveFileContent([<FromBody>] req: SaveFileRequest) = 
        if File.Exists req.Path then
            if req.Content = errorContent then
                { Success = false; Message = "Invalid content"}
            else
                File.WriteAllText(req.Path, req.Content) 
                { Success = true; Message = "" }
        else
            { Success = false; Message = "File not exist" }