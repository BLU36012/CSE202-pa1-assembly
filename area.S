.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl    %edi, %eax       # %eax = a
    addl    %esi, %eax       # %eax = a + b
    addl    %edx, %eax       # %eax = a + b + c
    shrl    $1, %eax         # %eax = (a + b + c) / 2 (left shift bivides by 2)
    movl    %eax, %ecx       # %ecx = p
    subl    %edi, %ecx       # %ecx = p - a
    movl    %eax, %r8d       # %r8d = p
    subl    %esi, %r8d       # %r8d = p - b
    movl    %eax, %r9d       # %r8d = p
    subl    %edx, %r9d       # %r8d = p - c
    imull   %ecx, %eax       # %eax = p * (p - a)
    imull   %r8d, %eax       # %eax = p * (p - a) * (p - b)
    imull   %r9d, %eax       # %eax = p * (p - a) * (p - b) * (p - c)
    movl    %eax, %edi        # move p * (p - a) * (p - b) * (p - c) to %edi for sqrt_recursive
    call    sqrt_recursive   # call sqrt(p * (p - a) * (p - b) * (p - c))
    retq
sqrt_recursive:
    cmpl    $0, %edi         # x-0 comparison
    jl      .negative1       # if x < 0, jump to negative1
    cmpl    $2, %edi         # if x < 2, jump to return x
    jl      .base            # return x if x < 2
    pushq   %rbx             # save %rbx on stack
    movl    %edi, %ebx       # %ebx = x
    sarl    $2, %edi         # %edi = x >> 2 (divide by 4)
    call    sqrt_recursive   # recursive call to calculate r_sqrt(x >> 2)
    shll    $1, %eax         # %ebx = r_sqrt(x >> 2) << 1 (multiply by 2)
    leal   1(%rax), %ecx          # %ecx = small_cand + 1 (large candidate)
    movl    %ecx, %edx       # %edx = large_cand
    imull   %ecx, %edx       # %ebx = large_cand * large_cand
    cmpl    %ebx, %edx       # compare large_cand * large_cand with x
    cmovle  %ecx, %eax       # if large_cand * large_cand > x, return small_cand
    popq    %rbx             # restore %rbx from stack
    jmp     .done
.negative1:
    movl    $-1, %eax        # return -1 for negative input
    retq
.base:
    movl    %edi, %eax       # return p for p < 2
    retq
.done:
    retq

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
