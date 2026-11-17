<CsTest>
description = "an audio value written into a two-dimensional k[][] member of a struct array's element is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign a to k[][], an array member of a struct array's element"]
</CsTest>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0
</CsOptions>
<CsInstruments>
sr = 1000
ksmps = 10
nchnls = 1
0dbfs = 1

struct Grid cells:k[][], level:k

instr 1
 kIndex = 1
 aSig = linseg:a(0, 1, 1000)
 gs:Grid[] init 2
 gs[kIndex].cells = aSig
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
