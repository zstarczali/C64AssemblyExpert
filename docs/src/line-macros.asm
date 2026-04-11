.const BITMAP_BASE = $2000
.const BITMAP_PLOT_COLOR = $01    // Fehér pontszín a hires bitmap 1-biteihez
.const SINE_CENTER_Y = 140
.const SINE_AMPLITUDE = 30
.const NUM_SHIPS = 6
.const SPRITE_0_COLOR = $03
.const SPRITE_SHIP_DATA = $0C00
.const SPRITE_SHIP_PTR = SPRITE_SHIP_DATA / 64
.const SPRITE_PATH_ANCHOR_X = 12   // A sprite ezen X pontja üljön a szinuszvonalon
.const SPRITE_PATH_ANCHOR_Y = 20   // A sprite ezen Y pontja üljön a szinuszvonalon
.const SPRITE_WRAP_X = 356
.const SPRITE_TRAIL_DASH_STEP = $04
.const SPRITE_TRAIL_RISE_Y = 31
.const SPRITE_TRAIL_LENGTH = 8

// ============================================
// Makró: Bitmap mód bekapcsolása (VIC-II)
// Bitmap módban minden 8x8-as blokk egy bit
// ============================================
.macro EnableBitmapMode() {
    lda $DD00
    and #$FC            // VIC bank bitjeinek törlése
    ora #$03            // VIC bank 0: $0000-$3FFF
    sta $DD00

    lda $D011           // Control Register 1 (jelenlegi érték)
    ora #$20            // OR: BMM bit (5. bit) = Bitmap Mode
    sta $D011           // Bitmap mód engedélyezés
    
    lda $D016           // Control Register 2
    and #$EF            // AND: MCM bit (4. bit) = 0 (multicolor OFF)
    sta $D016           // Normál bitmap mód
    
    // Memória konfiguráció: $D018
    // Bitmap adatok: $2000-$3FFF (default)
    // Screen RAM: $0400 (default, de bitmap módban más a funkció)
    lda #$18            // %00011000: bitmap @ $2000, screen @ $0400
    sta $D018
}

.macro EnableBitmapModeMulticolor() {
    lda $D011
    ora #$20            // BMM: Bitmap Mode
    sta $D011
    
    lda $D016
    ora #$10            // MCM: Multicolor mód
    sta $D016
    
    lda #$18
    sta $D018
}

.macro DisableBitmapMode() {
    lda $D011
    and #$DF            // AND: BMM (5. bit) = 0 (text mód vissza)
    sta $D011
    
    lda $D016
    and #$EF            // MCM OFF
    sta $D016

    lda #$14            // text screen @ $0400, charset @ $1000
    sta $D018
}

// ============================================
// Makró: Bitmap képernyő törlése (nullázása)
// Bitmap terület: $2000-$3FFF (8192 bájt = 8 KB)
// ============================================
.macro ClearBitmapScreen() {
    jsr ClearBitmapScreenRoutine
}

// ============================================
// Makró: Pont kirajzolása hires bitmap módba
// x: 0-319, y: 0-199
// A makró a $2000-es bitmap layoutjára számol címet.
// ============================================
.macro PlotPoint(x, y) {
    lda BITMAP_BASE + ((y >> 3) * 320) + ((x >> 3) * 8) + (y & 7)
    ora #($80 >> (x & 7))
    sta BITMAP_BASE + ((y >> 3) * 320) + ((x >> 3) * 8) + (y & 7)
}

// ============================================
// Makró: Szinuszgörbe kirajzolása PlotPoint-tal
// Középvonal: y=100, amplitúdó: 30 pixel
// A pontok forditási időben generálódnak.
// ============================================
.macro PlotSineWave() {
    jsr PlotSineWaveRoutine
}

// ============================================
// Makró: A szinuszgörbe alatti terület kitöltése
// 2 pixeles oszloppárokkal dolgozik.
// ============================================
.macro FillUnderSineArea() {
    jsr FillUnderSineAreaRoutine
}

// ============================================
// Makró: Űrhajó sprite beállítása
// ============================================
.macro SetupShipSprite() {
    jsr SetupShipSpriteRoutine
}

// ============================================
// Makró: Űrhajó animálása a szinuszgörbén
// ============================================
.macro AnimateShipOnSine() {
    jsr AnimateShipOnSineRoutine
}

// ============================================
// Makró: Várakozás billentyűleütésre
// Kilépéskor A a lenyomott karakter GETIN-kódját tartalmazza.
// ============================================
.macro WaitForKeyPress() {
    jsr WaitForKeyPressRoutine
}

