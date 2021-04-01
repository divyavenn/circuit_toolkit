
z = p([12 68])
answer = z
function eqp = p(P)
    x = 0;
    for n = 1 : length(P) 
        x = x+(1/P(n));
    end
    eqp = 1/x;
end
function eqs = s(S)
    x = 0;
    for n = 1 : length(S) 
        x = x +(S(n))
    end
    eqs = x;
end