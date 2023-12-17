function [alpha] = nystroem(X, C, kernel, y, lambda)
    KnM = kernel(X, C);
    KMM = kernel(C, C);
    alpha = (KnM' * KnM + lambda *length(y)* KMM)\(KnM'*y);
end