// ============================================
// Makró: Szöveges képernyő kulturált visszaállítása
// Text mód + normál screen/charset + clear screen.
// ============================================
.macro RestoreTextMode() {
    jsr RestoreTextModeRoutine
}

    * = SPRITE_SHIP_DATA "Ship Sprite Data"
ShipSpriteData:
    .byte %00000000, %01111111, %00000000
    .byte %00000001, %11111111, %11000000
    .byte %00000011, %11111111, %11100000
    .byte %00000011, %11100111, %11100000
    .byte %00000111, %11011001, %11110000
    .byte %00000111, %11011111, %11110000
    .byte %00000111, %11011001, %11110000
    .byte %00000011, %11100111, %11100000
    .byte %00000011, %11111111, %11100000
    .byte %00000011, %11111111, %11100000
    .byte %00000010, %11111111, %10100000
    .byte %00000001, %01111111, %01000000
    .byte %00000001, %00111110, %01000000
    .byte %00000000, %10011100, %10000000
    .byte %00000000, %10011100, %10000000
    .byte %00000000, %01001001, %00000000
    .byte %00000000, %01001001, %00000000
    .byte %00000000, %00111110, %00000000
    .byte %00000000, %00111110, %00000000
    .byte %00000000, %00111110, %00000000
    .byte %00000000, %00011100, %00000000
    .byte 0

    * = $4000 "Clear Bitmap Routine"
ClearBitmapScreenRoutine:
    // ZP pointerek: $FB-$FC (bitmap címre)
    lda #$00
    sta $FB
    lda #$20            // $2000 bitmap start
    sta $FC
    
    ldy #0              // Inner counter
    ldx #$20            // 32 oldal = 8192 bájt
    lda #0              // A = 0 (törléshez)
    
clear_loop:
    sta ($FB), y        // Törlés ZP pointeren keresztül
    iny
    bne clear_loop      // Ha Y még nem nulla, folytat
    
    // Következő oldal (page)
    inc $FC             // Inkrementálj magasabb bájt
    dex
    bne clear_loop      // 32 oldal végigmegy, majd kész

    // Hires bitmap módban a screen RAM felső nibble-je adja az 1-bitek színét,
    // az alsó nibble a 0-bitek színét. Így a háttér marad az aktuális D021,
    // a kirajzolt pontok pedig fehérek lesznek.
    lda $D021
    and #$0F
    ora #(BITMAP_PLOT_COLOR << 4)
    ldx #$00

clear_screen_ram:
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne clear_screen_ram
    
    rts

    * = $4100 "Keyboard Routine"
WaitForKeyPressRoutine:
    jsr FlushKeyBufferRoutine

wait_key_loop:
    jsr CheckKeyPressRoutine
    beq wait_key_loop
    rts

FlushKeyBufferRoutine:
flush_key_buffer:
    jsr $FF9F            // SCNKEY
    jsr $FFE4            // GETIN
    bne flush_key_buffer // Dobd ki a pufferben maradt karaktereket
    rts

CheckKeyPressRoutine:
    jsr $FF9F
    jsr $FFE4
    rts

    * = $4200 "Frame Wait Routine"
WaitFrameRoutine:
wait_frame_leave_zero:
    lda $D012
    beq wait_frame_leave_zero
wait_frame_enter_zero:
    lda $D012
    bne wait_frame_enter_zero
    rts

    * = $4300 "Plot Sine Routine"
PlotSineWaveRoutine:
    .for (var x = 0; x < 320; x++) {
        PlotPoint(x, SINE_CENTER_Y + round(SINE_AMPLITUDE * sin((x * 6.283185307179586) / 320.0)))
    }
    rts

    * = $5800 "Sprite Trail Routine"
DrawSpriteTrailRoutine:
    sec
    lda SpritePathLoTable, x
    sbc SpriteInitialPathLoTable, x
    and #SPRITE_TRAIL_DASH_STEP
    bne trail_done

    lda CurrentSpriteY
    cmp #SPRITE_TRAIL_RISE_Y
    bcc trail_done
    sec
    sbc #SPRITE_TRAIL_RISE_Y
    sta TrailPlotY

    lda SpritePathLoTable, x
    sta TrailPlotXLo
    lda SpritePathHiTable, x
    sta TrailPlotXHi

    lda TrailPlotXHi
    beq trail_draw_point
    cmp #$01
    bne trail_done
    lda TrailPlotXLo
    cmp #$40
    bcs trail_done

