function [alpha] = krr(X, kernel, y, lambda)
    K = kernel(X, X);
    alpha = (K + lambda *length(y)* eye (length(y)))\y;
end