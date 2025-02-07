digraph CDFG {
    node [shape=box];
    start [label="Start"]; end [label="End"];
    block0 [label="BasicBlock #0"]; instr0 [label="mflr r0"];
    instr1 [label="stwu r1,-48(r1)"];instr2 [label="stw r0,52(r1)"];
    instr3 [label="lwz r12,20(r14)"];instr4 [label="lwz r12,0(r12)"];
    instr5 [label="cmpwi r12,0"]; instr6 [label="bcl 4,2,0"];
    instr7 [label="lwz r17,12(r15)"];instr8 [label="addi r17,r17,0x0001"];
    instr9 [label="stw r17,12(r15)"];instr10 [label="mr r3,r17"];
    instr11 [label="lwz r11,4000(r16)"]; instr12 [label="mtlr r11"];
    instr13 [label="blrl cr0"]; instr14 [label="mr r18,r3"];
    instr15 [label="mr r3,r18"];instr16 [label="lwz r11,428(r16)"];
    instr17 [label="mtlr r11"];instr18 [label="blrl cr0"];
    instr19 [label="mr r17,r3"];instr20 [label="stw r17,16(r15)"];
    instr21 [label="lwz r0,140(r1)"]; instr22 [label="mtlr r0"];
    instr23 [label="addi r1,r1,0x0088"];instr24 [label="blr cr0"];
    start -> block0; block0 -> instr0;instr0 -> instr1;
    instr1 -> instr2; instr2 -> instr3; instr3 -> instr4;
    instr4 -> instr5;instr5 -> instr6; instr6 -> instr7;
    instr7 -> instr8; instr8 -> instr9;instr9 -> instr10;
    instr10 -> instr11; instr11 -> instr12;instr12 -> instr13;
    instr13 -> instr14;instr14 -> instr15;instr15 -> instr16;
    instr16 -> instr17; instr17 -> instr18; instr18 -> instr19;
    instr19 -> instr20; instr20 -> instr21;instr21 -> instr22;
    instr22 -> instr23;instr23 -> instr24; instr24 -> end;
}
