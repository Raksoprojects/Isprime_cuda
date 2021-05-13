#include <cuda.h>
#include <math.h>
#include <chrono>
#include <iostream>

#define N 1024
typedef unsigned long long int int64_cu;

__global__ void is_prime(int64_cu *prime, int64_cu *root, bool *c){
    if(*prime<2) {*c = false; return;}
    if(*prime % 2 == 0) {*c = false; return;}

    for(int64_cu k = 3+(2*blockIdx.x); k <= *root; k = k + 2 * N){
        if(*prime % k == 0) {*c = false; return ;}
        
    }
    *c = true;
    return ;
}

bool is_prime(int64_cu p){

    if(p<2) return false;
    if(p % 2 == 0) return false;

    for(int64_cu k = 3; k <= sqrt(p); k = k + 2){
        if(p % k == 0) return false;
    }
    return true;
}

int main(){
    
    ///Kod na CPU
    int64_cu test = 0;
    std::cout<<"Type a number to check if it is prime: ";
    std::cin>>test;
    auto t_start = std::chrono::high_resolution_clock::now();
    if(is_prime(test)){
        std::cout<<"It is a prime!";
    }
    else{
        std::cout<<"It is not a prime!";
    }
    auto t_end = std::chrono::high_resolution_clock::now();

    double elapsed_time_ms = std::chrono::duration<double, std::milli>(t_end-t_start).count();
    std::cout<<"It took: "<< elapsed_time_ms << " ms";

    ///Kod na GPU
    int64_cu prime, root; 
    bool czyjest;
    int64_cu *d_prime, *d_root;
    bool *czy;
    int64_cu size = N * sizeof(int64_cu);
    int size2 = sizeof(bool);

    ///Allocate space for devices copies
    cudaMalloc((void **)&d_prime, size);
    cudaMalloc((void **)&d_root, size);
    cudaMalloc((void **)&czy, size2);

    std::cout<<"Podaj liczbę do sprawdzenia: ";
    std::cin>>prime;
    root = sqrt(prime);

    t_start = std::chrono::high_resolution_clock::now();

    cudaMemcpy(d_prime, &prime, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_root, &root, size, cudaMemcpyHostToDevice);
    
    is_prime<<<N,1>>>(d_prime, d_root, czy);

    cudaMemcpy(&czyjest, czy, size2, cudaMemcpyDeviceToHost);

    cudaFree(d_prime); cudaFree(czy); cudaFree(d_root);
    if(czyjest){
        std::cout<<"To jest liczba pierwsza!";
    }
    else std::cout<<"To nie jest liczba pierwsza!";

    t_end = std::chrono::high_resolution_clock::now();
    
    elapsed_time_ms = std::chrono::duration<double, std::milli>(t_end-t_start).count();
    std::cout<<"It took: "<<elapsed_time_ms<<" ms!";

    return 0;
}