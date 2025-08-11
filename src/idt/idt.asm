section .asm
global enable_interrupt
global disable_interrupt
global int21h
extern no_interrupt_handler
global no_interrupt
extern int21h_handler
global idt_load

idt_load:
    push ebp
    mov ebp,esp

    mov ebx,[ebp+8]
    lidt [ebx]

    pop ebp
    ret

int21h:
    pushad
    cli
    call int21h_handler
    popad
    sti 
    iret

no_interrupt:
    pushad
    cli
    call no_interrupt_handler
    popad
    sti 
    iret

enable_interrupt:
    sti  
    ret

disable_interrupt:
    cli  
    ret