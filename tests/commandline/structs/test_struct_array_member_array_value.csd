<CsTest>
description = "an array, or an expression giving one, written into an array member of a struct array's element is copied as it was, and an audio value made an array as = makes it"

[expect]
exit = 0
output = ["every array member checked"]
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

opcode Check(kValue:k, kExpected:k, SWhat:S):void
 if kValue != kExpected then
  printks("%s: expected %g, got %g\n", 0, SWhat, kExpected, kValue)
  exitnowk(-1)
 endif
endop

instr 1
 kc = timeinstk()
 kIndex = 1
 kArr[] fillarray 1, 2

 vs:Bank[] init 2
 vs[kIndex].values = kArr
 Check(vs[kIndex].values[1], 2, "an array variable")
 es:Bank[] init 2
 es[kIndex].values = kArr * kc
 Check(es[kIndex].values[1], 2 * kc, "an array expression")
 ; an audio value becomes an array of its block, as kArr = aSig makes it
 aRamp = linseg:a(1, 1, 1001)
 kSamples:k[] = aRamp
 as:Bank[] init 2
 as[kIndex].values = aRamp
 Check(as[kIndex].values[0], kSamples[0], "an audio value's first sample")
 Check(as[kIndex].values[9], kSamples[9], "an audio value's last sample")

 if kc == 3 then
  printks("every array member checked\n", 0)
  turnoff
 endif
endin
</CsInstruments>
<CsScore>
i 1 0 1
e
</CsScore>
</CsoundSynthesizer>
