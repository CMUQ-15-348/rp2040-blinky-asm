.syntax unified
.cpu cortex-m0plus
.thumb_func
.global main

.section .reset, "ax"
// I want my reset code to just call main
b main