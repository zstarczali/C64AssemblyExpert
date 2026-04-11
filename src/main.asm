BasicUpstart2(start)			// <- This creates a basic sys line that can start your program


			* = $1000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling


start:
            lda $01
            sta 53280
            sta 53281

            nop
            nop
            rts
