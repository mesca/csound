<CsTest>
description = "a number written into a Complex member of a struct array's element is refused, as = refuses it for a Complex"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to Complex"]
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

struct Phasor z:Complex, level:k

instr 1
 kIndex = 1
 kValue = 5
 zs:Phasor[] init 2
 zs[kIndex].z = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
