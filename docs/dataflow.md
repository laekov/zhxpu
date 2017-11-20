## ADDIU 
ADDIU Rx immediate

Rx += immediate

* IF: -
* IF/ID: 可能被卡住. 
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

## ADDIU3
ADDIU3 Rx Ry Im

Ry = Rx + Im

* IF: -
* IF/ID: 可能被卡住
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

## ADDSP
ADDSP im

SP += im

* IF: -
* IF/ID: -
* Decode: 向 stall ctrl 发特殊寄存器锁信号. 向特殊寄存器组发读信号
* ID/EXE: 收SP的值
* EXE: ALU 做加法
* EXE/WB:  向 stall ctrl 发解锁信号
* WB: 写寄存器

## ADDU
ADDU rx ry rz

Rz = Rx + Ry

* IF: - 
* IF/ID: -
* Decode: 向 stall ctrl 发寄存器锁信号. 向通用寄存器发地址
* ID/EXE: 接收通用寄存器值
* EXE: ALU 做加法
* EXE/WB: 解锁
* WB: 写寄存器

## AND
AND Rx Ry
Rx &= Ry

* IF: -
* IF/ID: -
* Decode: 向 stall ctrl 发寄存器锁信号. 向通用寄存器发地址
* ID/EXE: 接收通用寄存器值
* EXE: ALU 做 AND
* EXE/WB: 解锁
* WB: 写寄存器

## B
B im

PC = PC + im

* IF: 分枝预测. 修改 next pc 的值 
* IF/ID: -
* Decode: -
* ID/EXE: - 
* EXE: 什么都不做
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB: stall ctrl 清空流水线

## BEQZ
BEQZ rx immediate

if (rx == 0) pc += immediate

* IF: 分枝预测. 预测是 true
* IF/ID: -
* Decode: -
* ID/EXE: -
* EXE: 判断寄存器值是否非零
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB:  清空流水

## BNEZ
BNEZ rx immediate

if (rx != 0) pc += immediate

* IF: 预测是true.
* IF/ID:  -
* Decode: -
* ID/EXE: -
* EXE: 判断寄存器值是否为零
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB: 清空流水

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

