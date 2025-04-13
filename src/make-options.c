#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    if(argc != 3) {
        return -1;
    }

    FILE *fp = fopen(argv[2], "w");

    int offset = 0;
    int zeroes = 512;

    // magic number
    offset += 2;
    zeroes -= 2;
    fputc(0xBE, fp);
    fputc(0xEF, fp);

    // kernel blocks count (512 bytes)
    offset += 2;
    zeroes -= 2;
    int blocks = atoi(argv[1]);
    fputc(blocks & 0xFF, fp);
    fputc(blocks >> 8, fp);

    for(int i = 0; i < zeroes; i++) {
        fputc(0, fp);
    }

    return 0;
}
