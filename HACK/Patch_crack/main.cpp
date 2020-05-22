#include <stdio.h>
#include <stdlib.h>

long sizeFile  (FILE *file);
bool checkFile (char *buffer, long num_bytes);
long checkSum  (char *buffer, long num_bytes);

bool readFile (FILE *file, char *buffer, long num_bytes);
char* allocateMemory (long num_bytes);
void  freeMemory (char* buffer);
void patching (char* buffer);

FILE* openFile (char *argument, const char* parametrs);
void closeFile (FILE *file);

void writeInFile (char *buffer, long num_bytes, FILE *file);


int main(int num_arguments, char** arguments)
{
    printf ("Now will be patching the program: %s\n", arguments[1]);

    FILE *file = openFile (arguments[1], "r+b");


    long num_bytes = sizeFile (file);
    char *buffer = allocateMemory (num_bytes);
    readFile (file, buffer, num_bytes);

    if (checkFile (buffer, num_bytes)) {
        patching (buffer);
        printf ("Patch completed successfully!\n");
    }
    else
        printf ("Invalid file or file version!\n");

    writeInFile (buffer, num_bytes, file);
    fclose (file);
    closeFile (file);
    freeMemory (buffer);
    getchar ();
}



FILE* openFile (char *argument, const char* parametrs) {
    FILE *file = fopen (argument, parametrs);
    if (file == nullptr) {
        printf ("Can't open file!\n");
        exit(0);
    }
    return file;

}

void closeFile (FILE *file) {
    fclose(file);
}

char* allocateMemory (long num_bytes) {
    char* point = (char*) calloc (num_bytes, sizeof (char) );
    if (point == nullptr) {
        printf ("Error in allocate memory!\n");
        exit(1);
    }
    return point;
}

void freeMemory (char* buffer) {
    free (buffer);
}

long sizeFile (FILE *file) {
    fseek (file, 0, SEEK_END);
    long last_symbol = ftell (file);
    fseek (file, 0, SEEK_SET);
    return last_symbol;
}

bool readFile (FILE *file, char *buffer, long num_bytes) {
    return fread ((void*) buffer, sizeof (char), num_bytes, file);
}

bool checkFile (char *buffer, long num_bytes) {
    long sum = checkSum (buffer, num_bytes);
    if (sum != -427936)
        return 0;
    else
        return 1;
}

long checkSum  (char *buffer, long num_bytes) {
    long sum = 0;
    for (long i = 0; i < num_bytes; i++)
        sum += i * buffer[i];
    return sum;
}

void patching (char* buffer) {
    char* str = "Crack by Texnar.";
    sprintf (buffer + 32, "%s\n\r$", str);
    buffer[13] = 0xE9;
    buffer[14] = 0xB3;
    buffer[15] = 0x00;
}

void writeInFile (char *buffer, long num_bytes, FILE* file) {
    fseek (file, 0, SEEK_SET);
    fwrite (buffer, sizeof (char), num_bytes, file);
}
