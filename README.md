# Testing Intel QAT Engine 
Tests are done with AES-512 algorithm.

[test-results]() directory has the post processing script used to make the recieved data into a presentable format.

initial-tests directory has the first basic test conducted with the openssl speed script.

external-tests directory contains trying to invoke the QAT Engine from c code. The fist method used the way openssl attempted it. Other attempts were also made.

Metrics directory contains the way to perform custom metrics. Futher details are provided [here](metrics/README.md).
