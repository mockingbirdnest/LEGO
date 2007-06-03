set PATH=%PATH%;C:\Rational\Apex\playground\lego.ss\wnt.ada95.wrk
set COLOR=/color ldraw
set NAME=ldraw
set SHOW=/skip left_right /skip top_bottom /show tees
rem set SHOW=/show top_bottom
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
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 9  /colorseed 41                                                           /out %NAME%40.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 26 /h 5 /seed 41 /bottom 14166431 /corner 12 /tee 1 /tee 11 /tee 13 /left 11000 /out %NAME%41.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 30 /h 1 /bottom 126224161122 /corner 24 /parts tiles                            /out %NAME%42.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 74 /h 1 /seed 43000 /bottom 134241141141116216661431621 /corner 9 /corner 20 /corner 45 /parts tiles /out %NAME%43.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 27 /h 1 /bottom 11131132132422 /corner 13 /parts tiles                          /out %NAME%44.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 25 /colorseed 45                                                           /out %NAME%45.ldr

rem generate_wall %COLOR% %SHOW% %TRACE% /w 27 /h 1 /bottom 1221144264 /corner 15 /colorseed 201 /parts plates_2xn          /out %NAME%201.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 66 /h 1 /seed 202 /bottom 22211444212121426126141141121 /corner 30 /corner 55 /colorseed 202 /parts plates_2xn /out %NAME%202.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 27 /h 6 /bottom 44443111221 /top 341316423 /corner 15 /tee 14 /tee 16           /out %NAME%203.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 3 /h 17 /bottom 21                                                              /out %NAME%204.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6 /h 14 /bottom 1212 /corner 3 /tee 2 /tee 4                                    /out %NAME%205.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 5 /h 13 /bottom 32                                                              /out %NAME%206.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6 /h 18 /tee 4 /right 555444333222111000                                        /out %NAME%207.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 8 /h 1 /bottom 2411 /colorseed 892                                              /out %NAME%208.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 74 /h 6 /gen 1000 /seed 2090 /left 011122 /bottom 12232422313361212214332222211441 /top 666666631443623411 /corner 9 /corner 20 /corner 45 /tee 19 /tee 21 /tee 44 /tee 46 /tee 59 /out %NAME%209.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 43 /h 2 /left 01 /bottom 62411321642133211 /top 34416663226 /corner 7 /corner 18 /tee 17 /tee 19 /out %NAME%210.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6 /h 11 /left 00111222333 /bottom 1311 /top 2211                                /out %NAME%211.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 21 /h 3 /bottom 14316231 /corner 6 /tee 5 /tee 7                                /out %NAME%212.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 6 /h 3 /bottom 321                                                              /out %NAME%213.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 4 /h 20 /left 00000000000000111111 /right 00000000000000111111 /bottom 31       /out %NAME%214.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 5 /h 20 /left 00000000000000111111 /right 00000000000000111111 /bottom 32       /out %NAME%215.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 14 /colorseed 216                                                          /out %NAME%216.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 33 /h 8 /gen 500 /seed 21700 /bottom 11226111123331113 /corner 6 /corner 22 /corner 23 /corner 26 /corner 27 /tee 5 /tee 7 /out %NAME%217.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 39 /h 7 /seed 218 /left 0002224 /right 0222222 /bottom 1416233124331212 /corner 12 /corner 28 /corner 29 /corner 32 /corner 33 /tee 11 /tee 13 /out %NAME%218.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 64 /h 1 /seed 219 /bottom 42233122233312143262311143 /corner 8 /corner 24 /corner 25 /corner 28 /corner 29 /corner 35 /tee 7 /tee 9 /tee 34 /tee 36 /tee 49 /out %NAME%219.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 18 /h 1 /bottom 22161321                                                        /out %NAME%220.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 31 /h 3 /bottom 31241231114332 /right 330 /corner 3 /tee 2 /tee 4 /tee 25       /out %NAME%221.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 52 /h 4 /gen 200 /seed 222 /bottom 21441212411122341213343 /right 9900 /corner 15 /corner 49 /tee 14 /tee 16 /tee 37 /out %NAME%222.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 51 /h 1 /seed 223 /bottom 34212343432446231 /corner 11 /corner 12 /corner 15 /corner 16 /corner 22 /parts tiles /out %NAME%223.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 13 /h 1 /bottom 11142121 /corner 8                                              /out %NAME%224.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 52 /h 1 /seed 225 /bottom 2621126121142132222243 /corner 15 /corner 49 /parts tiles /out %NAME%225.ldr

rem generate_wall %COLOR% %SHOW% %TRACE% /w 36 /h 1  /bottom 262412241241221 /colorseed 4010 /corner 30 /parts plates_2xn   /out %NAME%401.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 11 /h 1  /bottom 641 /parts plates_2xn                                          /out %NAME%402.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 41 /h 1  /bottom 124462242114611 /corner 6 /parts plates_2xn                    /out %NAME%403.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 13 /h 1  /bottom 421114 /colorseed 404000000 /parts plates_2xn                  /out %NAME%404.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 2  /h 1  /parts tiles                                                           /out %NAME%405.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 1  /h 1  /parts tiles                                                           /out %NAME%406.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 4  /h 1  /bottom 211 /colorseed 407                                             /out %NAME%407.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 32 /h 6  /seed 408 /bottom 311431344332 /corner 12 /corner 13 /corner 16 /corner 17 /corner 23 /tee 22 /tee 24 /left 111000 /top 66623234 /out %NAME%408.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 23 /h 17 /seed 4090 /bottom 11341321322 /left 00000000000020000 /right 00000000000000222 /corner 12 /corner 13 /corner 16 /corner 17 /out %NAME%409.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 4 /h 20 /left 00000000000000111111 /right 00000000000000111111 /bottom 4        /out %NAME%410.ldr
rem for /L %%i in (411, 1, 412) do generate_wall %COLOR% %SHOW% %TRACE% /w 1 /h 20 /colorseed %%i                           /out %NAME%%%i.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 2 /h 3                                                                          /out %NAME%413.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 55 /h 6 /gen 500 /bottom 116322332114312611211242 /top 33636666646 /corner 15 /corner 49 /tee 14 /tee 16 /tee 37 /out %NAME%414.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 3  /h 20  /bottom 12 /right 00000000000000111111                                /out %NAME%415.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 43 /h 3 /seed 416 /bottom 2266222422222331 /top 3663316636 /corner 3 /corner 37 /tee 2 /tee 4 /tee 25 /out %NAME%416.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 21 /h 6 /bottom 1426332 /top 322266 /corner 15 /tee 3                           /out %NAME%417.ldr
rem generate_wall %COLOR% %SHOW% %TRACE% /w 18 /h 9 /gen 500 /bottom 1326411 /top 343143 /corner 3 /tee 2 /tee 4            /out %NAME%418.ldr
generate_wall %COLOR% %SHOW% %TRACE% /w 3  /h 5 /bottom 21                                                              /out %NAME%419.ldr
generate_wall %COLOR% %SHOW% %TRACE% /w 2  /h 6 /bottom 11 /top 11                                                      /out %NAME%420.ldr
