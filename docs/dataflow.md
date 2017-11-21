zhxpu 控制器描述
===
## 概述
### 寄存器锁
Decode 向锁发信号, 表示该条指令需要写某个寄存器. 后续如需使用该寄存器, 则卡住. 在 EXE/WB 处解锁.

Decode 向锁发读取信号, 表示需要读该寄存器. 由 stall ctrl 判断是否需要将此条指令卡住.

### 时钟结构
通过独立的模块实现降频和发信号.

考虑特殊结构`set_back`. 即在一个时钟周期后向信号源发一个时钟信号来促使其恢复原有信号. (用于写内存等处)

## 分指令过程描述
### ADDIU 
ADDIU Rx immediate

Rx += immediate

* IF: -
* IF/ID: 可能被卡住. 
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

### ADDIU3
ADDIU3 Rx Ry Im

Ry = Rx + Im

* IF: -
* IF/ID: 可能被卡住
* Decode: 向 stall ctrl 发送寄存器锁信号. 向 reg ctrl 发地址
* ID/EXE: 收取操作数
* EXE: ALU做加法
* EXE/WB: 向 stall ctrl 发送寄存器解锁信号.
* WB: 写寄存器

### ADDSP
ADDSP im

SP += im

* IF: -
* IF/ID: -
* Decode: 向 stall ctrl 发特殊寄存器锁信号. 向特殊寄存器组发读信号
* ID/EXE: 收SP的值
* EXE: ALU 做加法
* EXE/WB:  向 stall ctrl 发解锁信号
* WB: 写寄存器

### ADDU
ADDU rx ry rz

Rz = Rx + Ry

* IF: - 
* IF/ID: -
* Decode: 向 stall ctrl 发寄存器锁信号. 向通用寄存器发地址
* ID/EXE: 接收通用寄存器值
* EXE: ALU 做加法
* EXE/WB: 解锁
* WB: 写寄存器

### AND
AND Rx Ry
Rx &= Ry

* IF: -
* IF/ID: -
* Decode: 向 stall ctrl 发寄存器锁信号. 向通用寄存器发地址
* ID/EXE: 接收通用寄存器值
* EXE: ALU 做 AND
* EXE/WB: 解锁
* WB: 写寄存器

### B
B im

PC = PC + im

* IF: 分枝预测. 修改 next pc 的值. 插入一条 nop
* IF/ID: -
* Decode: -
* ID/EXE: - 
* EXE: 什么都不做
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB: stall ctrl 清空流水线

### BEQZ
BEQZ rx immediate

if (rx == 0) pc += immediate

* IF: 分枝预测. 预测是 true. 插入一条 nop
* IF/ID: -
* Decode: -
* ID/EXE: -
* EXE: 判断寄存器值是否非零
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB:  清空流水

### BNEZ
BNEZ rx immediate

if (rx != 0) pc += immediate

* IF: 预测是true. 插入一条 nop
* IF/ID:  -
* Decode: -
* ID/EXE: -
* EXE: 判断寄存器值是否为零
* EXE/WB: 向 stall ctrl 发修改 pc 的信号
* WB: 清空流水

### BTEQZ
BTEQZ im

if (T=0) PC += im

* IF: 预测为true. 插入一条 nop 
* IF/ID: -
* Decode: -
* ID/EXE: -
* EXE: 不干活
* EXE/WB: 读T寄存器的值. 向 stall ctrl 发修改 pc 的信号
* WB: 清空流水

### CMP
CMP rx ry

T = (rx != ry)

* IF:  -
* IF/ID:  -
* Decode: 读寄存器 rx, ry
* ID/EXE: 收 rx ry 的值
* EXE: alu 进行运算, alu\_out\_ctrl 写T的值
* EXE/WB: -
* WB: -

### JR
JR rx

pc = rx

* IF: 插入一条 nop
* IF/ID: -
* Decode: 读寄存器 rx
* ID/EXE: 接收 rx 的值
* EXE: 传递 rx
* EXE/WB: 修改 pc
* WB: 清空流水

### LI
LI rx im

rx = im

* IF:  -
* IF/ID:  -
* Decode: -
* ID/EXE: -
* EXE: 传递 im
* EXE/WB: -
* WB: 修改 rx

### LW
LW rx ry im

ry = mem[rx + im]

* IF: -
* IF/ID: -
* Decode: 读寄存器 rx. 锁 rx
* ID/EXE: 收取 rx, 向 stall ctrl 发 mem 信号. 卡住流水
* EXE: 做加法, alu\_out指示读内存
* EXE/WB: 轮询等 alu\_out 返回数据, 向 stall ctrl 解锁 mem
* WB: 写寄存器

