syms L;
syms t;
syms i;
syms v;
i0 = 0;
%% find current from circuit
R = 24;
tau = L/R
i = i0*exp(-t/tau)
%% find voltage from current
v = L*diff(i,t)
%% find current from voltage
v = -10*t
syms i
t1 = 2
t2 = 4
i0 = -40
i = (1/L)*int(v,t,t1,t2)+i0
%% find power
syms p
p = v*i
%% find energy
syms w
w = .05*L*i^2
%% at a particular time
double(subs(w,t,.1))
%% find time when
double(solve(diff(i) == -1, t))
%% subsitute
double(subs(v,t,inf))