|; void heapify(int* array, int size, int index)
|;   @param array A pointer to the array
|;   @param size Size of the array 
|;   @param index Index in array
heapify:
  PUSH(LP) PUSH(BP)
  MOVE(SP, BP)

  PUSH(R1) PUSH(R2) PUSH(R3)
  PUSH(R4) PUSH(R5) PUSH(R6)
  PUSH(R7) PUSH(R8) PUSH(R9)
  LD(BP, -12, R1) |; R1 <- 'array'
  LD(BP, -16, R2) |; R2 <- 'size'
  LD(BP, -20, R3) |; R3 <- 'index'
  
heapify_loop:
  CMPLT(R3, R2, R0) |; break condition: 'index < size'
  BF(R0, heapify_end_loop) |; if break condition occurs

  MOVE(R3, R4) |; R4 <- 'largest = index'

  |; R5 <- 'left = index * 2 + 1'
  MULC(R3, 2, R0)
  ADDC(R0, 1, R0)
  MOVE(R0, R5)

  |; R6 <- 'right = (index + 1) * 2'
  ADDC(R3, 1, R0)
  MULC(R0, 2, R0)
  MOVE(R0, R6)

  |; heapify first if
  |; 'left < size'
  CMPLT(R5, R2, R0)

  LDARR(R1, R4, R7) |; R7 <- 'array[largest]'
  LDARR(R1, R5, R8) |; R8 <- 'array[left]'
  CMPLT(R7, R8, R9) |; 'array[largest] < array[left]'

  |; 'left < size && array[largest] < array[left]'
  AND(R0, R9, R0)
  |; if 'left < size && array[largest] < array[left]' true
  BF(R0, heapify_second_if)

  MOVE(R5, R4) |; 'largest = left'

heapify_second_if:
  |; 'right < size'
  CMPLT(R6, R2, R0)

  LDARR(R1, R4, R7) |; R7 <- 'array[largest]'
  LDARR(R1, R6, R8) |; R8 <- 'array[right]'
  CMPLT(R7, R8, R9) |; 'array[largest] < array[right]'

  |; 'right < size && array[largest] < array[right]'
  AND(R0, R9, R0)
  |; if 'right < size && array[largest] < array[right]' true
  BF(R0, heapify_third_if)

  MOVE(R6, R4) |; 'largest = right'

heapify_third_if: 
  CMPEQ(R4, R3, R0) |; largest != index

  |; if 'largest != index' false
  BT(R0, heapify_end_loop)

  ADDR(R1, R4, R0) |; 'array + largest' in R0
  ADDR(R1, R3, R7) |; R7 <- 'array + index' in R7
  |; 'swap(array + largest , array + index)'
  SWAP(R0, R7, R8, R9) |; R8 and R9 = Rtmps

  MOVE(R4, R3) |; index = largest

  BR(heapify_loop)
    
heapify_end_loop:
  |; void type, just pop everything
  POP(R9) POP(R8) POP(R7)
  POP(R6) POP(R5) POP(R4)
  POP(R3) POP(R2) POP(R1)
  POP(BP) POP(LP)
  RTN()


|; void heapsort(int* array, int size)
|;   @param array A pointer to the array
|;   @param size Size of the array 
heapsort:
  PUSH(LP) PUSH(BP)
  MOVE(SP, BP)
  
  PUSH(R1) PUSH(R2) PUSH(R3)
  PUSH(R4) PUSH(R5)
  LD(BP, -12, R1) |; R1 <- 'array'
  LD(BP, -16, R2) |; R2 <- 'size'

  |; R3 <- 'i = (size/2) - 1'
  DIVC(R2, 2, R0)
  SUBC(R0, 1, R3)

heapsort_first_loop:
  CMPLE(R31, R3, R0) |; 'i >= 0'
  BF(R0, heapsort_first_loop_end) |; if 'i >= 0' false

  |; if 'i >= 0' true
  PUSH(R3) |; push 'i' 3rd arg of heapify 
  PUSH(R2) |; push 'size' 2nd arg of heapify 
  PUSH(R1) |; push 'array' 1st arg of heapify 
  CALL(heapify, 3) |; call array_max function with 2 args

  SUBC(R3, 1, R3) |; '--i'
  BR(heapsort_first_loop)

heapsort_first_loop_end:
  |; R3 <- 'i = size - 1'
  SUBC(R2, 1, R3)

heapsort_second_loop:
  CMPLT(R31, R3, R0) |; 'i > 0'
  BF(R0, heapsort_end) |; if 'i > 0' false

  |; if 'i > 0' true
  ADDR(R1, R3, R0) |; 'array + i' in R0
  |; 'swap(array , array + i)'
  SWAP(R1, R0, R4, R5) |; R4 and R5 = Rtmps

  PUSH(R31) |; push '0' 3rd arg of heapify 
  PUSH(R3) |; push 'i' 2nd arg of heapify 
  PUSH(R1) |; push 'array' 1st arg of heapify 
  CALL(heapify, 3) |; call array_max function with 2 args 

  SUBC(R3, 1, R3) |; '--i'
  BR(heapsort_second_loop)

heapsort_end:
  |; void type, just pop everything
  POP(R5) POP(R4)
  POP(R3) POP(R2) POP(R1)
  POP(BP) POP(LP)
  RTN()
  