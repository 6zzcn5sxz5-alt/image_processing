# Short answers for the "Think about" questions

**Exercise 1.** The 1-bit image usually keeps recognizable large shapes, but much of the detail is lost. Aliasing is most visible after simple direct subsampling without antialiasing, particularly in thin or diagonal structures.

**Exercise 2.** Gaussian noise is additive; salt-and-pepper noise replaces individual pixels with black/white extremes. The brightness ramp is multiplicative, and motion blur is convolutional. Median filtering is especially suitable for salt-and-pepper noise.

**Exercise 3.** Adaptive histogram equalization often improves local contrast most, but can amplify noise. Gamma 0.5 brightens normalized intensities since `x^0.5 > x` for values between zero and one. Bicubic interpolation blends surrounding pixels into smoother transitions, unlike blocky nearest-neighbor upscaling.

**Exercise 4.** A Gaussian filter is usually effective on Gaussian noise, while a median filter generally handles salt-and-pepper noise better; decide the exact winner using the six calculated PSNR scores. Motion blur attenuates high spatial frequencies and adds direction-dependent bands in the frequency spectrum.

**Exercise 5.** A larger Canny sigma suppresses small details and noise-induced edges but can also remove genuine weak edges. The code prints exact edge-pixel counts and an approximate difference in false-edge counts relative to a clean reference; standard Canny already has some built-in Gaussian smoothing.

**Exercise 6.** Opening removes tiny bright speckles and thin bridges; hole filling repairs dark holes inside coin regions, and the size filter removes remaining small pieces. The code prints the largest labeled region. Touching coins can merge if their thresholded regions remain connected.
