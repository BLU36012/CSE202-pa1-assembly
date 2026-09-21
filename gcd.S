.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    cmpl    $0, %esi         # compare b with 0
    je      .base_case       # if b == 0, jump to base_case
    movl    %edi, %eax       # %eax = a
    cdq                      # sign extend %eax to %edx:%eax for division
    idivl   %esi             # %eax = a / b, %edx = a % b
    movl    %esi, %edi       # %edi = b (1st argument for recursive call)
    movl    %edx, %esi       # %esi = a % b (2nd argument for recursive call)
    pushq   %rbx             # save %rbx on stack
    movl    %esi, %ebx       # move b to %ebx
    call    gcd              # recursive call to gcd(b, a % b)
    popq    %rbx             # restore %rbx from stack
    retq
.base_case:
    movl    %edi, %eax       # move a to result register %eax
    jmp     .done              # jump to done
.done:
    retq


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
