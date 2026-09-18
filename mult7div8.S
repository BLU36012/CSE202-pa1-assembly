.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movsbl  %dil, %eax       # sign extend a to 32 bits
  imul    $7, %eax         # multiply by 7
  cmpl    $127, %eax       # check for overflow (greater than 127)
  jg      .overflow         # if greater than 127, jump to overflow
  cmpl    $-128, %eax      # check for overflow (less than -128)
  jl      .overflow         # if less than -128, jump to overflow
  movb    $0, (%rsi)       # set overflow to 0
  jmp     .done            # jump over the overflow block
.overflow:
  movb    $1, (%rsi)       # set overflow to 1
.done:
  sar     $3, %eax          # divide by 8 (arithmetic shift right)
  retq


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
