#include<cstdio>
#include<cstdlib>
#include<cstring>

using namespace std;

const int MAXLEN = 2;

int main()
{
	FILE *infile = fopen("kernel.bin","rb");
	freopen("kernel.out","w",stdout);
//	FILE *outfile = fopen("kernel.chr","wb");
	int rc;   
    unsigned char buf[MAXLEN];  
	while( (rc = fread(buf,sizeof(unsigned char),MAXLEN,infile)) != 0 )  
	{  
		for (int a=MAXLEN-1;a>=0;a--)
			printf("%X%X",buf[a]/16,buf[a]%16);
		printf("\n");
		//for (int a=0;a<MAXLEN;a++)
		//	printf("%c",buf[a]);
		//	fwrite(&buf[a],sizeof(unsigned char),1,outfile);
	}

	return 0;
}
