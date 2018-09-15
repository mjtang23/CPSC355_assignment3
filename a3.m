/* Marcus Tang 10086730 *credit to Sarah in tutorial T05*
Designed to place random numbers into a array, and then insert sort them from
smallest to largest*/

before:    .asciz "before [%d] = %d\n"
           .align 4
after:     .asciz "after [%d] = %d\n"
           .align 4

define(local_var, `define(last_sym, 0)')
define(`var', `define(`last_sym', eval((last_sym - ifelse($3,,$2,$3)) & -$2))$1 = last_sym')
define(i, %l3)
define(j, %l0)
define(j_1, %l1)
define(j_1add, %l2)
define(jadd, %l5)
define(adres, %l4)
define(jtemp, %o2)
define(prev_j, %o0)
define(pres_j, %o1)
define(rand_val, %o3)


local_var
var(array, 4*40)

.global main
main:
     save  %sp, (-92 + last_sym) & -8, %sp  ! Where last_sym is 4*40
     set   0, i  ! The for loop count


loop:
     cmp   i, 40          ! Compares count to count limit
     be,a  Sort_guard     ! Branches to end if count equals count limit
     set   1, i
     call  rand           ! Provides a random number to %o0
     nop
     and   rand_val, 0xFF, rand_val ! random number mod 256

set_values:
     mov   i, adres
     sll   adres, 2, adres    ! mulitply index by 4 to create offset
     add   adres, array, adres! add the offset to the array
     st    rand_val, [%fp + adres] ! Storing result into next avaliable index in array
     set   before, %o0
     mov   i, %o1
     mov   rand_val, %o2          ! Prints elements before the sort
     call  printf
     nop
     inc   i                  ! Increases the count for the loop
     ba    loop               ! Goes back to loop guard
     nop

Sort_guard:
    cmp    i, 40                ! To see if it ran 40 times
  	be,a   spitout_val          ! Goes to print values if sorting is finished
    set    0, i
  	mov    i, j ! Move i into j ! To make j the same value as i

Sorting:
   sub    j, 1, j_1              ! Becomes a temp for j-1
	 sll    j_1, 2, j_1add         ! Mulitiplies j-1 temp by 4 for address
	 sll    j, 2, jadd             ! Multiplies j by 4 for address
	 add    j_1add, array, j_1add  ! Uses the offset from j-1
	 add    jadd, array, jadd      ! Uses the offset from j
	 ld     [%fp + j_1add], prev_j   ! Getting the value from j-1, and store in %o0
	 ld     [%fp + jadd], pres_j     ! Getting the value from j, and store in %o1
	 cmp    prev_j, pres_j           ! Compares the values from j-1 and j
	 ble,a  Sort_guard            ! Goes back to guard if no swap is needed
	 inc    i

Swap:
  mov  pres_j, jtemp           ! placing the index j value in a temp
	mov   prev_j, pres_j         ! swapping the value of j-1 value into j
	mov   jtemp , prev_j         ! using temp to replace the j-1 value
	st    %o1, [%fp + jadd]      ! Stores value from j-1 into j
  st    prev_j, [%fp + j_1add] ! Stores value from j into j-1
  sub   j, 1, j                ! To see if there is more that need to be swapped
  cmp   j, 0
  bne   Sorting                ! Goes back to sort if more elements need comparing
  nop
  ba  Sort_guard               ! Goes back to guard all elements are compared
  inc   i



spitout_val:
    mov   i, adres              ! Gives the index
    sll   adres, 2, adres       ! Multiplies the index by 4 to create offset
    add   adres, array, adres   ! Adds the offset to the array
    ld    [%fp + adres], jtemp  ! Stores the element into %o2
    mov   i, pres_j             ! Stores index into %o1
    set   after, %o0            ! Prints elements after sort
    call  printf
    inc   i



done:
    cmp   i, 40
    bl    spitout_val         ! To see if all the elements in array print off
    nop

    mov     1, %g1    ! Ending the program
    ta      0