trail_draw_point:
    jsr SetTrailPointRoutine

trail_done:
    rts

UpdateTrailBufferRoutine:
    ldx CurrentShipIndex
    lda TrailHeadTable, x
    sta TrailBufferIndex

    txa
    asl
    asl
    asl
    clc
    adc TrailBufferIndex
    tay

    lda TrailBufferYTable, y
    cmp #$FF
    beq trail_store_new_point

    lda TrailBufferXLoTable, y
    sta TrailPlotXLo
    lda TrailBufferXHiTable, y
    sta TrailPlotXHi
    lda TrailBufferYTable, y
    sta TrailPlotY
    jsr RestoreTrailPointRoutine

trail_store_new_point:
    lda TrailPlotVisible
    beq trail_store_empty_slot

    lda TrailPlotXLo
    sta TrailBufferXLoTable, y
    lda TrailPlotXHi
    sta TrailBufferXHiTable, y
    lda TrailPlotY
    sta TrailBufferYTable, y
    jsr SetTrailPointRoutine
    jmp trail_advance_buffer

trail_store_empty_slot:
    lda #$FF
    sta TrailBufferYTable, y

trail_advance_buffer:
    ldx CurrentShipIndex
    inc TrailHeadTable, x
    lda TrailHeadTable, x
    cmp #SPRITE_TRAIL_LENGTH
    bcc trail_buffer_done
    lda #$00
    sta TrailHeadTable, x

trail_buffer_done:
    rts

SetTrailPointRoutine:
    jsr PrepareTrailPointRoutine
    ldy #$00
    lda ($FD), y
    ora TrailPlotMask
    sta ($FD), y
    rts

RestoreTrailPointRoutine:
    jsr PrepareTrailPointRoutine

    lda TrailPlotXLo
    lsr
    sta TrailPairIndex
    lda TrailPlotXHi
    beq trail_check_fill
    lda TrailPairIndex
    clc
    adc #128
    sta TrailPairIndex

trail_check_fill:
    ldy TrailPairIndex
    lda TrailPlotY
    cmp FillSinePairYTable, y
    bcs trail_restore_set

    lda #<SineYTable
    clc
    adc TrailPlotXLo
    sta $FB
    lda #>SineYTable
    adc TrailPlotXHi
    sta $FC
    ldy #$00
    lda ($FB), y
    cmp TrailPlotY
    beq trail_restore_set

    lda TrailClearMask
    ldy #$00
    and ($FD), y
    sta ($FD), y
    rts

trail_restore_set:
    ldy #$00
    lda ($FD), y
    ora TrailPlotMask
    sta ($FD), y
    rts

PrepareTrailPointRoutine:
    lda TrailPlotXLo
    and #$F8
    sta TrailByteOffsetLo
    lda TrailPlotXHi
    sta TrailByteOffsetHi

    ldy TrailPlotY
    lda BitmapYBaseLoTable, y
    clc
    adc TrailByteOffsetLo
    sta $FD
    lda BitmapYBaseHiTable, y
    adc TrailByteOffsetHi
    sta $FE

    lda TrailPlotXLo
    and #$07
    tay
    lda PixelMaskTable, y
    sta TrailPlotMask
    lda PixelClearMaskTable, y
    sta TrailClearMask
    rts

    * = $4E00 "Fill Sine Routine"
FillUnderSineAreaRoutine:
    lda #$00
    sta FillPairIndexLo
    sta FillColumnOffsetLo
    sta FillColumnOffsetHi
    lda #$C0
    sta FillPairMask

fill_pair_loop:
    ldx FillPairIndexLo
    lda FillSinePairYTable, x
    sta FillCurrentY

fill_column_loop:
    ldy FillCurrentY
    lda BitmapYBaseLoTable, y
    clc
    adc FillColumnOffsetLo
    sta $FD
    lda BitmapYBaseHiTable, y
    adc FillColumnOffsetHi
    sta $FE

    ldy #$00
    lda ($FD), y
    ora FillPairMask
    sta ($FD), y

    inc FillCurrentY
    lda FillCurrentY
    cmp #200
    bne fill_column_loop

    inc FillPairIndexLo

    lda FillPairMask
    lsr
    lsr
    sta FillPairMask
    bne fill_pair_mask_ok

    lda #$C0
    sta FillPairMask
    clc
    lda FillColumnOffsetLo
    adc #$08
    sta FillColumnOffsetLo
    lda FillColumnOffsetHi
    adc #$00
    sta FillColumnOffsetHi

