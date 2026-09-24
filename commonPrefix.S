.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
   xorl    %eax, %eax          # %eax = 0 (return value in %eax)

.loop:
    movzbq  (%rdi,%rax), %rcx  # %rcx = a[n] (load char a[n] into %rcx)
    testb   %cl, %cl           # check if a[n] == 0
    je      .Ldone             # if zero, jump to done

    movzbq  (%rsi,%rax), %rdx  # %rdx = b[n] (load char b[n] into %rdx)
    cmpb    %dl, %cl           # compare a[n] and b[n]
    jne     .Ldone             # if a[n] != b[n], jump to done

    incq    %rax               # %rax = n++
    jmp     .loop              # repeat

.Ldone:
    retq                        # return n (%eax)


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
