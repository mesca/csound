<CsTest>
description = "a number written into an f member of a struct array's element is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to f, a member of a struct array's element"]
</CsTest>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0
</CsOptions>
<CsInstruments>
sr = 1000
ksmps = 16
nchnls = 1
0dbfs = 1

struct Spectrum frame:f, level:k

instr 1
 kIndex = 1
 kValue = 5
 ss:Spectrum[] init 2
 ss[kIndex].frame = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
