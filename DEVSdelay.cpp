#ifndef DEVSdelay_C
#define DEVSdelay_C

#include <math.h>

double ARRu[1000];
double ARRmu[1000];
double ARRpu[1000];
double ARRtime[1000];
int counterIn=1;


double getSigmaDint(int counterOut, double tim, double delay){

  if ((counterOut+1)%1000==counterIn){
    return 4e10;
  }else{
    if (ARRtime[counterOut]+delay-tim < 0){
      return counterOut;
    }else{
      return ARRtime[counterOut]+delay-tim;
    }

  }
}


double getSigmaDext(int counterOut, double uIN, double muIN, double puIN, double tim, double sig, double eps, double delay){

  if(counterIn!=counterOut){
    ARRtime[counterIn-1]=tim;
    ARRu[counterIn-1]=uIN;
    ARRmu[counterIn-1]=muIN;
    ARRpu[counterIn-1]=puIN;

    if(counterIn==((counterOut+1)%1000)){
      counterIn++;
      return delay;
    }else{
      counterIn++;
      return sig-eps;
    };

  };
}


double getSigmaDintDext(int counterOut, double uIN, double muIN, double puIN, double tim, double sig, double eps, double delay){

  if(counterIn!=counterOut){
    ARRtime[counterIn-1]=tim;
    ARRu[counterIn-1]=uIN;
    ARRmu[counterIn-1]=muIN;
    ARRpu[counterIn-1]=puIN;
    counterIn++;
  };

  if ((counterOut+1)%1000==counterIn){
    return 4e10;
  }else{
    if (ARRtime[counterOut]+delay-tim < 0){
      return counterOut;
    }else{
      return ARRtime[counterOut]+delay-tim;
    }

  }
}


double getU(int counterOut){
  return ARRu[counterOut];
}

double getMU(int counterOut){
  return ARRmu[counterOut];
}

double getPU(int counterOut){
  return ARRpu[counterOut];
}

#endif
