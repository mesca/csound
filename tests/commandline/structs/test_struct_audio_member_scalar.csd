<CsTest>
description = "a number written into an audio member of a struct array's element fills its block, as = fills an audio variable"

[expect]
exit = 0
output = ["every audio member checked", "a first statement checked"]
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

struct ABox sig:a, level:k
struct Holder inner:ABox
gfs@global:ABox[] init 2

; every sample of the block, not only the first
opcode CheckBlock(aSig:a, kExpected:k, SWhat:S):void
 samples:k[] = aSig
 kn = 0
 while kn < lenarray(samples) do
  if samples[kn] != kExpected then
   printf("%s: sample %d expected %g, got %g\n", 1, SWhat, kn, kExpected,
          samples[kn])
   exitnowk(-1)
  endif
  kn += 1
 od
endop

instr 1
 kc = timeinstk()
 kIndex = 1
 iValue = 0.25

 ; what = does for an audio variable and a plain struct's member
 aPlain = kc
 CheckBlock(aPlain, kc, "an audio variable")
 box:ABox init
 box.sig = kc
 CheckBlock(box.sig, kc, "a plain struct's member")

 ; written in place, at an i and at a k index
 cs:ABox[] init 2
 cs[1].sig = 1
 CheckBlock(cs[kIndex].sig, 1, "a constant at an i index")
 ks:ABox[] init 2
 ks[kIndex].sig = kc
 CheckBlock(ks[kIndex].sig, kc, "a k value at a k index")
 is:ABox[] init 2
 is[1].sig = iValue
 CheckBlock(is[kIndex].sig, iValue, "an i value at an i index")
 es:ABox[] init 2
 es[kIndex].sig = kc * 2
 CheckBlock(es[kIndex].sig, kc * 2, "an expression at a k index")
 hs:Holder[] init 2
 hs[1].inner.sig = kc
 CheckBlock(hs[kIndex].inner.sig, kc, "a nested member")

 ; through the element's copy: an i index read from an array at a k index
 slots:i[] fillarray 0, 1
 kSlot = 1
 ps:ABox[] init 2
 ps[slots[kSlot]].sig = kc
 CheckBlock(ps[kIndex].sig, kc, "a member written through the element's copy")

 ; a function is called in its audio form, as aSig = linseg(...) calls it
 aLine = linseg:a(0, 1, 1000)
 ls:ABox[] init 2
 ls[kIndex].sig = linseg(0, 1, 1000)
 CheckBlock(ls[kIndex].sig - aLine, 0, "a function's audio form")
 ; one with no audio form, or written with a type of its own, is called
 ; in that form, and its value fills the block
 ts:ABox[] init 2
 ts[kIndex].sig = timeinstk()
 CheckBlock(ts[kIndex].sig, kc, "a function with no audio form")
 kStep = linseg:k(0, 1, 1000)
 ss:ABox[] init 2
 ss[kIndex].sig = linseg:k(0, 1, 1000)
 CheckBlock(ss[kIndex].sig, kStep, "a function written with a type of its own")

 ; an audio value is copied as it was
 aRamp = linseg:a(0, 1, 1000)
 vs:ABox[] init 2
 vs[kIndex].sig = aRamp
 CheckBlock(vs[kIndex].sig - aRamp, 0, "an audio value")

 if kc == 4 then
  printks("every audio member checked\n", 0)
  turnoff
 endif
endin

; the number goes into its block when the write is an instrument's first
; statement too
instr 2
 gfs[1].sig = 0.5
 kIndex = 1
 CheckBlock(gfs[kIndex].sig, 0.5, "the first statement of an instrument")
 printks("a first statement checked\n", 0)
 turnoff
endin
</CsInstruments>
<CsScore>
i 1 0 1
i 2 0 1
e
</CsScore>
</CsoundSynthesizer>
