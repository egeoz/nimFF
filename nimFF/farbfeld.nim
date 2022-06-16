import cligen, nimPNG, std/os, strutils, nimFF

clCfg.helpSyntax = ""
clCfg.hTabCols = @[clOptKeys, clDescrip]
clCfg.version = "0.1"

proc farbfeld(files: seq[string], output: string = "") =
    for fileName in files:
        if output != "" and files.len > 1: 
            echo "Only 1 argument can be given with --output.\nSee farbfeld --help for more information."
            quit(1)

        if not fileExists(fileName):
            echo "No such file found."
            quit(1)

        let (path, name, ext) = splitFile(fileName)
        var output = output

        if output == "":
            output = path & "/" & name

            if ext == ".ff":
                ffToPNG(fileName, output & ".png")
            elif ext == ".png":
                pngToFF(fileName, output & ".ff")
            else:
                echo "Not a valid image file."
                quit(1)
        else:
            if output.endsWith("/"): output = output[0 .. output.high]
            if dirExists(output): output &= "/" & name

            if ext == ".ff":
                ffToPNG(fileName, output & ".png")
            elif ext == ".png":
                pngToFF(fileName, output & ".ff")
            else:
                echo "Not a valid image file."
                quit(1)

when isMainModule:
    dispatch(farbfeld, cmdName = "farbfeld", help = {"help": "Display this help page.", "version": "Show version info.", "output": "Specify the output file."}, 
         short = {"version": 'v', "output": 'o'})
