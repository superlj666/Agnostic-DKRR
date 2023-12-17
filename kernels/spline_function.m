% splines is p-series
% X and Z can be different dimensional
function val = spline_function(X, Z, q)
    k_values = 1 : 5e2;
    difference = X*ones(1, length(Z)) - ones(length(X), 1)*Z';
    
    if length(X) * length(Z) < 50*2^30 / (8 * length(k_values)) %%% Memory less than 50G
        difference = reshape(difference, [1, length(X), length(Z)]);
        val = 1 + 2*sum(cos(k_values' .* (2 * pi) .* difference) ./ ((k_values'.^q)*ones(1, length(X))), 1);
        val = reshape(val, [length(X), length(Z)]);
    else
        res = 0;
        for i = k_values
            res = res + cos(k_values(i) .* (2 * pi) .* difference) ./ k_values(i).^q;
        end
        val = 1 + 2*res;
    end
end
