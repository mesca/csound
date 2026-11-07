<CsTest>
description = "k values cross an oversampled UDO on time, held through its local k-periods"

[expect]
exit = 0
</CsTest>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 1
0dbfs = 1

gkPassed init 0
gkLocalMisreads init 0
gkChecked init 0

opcode Pass(value:k, factor:i, mode:i):k
  oversample(factor, mode)
  if value != gkPassed then
    gkLocalMisreads += 1
  endif
  result:k = value
  xout(result)
endop

; The local cycle count goes out: the caller must get the last of each group.
opcode LocalPeriod(factor:i, mode:i):k
  oversample(factor, mode)
  period:k = timeinstk()
  xout(period)
endop

; Classic, with xin before the rate, for an output that is also the input.
opcode Increment, k, kii
  kValue, iFactor, iMode xin
  oversample iFactor, iMode
  xout kValue + 1
endop

opcode PassArray(values:k[], factor:i, mode:i):k[]
  oversample(factor, mode)
  results:k[] = values * 2
  xout(results)
endop

opcode IncrementArray, k[], k[]ii
  kValues[], iFactor, iMode xin
  oversample iFactor, iMode
  kResults[] = kValues + 1
  xout kResults
endop

instr Check
  iFactor = p4
  iMode = p5
  kPeriod = timeinstk()

  ; Starts at 1, for the first k-period, and steps at the hundredth.
  kPassed = kPeriod < 100 ? 1 : 0
  gkPassed = kPassed
  kReturned = Pass(kPassed, iFactor, iMode)
  if kReturned != kPassed || gkLocalMisreads != 0 then
    printks "factor %g, mode %g, k-period %g: passed %g, returned %g, misread %g times\n", \
      0, iFactor, iMode, kPeriod, kPassed, kReturned, gkLocalMisreads
    exitnowk -1
  endif

  kLocal = LocalPeriod(iFactor, iMode)
  if kLocal != kPeriod * iFactor then
    printks "factor %g, mode %g, k-period %g: returned local k-period %g\n", \
      0, iFactor, iMode, kPeriod, kLocal
    exitnowk -1
  endif

  kCount init 0
  kCount Increment kCount, iFactor, iMode
  if kCount != kPeriod then
    printks "factor %g, mode %g, k-period %g: count %g\n", \
      0, iFactor, iMode, kPeriod, kCount
    exitnowk -1
  endif

  kArray[] init 2
  kArray[0] = kPassed
  kArray[1] = 1 - kPassed
  kDoubled[] = PassArray(kArray, iFactor, iMode)
  if kDoubled[0] != 2 * kPassed || kDoubled[1] != 2 - 2 * kPassed then
    printks "factor %g, mode %g, k-period %g: passed %g, %g, returned %g, %g\n", \
      0, iFactor, iMode, kPeriod, kArray[0], kArray[1], kDoubled[0], kDoubled[1]
    exitnowk -1
  endif

  ; Unlike a scalar's init, this does not clear a reused instance's array.
  kCounts[] init 2
  if kPeriod == 1 then
    kCounts[0] = 0
    kCounts[1] = 0
  endif
  kCounts IncrementArray kCounts, iFactor, iMode
  if kCounts[0] != kPeriod || kCounts[1] != kPeriod then
    printks "factor %g, mode %g, k-period %g: counts %g, %g\n", \
      0, iFactor, iMode, kPeriod, kCounts[0], kCounts[1]
    exitnowk -1
  endif

  gkChecked += 1
endin

instr CheckResults
  ; Ten notes of 150 k-periods.
  if i(gkChecked) != 1500 then
    prints "Expected 1500 k-periods checked, got %g\n", i(gkChecked)
    exitnow -1
  endif
endin
</CsInstruments>
<CsScore>
; Every converter, sinc to linear, at two factors.
i "Check" 0 0.2 2 0
i "Check" + . 2 1
i "Check" + . 2 2
i "Check" + . 2 3
i "Check" + . 2 4
i "Check" + . 4 0
i "Check" + . 4 1
i "Check" + . 4 2
i "Check" + . 4 3
i "Check" + . 4 4
i "CheckResults" 2 0.1
e
</CsScore>
</CsoundSynthesizer>
