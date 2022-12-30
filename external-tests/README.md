```bash
sudo apt install gcc wget libssl-dev -y
sudo apt install python python3-pip python-is-python3 -y && pip install pandas
PATH=/home/anand_navchetana/.local/bin:$PATH
```

```bash
sudo dnf update -y
sudo dnf install wget  openssl-devel -y && sudo yum install python3 python3-pip -y && sudo pip3 install pandas && sudo dnf group install "Development Tools" -y
```

```bash
mkdir tests && cd tests && rm ./*
wget https://raw.githubusercontent.com/abhayhk2001/open-ssl-tests/main/external-tests/EncryptDecryptPerfTest.c https://raw.githubusercontent.com/abhayhk2001/open-ssl-tests/main/external-tests/run-tests.py https://raw.githubusercontent.com/abhayhk2001/open-ssl-tests/main/external-tests/tests.csv

cc -g -O3 -o EncryptDecryptPerfTest EncryptDecryptPerfTest.c -lssl -lcrypto

python3 run-tests.py
```

-lssl -lcrypto -> gcc linking with the libraries "ssl" and "crypto"

If -lssl is not working
libssl.so
```
apt-file update
apt-file search libssl.a 
```

if -lcrypto not working

<hr>
<hr>

# Connecting to QAT engine programatically (C, C++)

2 approaches

1. Using the way openssl speen application invokes the engine

```
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/engine.h>
#include <openssl/crypto.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>


static ENGINE *try_load_engine(const char *engine)
{
    ENGINE *e = ENGINE_by_id("dynamic");
    if (e) {
        if (!ENGINE_ctrl_cmd_string(e, "SO_PATH", engine, 0)
            || !ENGINE_ctrl_cmd_string(e, "LOAD", NULL, 0)) {
            ENGINE_free(e);
            e = NULL;
        }
    }
    return e;
}

ENGINE *setup_engine(const char *engine, int debug)
{
    ENGINE *e = NULL;

#ifndef OPENSSL_NO_ENGINE
    if (engine != NULL) {
        if (strcmp(engine, "auto") == 0) {
            ENGINE_register_all_complete();
            printf("Engine is auto");
            return NULL;
        }
        if ((e = ENGINE_by_id(engine)) == NULL
            && (e = try_load_engine(engine)) == NULL) {
                printf("engine load failed");
            return NULL;
        }
        // ENGINE_ctrl_cmd(e, "SET_USER_INTERFACE", 0, ui_method, 0, 1);
        if (!ENGINE_set_default(e, ENGINE_METHOD_ALL)) {
            ENGINE_free(e);
            return NULL;
        }

        printf("engine \"%s\" set.\n", ENGINE_get_id(e));
    }
#endif
    return e;
}


int main(int argc, char *argv[])
{
    ENGINE *e = NULL;
    const char *engine_id = "qatengine";
    e = setup_engine(engine_id, 0);
}
```