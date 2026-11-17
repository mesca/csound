<CsTest>
description = "a string written into a number member of a struct array's element is refused, as = refuses it for a number"

[expect]
exit = "nonzero"
stderr = ["cannot assign S to k"]
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

struct Flagged on:B, level:k

instr 1
 kIndex = 1
 fs:Flagged[] init 2
 fs[kIndex].level = "loud"
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
