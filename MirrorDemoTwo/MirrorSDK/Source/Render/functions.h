#ifndef _SOME_FUNCTIONS_IN_MAIN_CPP_
#define _SOME_FUNCTIONS_IN_MAIN_CPP_



typedef struct tagBITMAPFILEHEADER2 {
	unsigned short    bfType;
	unsigned long     bfSize;
	unsigned short    bfReserved1;
	unsigned short    bfReserved2;
	unsigned long     bfOffBits;
} BITMAPFILEHEADER2;

typedef struct tag_bitmapinfoheader{
	unsigned long		biSize;
	long				biWidth;
	long				biHeight;
	unsigned short      biPlanes;
	unsigned short      biBitCount;
	unsigned long		biCompression;
	unsigned long		biSizeImage;
	long				biXPelsPerMeter;
	long				biYPelsPerMeter;
	unsigned long		biClrUsed;
	unsigned long		biClrImportant;
} BITMAPINFOHEADER2;

#ifndef WIDTHBYTES
#define WIDTHBYTES(bits)    ((((bits) + 31)>>5)<<2)
#endif

unsigned char *ReadBmpFile2(const char *filename, int * ht_t, int * wd_t);

void Mirror_YUV420SP_to_BGR24(unsigned char *pYUV420, int wd, int ht, unsigned char* pBGR24, int mode);
void Mirror_BGR24_to_YUV420SP(unsigned char *pBGR24, int wd, int ht, unsigned char* pYUV420, int mode);

unsigned char * LoadDataBuffer(char *filename, int & buf_size);


#endif
