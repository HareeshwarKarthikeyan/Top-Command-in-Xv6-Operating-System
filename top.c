#include "types.h"
#include "user.h"
#include "stat.h"

static char
getc(int fd, char **buffer)
{
    int i = 0;
    char buf[256]; // read input into buffer
    while (read(fd, &buf[i], 1))
    {
        if ((buf[i] == '\n' || buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\r' || buf[i] == '\v' || buf[i] == '\f'))
            break;
        else
            i++;
    }
    buf[i] = '\0';
    *(buffer) = buf;
    return buf[0];
}

int main(int argc, char *argv[])
{
    //clear screen
    printf(1, "\033[2J\033[1;1H\n");
    gettop();

    char *c;
    *c = getc(1, &c);
    while (*c != 'q' && *c != 'Q')
    {
        //clear screen
        printf(1, "\033[2J\033[1;1H\n");
        gettop();
        *c = getc(1, &c);
    }
    printf(1, "\033[2J\033[1;1H\n");
    exit();
}