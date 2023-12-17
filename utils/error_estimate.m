function error_rate = error_estimate(y_predict, y_test)
    if length(unique(y_predict)) == 2
        error_rate = mean(y_predict ~= sign(y_test));
    else
        error_rate = sqrt(sum((y_predict - y_test).^2)/length(y_test));
    end
end