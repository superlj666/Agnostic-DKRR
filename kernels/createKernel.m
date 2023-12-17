function f = createKernel(k_type, k_par)
    switch k_type
        case 'gaussian'
            f = @(X1,X2) gaussian_kernel(X1, X2, k_par);
        case 'linear'
            f = @(X1,X2) linear_kernel(X1, X2);
        case 'poly'
            f = @(X1,X2) poly_kernel(X1, X2, k_par);
        case 'spline'
            f = @(X1,X2) spline_kernel(X1, X2, k_par);
    end
end

function K = linear_kernel(X1, X2)
    K = X1*X2';
end

function K = poly_kernel(X1, X2, k_par)
    K = (X1*X2' + 1).^k_par;
end

function D = gaussian_kernel(X1, X2, sigma)
    sq1 = sum(X1.^2,2); 
    sq2 = sum(X2.^2,2)';    
    D = X1*X2'; 
    clear X2
    clear X1    
    D = -2.0*D; 
    D = bsxfun(@plus, D, sq2);
    clear sq2   
    D = bsxfun(@plus, D, sq1);
    clear sq1   
    D = bsxfun(@times, D, -1/(2*sigma^2));  
    if isa(D, 'gpuArray')
        D = arrayfun(@exp, D);
    else
        D = exp(D);
    end
end

function K = spline_kernel(X1, X2, k_par)
    K = spline_function(X1, X2, k_par);
end