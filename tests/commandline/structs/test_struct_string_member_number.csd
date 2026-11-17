<CsTest>
description = "a number written into a string member of a struct array's element is assigned as = assigns it to a string"

[expect]
exit = 0
output = ["every string member checked"]
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
struct Holder inner:Named

strset 5, "five"

opcode Check(SValue:S, SExpected:S, SWhat:S):void
 if strcmpk(SValue, SExpected) != 0 then
  printks("%s: expected %s, got %s\n", 0, SWhat, SExpected, SValue)
  exitnowk(-1)
 endif
endop

instr 1
 kc = timeinstk()
 kIndex = 1
 iFive = 5

 ; what = does for a string variable: the string strset gave the number
 SPlain = 5
 Check(SPlain, "five", "a string variable")

 ; through the element's copy, at an i index
 cs:Named[] init 2
 cs[1].name = 5
 Check(cs[kIndex].name, "five", "a constant at an i index")
 ; in place, at a k index, and a nested member
 is:Named[] init 2
 is[kIndex].name = iFive
 Check(is[kIndex].name, "five", "an i value at a k index")
 hs:Holder[] init 2
 hs[kIndex].inner.name = iFive
 Check(hs[kIndex].inner.name, "five", "a nested member")

 if kc == 3 then
  printks("every string member checked\n", 0)
  turnoff
 endif
endin
</CsInstruments>
<CsScore>
i 1 0 1
e
</CsScore>
</CsoundSynthesizer>
