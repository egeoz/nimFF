# nimFF
Farbfeld Encoder and Decoder written in Nim

### Farbfeld

farbfeld is a lossless image format which is easy to parse, pipe and compress. It has the following format:


| Bytes | Description                             |   |   |   |
|-------|-----------------------------------------|---|---|---|
| 8     | "farbfeld" magic value                  |   |   |   |
| 4     | 32-bit unsigned integer value (width)   |   |   |   |
| 4     | 32-bit unsigned integer value (height)  |   |   |   |
|[2222] | 4x16-bit unsigned integer values (RGBA) |   |   |   |

[More information on the Farbfeld format](https://tools.suckless.org/farbfeld/)

## Basic Usage
An example PNG <=> FF conversion tool can be found in "farbfeld.nim"

```nim
import nimFF

# type
#     Farbfeld* = object
#         header: string
#         width: uint32
#         height: uint32
#         data: seq[uint16]     
        

# proc decodeFarbfeld*(input: string): (uint32, uint32, seq[uint8]) =
let (width, height, imgData) = decodeFarbfeld("image.ff") # Load farbfeld image data into a tuple. "imgData" is of seq[uint8] RGBA values with size of (width * height * 4)

# proc encodeFarbfeld*(width: uint32 | int, height: uint32 | int, data: seq[uint8]): Farbfeld =
let ff = encodeFarbfeld(1920, 1080, imgData) # ff is of type Farbfeld.

# proc ffToPNG*(input, output: string) =
ffToPNG(fileName, output) # Converts "fileName" FF image to "output" PNG.

# proc pngToFF*(input, output: string) =
pngToFF(fileName, output) # Converts "fileName" PNG image to "output" FF.

```

## Usage of farbfeld tool
```
Usage:
  farbfeld [optional-params] [files: string...]
Options:
  -h, --help      Display this help page.
  -v, --version   Show version info.
  -o=, --output=  Specify the output file.
```

```bash
$ ./farbfeld image.ff           # Converts "image.ff" to "image.png".
$ ./farbfeld image.png          # Converts "image.png" to "image.ff"
$ ./farbfeld image.ff -o ../    # Converts "image.ff" to PNG and saves it to the specified path. 
```

## Installation via nimble
```$ nimble install nimFF```