.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl    $2, %edi          # compare n with 2
  jl      .not_prime        # if n < 2, jump to not_prime
  testl   $1, %edi          # check if n is even
  jz      .check_two        # if n is even, jump to check_two
  movl    $3, %ecx          # %ecx = i = 3 (start checking from 3)
  jmp     .loop               # jump to the loop to check for odd divisors
.check_two:
  cmpl    $2, %edi          # compare n with 2
  je      .is_prime         # if n == 2, jump to is_prime
  jmp     .not_prime        # if n is even and not 2, jump to not_prime
.loop:
  movl    %ecx, %esi        # %esi = i (temporary storage for i)
  imull   %ecx, %ecx        # %ecx = i * i
  cmpl    %edi, %ecx        # compare i * i with n
  jle     .inner_if          # if i * i <= n, jump to inner_if
  jmp     .is_prime          # if i * i > n, jump to is_prime
.inner_if:
  movl  %esi, %ecx          # restore i from temporary storage %ecx = i
  movl   %edi, %eax         # %eax = n for division on next line
  cltd                       # sign extend %eax to %edx:%eax for division
  idivl   %ecx               # divide n by i, quotient in %eax, remainder in %edx
  addl   $2, %ecx           # increment i by 2
  testl   %edx, %edx        # check if remainder is 0
  jz      .not_prime        # if n % i == 0, jump to not_prime
  jmp     .loop             # repeat the loop
.is_prime:
  movl    $1, %eax           # %eax = 1 (set result to 1, indicating prime)
  jmp .done                  # Jumps to done after setting result to 1
.not_prime:
  movl    $0, %eax           # %eax = 0 (set result to 0, indicating not prime)
  jmp .done                  # Jumps to done after setting result to 0
.done:
  ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
