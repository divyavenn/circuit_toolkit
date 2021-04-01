syms b;
a = 25e-3; 
c = 25e-3;

equ1 = (b-a)*(330) + (b-c)*(270) + (b)*150 == 0;


sol = solve(equ1,b);
i0 = double(sol) 

v270 = (i0-c)*(270);    
p_supplied = double(c*(v270))
