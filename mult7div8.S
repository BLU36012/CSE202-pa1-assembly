.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl  %dil, %eax       # %eax = (signed) a
  imul    $7, %eax         # %eax = 7 * a
  cmpl    $127, %eax       # compare result with 127 (max signed char)
  jg      .overflow        # if greater than 127, jump to overflow
  cmpl    $-128, %eax      # check for overflow (less than -128)
  jl      .overflow        # if less than -128, jump to overflow
  movb    $0, (%rsi)       # %rsi = 0 (set overflow to 0)
  jmp     .done            # jump over the overflow block if no overflow occurred
.overflow:
  movb    $1, (%rsi)       # %rsi = 1 (set overflow to 1)
.done:
  movsbl  %al, %eax        # %eax = (signed) mult (truncate to signed char)
  testl   %eax, %eax       # %eax & %eax (check if mult is negative)
  jns     .pos             # if positive/zero, skip bias
  addl    $7, %eax         # %eax = mult + 7 (bias for negative numbers)
.pos:
  sar     $3, %eax         # divide by 8 (arithmetic shift right)
  retq


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
