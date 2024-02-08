#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
void func(){
  pid_t p;
  p = fork();
  if(p < 0){
    perror("fork fail");
    exit(1);
  }
  else if(p == 0){
    int num;
    for(int i=0; i < 1000000; i++){
      num = rand()/rand();
    }
    sleep(0.5);
    func();
  }
  else{
    int num;
    for(int i=0; i< 10000000; i++){
      num=rand()/rand();
    }
    sleep(0.5);
    func();
  }
}

int main(){
  FILE* file = fopen("/etc/boot/pid.txt", "w");
  pid_t pid = getpid();
  fprintf(file, "%d\n",pid);
  fclose(file);
  func();
  return 0;
}
