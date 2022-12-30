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