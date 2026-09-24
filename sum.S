.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    xorl    %eax, %eax          # total = 0
.loop:
    testq   %rdi, %rdi          # check if ptr == NULL
    jz      .done               # if ptr == NULL, jump to done
    addq    8(%rdi), %rax       # %rax += ptr->value
    movq    16(%rdi), %rdi      # %rdi = ptr->next
    jmp     .loop               # jump back to top of loop
.done:
    retq


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
