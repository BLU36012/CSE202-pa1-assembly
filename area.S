.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl    %edi, %eax       # %eax = a
    addl    %esi, %eax       # %eax = a + b
    addl    %edx, %eax       # %eax = a + b + c
    shrl    $1, %eax         # %eax = (a + b + c) / 2 (left shift bivides by 2)
    movl    %eax, %ebx       # %ebx = p
    movl    %ebx, %ecx       # %ecx = p
    subl    %edi, %ecx       # %ecx = p - a
    movl    %ebx, %edx       # %edx = p
    subl    %esi, %edx       # %edx = p - b
    movl    %ebx, %r8d        # %r8d = p
    subl    %edi, %r8d       # %r8d = p - c
    imull   %ecx, %eax       # %eax = p * (p - a)
    imull   %edx, %eax       # %eax = p * (p - a) * (p - b)
    imull   %r8d, %eax       # %eax = p * (p - a) * (p - b) * (p - c)
sqrt_recursive:
    cmpl    $0, %eax         # p-0 comparison
    jl      .negative1       # if p < 0, jump to negative1
    cmpl    $2, %eax         # if p < 2, jump to return p
    jl      .done            #return p if p < 2
    movl    %eax, %ebx       # %ebx = p (temp variable for recursive call)
    shrl    $2, %ebx         # %ebx = p >> 2 (divide by 4)
    call    sqrt_recursive   # recursive call to calculate r_sqrt(p >> 2)
    shll    $1, %ebx         # %ebx = r_sqrt(p >> 2) << 1 (multiply by 2)
    movl    %eax, %ebx       # %ebx = r_sqrt(p >> 2) << 1 (small candidate)
    addl    $1, %ebx         # %ebx = small_cand + 1 (large candidate)
    imull   %ebx, %ebx       # %ebx = large_cand * large_cand
    cmpl    %eax, %ebx       # compare large_cand * large_cand with p
    cmovg   %eax, %eax       # if large_cand * large_cand > p, return small_cand
    cmpl    %eax, %ebx       # compare large_cand * large_cand with p
    cmovle  %ebx, %eax       # if large_cand * large_cand <= p,move large_cand to %eax
    jmp     .done
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