fill_pair_mask_ok:
    lda FillPairIndexLo
    cmp #160
    bne fill_pair_loop
    rts

    * = $5200 "Sprite Setup Routine"
SetupShipSpriteRoutine:
    ldx #$00

setup_ship_loop:
    lda #SPRITE_SHIP_PTR
    sta $07F8, x

    lda SpriteColorTable, x
    sta $D027, x

    inx
    cpx #NUM_SHIPS
    bne setup_ship_loop

    lda $D015
    and #$C0
    sta $D015

    lda $D017
    and #$C0
    sta $D017

    lda $D01D
    and #$C0
    sta $D01D

    lda $D01C
    and #$C0
    sta $D01C

    lda $D01B
    and #$C0
    sta $D01B

    lda $D010
    and #$C0
    sta $D010

    rts

    * = $5280 "Sprite Sine Routine"
AnimateShipOnSineRoutine:
    jsr FlushKeyBufferRoutine

    ldx #$00

init_ship_positions:
    lda SpriteInitialPathLoTable, x
    sta SpritePathLoTable, x
    lda SpriteInitialPathHiTable, x
    sta SpritePathHiTable, x
    inx
    cpx #NUM_SHIPS
    bne init_ship_positions

animate_ship_loop:
    jsr WaitFrameRoutine
    jsr CheckKeyPressRoutine
    beq animate_continue
    jmp animate_animation_done

animate_continue:

    lda #$00
    sta VisibleMask
    sta MsbMask

    ldx #$00

animate_each_ship:
    clc
    lda SpriteSineTableLoTable, x
    adc SpritePathLoTable, x
    sta $FB
    lda SpriteSineTableHiTable, x
    adc SpritePathHiTable, x
    sta $FC

    ldy #$00
    lda ($FB), y
    sta CurrentSpriteY

    sec
    lda SpritePathLoTable, x
    sbc #SPRITE_PATH_ANCHOR_X
    sta CurrentLeftEdgeLo
    lda SpritePathHiTable, x
    sbc #$00
    sta CurrentLeftEdgeHi

    jsr DrawSpriteTrailRoutine

    lda SpriteXRegisterLoTable, x
    sta $FD
    lda #$D0
    sta $FE
    lda CurrentLeftEdgeLo
    sta ($FD), y

    lda SpriteYRegisterLoTable, x
    sta $FD
    lda CurrentSpriteY
    sta ($FD), y

    lda VisibleMask
    ora SpriteMaskTable, x
    sta VisibleMask

    lda CurrentLeftEdgeHi
    beq animate_advance_ship
    lda MsbMask
    ora SpriteMaskTable, x
    sta MsbMask

animate_advance_ship:
    clc
    lda SpritePathLoTable, x
    adc SpriteSpeedTable, x
    sta SpritePathLoTable, x
    lda SpritePathHiTable, x
    adc #$00
    sta SpritePathHiTable, x

    lda SpritePathHiTable, x
    cmp #>SPRITE_WRAP_X
    bcc animate_next_ship
    bne animate_wrap_ship
    lda SpritePathLoTable, x
    cmp #<SPRITE_WRAP_X
    bcc animate_next_ship

animate_wrap_ship:
    lda #SPRITE_PATH_ANCHOR_X
    sta SpritePathLoTable, x
    lda #$00
    sta SpritePathHiTable, x

animate_next_ship:
    inx
    cpx #NUM_SHIPS
    beq animate_after_ship_loop
    jmp animate_each_ship

animate_after_ship_loop:

    lda $D015
    and #$C0
    ora VisibleMask
    sta $D015

    lda $D010
    and #$C0
    ora MsbMask
    sta $D010
    jmp animate_ship_loop

animate_animation_done:
    rts

    * = $4180 "Restore Text Routine"
RestoreTextModeRoutine:
    lda #$00
    sta $D015
    sta $D010

    lda $D011
    and #$DF            // Bitmap OFF
    sta $D011

    lda $D016
    and #$EF            // Multicolor OFF
    sta $D016

    lda #$14            // text screen @ $0400, charset @ $1000
    sta $D018

    lda #$93            // CHR$(147): clear screen + home
    jsr $FFD2
    rts

    * = $6000 "Sprite Sine Tables"
