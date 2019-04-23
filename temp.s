/* -- matmul.s */
.data
mat_A: .float 0.1, 0.2, 0.0, 0.1
       .float 0.2, 0.1, 0.3, 0.0
       .float 0.0, 0.3, 0.1, 0.5 
       .float 0.0, 0.6, 0.4, 0.1
mat_B: .float  4.92,  2.54, -0.63, -1.75
       .float  3.02, -1.51, -0.87,  1.35
       .float -4.29,  2.14,  0.71,  0.71
       .float -0.95,  0.48,  2.38, -0.95
mat_C: .float 0.0, 0.0, 0.0, 0.0
       .float 0.0, 0.0, 0.0, 0.0
       .float 0.0, 0.0, 0.0, 0.0
       .float 0.0, 0.0, 0.0, 0.0
       .float 0.0, 0.0, 0.0, 0.0
 
format_result : .asciz "Matrix result is:\n%5.2f %5.2f %5.2f %5.2f\n%5.2f %5.2f %5.2f %5.2f\n%5.2f %5.2f %5.2f %5.2f\n%5.2f %5.2f %5.2f %5.2f\n"
 
.text
 
naive_matmul_4x4:
    /* r0 address of A
       r1 address of B
       r2 address of C
    */
    push {r4, r5, r6, r7, r8, lr} /* Keep integer registers */
    /* First zero 16 single floating point */
    /* In IEEE 754, all bits cleared means 0 */
    mov r4, r2
    mov r5, #16
    mov r6, #0
    b .Lloop_init_test
    .Lloop_init :
      str r6, [r4], +#4   /* *r4 ← r6 then r4 ← r4 + 4 */
    .Lloop_init_test:
      subs r5, r5, #1
      bge .Lloop_init
 
    /* We will use 
           r4 as i
           r5 as j
           r6 as k
    */
    mov r4, #0 /* r4 ← 0 */
    .Lloop_i:  /* loop header of i */
      cmp r4, #4  /* if r4 == 4 goto end of the loop i */
      beq .Lend_loop_i
      mov r5, #0  /* r5 ← 0 */
      .Lloop_j: /* loop header of j */
       cmp r5, #4 /* if r5 == 4 goto end of the loop j */
        beq .Lend_loop_j
        /* Compute the address of C[i][j] and load it into s0 */
        /* Address of C[i][j] is C + 4*(4 * i + j) */
        mov r7, r5               /* r7 ← r5. This is r7 ← j */
        adds r7, r7, r4, LSL #2  /* r7 ← r7 + (r4 << 2). 
                                    This is r7 ← j + i * 4.
                                    We multiply i by the row size (4 elements) */
        adds r7, r2, r7, LSL #2  /* r7 ← r2 + (r7 << 2).
                                    This is r7 ← C + 4*(j + i * 4)
                                    We multiply (j + i * 4) by the size of the element.
                                    A single-precision floating point takes 4 bytes.
                                    */
        vldr s0, [r7] /* s0 ← *r7 */
 
        mov r6, #0 /* r6 ← 0 */
        .Lloop_k :  /* loop header of k */
          cmp r6, #4 /* if r6 == 4 goto end of the loop k */
          beq .Lend_loop_k
 
          /* Compute the address of a[i][k] and load it into s1 */
          /* Address of a[i][k] is a + 4*(4 * i + k) */
          mov r8, r6               /* r8 ← r6. This is r8 ← k */
          adds r8, r8, r4, LSL #2  /* r8 ← r8 + (r4 << 2). This is r8 ← k + i * 4 */
          adds r8, r0, r8, LSL #2  /* r8 ← r0 + (r8 << 2). This is r8 ← a + 4*(k + i * 4) */
          vldr s1, [r8]            /* s1 ← *r8 */
 
          /* Compute the address of b[k][j] and load it into s2 */
          /* Address of b[k][j] is b + 4*(4 * k + j) */
          mov r8, r5               /* r8 ← r5. This is r8 ← j */
          adds r8, r8, r6, LSL #2  /* r8 ← r8 + (r6 << 2). This is r8 ← j + k * 4 */
          adds r8, r1, r8, LSL #2  /* r8 ← r1 + (r8 << 2). This is r8 ← b + 4*(j + k * 4) */
          vldr s2, [r8]            /* s1 ← *r8 */
 
          vmul.f32 s3, s1, s2      /* s3 ← s1 * s2 */
          vadd.f32 s0, s0, s3      /* s0 ← s0 + s3 */
 
          add r6, r6, #1           /* r6 ← r6 + 1 */
          b .Lloop_k               /* next iteration of loop k */
        .Lend_loop_k: /* Here ends loop k */
        vstr s0, [r7]            /* Store s0 back to C[i][j] */
        add r5, r5, #1  /* r5 ← r5 + 1 */
        b .Lloop_j /* next iteration of loop j */
       .Lend_loop_j: /* Here ends loop j */
       add r4, r4, #1 /* r4 ← r4 + 1 */
       b .Lloop_i     /* next iteration of loop i */
    .Lend_loop_i: /* Here ends loop i */
 
    pop {r4, r5, r6, r7, r8, lr}  /* Restore integer registers */
    bx lr /* Leave function */
 
 
.globl main
main:
    push {r4, r5, r6, lr}  /* Keep integer registers */
    vpush {d0-d1}          /* Keep floating point registers */
 
    /* Prepare call to naive_matmul_4x4 */
    ldr r0, addr_mat_A  /* r0 ← a */
    ldr r1, addr_mat_B  /* r1 ← b */
    ldr r2, addr_mat_C  /* r2 ← c */
    bl naive_matmul_4x4
 
    /* Now print the result matrix */
    ldr r4, addr_mat_C  /* r4 ← c */
 
    vldr s0, [r4] /* s0 ← *r4. This is s0 ← c[0][0] */
    vcvt.f64.f32 d1, s0 /* Convert it into a double-precision
                           d1 ← s0
                         */
    vmov r2, r3, d1      /* {r2,r3} ← d1 */
 
    mov r6, sp     /* Remember the stack pointer, we need it to restore it back later */
                   /* r6 ← sp */
 
    mov r5, #1  /* We will iterate from 1 to 15 (because the 0th item has already been handled */
    add r4, r4, #60 /* Go to the last item of the matrix c, this is c[3][3] */
    .Lloop:
        vldr s0, [r4] /* s0 ← *r4. Load the current item */
        vcvt.f64.f32 d1, s0 /* Convert it into a double-precision
                               d1 ← s0
                             */
        sub sp, sp, #8      /* Make room in the stack for the double-precision */
        vstr d1, [sp]       /* Store the double precision in the top of the stack */
        sub r4, r4, #4      /* Move to the previous element in the matrix */
        add r5, r5, #1      /* One more item has been handled */
        cmp r5, #16         /* if r5 != 16 go to next iteration of the loop */
        bne .Lloop
 
    ldr r0, addr_format_result /* r0 ← &format_result */
    bl printf /* call printf */
    mov sp, r6  /* Restore the stack after the call  */
 
    mov r0, #0
    vpop {d0-d1}
    pop {r4, r5, r6, lr}
    bx lr
 
addr_mat_A : .word mat_A
addr_mat_B : .word mat_B
addr_mat_C : .word mat_C
addr_format_result : .word format_result
