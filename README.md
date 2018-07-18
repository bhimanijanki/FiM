# FiM

Predicting performance of an application running on parallel computing platforms is increasingly becoming important because of its influence on development time and resource management. However, predicting the performance with respect to parallel processes is complex for iterative and multi-stage applications. This research proposes a performance approximation approach \textit{FiM} to predict the calculation time with FiM-Cal and communication time with FiM-Com, of an application running on a master-compute distributed framework. FiM-Cal consists of two key components that are coupled with each other: 1) Stochastic Markov Model to capture non-deterministic runtime that often depends on parallel resources, e.g., number of processes. 2) Machine Learning Model that extrapolates the parameters for calibrating our Markov model when we have changes in application parameters such as dataset. Along with the parallel calculation time, parallel computing platforms consume some data transfer time to communicate between master and compute nodes. FiM-Com consists of a simulation queuing model to quickly estimate communication time. Our new modeling approach considers different design choices along multiple dimensions, namely (i) process level parallelism, (ii) distribution of cores on multi-processor platform, (iii) application related parameters, and (iv) characteristics of datasets.

FiM-Cal
Built in MATLAB
Related Reference Files
file_read.m
tp.m
predCal.m

FiM-Com
Built in C/C++
Related Reference Files
broadcast.c
scatter.c
uplink.c
