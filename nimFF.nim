import binarylang, nimFF/endians2, nimPNG, std/streams

const MAGIC_HEADER = "farbfeld"
var height, width: uint32

struct(ffImg):
    s: magicHeader(8)
    u32: width
    u32: height
    u16: ffImgData[width * height * 4]

type 
    PNGPix = seq[uint8]

type
    Farbfeld* = object
        header: string
        width: uint32
        height: uint32
        data: seq[uint16]     
        
proc decodeFarbfeld*(input: string): (uint32, uint32, seq[uint8]) =
    var fstream = newFileBitStream(input)
    defer: close(fstream)

    let imgData = ffImg.get(fstream)
    if imgData.magicHeader != MAGIC_HEADER:
        stderr.write("Not a valid farbfeld file.")
        quit(1)

    var ffImgData = newSeq[uint8](imgData.ffImgData.len)

    for i in countup(0, ffImgData.len - 1):
        ffImgData[i] = uint8(imgData.ffImgData[i] div 257)

    return (imgData.width, imgData.height, ffImgData)

proc encodeFarbfeld*(width: uint32 | int, height: uint32 | int, data: seq[uint8]): Farbfeld =
    var ffData = newSeq[uint16](data.len)

    for i in countup(0, data.len - 1):
        ffData[i] = uint16(data[i]) * 257 

    return Farbfeld(header: MAGIC_HEADER,
                    width: uint32(width).toBE,
                    height: uint32(height).toBE,
                    data: ffData)

proc ffToPNG*(input, output: string) =
    let (width, height, rgbaData) = decodeFarbfeld(input)
    discard savePNG32(output, rgbaData, int(width), int(height))

proc pngToFF*(input, output: string) =
    var pngData: PNGResult[PNGPix]
    let res = loadPNG32(PNGPix, input)

    pngData = res.get()

    height = uint32(pngData.height)
    width = uint32(pngData.width)

    var fstream = newFileStream(output, fmWrite)
    var ff = encodeFarbfeld(width, height, pngData.data)

    if not isNil(fstream):
        fstream.write(ff.header)
        fstream.write(ff.width)
        fstream.write(ff.height)

        for i in countup(0, ff.data.len - 1):
            fstream.write(ff.data[i])  

        fstream.close()
