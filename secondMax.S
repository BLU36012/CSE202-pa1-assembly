.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
# We are going to use %r8w and %r9w to hold first and second (signed 16-bit)
secondMax:
  movw    %di, %r8w       # %r8w = v1
  movw    %si, %r9w       # %r9w = v2
  cmpw    %si, %di        # Compare v1 and v2
  cmovl   %si, %r8w       # If v1 < v2, first = v2
  cmovl   %di, %r9w       # If v1 < v2, second = v1
  cmpw    %dx, %r8w       # Compare v3 and first
  cmovl   %r8w, %r9w      # If v3 > first, second = first
  cmovl  %dx, %r8w       # If v3 > first, first = v3
  cmpw    %dx, %r9w       # Compare v3 and second
  cmovl   %dx, %r9w       # If v3 > second, second = v3
  cmpw    %cx, %r8w       # Compare v4 and first
  cmovl   %r8w, %r9w      # If v4 > first, second = first
  cmovl   %cx, %r8w       # If v4 > first, first = v4
  cmpw    %cx, %r9w       # Compare v4 and second
  cmovl   %cx, %r9w       # If v4 > second, second = v4
  movw    %r9w, %ax       # Move second to result
  retq

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
