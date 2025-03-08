// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

// Defining the macros for username and password
/////////////////////////////////////////////
#ifndef USERNAME
#define USERNAME "NONE"
#endif

#ifndef PASSWORD
#define PASSWORD "NONE"
#endif
/////////////////////////////////////////////

char *argv[] = {"sh", 0};

int main(void)
{
    int pid, wpid;

    if (open("console", O_RDWR) < 0)
    {
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0); // stdout
    dup(0); // stderr

    // Secured shell login using username and password
    /////////////////////////////////////////////////////////////////////////////////

    int attempts = 0;
    int max_username_size = 100;
    int max_password_size = 100;

    char username[] = USERNAME;
    char password[] = PASSWORD;

    int username_size = sizeof(username);
    int password_size = sizeof(password);

    int logged_in = 0;

    while (attempts < 3)
    {
        printf(1, "Enter Username: ");

        char username_array[max_username_size];
        int input_username_size = read(0, username_array, max_username_size);

        int is_correct_username = 1;
        if (username_size == input_username_size)
        {
            for (int i = 0; i < username_size - 1; i++)
            {
                if (username[i] != username_array[i])
                {
                    is_correct_username = 0;
                    break;
                }
            }
        }
        else
        {
            is_correct_username = 0;
        }

        if (!is_correct_username)
        {
            printf(1, "Incorrect username. Enter details again\n");
            attempts++;
            continue;
        }

        printf(1, "Enter Password: ");

        char password_array[max_password_size];
        int input_password_size = read(0, password_array, max_password_size);

        int is_correct_password = 1;
        if (password_size == input_password_size)
        {
            for (int i = 0; i < password_size - 1; i++)
            {
                if (password[i] != password_array[i])
                {
                    is_correct_password = 0;
                    break;
                }
            }
        }
        else
        {
            is_correct_password = 0;
        }

        if (!is_correct_password)
        {
            printf(1, "Incorrect Password. Enter details again\n");
            attempts++;
            continue;
        }

        logged_in = 1;
        break;
    }

    if (logged_in)
    {
        printf(1, "Login successful\n");
    }
    else
    {
        printf(1, "Login unsuccessful. Out of valid attempts\n");
        while (1){
            sleep(100);
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////

    for (;;)
    {
        printf(1, "init: starting sh\n");
        pid = fork();
        if (pid < 0)
        {
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0)
        {
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        while ((wpid = wait()) >= 0 && wpid != pid)
            printf(1, "zombie!\n");
    }
}
