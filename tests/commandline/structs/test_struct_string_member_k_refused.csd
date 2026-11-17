<CsTest>
description = "a k written into a string member of a struct array's element is refused, as = refuses it for a string"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to S"]
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

struct Named name:S, level:k

instr 1
 kIndex = 1
 kValue = 5
 ns:Named[] init 2
 ns[kIndex].name = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
