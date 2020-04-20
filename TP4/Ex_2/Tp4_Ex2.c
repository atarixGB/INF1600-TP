
#include <stdio.h>

unsigned int change_endianness(unsigned int x)
{
	unsigned int y = 0;

	
/* 	 * Remplacez le code suivant par de l'assembleur en ligne
	 * en utilisant le moins d'instructions possible */
	 
/* 	 y = ( x & 0xff000000 ) >> 24 | (x & 0x00ff0000) >> 8 | 
	 	 ( x & 0x0000ff00 ) <<  8 | (x & 0x000000ff) << 24; */

	asm volatile (
		"movl %1, %0 \n\t"
		"bswap %0 \n\t"
		: "=r" (y) 	// sorties --> %0 = y
		: "r" (x) 	// entrées --> %1 = x
		: "%eax" 	// registres modifiés 
	); 

    
	return y;
}

int main()
{
	unsigned int data = 0xff1122ee;

	printf("Donnée en little-endian: %08x\n"
	       "Donnée en big-endian   : %08x\n"
	       "Donnée en little-endian: %08x\n",
	       data,
	       change_endianness(data),
           change_endianness(change_endianness(data))
           );

	return 0;
}
