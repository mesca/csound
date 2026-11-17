<CsTest>
description = "an audio value written into an a[] member of a struct array's element is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign a to a[], an array member of a struct array's element"]
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

struct Bus sigs:a[], level:k

instr 1
 kIndex = 1
 aSig = linseg:a(0, 1, 1000)
 bs:Bus[] init 2
 bs[kIndex].sigs = aSig
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
