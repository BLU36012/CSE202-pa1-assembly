.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    testl   %ecx, %ecx          # Check if size == 0
    jz      .done               # If size == 0, return immediately
    xorq    %r8, %r8            # %r8 = loop index i = 0
.loop:
    movss   (%rdi, %r8, 4), %xmm0   # Load a[i] into %xmm0
    mulss   (%rsi, %r8, 4), %xmm0   # %xmm0 = a[i] * b[i]
    movss   %xmm0, (%rdx, %r8, 4)   # Store result in c[i]

    incq    %r8                     # i++
    cmpl    %ecx, %r8d              # Compare i with size
    jb      .loop                   # If i < size, repeat loop
.done:
    ret

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
