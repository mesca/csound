<CsTest>
description = "a number written into a boolean member of a struct array's element, and a boolean into a number member, are assigned as = assigns them"

[expect]
exit = 0
output = ["every number and boolean member checked"]
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

struct Flagged on:B, level:k, count:i, ready:b
; pitch is a p, as a member without a type takes its name's first letter
struct Note pitch, amp:k
gbChanged@global:b init 1

opcode Check(kValue:k, kExpected:k, SWhat:S):void
 if kValue != kExpected then
  printks("%s: expected %g, got %g\n", 0, SWhat, kExpected, kValue)
  exitnowk(-1)
 endif
endop

instr 1
 kc = timeinstk()
 kIndex = 1
 bFlag:B = kc > 1

 ; what = does for a boolean and a number variable
 bPlain:B = kc + 0.5
 Check(bPlain ? 1 : 0, 1, "a boolean variable")
 kPlain = bFlag
 Check(kPlain, kc > 1 ? 1 : 0, "a number variable")

 ; a number into a boolean member, at an i and at a k index
 is:Flagged[] init 2
 is[1].on = kc + 0.5
 Check(is[kIndex].on ? 1 : 0, 1, "a k into a boolean member at an i index")
 kOnNumber = is[kIndex].on
 Check(kOnNumber, 1, "the boolean member read as a number")
 cs:Flagged[] init 2
 cs[kIndex].on = 1
 Check(cs[kIndex].on ? 1 : 0, 1, "a constant into a boolean member at a k index")
 kOnConstant = cs[kIndex].on
 Check(kOnConstant, 1, "the boolean member read as a number, after a constant")
 ; a boolean into a number member
 ks:Flagged[] init 2
 ks[kIndex].level = bFlag
 Check(ks[kIndex].level, kc > 1 ? 1 : 0, "a boolean into a number member")
 ; an audio value into a number member is its first sample, as on
 ; develop, and as kPlain = aSig takes it
 aRamp = linseg:a(1, 1, 1001)
 kFromAudio = aRamp
 as:Flagged[] init 2
 as[kIndex].level = aRamp
 Check(as[kIndex].level, kFromAudio, "an audio value into a number member")
 ; and so is an audio function's, which has no k form
 aTone = tone(aRamp, 100)
 kToneFirst = aTone
 ts:Flagged[] init 2
 ts[kIndex].level = tone(aRamp, 100)
 Check(ts[kIndex].level, kToneFirst, "an audio function into a number member")

 ; an i and a b member, written in performance at a k index, take an
 ; audio value and a boolean as a k does, and a k as a B does
 ns:Flagged[] init 2
 ns[kIndex].count = aRamp
 Check(ns[kIndex].count, kFromAudio, "an audio value into an i member at a k index")
 ns[kIndex].count = bFlag
 Check(ns[kIndex].count, kc > 1 ? 1 : 0, "a boolean into an i member at a k index")
 ns[kIndex].ready = kc + 0.5
 Check(ns[kIndex].ready ? 1 : 0, 1, "a k into a b member at a k index")
 ; an i member read at a k index is a k, which goes into a b member as a B
 rs:Flagged[] init 2
 rs[kIndex].count = kc - 1
 qs:Flagged[] init 2
 qs[kIndex].ready = rs[kIndex].count
 Check(qs[kIndex].ready ? 1 : 0, kc > 1 ? 1 : 0, "an i member read at a k index into a b member")

 ; a b, which `=` gives an i at init only, is the value it had then,
 ; as iPlain = gbChanged keeps it when another note changes it
 iPlain = gbChanged
 gs:Flagged[] init 2
 gs[kIndex].count = gbChanged
 Check(gs[kIndex].count, iPlain, "a b into an i member at a k index, as at init")

 ; a p member takes a number as an i member does, and a boolean as a k
 ps:Note[] init 2
 ps[kIndex].pitch = 60
 Check(ps[kIndex].pitch, 60, "a constant into a p member at a k index")
 ps[kIndex].pitch = bFlag
 Check(ps[kIndex].pitch, kc > 1 ? 1 : 0, "a boolean into a p member at a k index")

 if kc == 3 then
  printks("every number and boolean member checked\n", 0)
  turnoff
 endif
endin

; changes the b instr 1 writes, after instr 1's init
instr 2
 gbChanged = 1 < 0
endin
</CsInstruments>
<CsScore>
i 1 0 1
i 2 0.015 0.01
e
</CsScore>
</CsoundSynthesizer>
