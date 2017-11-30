f = open("kernel.out","r")


def trans(c):
    if c=='0':
        return "0000"
    if c=='1':
        return "0001"
    if c=='2':
        return "0010"
    if c=='3':
        return "0011"
    if c=='4':
        return "0100"
    if c=='5':
        return "0101"
    if c=='6':
        return "0110"
    if c=='7':
        return "0111"
    if c=='8':
        return "1000"
    if c=='9':
        return "1001"
    if c=='A':
        return "1010"
    if c=='B':
        return "1011"
    if c=='C':
        return "1100"
    if c=='D':
        return "1101"
    if c=='E':
        return "1110"
    if c=='F':
        return "1111"

def reg(s):
    return "R"+str((ord(s[0])-ord('0'))*4+(ord(s[1])-ord('0'))*2+(ord(s[2])-ord('0')))

cnt = 0

for line in f:
    s = ""
    for a in range(0,4):
        s = s + trans(line[a])

    cnt += 1
    #print cnt,line.replace("\n","")

    if s[0:5] == "01001":
        print "ADDIU",reg(s[5:8]),s[8:16]
    elif s[0:5] == "01000":
        print "ADDIU3",reg(s[5:8]),reg(s[8:11]),s[11:16]
    elif s[0:5] == "01100":
        if s[5:8] == "011":
            print "ADDSP",s[8:16]
        elif s[5:8] == "000":
            print "BTEQZ"
        elif s[5:8] == "100" and s[11:16] =="00000":
            print "MTSP",reg(s[8:11])
        else:
            gg
    elif s[0:5] == "11100":
        if s[14:16] == "01":
            print "ADDU",reg(s[5:8]),reg(s[8:11]),reg(s[11:14])
        elif s[14:16] == "11":
            print "SUBU",reg(s[5:8]),reg(s[8:11]),reg(s[11:14])
        else:
            gg
    elif s[0:5] == "11101":
        if s[11:16] == "01100":
            print "AND",reg(s[5:8]),reg(s[8:11])
        elif s[8:16] == "00000000":
            print "JR",reg(s[5:8])
        elif s[11:16] == "01010":
            print "CMP",reg(s[5:8]),reg(s[8:11])
        elif s[8:16] == "01000000":
            print "MFPC",reg(s[5:8])
        elif s[11:16] == "01101":
            print "OR",reg(s[5:8]),reg(s[8:11])
        elif s[8:16] == "11000000":
            print "JALR",reg(s[5:8])
        elif s[5:16] == "00000100000":
            print "JRRA"
        elif s[11:16] == "00111":
            print "SRAV",reg(s[5:8]),reg(s[8:11])
        else:
            gg
    elif s[0:5] == "00010":
        print "B",s[5:16]
    elif s[0:5] == "00100":
        print "BEQZ",reg(s[5:8]),s[8:16]
    elif s[0:5] == "00101":
        print "BNEZ",reg(s[5:8]),s[8:16]
    elif s[0:5] == "01101":
        print "LI",reg(s[5:8]),s[8:16]
    elif s[0:5] == "10011":
        print "LW",reg(s[5:8]),reg(s[8:11]),s[11:16]
    elif s[0:5] == "10010":
        print "LW_SP",reg(s[5:8]),s[8:16]
    elif s[0:5] == "11110":
        if s[8:16] == "00000000":
            print "MFIH",reg(s[5:8])
        elif s[8:16] == "00000001":
            print "MTIH",reg(s[5:8])
        else:
            gg
    elif s[0:5] == "00001":
        if s[5:16] == "00000000000":
            print "NOP"
        else:
            gg
    elif s[0:5] == "00110":
        if s[14:16] == "00":
            print "SLL",reg(s[5:8]),reg(s[8:11]),s[11:14]
        elif s[14:16] == "11":
            print "SRA",reg(s[5:8]),reg(s[8:11]),s[11:14]
        elif s[14:16] == "10":
            print "SRL",reg(s[5:8]),reg(s[8:11]),s[11:14]
        else:
            gg
    elif s[0:5] == "11011":
        print "SW",reg(s[5:8]),reg(s[8:11]),s[11:16]
    elif s[0:5] == "11010":
        print "SW_SP",reg(s[5:8]),s[8:16]
    elif s[0:5] == "01111":
        if s[11:16] == "00000":
            print "MOVE",reg(s[5:8]),reg(s[8:11])
        else:
            gg
    elif s[0:5] == "00000":
        print "ADDSP3",reg(s[5:8]),s[8:16]
    else:
        gg
