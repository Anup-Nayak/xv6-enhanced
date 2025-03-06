// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };

void login() {
  int attempts = 3;
  char uname[32], pass[32];

  while(attempts--) {
    printf(1, "Enter username: ");
    gets(uname, sizeof(uname));
    uname[strlen(uname) - 1] = '\0'; 

    if(strcmp(uname, USERNAME) != 0) {
      continue;
    }

    printf(1, "Enter password: ");
    gets(pass, sizeof(pass));
    pass[strlen(pass) - 1] = '\0';

    if(strcmp(pass, PASSWORD) == 0) {
      printf(1, "Login successful\n");
      return;
    }
  }

  while(1){
    sleep(100);
  }
}



int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr


  for(;;){

    login();

    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
