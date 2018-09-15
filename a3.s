/* Marcus Tang 10086730 *credit to Sarah in tutorial T05*
Designed to place random numbers into a array, and then insert sort them from
smallest to largest*/

before:    .asciz "before [%d] = %d\n"
           .align 4
after:     .asciz "after [%d] = %d\n"
           .align 4
















array = -160

.global main
main:
     save  %sp, (-92 + -160) & -8, %sp  ! Where -160 is 4*40
     set   0, %l3  ! The for loop count


loop:
     cmp   %l3, 40          ! Compares count to count limit
     be,a  Sort_guard     ! Branches to end if count equals count limit
     set   1, %l3
     call  rand           ! Provides a random number to %o0
     nop
     and   %o3, 0xFF, %o3 ! random number mod 256

set_values:
     mov   %l3, %l4
     sll   %l4, 2, %l4    ! mulitply -1 by 4 to create offset
     add   %l4, array, %l4! add the offset to the array
     st    %o3, [%fp + %l4] ! Storing result into next avaliable -1 in array
     set   before, %o0
     mov   %l3, %o1
     mov   %o3, %o2          ! Prints elements before the sort
     call  printf
     nop
     inc   %l3                  ! Increases the count for the loop
     ba    loop               ! Goes back to loop guard
     nop

Sort_guard:
    cmp    %l3, 40                ! To see if it ran 40 times
  	be,a   spitout_val          ! Goes to print values if sorting is finished
    set    0, %l3
  	mov    %l3, %l0 ! Move %l3 into %l0 ! To make %l0 the same value as %l3

Sorting:
   sub    %l0, 1, %l1              ! Becomes a temp for %l0-1
	 sll    %l1, 2, %l2         ! Mulitiplies %l0-1 temp by 4 for address
	 sll    %l0, 2, %l5             ! Multiplies %l0 by 4 for address
	 add    %l2, array, %l2  ! Uses the offset from %l0-1
	 add    %l5, array, %l5      ! Uses the offset from %l0
	 ld     [%fp + %l2], %o0   ! Getting the value from %l0-1, and store in %o0
	 ld     [%fp + %l5], %o1     ! Getting the value from %l0, and store in %o1
	 cmp    %o0, %o1           ! Compares the values from %l0-1 and %l0
	 ble,a  Sort_guard            ! Goes back to guard if no swap is needed
	 inc    %l3

Swap:
  mov  %o1, %o2           ! placing the -1 %l0 value in a temp
	mov   %o0, %o1         ! swapping the value of %l0-1 value into %l0
	mov   %o2 , %o0         ! using temp to replace the %l0-1 value
	st    %o1, [%fp + %l5]      ! Stores value from %l0-1 into %l0
  st    %o0, [%fp + %l2] ! Stores value from %l0 into %l0-1
  sub   %l0, 1, %l0                ! To see if there is more that need to be swapped
  cmp   %l0, 0
  bne   Sorting                ! Goes back to sort if more elements need comparing
  nop
  ba  Sort_guard               ! Goes back to guard all elements are compared
  inc   %l3



spitout_val:
    mov   %l3, %l4              ! Gives the -1
    sll   %l4, 2, %l4       ! Multiplies the -1 by 4 to create offset
    add   %l4, array, %l4   ! Adds the offset to the array
    ld    [%fp + %l4], %o2  ! Stores the element into %o2
    mov   %l3, %o1             ! Stores -1 into %o1
    set   after, %o0            ! Prints elements after sort
    call  printf
    inc   %l3



done:
    cmp   %l3, 40
    bl    spitout_val         ! To see if all the elements in array print off
    nop

    mov     1, %g1    ! Ending the program
    ta      0
