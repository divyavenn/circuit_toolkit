%% main
%% define frequency
global w 
f = 50e3;
w = 2*pi*f;
w =  100
%% define circuit
Z = p([r(10), c(800e-6), l(0.2e-3)])
%% current divider
% idiv(array of parallel elements, index of the one whose current you want)
ratio = idiv([r(10), c(800e-6), l(0.2e-3)],3)
I0 = 0.02*exp(1j*0.6)
I = I0*ratio
Iamp = abs(I)
Iangle = angle(I)
%% node voltage method
%define constants
Lz = 5.0000e+02i
Cz = -64.0000i
IA = 2
Iphase = -.55
I = IA*exp(1j*Iphase)
%equation matrices
A = [1/480+1/Lz,    -1/Lz;
    -1/Lz,  1/Lz+1/Cz+1/200]
d = [I;
    0]
%solve
sol =(A\d)
%isolate desired voltage
vg = sol(2)
%find polar components
amp = abs(vg)
phase = angle(vg)
%% define voltage
syms t
VA = 55
%if in sin form convert to cosine by -90 phase
Vphase = deg2rad(-90)
V = VA*exp(1j*Vphase)
%% voltage to current
I = V/Z
IA = abs(I)
Iphase = angle(I)
sprintf('i(t) = %f*cos(%f t + %f)',IA,w,rad2deg(Iphase)) 
%% define current
IA = 0.0200
Iphase = 0.5992
I = IA*exp(1j*Iphase)
%% phasor: current to voltage
Z = l(0.2e-3)
V = I*Z
VA = abs(V)
Vphase = rad2deg(angle(V))
%v = VA * cos(w*t + Vphase);
sprintf('v(t) = %f*cos(%f t + %f)',double(VA),double(w),double(Vphase)) 
%% Define functions
%current divider formula
function Idiv = idiv(P,k)
    t = s(P)
    ro = (t - P(k))
    Idiv = ro/t
end


%Capactive reactance: two approaches
function XC = xc2(ia, va)
    global w
    XC = va/ia;
end
function XC = xc1(c)
    global w
    XC = 1/(w*c);
end
%Inductive reactance: two approaches
function XL = xl1(l)
    global w
    XL = (w*l)
end
function XL = x2(ia, va)
    global w
    XL = ia/va;
end


%Impedence of various elements
function ZofR = r(r)
    ZofR = r
end
function ZofC = c(c)
    global w
    ZofC = 1/(w*c*1j)
end
function ZofL = l(l)
    global w 
    ZofL = w*l*1j
end


%parallel and series computations
function eq = p(P)
    x = 0;
    for n = 1 : length(P) 
        x = x+(1/P(n));
    end
    eq = 1/x;
end
function eq = s(S)
    x = 0;
    for n = 1 : length(S) 
        x = x+(S(n));
    end
    eq = x
end