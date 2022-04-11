// Record into loop 0
schedule(nstrnum("LoopBufferRecord"), 0, -1, 0)
// Stop recording loop 0
schedule(-nstrnum("LoopBufferRecord"), 0, 0, 0)

// LOOP 1 
schedule(nstrnum("LoopBufferRecord"), 0, -1, 1)
schedule(-nstrnum("LoopBufferRecord"), 0, 0, 1)

// LOOP 2 
schedule(nstrnum("LoopBufferRecord"), 0, -1, 2)
schedule(-nstrnum("LoopBufferRecord"), 0, 0, 2)

// LOOP 3 
schedule(nstrnum("LoopBufferRecord"), 0, -1, 3)
schedule(-nstrnum("LoopBufferRecord"), 0, 0, 3)

// LOOP 4 
schedule(nstrnum("LoopBufferRecord"), 0, -1, 4)
schedule(-nstrnum("LoopBufferRecord"), 0, 0, 4)