# Tests conducted with OpenSSL speed

To install QAT engine on a ubuntu system follow [setup-ubuntu.sh](setup-ubuntu.sh).
To install QAT engine on a rhel8 system follow [setup-rhel8.sh](setup-rhel8.sh).

Then run 
```bash
python3 run-tests.py
```
to run openssl speed for AES algorithm with 128 and 256 block sizes, with and without QAT optimization and compare the results. 
