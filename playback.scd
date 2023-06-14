// Execute the following in order
Server.default.boot;
(
var bufferlength = 2.0;
// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * bufferlength, 1); // a four second 1 channel Buffer
Bag.fill(10, { arg i; 100.rand });
)

s.quit;
// record for four seconds
(
SynthDef(RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
	formant = SoundIn.ar(0,1.0);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)

// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
	playbuf = PlayBuf.ar(1,bufnum, 2.rand+0.2, 1.0, 88200.rand); // channels, buffername, rate, trigger (i think we need to use that to trigger from button), startposition (samples)
	playbuf = playbuf ! 2;
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)