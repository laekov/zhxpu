## ADDIU 
ADDIU Rx Ry

Rx += Ry

* IF: -
* IF/ID: 可能被卡住. 
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

## ADDIU3

* IF: -
* IF/ID: 可能被卡住
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

## ADDSP

* IF: -
* IF/ID: -
* Decode: 向 stall ctrl 发特殊寄存器锁信号. 向特殊寄存器组发读信号
* ID/EXE: 收SP的值
* EXE: ALU 做加法
* EXE/WB:  向 stall ctrl 发解锁信号
* WB: 写寄存器

## ADDU

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## AND

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## B

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## BEQZ

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## BNEZ

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## BTEQZ

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## CMP

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## JR

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## LI

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## LW

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## LW\_SP

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## MFIH

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## MFPC

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## MTIH

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## MTSP

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## NOP

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## OR

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SLL

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SRA

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SUBU

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SW

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SW\_SP

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## JALR

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## JRRA

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## MOVE

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SRL

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

## SRAV

* IF: 
* IF/ID: 
* Decode:
* ID/EXE:
* EXE:
* EXE/WB:
* WB: 

