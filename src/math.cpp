// src/math.cpp
// Minimal example: two exported functions
#include <stdint.h>

extern "C" {
  int32_t add(int32_t a, int32_t b) { return a + b; }
  int32_t fib(int32_t n) {
    if (n <= 1) return n;
    int32_t a = 0, b = 1;
    for (int32_t i = 2; i <= n; ++i) {
      int32_t tmp = a + b;
      a = b; b = tmp;
    }
    return b;
  }
}
