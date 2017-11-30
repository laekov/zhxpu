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
    print cnt,line.replace("\n","")

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
            print s
            gg
    elif s[0:5] == "11100":
        print ""
