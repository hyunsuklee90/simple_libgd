#include "stdio.h"
#include <gd.h>

#ifdef __cplusplus
extern "C"{
#endif

void gd_print_image(int *nx, int *ny, int** fmap, char *fname, int* s)
{
	FILE* out;
	gdImagePtr im;
	int color;

	// im = gdImageCreate(*nx, *ny);
	im = gdImageCreateTrueColor(*nx, *ny);

	gdImageColorAllocate(im, 255, 255, 255); 

	int i = 0;
	for (int y = 0; y < *ny; y++) {
		for (int x = 0; x < *nx; x++) {
			color = gdImageColorAllocate(im, fmap[0][i], fmap[0][i + 1], fmap[0][i + 2]);
			gdImageSetPixel(im, x, y, color);
			i = i + 3;
		}
	}

	char* fname_s = malloc(sizeof(char) * (*s+1));

	if (NULL != fname_s) {
		for (int i = 0; i < *s; i++) {
			// fname_s[i] = fname[0][i];
			fname_s[i] = fname[i];
		}
		fname_s[*s] = '\0';

		out = fopen(fname_s, "wb");

		gdImageGif(im, out);

		fclose(out);
	}
	free(fname_s);
	gdImageDestroy(im);

};
#ifdef __cplusplus
}
#endif
