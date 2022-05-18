#include "index.h"

#define N 100			//sample buffer length
#define N2 128			//averaging buffer length
#define DEGREE 32		//number of theta test values to try
#define SUMSAMP 70		//number of theta test values to try

float Fs = 16000.0;		//irrelevant since jumper in 3-4

int* lights = (int*)0x90080000;

short buffer1[N] = {0};
short buffer2[N] = {0};
int buffer3[N2] = {0};
int buf_full = 0;
int buf_index = 0;

interrupt void c_int12()      //McBSP1 receive ISR
{
	
	int sample = input_leftright_sample();
   	
   buffer1[buf_index] = (short)(sample >> 16);
   buffer2[buf_index] = (short)sample;

	buf_index++;
	if(buf_index == N) {
		buf_index = 0;
		buf_full = 1;
	}
   	   	
	return;			//return from interrupt
}

void main()
{                           
	int i;  
	int j;   
	int k = 0;
	int z, test_amp;
	int region;
	int out;
	int sum = 0;
	
	int max_theta_index = 0;
	int max_amplitude = -1;
	
	for(k=0;k<N2;k++) buffer3[k] = 0;
	k = 0;

	comm_intr();            //init DSK, codec, McBSP
  	while(1) {
		if(buf_full) {
			buf_full = 0;
			max_amplitude = -1;
			
   			for(i=0; i<DEGREE; i++) {
				test_amp = 0;

				for(j=0; j<SUMSAMP; j++) {
   					z = buffer1[index[0][i]+j] + buffer2[index[1][i]+j];
					test_amp += (z * z) >> 15;
   				}
   			
   				if(test_amp > max_amplitude) {
   					max_amplitude = test_amp;
   					max_theta_index = i;
				}
   			}

   			region = max_theta_index >> 2;
   			sum -= buffer3[k];
   			buffer3[k++] = region;
   			sum += region;
   			
   			if(k == N2) {
   				k = 0;
   				out = sum >> 7;
   				/*if(out > 3)
   					out = 0;
   				else
   					out = 7;*/
   				*lights = out << 24;
   			}
   		}
	}
}
