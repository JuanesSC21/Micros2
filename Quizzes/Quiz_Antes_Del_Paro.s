;-----------------------------------------------------------
;Hacer un programa en ensamblador que recibe la dirección 'd' de memoria donde comienza un vector en R3.
;
;     |<d>  |
; V=  |<d+4>|
;     |<d+8>|
;
;tambien recibe la dirección 'e' donde escribe la magnitud al cuadrado del vector
;             2
;        | x |
;|V|^2=  | y |  = x^2 + y^2 + z^2
;        | z |
;
;Solución:
:-------------------------------------------------------------

0x00    LD R3,[R1+0]  ; X
0x04    SMUL R4,R3,R3 ; X^2
0x08    LD R3,[R1+4]  ; Y
0x0C    SMUL R5,R3,R3 ; Y^2
0x10    LD R3,[R1+8]  ; Z
0x14    SMUL R3,R3,R3 ; Z^2
0x18    ADD R3,R3,R4  ; Z^2+X^2
0x1C    ADD R3,R3,R5  ; Z^2+X^2+Y^2
0x20    LD [R2+0],R3  ; 

