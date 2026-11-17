<CsTest>
description = "a number written into an array member of a struct array's element in place is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to k[], an array member of a struct array's element"]
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

struct Bank values:k[], level:k

instr 1
 kIndex = 1
 kValue = 5
 bs:Bank[] init 2
 bs[kIndex].values = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
