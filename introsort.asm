|; int median3(int* array, int n)
|;   @param array A pointer to the array
|;   @param n Size of the array
median3:
  PUSH(LP) PUSH(BP)
  MOVE(SP, BP)
  
  PUSH(R1) PUSH(R2)
  PUSH(R3) PUSH(R4)
  LD(BP, -12, R1) |; R1 <- 'array'
  LD(BP, -16, R2) |; R2 <- 'n'

  LDARR(R1, R31, R3) |; R3 <- 'a = array[0]'

  |; R4 <- 'b = array[n / 2]'
  DIVC(R2, 2, R0)
  LDARR(R1, R0, R4)

  |; R2 <- 'c = array[n - 1]'
  SUBC(R2, 1, R0)
  LDARR(R1, R0, R2)

|; median3_parent_if 
  CMPLT(R3, R4, R0) |; 'a < b'
  BF(R0, median3_parent_else_if) |; if 'a < b' false

|; median3_first_child_if - if 'a < b' true
  CMPLT(R4, R2, R0) |; 'b < c'
  BF(R0, median3_first_child_else_if) |; if 'b < c' false

  |; if 'b < c' true
  MOVE(R4, R0) |; return b;
  BR(median3_end)

median3_first_child_else_if:
  CMPLT(R3, R2, R0) |; 'a < c'
  BF(R0, median3_first_child_else) |; if 'a < c' false

  |; if 'a < c' true
  MOVE(R2, R0) |; return c;
  BR(median3_end)

median3_first_child_else:
  MOVE(R3, R0) |; return a;
  BR(median3_end)

median3_parent_else_if:
  CMPLT(R4, R2, R0) |; 'b < c'
  BF(R0, median3_parent_else) |; if 'b < c' false

|; median3_second_child_if - if 'b < c' true
  CMPLT(R3, R2, R0) |; 'a < c'
  BF(R0, median3_second_child_else) |; if 'a < c' false

  |; if 'a < c' true
  MOVE(R3, R0) |; return a;
  BR(median3_end)

median3_second_child_else:
  MOVE(R2, R0) |; return c;
  BR(median3_end)

median3_parent_else:
  MOVE(R4, R0) |; return b;
  |; BR(median3_end)

median3_end:
  POP(R4) POP(R3)
  POP(R2) POP(R1)
  POP(BP) POP(LP)
  RTN()


|; void introsort(int* array, int size, int maxd)
|;   @param array A pointer to the array
|;   @param size Size of the array
|;   @param maxd Maximum number of recursive calls
introsort:
  PUSH(LP) PUSH(BP)
  MOVE(SP, BP)

  PUSH(R1) PUSH(R2)
  PUSH(R3) PUSH(R4)
  PUSH(R5) PUSH(R6)
  PUSH(R7) PUSH(R8)
  PUSH(R9) PUSH(R10)
  LD(BP, -12, R1) |; R1 <- 'array'
  LD(BP, -16, R2) |; R2 <- 'n'
  LD(BP, -20, R3) |; R3 <- 'maxd'

introsort_loop:
  CMPLEC(R2, 1, R0) |; break condition: 'n > 1'
  BT(R0, introsort_end_loop) |; if break condition occurs

  CMPLEC(R3, 0, R0) |; 'maxd <= 0'
  BF(R0, introsort_continue_loop) |; if 'maxd <= 0' false

  |; if 'maxd <= 0' true
  PUSH(R2) |; push 'n' 2nd arg of heapsort 
  PUSH(R1) |; push 'array' 1st arg of heapsort 
  CALL(heapsort, 2) |; call heapsort function with 2 args
  BR(introsort_end_loop)

introsort_continue_loop:
  SUBC(R3, 1, R3) |; 'maxd -= 1'

  |; 'pivot = median3(array, n)'
  PUSH(R2) |; push 'n' 2nd arg of median3 
  PUSH(R1) |; push 'array' 1st arg of median3 
  CALL(median3, 2) |; call median3 function with 2 args
  MOVE(R0, R4) |; R4 <- 'pivot'

  CMOVE(0, R5) |; R5 <- 'i = 0'
  CMOVE(0, R6) |; R6 <- 'l = 0'
  MOVE(R2, R7) |; R7 <- 'r = n'

