#include <stdio.h>
#include <memory.h>
#include <stdint.h>

enum {
	ENV_SIZE = 4096	// environment size fro u-boot on NanoPi
};

static void make_crc_table(uint32_t crc_table[])
{
	uint32_t c;
	int n, k;
	uint32_t poly = 0xedb88320L;		/* polynomial exclusive-or pattern */

	for (n = 0; n < 256; n++) {
		c = n;
		for (k = 0; k < 8; k++)
			c = c & 1 ? poly ^ (c >> 1) : c >> 1;
		crc_table[n] = c;
	}
}

int main(int argc, char *argv[])
{
	char buf[ENV_SIZE];
	uint32_t crc_table[256];
	uint32_t crc = 0xffffffffL;
	int c, len = 4;

	// first four bytes of env is crc
	make_crc_table(crc_table);
	while( (c = getchar()) != EOF ) {
		if( c == '\r' )
			continue;
		if( len == ENV_SIZE ) {
			fprintf(stderr, "fatal: environment too long\n");
			return 1;
		}
		if( c == '\n' )
			c = '\0';
		buf[len++] = c;
		crc = crc_table[(crc ^ c) & 255] ^ (crc >> 8);
	}
	while( len < ENV_SIZE ) {
		buf[len++] = 0;
		crc = crc_table[crc & 255] ^ (crc >> 8);
	}
	crc ^= 0xffffffffL;
	// store crc in little endian
	buf[0] = crc;
	buf[1] = crc >> 8;
	buf[2] = crc >> 16;
	buf[3] = crc >> 24;
	while( len ) {
		if( (c = fwrite(buf + ENV_SIZE - len, 1, len, stdout)) < 0 ) {
			perror("write");
			return 1;
		}
		len -= c;
	}
	return 0;
}

