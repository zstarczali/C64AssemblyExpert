BasicUpstart2(start)			// <- This creates a basic sys line that can start your program

.import source "line-macros.asm"

			* = $1000 "Main Program"		// <- The name 'Main program' will appear in the memory map when assembling


start:          
            EnableBitmapMode()          // Grafikus módra váltás
            ClearBitmapScreen()         // Képernyő törlése
            FillUnderSineArea()
            PlotSineWave()
            SetupShipSprite()
            AnimateShipOnSine()
            RestoreTextMode()           // Vissza BASIC text képernyőre
            rts