introsort_inner_loop:
  CMPLT(R5, R7, R0) |; break condition: 'i < r'
  BF(R0, introsort_end_inner_loop) |; if break condition occurs

|; introsort_inner_loop_if:
  LDARR(R1, R5, R0) |; 'array[i]'
  CMPLT(R0, R4, R0) |; 'array[i] < pivot'
  BF(R0, introsort_inner_loop_else_if) |; if 'array[i] < pivot' false

  |; if 'array[i] < pivot' true
  ADDR(R1, R5, R0) |; 'array + i' in R0
  ADDR(R1, R6, R8) |; 'array + l' in R8
  |; 'swap(array + i, array + l)'
  SWAP(R0, R8, R9, R10) |; R9 and R10 = Rtmps

  ADDC(R5, 1, R5) |; 'i += 1'
  ADDC(R6, 1, R6) |; 'l += 1'

  BR(introsort_inner_loop)

introsort_inner_loop_else_if:
  LDARR(R1, R5, R0) |; 'array[i]'
  CMPLT(R4, R0, R0) |; 'array[i] > pivot'
  BF(R0, introsort_inner_loop_else) |; if 'array[i] > pivot' false

  |; if 'array[i] > pivot' true
  SUBC(R7, 1, R7) |; 'r -= 1'

  ADDR(R1, R5, R0) |; 'array + i' in R0
  ADDR(R1, R7, R8) |; 'array + r' in R8
  |; 'swap(array + i, array + r)'
  SWAP(R0, R8, R9, R10) |; R9 and R10 = Rtmps

  BR(introsort_inner_loop)

introsort_inner_loop_else:
  ADDC(R5, 1, R5) |; 'i += 1'
  BR(introsort_inner_loop)

introsort_end_inner_loop:
  PUSH(R3) |; push 'maxd' 3rd arg of introsort 
  PUSH(R6) |; push 'l' 2nd arg of introsort 
  PUSH(R1) |; push 'array' 1st arg of introsort 
  CALL(introsort, 3) |; call introsort function with 3 args

  |; ADD(R1, R7, R1) |; 'array += r'
  |; 'array += r'
  ADDR(R1, R7, R0)
  MOVE(R0, R1)

  SUB(R2, R7, R2) |; 'n -= r'

  BR(introsort_loop)

introsort_end_loop:
  |; void type, just pop everything
  POP(R10) POP(R9)
  POP(R8) POP(R7)
  POP(R6) POP(R5)
  POP(R4) POP(R3)
  POP(R2) POP(R1)
  POP(BP) POP(LP)
  RTN()


|; void sort(int* array, int size)
|;   @param array A pointer to the array
|;   @param size Size of the array 
sort:
  PUSH(LP) PUSH(BP)
  MOVE(SP, BP)
  
  PUSH(R1) PUSH(R2) |;PUSH(R3)
  LD(BP, -12, R1) |; R1 <- 'array'
  LD(BP, -16, R2) |; R2 <- 'size'

  CMPEQC(R2, 0, R0) |; 'size == 0'
  BT(R0, sort_end) |; if 'size == 0' true

  |; if 'size == 0' false
  PUSH(R2) |; push 'size' only arg of log2 
  CALL(log2, 1) |; call log2 function with 1 arg
  MULC(R0, 2, R0) |; R0 <- 'maxd = 2 * (int)log2(size)'

  PUSH(R0) |; push 'maxd' 3rd arg of introsort 
  PUSH(R2) |; push 'size' 2nd arg of introsort 
  PUSH(R1) |; push 'array' 1st arg of introsort 
  CALL(introsort, 3) |; call introsort function with 3 args

sort_end:
  |; void type, just pop everything
  |; POP(R3) 
  POP(R2) POP(R1)
  POP(BP) POP(LP)
  RTN()
