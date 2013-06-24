#! /bin/bash
PATH=${PATH}:${HOME}/apex/lego.ss/phl/l86.ada95.wrk
COLOR="/color ldraw"
NAME="actual"
SHOW="/skip left_right"
TRACE="/trace age /trace mozart /trace imperfections"

generate_roof $COLOR $SHOW $TRACE /w 30 /h 18 /gen 200 /left 000023113200000000 /right 000000000000000004 /out ${NAME}801.ldr
generate_roof $COLOR $SHOW $TRACE /w 16 /h 28 /gen 200 /left 0000000000000000006460000005                 /out ${NAME}802.ldr
generate_roof $COLOR $SHOW $TRACE /w 1 /h 9 /out ${NAME}807.ldr
generate_roof $COLOR $SHOW $TRACE /w 2 /h 1 /out ${NAME}808.ldr
