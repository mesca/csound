<CsTest>
description = "a number written into a w member of a struct array's element is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to w, a member of a struct array's element"]
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

struct Spectrum spec:w, level:k

instr 1
 kIndex = 1
 kValue = 5
 ss:Spectrum[] init 2
 ss[kIndex].spec = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
