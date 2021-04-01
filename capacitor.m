C = 3.3333e-6;
syms t;
syms v;
syms i;
t1 = 2;
t2 = 6;
v0 = 102;
%% find voltage
R = 12e3 ;
tau = R*C
v = v0*exp(-t/tau)
vpa(v)
%% find current
i = C*diff(v,t)
i = 50e-3*exp(-2000*t)
vpa(i)
v = (1/C)*int(i, t, 0, inf) + v0
%% find power
p = v*i
%% find energy
E = .5 * C * v^2

%% substitute a particular time
double(subs(E,t,0))