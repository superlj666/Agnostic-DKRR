function [lambda, k_par, M, M_set, m, m_set, T, repeat, ntr, nts, ntr_ssl_set, ntr_ssl] = best_parameters_SSL_DKRR(data_name)
    lambda = 1e-6;
    k_par = 1;
    ntr_ssl = 5000;
    ntr = 3000;
    nts = 5000;     
    ntr_ssl_set = linspace(0, 5000, 10);
    m = 10;
    M = 400;
    M_set = ceil(linspace(20, 200, 10));
    m_set = ceil(linspace(10, 100, 10));
    T = 5;    
    repeat = 10;
    if strcmp(data_name, 'EEG')
        lambda = 1e-7;
        k_par = 1;       
    elseif strcmp(data_name, 'SUSY')
        lambda = 8e-6;
        k_par = 2^2.5;
    elseif strcmp(data_name, 'covtype')    
        lambda = 2^-6;
        k_par = 2^1;   
    elseif strcmp(data_name, 'HIGGS')
        lambda = 10^-8;
        k_par = 5;     
    elseif strcmp(data_name, 'cod-rna')
        lambda = 10^-5;
        k_par = 0.1;     
    end
end