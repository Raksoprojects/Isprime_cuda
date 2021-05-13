#include <iostream>
#include <math.h>
#include <chrono>

bool is_prime(int64_t p){

    if(p<2) return false;
    if(p % 2 == 0) return false;

    for(int64_t k = 3; k <= sqrt(p); k = k + 2){
        if(p % k == 0) return false;
    }
    return true;
}

int main(){
    int64_t test = 0;
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
}