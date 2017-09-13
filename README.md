## Alfresco Config Editor

## Development

```bash
# create project
elm-package install elm-lang/http

# build
elm-make src/Index.elm --output=dist/main.js

# watch
watchman-make -p 'src/*.elm' --make='elm-make src/Main.elm --output=backend/ConfigEditor/wwwroot/dist/Main.js' -t ""

# run
./build.sh --target Watch-Run
```