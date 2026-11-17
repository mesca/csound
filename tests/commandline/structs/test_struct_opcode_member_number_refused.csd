<CsTest>
description = "a number written into an Opcode member of a struct array's element is refused, as = refuses it for an Opcode"

[expect]
exit = "nonzero"
stderr = ["cannot assign k to Opcode"]
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

struct Handler op:Opcode, level:k

instr 1
 kIndex = 1
 kValue = 5
 hs:Handler[] init 2
 hs[kIndex].op = kValue
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
