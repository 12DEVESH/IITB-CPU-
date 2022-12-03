#project discription

IITB-CPU is a 16-bit very simple computer developed for the teaching that is based on the Little 
Computer Architecture. The IITB-CPU is an 8-register, 16-bit computer system. It has 8 general-purpose 
registers (R0 to R7). Register R7 is always stores Program Counter. PC points to the next instruction. All 
addresses are short word addresses (i.e. address 0 corresponds to the first two bytes of main memory, 
address 1 corresponds to the second two bytes of main memory, etc.). This architecture uses condition 
code register which has two flags Carry flag (c) and Zero flag (z). The IITB-CPU is very simple, but it is 
general enough to solve complex problems. The architecture allows predicated instruction execution 
and multiple load and store execution. There are three machine-code instruction formats (R, I, and J
type) and a total of 14 instructions.

INSTRUCTION FORMAT: 

![instruction format](https://user-images.githubusercontent.com/96682968/205432219-4e4b40e3-d1f2-45f0-9a7e-0576e0d482a4.PNG)
INSTRUCTION ENCODING:

![intr encoding](https://user-images.githubusercontent.com/96682968/205432344-3f71f228-0cca-4aed-ad07-68f8cb70839f.PNG)
INSTRUCTION DESCRIPTION:

![instr desc](https://user-images.githubusercontent.com/96682968/205432453-7139b63a-f554-454f-a9f7-7a48e9920bf3.PNG)
![instr desc2](https://user-images.githubusercontent.com/96682968/205432462-cae834a1-e383-4959-b173-df042aa8b84d.PNG)
