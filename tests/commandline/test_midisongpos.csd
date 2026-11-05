<CsTest>
description = "midisongpos reports a Song Position Pointer on the k-cycle it comes"

[expect]
exit = 0
</CsTest>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0 -F songpos.mid
</CsOptions>
<CsInstruments>
sr = 1000
ksmps = 1
nchnls = 1

gkHeard init 0
gkFirst init -1
gkLast init -1
gkBefore init -1

; The flag on each k-cycle a Song Position Pointer came, and the position,
; in sixteenths, held from the last one.
instr Read
  kHeard, kPosition midisongpos
  if kHeard == 1 then
    gkHeard = gkHeard + 1
    if gkFirst == -1 then
      gkFirst = kPosition
    endif
    gkLast = kPosition
  elseif gkHeard == 0 then
    gkBefore = kPosition
  endif
endin

instr Check
  if i(gkHeard) != 2 || i(gkFirst) != 144 || i(gkLast) != 5 || i(gkBefore) != 0 then
    prints "heard %d, first %d, last %d, before any %d\n", \
           i(gkHeard), i(gkFirst), i(gkLast), i(gkBefore)
    exitnow -1
  endif
endin
</CsInstruments>
<CsScore>
; Song positions 144 (0x10, 0x01) at 0.25 s and 5 at 0.5 s.
i "Read" 0 1
i "Check" 1 0
</CsScore>
<CsFileB filename="songpos.mid">
TVRoZAAAAAYAAAABAeBNVHJrAAAAD4Fw8hABgXDyBQCBcP8vAA==
</CsFileB>
</CsoundSynthesizer>
