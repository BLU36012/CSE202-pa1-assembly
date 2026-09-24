.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
    xorl    %eax, %eax          # %eax = 0 (i = 0)
    movl    %esi, %ecx          # %ecx = n
    sarl    $1, %ecx            # %ecx = n / 2 (loop limit)
    cmpl    %ecx, %eax          # compare i and n/2
    jl      .loop               # if i < n/2, jump to loop 
    retq                        # return if array requires no reversing

.loop:
    movl    %esi, %r8d          # %r8d = n
    subl    %eax, %r8d          # %r8d = n - i
    decl    %r8d                # %r8d = n - i - 1
    movq    (%rdi,%rax,8), %rdx # %rdx = list[i]
    movq    (%rdi,%r8,8), %r9   # %r9 = list[n-i-1]
    movq    %r9, (%rdi,%rax,8)  # list[i] = list[n-i-1]
    movq    %rdx, (%rdi,%r8,8)  # list[n-i-1] = temp
    incl    %eax                # i++
    cmpl    %ecx, %eax          # compare i and n/2
    jl      .loop               # if i < n/2, jump back to top of loop

    retq                        # return when the loop finishes


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
