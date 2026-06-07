## Guards the zero-dependency `chroma/colortypes` surface (see request 2026-06-07).
## 1. Compile-time: colortypes.nim must stay import-free (no import/from/include).
## 2. Runtime: the narrow surface stands alone and exposes the symbols consumers use.
import std/strutils
import chroma/colortypes

const src = staticRead("../src/chroma/colortypes.nim")
static:
  var lineNo = 0
  for raw in src.splitLines():
    inc lineNo
    let line = raw.strip()
    if line.startsWith("import ") or line.startsWith("from ") or
       line.startsWith("include ") or line == "import" or line == "include":
      raise newException(Defect,
        "colortypes.nim must remain import-free (zero-dep surface); line " &
        $lineNo & ": " & raw)

let c = rgbx(255, 128, 0, 255)
doAssert (c.r, c.g, c.b, c.a) == (255'u8, 128'u8, 0'u8, 255'u8)
let x: ColorRGBX = rgbx(0, 0, 0, 0)
doAssert x.a == 0
echo "zerodep guard OK"
