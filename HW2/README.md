`Run command`: Type `make all` to create executables `trap.ex` and `ones.ex`. Type `./trap.ex` or `./ones.ex` to run executables.

`Q1`: What are the right answers:
(1) \int_{0}^{2} x^{2} = 8/3 = 2.66666..
(2) \int_{0}^{pi} sin(x) = 2

`Q2`: How many intervals do you have to use to get a decent answer?
Using N = 100 produces decent answers in my opinion: (1) 2.6667999999999994, (2) 1.9998355041618150

`trap.ex` sample outputs:
`N = 1:`
a =
0
 b =
2
 N =
1
 x^2 solution =    4.0000000000000000
 sin(x) solution =   0.90929742682568171

 a =
0
 b =
3.14159
 N =
1
 x^2 solution =    15.503099055360838
 sin(x) solution =    4.1682455794495013E-006

`N = 10:`
 a =
0
 b =
2
 N =
10
 x^2 solution =    2.6800000000000006
 sin(x) solution =    1.4114231970988789

 a =
0
 b =
3.14159
 N =
10
 x^2 solution =    10.387076367091758
 sin(x) solution =    1.9835235653860221

`N = 100:`
a =
0
 b =
2
 N =
100
 x^2 solution =    2.6667999999999994
 sin(x) solution =    1.4160996313378877

a =
0
 b =
3.14159
 N =
100
 x^2 solution =    10.335916140209074
 sin(x) solution =    1.9998355041618150

`ones.ex` sample outputs:
m =
3
 Generated matrix:
   3   3
           1           0           1
           1           0           0
           0           0           0

 Periodic matrix:
   5   5
           0           0           0           0           0
           1           1           0           1           1
           0           1           0           0           1
           0           0           0           0           0
           1           1           0           1           1

 Calculated matrix:
   3   3
           0           1           0
           0           1           1
           1           1           1

 m =
4
 Generated matrix:
   4   4
           1           0           1           1
           0           0           0           0
           0           0           0           0
           1           0           0           1

 Periodic matrix:
   6   6
           1           1           0           0           1           1
           1           1           0           1           1           1
           0           0           0           0           0           0
           0           0           0           0           0           0
           1           1           0           0           1           1
           1           1           0           1           1           1

 Calculated matrix:
   4   4
           1           1           0           1
           0           0           0           1
           0           0           0           0
           1           1           1           1

 m =
7
 Generated matrix:
   7   7
           1           0           1           1           0           0           0
           0           0           0           0           0           1           0
           0           1           0           1           0           0           1
           0           0           1           0           1           0           0
           0           1           0           1           1           1           0
           0           1           1           0           0           1           0
           1           1           1           1           0           1           0

 Periodic matrix:
   9   9
           0           1           1           1           1           0           1           0           1
           0           1           0           1           1           0           0           0           1
           0           0           0           0           0           0           1           0           0
           1           0           1           0           1           0           0           1           0
           0           0           0           1           0           1           0           0           0
           0           0           1           0           1           1           1           0           0
           0           0           1           1           0           0           1           0           0
           0           1           1           1           1           0           1           0           1
           0           1           0           1           1           0           0           0           1

 Calculated matrix:
   7   7
           0           1           1           1           1           0           1
           1           1           1           1           1           0           1
           0           0           1           0           1           1           0
           1           1           1           1           1           1           0
           0           1           1           1           1           1           0
           1           1           1           1           1           1           1
           1           1           1           1           1           0           1
