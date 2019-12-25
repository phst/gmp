// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <gmp.h>

int main(void) {
  mpz_t z;
  mpz_init_set_ui(z, 1);
  mpz_add(z, z, z);
  fputs("1 + 1 = ", stdout);
  mpz_out_str(stdout, 10, z);
  putchar('\n');
  bool ok = mpz_cmp_ui(z, 2) == 0;
  mpz_clear(z);
  return ok ? EXIT_SUCCESS : EXIT_FAILURE;
}
