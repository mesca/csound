<CsTest>
description = "a number written into an array member of a struct array's element through the element's copy is refused"

[expect]
exit = "nonzero"
stderr = ["cannot assign c to i[], an array member of a struct array's element"]
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

struct Bank values:i[], level:k

instr 1
 bs:Bank[] init 2
 bs[1].values = 5
endin
</CsInstruments>
<CsScore>
i 1 0 0.1
e
</CsScore>
</CsoundSynthesizer>
