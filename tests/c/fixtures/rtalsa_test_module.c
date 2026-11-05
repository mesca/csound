/*
  rtalsa_test_module.c:

  InOut/rtalsa.c's raw MIDI and devfile readers on bytes a test gives them:
  snd_rawmidi_read is a stand-in that reads them, and the devfile is a
  pipe they are written to. No device is opened.
*/

/* Before ALSA's header, so its declaration is the stand-in's too. */
#define snd_rawmidi_read csound_test_snd_rawmidi_read
#include <alsa/asoundlib.h>
#include <string.h>
#include <unistd.h>

/* libcsound, or another module, defines these too */
#define csoundModuleCreate csound_test_rtalsa_module_create
#define csoundModuleInit csound_test_rtalsa_module_init
#define csoundModuleDestroy csound_test_rtalsa_module_destroy
#define csoundModuleInfo csound_test_rtalsa_module_info
#define listDevices csound_test_rtalsa_list_devices
#define strNcpy csound_test_rtalsa_strncpy
#include "../../../InOut/rtalsa.c"

static const unsigned char *feed;
static size_t feed_len, feed_pos;

ssize_t snd_rawmidi_read(snd_rawmidi_t *rmidi, void *buffer, size_t size)
{
    size_t n = feed_len - feed_pos;
    (void) rmidi;
    if (n > size)
      n = size;
    memcpy(buffer, feed + feed_pos, n);
    feed_pos += n;
    return (ssize_t) n;
}

/* The bytes the raw MIDI reader - or, `file` set, the devfile reader -
   gives Csound for the bytes `in`, read from a device opened afresh;
   -1 if the pipe cannot be made. */
int32_t csound_test_rtalsa_read(int32_t file, const unsigned char *in,
                                int32_t inlen, unsigned char *out,
                                int32_t outlen)
{
    int32_t n;
    if (!file) {
      alsaMidiInputDevice dev;
      memset(&dev, 0, sizeof(dev));
      dev.dev = (snd_rawmidi_t *) &dev;  /* any device: the read is ours */
      feed = in;
      feed_len = (size_t) inlen;
      feed_pos = 0;
      return midi_in_read(NULL, &dev, out, outlen);
    }
    else {
      midiDevFile dev;
      int fds[2];
      if (pipe(fds) != 0)
        return -1;
      if (write(fds[1], in, (size_t) inlen) != (ssize_t) inlen) {
        close(fds[0]);
        close(fds[1]);
        return -1;
      }
      close(fds[1]);
      memset(&dev, 0, sizeof(dev));
      dev.fd = fds[0];
      n = midi_in_read_file(NULL, &dev, out, outlen);
      close(fds[0]);
      return n;
    }
}