SpriteSineTable0:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y - 40 - SPRITE_PATH_ANCHOR_Y + round(8  * sin((i * 6.283185307179586) / 320.0))
SpriteSineTable1:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y - 24 - SPRITE_PATH_ANCHOR_Y + round(12 * sin((i * 6.283185307179586) / 320.0))
SpriteSineTable2:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y - 8  - SPRITE_PATH_ANCHOR_Y + round(16 * sin((i * 6.283185307179586) / 320.0))
SpriteSineTable3:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y + 8  - SPRITE_PATH_ANCHOR_Y + round(20 * sin((i * 6.283185307179586) / 320.0))
SpriteSineTable4:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y + 24 - SPRITE_PATH_ANCHOR_Y + round(24 * sin((i * 6.283185307179586) / 320.0))
SpriteSineTable5:
    .fill SPRITE_WRAP_X, SINE_CENTER_Y + 40 - SPRITE_PATH_ANCHOR_Y + round(30 * sin((i * 6.283185307179586) / 320.0))

    * = $6860 "Sprite Animation Variables"
CurrentLeftEdgeLo:
    .byte 0
CurrentLeftEdgeHi:
    .byte 0
SamplePathLo:
    .byte 0
SamplePathHi:
    .byte 0
CurrentSpriteY:
    .byte 0
VisibleMask:
    .byte 0
MsbMask:
    .byte 0
FillPairIndexLo:
    .byte 0
FillCurrentY:
    .byte 0
FillColumnOffsetLo:
    .byte 0
FillColumnOffsetHi:
    .byte 0
FillPairMask:
    .byte 0
TrailPlotXLo:
    .byte 0
TrailPlotXHi:
    .byte 0
TrailPlotY:
    .byte 0
TrailPlotMask:
    .byte 0
TrailClearMask:
    .byte 0
TrailByteOffsetLo:
    .byte 0
TrailByteOffsetHi:
    .byte 0
CurrentShipIndex:
    .byte 0
TrailBufferIndex:
    .byte 0
TrailPairIndex:
    .byte 0
TrailPlotVisible:
    .byte 0

    * = $6880 "Sprite Tables"
PixelMaskTable:
    .byte $80, $40, $20, $10, $08, $04, $02, $01
PixelClearMaskTable:
    .byte $7F, $BF, $DF, $EF, $F7, $FB, $FD, $FE
SpriteColorTable:
    .byte $03, $05, $07, $0A, $0D, $0E
SpriteMaskTable:
    .byte $01, $02, $04, $08, $10, $20
SpriteXRegisterLoTable:
    .byte $00, $02, $04, $06, $08, $0A
SpriteYRegisterLoTable:
    .byte $01, $03, $05, $07, $09, $0B
SpriteSineTableLoTable:
    .byte <SpriteSineTable0, <SpriteSineTable1, <SpriteSineTable2, <SpriteSineTable3, <SpriteSineTable4, <SpriteSineTable5
SpriteSineTableHiTable:
    .byte >SpriteSineTable0, >SpriteSineTable1, >SpriteSineTable2, >SpriteSineTable3, >SpriteSineTable4, >SpriteSineTable5
SpriteInitialPathLoTable:
    .byte 12, 12, 12, 12, 12, 12
SpriteInitialPathHiTable:
    .byte 0, 0, 0, 0, 0, 0
SpriteSpeedTable:
    .byte 1, 2, 1, 3, 2, 3
SpritePathLoTable:
    .byte 0, 0, 0, 0, 0, 0
SpritePathHiTable:
    .byte 0, 0, 0, 0, 0, 0
TrailHeadTable:
    .byte 0, 0, 0, 0, 0, 0

    * = $68E0 "Sprite Trail Buffers"
TrailBufferXLoTable:
    .fill NUM_SHIPS * SPRITE_TRAIL_LENGTH, 0
TrailBufferXHiTable:
    .fill NUM_SHIPS * SPRITE_TRAIL_LENGTH, 0
TrailBufferYTable:
    .fill NUM_SHIPS * SPRITE_TRAIL_LENGTH, $FF

    * = $6980 "Sine Fill Tables"
FillSinePairYTable:
    .fill 160, SINE_CENTER_Y + round(SINE_AMPLITUDE * sin(((i * 2) * 6.283185307179586) / 320.0))

SineYTable:
    .fill 320, SINE_CENTER_Y + round(SINE_AMPLITUDE * sin((i * 6.283185307179586) / 320.0))

BitmapYBaseLoTable:
    .fill 200, <(BITMAP_BASE + ((i >> 3) * 320) + (i & 7))
BitmapYBaseHiTable:
    .fill 200, >(BITMAP_BASE + ((i >> 3) * 320) + (i & 7))

    * = $2000 "Bitmap Data"
    .byte 0  // Placeholder
