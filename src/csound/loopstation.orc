sr=48000
ksmps=64
nchnls=2
nchnls_i=2
0dbfs=1

/* LOOP RECORDING/PLAYBACK CODE */

gktempo init 60
ga_loop_phasor init 0

gi_max_loop_rec_time init 5 * 60  ;; 5 MINUTES LOOP TIME PER LOOP
gi_loop_table_size init gi_max_loop_rec_time * sr

; gi_loop_table_size_power_of_two = pow(2, ceil(log(gi_loop_table_size)/log(2)));

; print gi_loop_table_size_power_of_two

gi_max_loops init 5                ;; NUMBER OF LOOPS TO HOLD IN MEMORY      

/* INITIALIZE LOOP TABLES */

gi_loop_table_numbers[] init (gi_max_loops * 2)

;; Using array to store data regarding each loop
;; data values are:
;; 0 - loop length in samples
;; 1 - bar length for loop buffer (1,2,4,8,16, etc. - negative value denotes free length loop)
gi_loop_table_info[] init (gi_max_loops * 2) 

instr LoopStationInitialize
    indx = 0
    while (indx < gi_max_loops) do

        ;; init memory for stereo audio buffers
        indx1 = indx * 2
        indx2 = indx1 + 1

        gi_loop_table_numbers[indx1] = ftgen(0, 0, -gi_loop_table_size, 2, 0)
        gi_loop_table_numbers[indx2] = ftgen(0, 0, -gi_loop_table_size, 2, 0)

        ;; initialize loob buffer information
        ;; period of 4 bars
        gi_loop_table_info[indx * 2] = (60 / i(gktempo))  * 4 * sr * 4 
        gi_loop_table_info[indx * 2 + 1] = 4 

        indx += 1
    od 
endin

/** PLAYBACK UDO */

opcode loop_buffer_info, ii, i
    ibufnum xin
    inumSamples = gi_loop_table_info[ibufnum * 2]
    inumBars = gi_loop_table_info[ibufnum * 2 + 1]
    xout inumSamples, inumBars
endop

opcode play_loop_buffers, aa, ia 
    ibufnum, aphs xin

    itab1 = gi_loop_table_numbers[ibufnum * 2]
    itab2 = gi_loop_table_numbers[ibufnum * 2 + 1]

    inumSamples, inumBars = loop_buffer_info(ibufnum)
    ; a1 = flooper2:a(1, 1, 0, inumSamples, 0, itab1)
    ; a2 = flooper2:a(1, 1, 0, inumSamples, 0, itab2)

    ; aphs = ga_loop_phasor * (inumSamples / sr)
    ; print inumSamples
    ; a1 mincer aphs, 1, 1, itab1, 1
    ; a2 mincer aphs, 1, 1, itab2, 1

    aphs = ga_loop_phasor * inumSamples
    a1 = table:a(aphs, itab1)
    a2 = table:a(aphs, itab2)

    if((ibufnum + 1) < gi_max_loops) then
       anext1, anext2 play_loop_buffers ibufnum + 1, aphs
       a1 += anext1
       a2 += anext2
    endif
    xout a1, a2
endop

; /** PRIMARY INSTRUMENTS FOR LOOP STATION */

instr LoopPhasor
    ga_loop_phasor = phasor:a(gktempo / 60 / 4) ;; Temporary: use static 4 bar phasor
endin

instr LoopStationPlayer

    a1, a2 play_loop_buffers 0, ga_loop_phasor

    a1 = limit:a(a1, -1, 1)
    a2 = limit:a(a2, -1, 1)
    out(a1, a2)
endin


instr LoopBufferRecord
    ibufnum = p4
    itab1 = gi_loop_table_numbers[ibufnum * 2]
    itab2 = gi_loop_table_numbers[ibufnum * 2 + 1]

    inumSamples, inumBars = loop_buffer_info(ibufnum)

    aphs = ga_loop_phasor * inumSamples

    aenv = linsegr:a(0, 64/sr, 1, p3, 1, 64/sr, 0)
    asig = inch:a(1) * aenv

    out(asig, asig)

    a1 = table:a(aphs, itab1)
    a2 = table:a(aphs, itab2)
    tablew(asig + a1, aphs, itab1)
    tablew(asig + a2, aphs, itab2)
endin


schedule("LoopStationInitialize", 0, -1)
schedule("LoopPhasor", 0, -1)
schedule("LoopStationPlayer", 0, -1)
