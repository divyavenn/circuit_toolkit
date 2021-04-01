x = series([36 18 12]);
y = prl([x 24]);
n = prl([5 11]);
z = series([y n 30]);
answer = z
function eq = series(S)
    x = 0;
    for n = 1 : length(S) 
        x = x+(1/S(n));
    end
    eq = 1/x
end
function eq = prl(P)
    x = 0;
    for n = 1 : length(P) 
        x = x+(P(n));
    end
    eq = x
end