#include<cstdio>
#include<cstdlib>
#include<cstring>

using namespace std;

const int MAXLEN = 2;

int main()
{
	FILE *infile = fopen("kernel.bin","rb");
	freopen("kernel.out","w",stdout);
	int rc;   
    unsigned char buf[MAXLEN];  
	while( (rc = fread(buf,sizeof(unsigned char),MAXLEN,infile)) != 0 )  
	{  
		for (int a=MAXLEN-1;a>=0;a--)
			printf("%X%X",buf[a]/16,buf[a]%16);
		printf("\n");
	}

	return 0;
}
