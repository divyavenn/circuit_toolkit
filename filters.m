%% main
w = f2w(10e3)
s = 1j*10*w
gain = 4
h = -1*gain*(s/(s+w))
V = 4*exp(1j*0)
amplitude = abs(V*h)
angle = rad2deg(angle(V*h))

%%

w = f2w(325)
syms r2
c = .75e-6
double(solve(w == lf_cw(r2,c), r2))

%%
rl = 1/(.75e-6*f2w(250))
rh = 1/(.75e-6*f2w(9250))
%%
w = f2w(9000)
syms r1
double(solve(w == hf_cw(r1,c), r1))

%% High pass filter
w = f2w(10e3)
gain = 4
c = 60e-9

syms r1
fwd_path_r = double(solve(hf_cw(r1,c) == w, r1))
syms r2
fdbk_r = double(solve(pg(fwd_path_r,r2) == gain, r2))

%% Low pass filter
w = f2w(4.5e3)
gain = db2pg(10)

syms r2
c = 60e-9
fdbk_r = double(solve(hf_cw(r2,c) == w, r2))
syms r1
fwd_path_r = double(solve(pg(r1,fdbk_r) == gain, r1))
%% base function definition
function db = pg2db(pg)
    db = 20*log10(pg)
end
function pb_gain_from_db = db2pg(db)
    pb_gain_from_db = 10^(db/20)
end
function passband_gain = pg(r1,r2)
    passband_gain = r2/r1;
end
function lpf_cutoff_w = lf_cw(r2,c)
    lpf_cutoff_w = 1/(r2*c)
end

function hpf_cutoff_w = hf_cw(r1,c)
    hpf_cutoff_w = 1/(r1*c)
    %'R1 (forward path resistor) has value %f, cutoff frequ in rad/sec is %f', r1, hpf_cutoff_w)
end

function w = f2w(f)
    w = 2*pi*f
end

function f = w2f(w)
    f = w/(2*pi)
end
%% advanced function definition
function lpf_H = lpf_H(s,r2,r1,c)
    w = lf_cw(r2,c)
    lpf_H = -1*pg(r2,r1)*(w/(s+w))
end

function hpf_H = hpf_H(s,r2,r1,c)
    w = hf_cw(r1,c)
    lpf_H = -1*pg(r2,r1)*(s/(s+w))
end