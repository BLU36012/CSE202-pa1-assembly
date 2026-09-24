.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
    xorl    %eax, %eax          # %eax = 0
    movl    %esi, %ecx          # %ecx = %esi
    decl    %ecx                # %ecx = n - 1

.loop:
    cmpl    %ecx, %eax          # compare lo and hi
    jg      .not_found          # if lo > hi, jump to not_found

    movl    %ecx, %r8d
    subl    %eax, %r8d          # %r8d = hi - lo
    sarl    $1, %r8d            # r8d = (hi - lo) / 2
    addl    %eax, %r8d          # %r8d = mid

    movslq  %r8d, %r9           # sign-extend mid to 64-bit for memory indexing
    movl    (%rdi,%r9,4), %r10d # %r10d = arr[mid] 
    cmpl    %edx, %r10d         # compare arr[mid] with target (%edx)
    je      .found              # jump to .found if arr[mid] == target
    jl      .less               # jump to .less if arr[mid] < target
    movl    %r8d, %ecx          # %ecx = mid
    decl    %ecx                # hi = mid - 1
    jmp     .loop

.less:
    movl    %r8d, %eax          # %eax = mid
    incl    %eax                # %eax = mid + 1
    jmp     .loop

.found:
    movl    %r8d, %eax          # return mid
    ret

.not_found:
    movl    $-1, %eax           # %eax = -1
    ret


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
