function [X] = Zero_fill(X)

for i=1:1:size(X,1)
    if i > 1
    if (X(i,1) == 0 && X(i,2) == 0)
        X(i,1) = X(i-1,1);
        X(i,2) = X(i-1,2);
    else
        X(i,1) = X(i,1);
        X(i,2) = X(i,2);
    end
    else
        X(i,1) = X(i,1);
        X(i,2) = X(i,2);
    end
end