### LW\_SP
LW\_SP rx im

rx = mem[sp + im]

* IF:  -
* IF/ID:  -
* Decode: 读特殊寄存器 sp
* ID/EXE: 收取 sp, 向 stall ctrl 发 mem 信号 
* EXE: 做加法, alu\_out 指示读内存
* EXE/WB: 轮询等 alu\_out 返回数据. 向 stall ctrl 解锁 mem
* WB: 写寄存器

### MFIH
MFIH rx

rx = ih

* IF:  -
* IF/ID:  -
* Decode: 读特殊寄存器 ih, 锁 rx
* ID/EXE: 收 ih
* EXE: 传递 ih
* EXE/WB: 解锁 rx
* WB: 写寄存器

### MFPC
MFPC rx

rx = pc

* IF:  -
* IF/ID:  -
* Decode: 锁rx
* ID/EXE: -
* EXE: 传递 pc
* EXE/WB: 解锁 rx
* WB: 写寄存器

### MTIH
MTIH rx

ih = rx

* IF:  -
* IF/ID:  -
* Decode: 读 rx, 锁 rx, ih
* ID/EXE: 收 rx
* EXE: 传递 rx
* EXE/WB: 解锁 rx, ih
* WB: 写 ih

### MTSP
MTSP Rx

sp = rx

* IF: -
* IF/ID: -
* Decode: 读 rx, 查询 rx, 锁 sp
* ID/EXE: 收 rx
* EXE: 传递 rx
* EXE/WB: 解锁 rx, sp
* WB: 写 sp

### NOP
NOP

啥都不干

* IF: -
* IF/ID: -
* Decode: -
* ID/EXE: -
* EXE: -
* EXE/WB: -
* WB: -

### OR
OR rx ry

rx |= ry

* IF:  -
* IF/ID:  -
* Decode: 读 rx, ry, 锁 rx
* ID/EXE: 收 rx
* EXE: 算或
* EXE/WB: 解锁 rx
* WB:  写 rx

### SLL
SLL rx ry im

rx = ry << im

* IF: -
* IF/ID:  -
* Decode: 读 ry, 锁 rx
* ID/EXE: 收 ry
* EXE: 算位移
* EXE/WB: 解锁 rx
* WB: 写 rx

### SRA
SRA rx ry im

rx = ry >> im

* IF: -
* IF/ID:  -
* Decode: 读 ry, 锁 rx
* ID/EXE: 收 ry
* EXE: 算位移
* EXE/WB: 解锁 rx
* WB: 写 rx

### SUBU
subu rx ry rz

rz = rx - ry

* IF: -
* IF/ID: - 
* Decode: 读 rx, ry, 锁 rz
* ID/EXE: 收 rx, ry
* EXE: 算减法
* EXE/WB: 解锁 rz
* WB: 写 rz

### SW
sw rx ry im

mem[rx + im] = ry

* IF: -
* IF/ID:  -
* Decode: 读 rx, ry
* ID/EXE: 收 rx, ry
* EXE: 算加法, alu out ctrl 写内存
* EXE/WB: -
* WB: -

### SW\_SP
`sw_sp rx im`

mem[sp + im] = rx

* IF: -
* IF/ID: -
* Decode: 读 sp
* ID/EXE: 收 sp
* EXE: 算加法, alu out ctrl 写内存
* EXE/WB: -
* WB: -

### JALR
jalr rx

ra = pc + 1, pc = rx

* IF: -
* IF/ID: -
* Decode: 锁 ra, 读 rx
* ID/EXE: 收 rx
* EXE: 传递 rx
* EXE/WB: 解锁 ra
* WB: 写 pc, ra

### JRRA
jrra

pc = ra

* IF: -
* IF/ID:  -
* Decode: 读 ra
* ID/EXE: 收 ra
* EXE: 传 ra
* EXE/WB: -
* WB: 修改 pc

### MOVE
move rx ry

rx = ry

* IF:  -
* IF/ID:  -
* Decode: 读 ry, 锁 rx
* ID/EXE: 收 ry
* EXE: 传递 ry
* EXE/WB: 解锁 rx
* WB: 写 rx

### SRL
srl rx ry im

rx = ry >> im

* IF: -
* IF/ID:  -
* Decode: 读 ry, 锁 rx
* ID/EXE: 收 ry
* EXE: 算位移
* EXE/WB: 解锁 rx
* WB: 写 rx

### SRAV
srav rx ry

ry = ry >> rx

* IF: -
* IF/ID:  -
* Decode: 读 rx, ry, 锁 ry
* ID/EXE: 收 rx, ry
* EXE: 算位移
* EXE/WB: 解锁 ry
* WB: 写 ry

