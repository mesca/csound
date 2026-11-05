/*
  rtalsa_midi_test.cpp:

  The ALSA raw MIDI and devfile readers (InOut/rtalsa.c) pass a Song
  Position Pointer with its two data bytes, as they pass a channel
  message: they dropped it. It keeps no running status, and cancels any,
  as a system common message does. Song Select and the MTC quarter frame
  are still dropped.

  The readers run on bytes the test gives them
  (fixtures/rtalsa_test_module.c), so no MIDI hardware is required.

  The test is only compiled when the rtalsa plugin target exists.
*/

#include "gtest/gtest.h"

#if defined(CSOUND_TEST_RTALSA)

#include <cstdint>
#include <string>

extern "C" {
int32_t csound_test_rtalsa_read(int32_t, const unsigned char *, int32_t,
                                unsigned char *, int32_t);
}

namespace {

using Bytes = std::basic_string<unsigned char>;

Bytes read(bool file, const Bytes &in) {
  unsigned char out[64];
  int32_t n = csound_test_rtalsa_read(file ? 1 : 0, in.data(),
                                      static_cast<int32_t>(in.size()), out,
                                      static_cast<int32_t>(sizeof(out)));
  return n < 0 ? Bytes() : Bytes(out, static_cast<size_t>(n));
}

struct Case {
  const char *what;
  Bytes in, out;
};

TEST(RtalsaMidiReaders, PassASongPosition) {
  const Case cases[] = {
      {"a note, a song position, a clock and a note",
       {0x90, 60, 100, 0xF2, 0x10, 0x01, 0xF8, 0x90, 62, 64},
       {0x90, 60, 100, 0xF2, 0x10, 0x01, 0xF8, 0x90, 62, 64}},
      {"running status, then a song position",
       {0x90, 60, 100, 62, 64, 0xF2, 0x05, 0x00},
       {0x90, 60, 100, 0x90, 62, 64, 0xF2, 0x05, 0x00}},
      {"a clock inside a song position",
       {0xF2, 0x10, 0xF8, 0x01},
       {0xF8, 0xF2, 0x10, 0x01}},
      {"no running status after a song position, nor after a sysex",
       {0xF2, 0x10, 0x01, 0x05, 0x06, 0xF0, 0x7E, 0xF7, 0x07, 0x08},
       {0xF2, 0x10, 0x01}},
      {"song select and the quarter frame dropped",
       {0xF3, 0x02, 0xF1, 0x10, 0xC0, 5},
       {0xC0, 5}},
  };
  for (bool file : {false, true})
    for (const auto &c : cases)
      EXPECT_EQ(read(file, c.in), c.out)
          << c.what << (file ? " (devfile)" : " (raw)");
}

}  // namespace

#endif
