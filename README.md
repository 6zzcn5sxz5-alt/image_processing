# Image Processing — In-class Exercises 1–6

This submission covers all six in-class MATLAB image-processing exercises. The mini project (`rice.png`) is **not** part of the submission.

## Submission structure required by the lecturer

```text
<your-github-repository>/
└── exercises/
    ├── exercises.mlx   # RUN and SAVE this in the MATLAB Live Editor
    └── exercises.pdf   # exported with code and executed outputs
```

The prepared source code is `exercises/exercises.m`. `exercises/make_submission.m` is an optional helper to generate the two required files in MATLAB. If you upload the source and helper too, that is fine; the two deliverables above are mandatory.

## How to finish it in MATLAB (short route)

1. Open MATLAB and set **Current Folder** to the downloaded `exercises` folder. You need the **Image Processing Toolbox**.
2. Open `exercises.m`, right-click the document tab, select **Open exercises.m as Live Script**, and save it with the name **`exercises.mlx`**. Alternatively, in the MATLAB Command Window execute `make_submission` to attempt automatic conversion and PDF export.
3. Open `exercises.mlx` in Live Editor, click **Run** (all sections), inspect the figures, PSNR table, image dimensions, coin areas and edge counts. Fix any environment-specific image/toolbox problem before submission.
4. Press **Ctrl+S** to save **with the executed outputs**. Then in **Live Editor > Export > Export to PDF**, select the filename `exercises.pdf` (or run `export('exercises.mlx','exercises.pdf','Run',true,'CatchError',false)` in the Command Window).
5. Upload `exercises.mlx` and `exercises.pdf` into your public or lecturer-accessible GitHub repository in the `exercises/` folder. **Do not upload** `cameraman.tif`, `pout.tif` or `coins.png`.
6. Paste the **repository URL** (not the individual file URLs) into Moodle and submit.

## What the six sections do

- **1 — Pixels and quantization:** image size/class; 4-, 2-, 1-bit quantization; 8× downsampling with and without `imresize`.
- **2 — Image degradation:** Gaussian and salt/pepper noise, motion blur, and multiplicative brightness ramp.
- **3 — Contrast and geometry:** histogram, gamma 0.5, `histeq`, `adapthisteq`; nearest vs bicubic on 40×40 patch.
- **4 — Filtering:** mean, Gaussian, median for both noises, six PSNR scores against the original in a table; original and motion-blurred FFT spectra.
- **5 — Edge maps:** Sobel, Canny for sigma 1/2/3, extra smoothing vs no extra smoothing, counts of edge pixels and approximate false edges.
- **6 — Segmentation:** Otsu threshold, `imopen` / `imfill` / `bwareaopen`, labeling, per-coin pixel area, largest region.

Brief English answers to every “Think about” prompt are included as comments inside `exercises.m`; they carry over when converted to a Live Script. Numerical answers are deliberately computed at runtime rather than invented.

### Note about accuracy and runtime

The files were prepared without running MATLAB in this environment, so `exercises.mlx` and the actual executed `exercises.pdf` are not part of this starter package. Those **must be generated and checked in MATLAB**, as explained above. For Exercise 5, the “false-edge removal” statistic is an explicitly labeled approximation against edges from the clean image, with a one-pixel spatial tolerance. For Exercise 6, touching coins may remain a single connected component.
