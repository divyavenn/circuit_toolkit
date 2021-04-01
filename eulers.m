
%% Data Def
da = -1;
db = 1;
dc=1.414;
dtheta=2.356;
ea = 4;
eb = 4;
ec = 5.6568;
etheta = 0.7853;
fa = -10;
fb = 0;
fc = 10;
ftheta = 3.1415;
ga = 0;
gb = -3;
gc = 3;
gtheta = -1.57;
ha = -3;
hb = -5;
rc = 5;
rtheta = pi/4; 
ra = 3.5355;
rb = 3.5355;
kc = 6;
ktheta = 3*pi/2;
ka = 0;
kb = -6;
%% To Rect
toRect(125, 3*pi/4)
%% To Polar
toPolar(ga,gb)
%% Adding
x_a = 3;
x_b = 5;
y_a = -10;
y_b = -3;
answerInRect = printRect((x_a+y_a), (x_b+y_b))
answerInPolar = toPolar((x_a+y_a), (x_b+y_b))
%% Subtracting
x_a = ha;
x_b = hb;
y_a = da;
y_b = db;
answerInRect = printRect((x_a-y_a), (x_b-y_b))
answerInPolar = toPolar((x_a-y_a), (x_b-y_b))
%% Multiplying
x_c = fc;
x_theta= ftheta;
y_c = gc;
y_theta= gtheta;
answerInRect = toRect(x_c*y_c, x_theta+y_theta)
answerInPolar = printPolar(x_c*y_c, x_theta+y_theta)
%% Dividing
x_c = rc;
x_theta= rtheta;
y_c = dc;
y_theta= dtheta;
answerInRect = toRect(x_c/y_c, x_theta-y_theta)
answerInPolar = printPolar(x_c/y_c, x_theta-y_theta)

%% Setup
function answerRect = printRect(a,b)
    answerRect = sprintf('%f + j(%f)', (a), (b));
end
function answerPolar = printPolar(c,theta)
    answerPolar = sprintf('%fe^(j(%f) = %f<%f', (c),(theta), c, theta);
end
function inRect = toRect(c, theta)
    inRect = c*exp(i*theta);
end
function inPolar = toPolar(a,b)
    x = a + b*i;
    c = abs(x);
    theta = angle(x);
    inPolar = printPolar(c, theta);
end
