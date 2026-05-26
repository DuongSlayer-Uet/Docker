#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *fp;
    char version[128];

    // kiểm tra python3.9 có tồn tại không
    int ret = system("which python3.9 > /dev/null 2>&1");

    if (ret != 0) {
        printf("Error: Python 3.9 not found\n");
        return 1;
    }

    // lấy version
    fp = popen("python3.9 --version 2>&1", "r");

    if (fp == NULL) {
        printf("Error running command\n");
        return 1;
    }

    fgets(version, sizeof(version), fp);

    printf("Detected Python Version: %s", version);

    // ghi log
    FILE *log = fopen("/tmp/python_ver.log", "w");

    if (log != NULL) {
        fprintf(log, "%s", version);
        fclose(log);
    }

    pclose(fp);

    return 0;
}
