set PATH=%PATH%;C:\Rational\Apex\playground\lego.ss\wnt.ada95.wrk
set COLOR=/color ldraw
set NAME=ldraw
set SHOW=/skip left_right /skip top_bottom /show tees
set TRACE=/trace age /trace mozart
rem generate_wall %COLOR% %SHOW% %TRACE% /w 22 /h 13 /gen 500 /bottom 1344442 /top 61432141 /tee 1 /tee 7                   /out %NAME%1.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 5  /h 14 /bottom 131                                                            /out %NAME%2.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6  /h 3  /bottom 1311 /top 141 /tee 1                                           /out %NAME%3.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 20 /h 10 /top 444413 /corner 8 /tee 1 /tee 7 /tee 9                             /out %NAME%4.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 12 /h 2  /bottom 33312 /top 14124 /corner 8 /tee 1 /tee 7 /tee 9                /out %NAME%5.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6  /h 9  /bottom 123 /top 2211 /corner 2 /tee 1 /tee 3                          /out %NAME%6.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 5  /h 19 /right 0001110001110001110                                             /out %NAME%7.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 3  /h 9  /bottom 12                                                             /out %NAME%8.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 14 /h 2  /top 2121212111 /bottom 12614                                          /out %NAME%9.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 47 /h 19 /gen 5000 /seed 123 /right 0001110001110001110 /corner 22 /corner 24   /out %NAME%10.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 27 /h 19 /gen 5000 /seed 111293 /left 6665554443332221110 /corner 9 /corner 26  /out %NAME%11.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 80 /h 2  /gen 1000 /bottom 231133342221613341423124231113413 /top 2666666636312121212121212111 /corner 9 /corner 26 /corner 55 /corner 57 /out %NAME%12.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 19 /h 23 /left 00011122233344455566677 /right 22222222222222222111000           /out %NAME%13.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 21 /h 1  /bottom 326123121 /corner 18                                           /out %NAME%14.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 57 /h 3  /gen 1000 /bottom  133621331333332163331 /top 3212121212121212123212121212164 /corner 2 /corner 31 /corner 48 /out %NAME%15.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 11 /h 1  /bottom 11111321                                                       /out %NAME%16.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 78 /h 3  /gen 1000 /bottom 1411113213212121212121212113631121212121212121 /top 166666666666632 /corner 17 /corner 21 /corner 46 /corner 53 /tee 17 /tee 20 /tee 22 /tee 45 /tee 52 /tee 54 /out %NAME%17.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6  /h 3                                                                         /out %NAME%18.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 81 /h 3  /gen 1000 /bottom 14311631646323612434123221231 /top 166666666666662 /corner 16 /corner 27 /corner 52 /tee 19 /tee 60 /tee 66 /out %NAME%19.ldr
rem for /L %%i in (20, 1, 24) do generate_wall %COLOR% %SHOW% %TRACE% /w 2 /h 3 /bottom 11 /top 11 /seed %%i /colorseed %%i /out %NAME%%%i.ldr
rem for /L %%i in (25, 1, 29) do generate_wall %COLOR% %SHOW% %TRACE% /w 2 /h 3 /bottom 11 /seed %%i /colorseed %%i         /out %NAME%%%i.ldr
rem for /L %%i in (30, 1, 33) do generate_wall %COLOR% %SHOW% %TRACE% /w 2 /h 3 /top 11 /seed %%i /colorseed %%i            /out %NAME%%%i.ldr
rem for /L %%i in (34, 1, 35) do generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 3 /colorseed %%i                              /out %NAME%%%i.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 14 /colorseed 36                                                           /out %NAME%36.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 11 /colorseed 37                                                           /out %NAME%37.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 8  /colorseed 38                                                           /out %NAME%38.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 2  /colorseed 39                                                           /out %NAME%39.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 9  /colorseed 40                                                           /out %NAME%40.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 26 /h 5 /seed 41 /bottom 14166431 /corner 12 /tee 1 /tee 11 /tee 13 /left 11000 /out %NAME%41.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 30 /h 1  /bottom 126224161122 /corner 24 /parts tiles                           /out %NAME%42.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 78 /h 1  /bottom 12234241141141116216661431621 /corner 13 /corner 24 /corner 49 /parts tiles /out %NAME%43.ldr
generate_wall %COLOR% %SHOW% %TRACE% /w 26 /h 1 /bottom 1131132132422 /corner 12 /parts tiles                          /out %NAME%44.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 25 /colorseed 45                                                           /out %NAME%45.ldr
