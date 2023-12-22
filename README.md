## Experiments for TIT paper "[Optimal Rates for Agnostic Distributed Learning](https://ieeexplore.ieee.org/document/10365227)".
---
### Installation on LINUX
To install FALKON, set the MATLAB shell path to the kernels folder and run:

`mex -largeArrayDims ./tri_solve_d.cpp -lmwblas -lmwlapack`

`mex -largeArrayDims ./inplace_chol.cpp -lmwblas -lmwlapack`

To install libsvm for loading libsvm datasets, set the MATLAB shell path to the `./utils/libsvm/matlab` folder and just run:

`make`

### Folders
- `kernels` contains basic functions for kernels and random features.
- `methods` consists of compared methods.
- `utils` involves utility tools, including figures, data processing, simulated data generating and so on.
- `datasets` stores the primal datasets from libsvm or other sources.
- `data` stores '.mat' files after data processing for datasets.
- `results` stores intermediate results and outputs.

### Utils
- `generate_simulated_spline` is used to generate simulated dataset with different settings.
- `data_preprocess` generates the training and testing sets based on given datasets.

### Description
- `best_parameters_SSL_DKRR` includes used hyperparameters for datasets, including data partitions, $\sigma$, $\lambda$ and iteration times.
- `test_ssl_unlabeled` records the test errors and training times in terms of different number of unlabeled examples.
- `test_ssl_unlabeled` is used to draw two figures: classification error and training time versus the number of unlabeled examples.
- `test_ssl_partitions` records the test errors and training times in terms of different number of partitions.
- `draw_ssl_partitions` is used to draw two figures: classification error and training time versus the number of partitions.
- `run_script_SSL_DKRR` is the script that conducts experiments and draw visual comparison in terms of different datasets.

### How to RUN
- Just run `run_script_SSL_DKRR`.
- *OR* run `test_ssl_unlabeled` and `test_ssl_unlabeled` for comparion on the number of unlabeled exmaples.
- *OR* run `test_ssl_partitions` and `draw_ssl_partitions` for comparion on the number of partitions.