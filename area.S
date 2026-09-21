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
