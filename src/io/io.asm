section .asm

global insb
global insw

global outb
global outw

insb:
    PUSH ebp
    mov ebp,esp
    xor eax,eax
    mov edx,[ebp+8]
    in al,dx
    POP ebp
    ret

insw:
    PUSH ebp
    mov ebp,esp
    xor eax,eax
    mov edx,[ebp+8]
    in ax,dx
    POP ebp
    ret

outb:
    PUSH ebp
    mov ebp,esp
    mov eax,[ebp+12]
    mov edx,[ebp+8]
    out dx,al
    POP ebp
    ret

outw:
    PUSH ebp
    mov ebp,esp
    mov eax,[ebp+12]
    mov edx,[ebp+8]
    out dx,ax
    POP ebp
    ret