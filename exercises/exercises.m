% IMAGE PROCESSING — IN-CLASS EXERCISES 1–6
% MATLAB R2022a or newer recommended. Requires Image Processing Toolbox.
% Images: cameraman.tif, pout.tif, coins.png (MATLAB example images).
% All figures, counts and PSNR values are computed from the input images.
% Run ALL sections, save the Live Script with its output, then export to PDF.

%% Exercise 1 — Pixels and quantization
% Load the image and report the size and data class.
I = imread('cameraman.tif');
disp('Exercise 1: cameraman.tif');
disp(['Image size: ' mat2str(size(I))]);
disp(['Image class: ' class(I)]);
% Quantization: 4 bits = 16 levels; 2 bits = 4 levels; 1 bit = 2 levels.
% Conversion is kept in [0,1] to avoid an overflow in uint8.
Id = im2double(I);
q4 = floor(Id * 16) / 15;
q2 = floor(Id * 4) / 3;
q1 = floor(Id * 2) / 1;
q4 = min(q4,1); q2 = min(q2,1); q1 = min(q1,1);
% Direct indexing skips pixels; imresize with bicubic interpolation uses
% antialiasing when it reduces the image size.
manualSmall = I(1:8:end,1:8:end);
resizedSmall = imresize(I,1/8,'bicubic');
manualDisplay = imresize(manualSmall,size(I),'nearest');
resizeDisplay = imresize(resizedSmall,size(I),'nearest');
disp(['Direct subsampling size: ' mat2str(size(manualSmall))]);
disp(['imresize subsampling size: ' mat2str(size(resizedSmall))]);
tiledlayout(2,4,'TileSpacing','compact','Padding','compact');
nexttile; imshow(I); title('Original (8-bit)');
nexttile; imshow(q4); title('Quantized (4-bit)');
nexttile; imshow(q2); title('Quantized (2-bit)');
nexttile; imshow(q1); title('Quantized (1-bit)');
nexttile; imshow(I); title('Original');
nexttile; imshow(manualDisplay); title('Every 8th pixel');
nexttile; imshow(resizeDisplay); title('imresize by 1/8');
nexttile; imshow(abs(double(manualDisplay)-double(resizeDisplay)),[]);
title('Difference');
sgtitle('Exercise 1: Quantization and 8x downsampling');
% Think about: At 1 bit the main silhouette is usually still visible,
% but much of the fine detail is lost. Aliasing is clearest in direct
% subsampling, especially on fine textures and diagonal structures.

%% Exercise 2 — Degrade an image
rng(42,'twister'); % make the noise reproducible
noiseGaussian = imnoise(I,'gaussian',0,0.01);
noiseSP = imnoise(I,'salt & pepper',0.05);
H = fspecial('motion',15,30);
imageMotion = imfilter(I,H,'replicate','conv');
[rows,cols] = size(I);
ramp = repmat(linspace(0.5,1.4,cols),rows,1);
imageRamp = im2uint8(min(1,max(0,im2double(I).*ramp)));
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
nexttile; imshow(I); title('Original');
nexttile; imshow(noiseGaussian); title('Gaussian noise (var = 0.01)');
nexttile; imshow(noiseSP); title('Salt & pepper (0.05)');
nexttile; imshow(imageMotion); title('Motion blur (15 px, 30 deg)');
nexttile; imshow(imageRamp); title('Multiplicative brightness ramp');
nexttile; imagesc(ramp); axis image off; colorbar; title('Brightness multiplier');
sgtitle('Exercise 2: Different degradations');
% Think about: Gaussian noise is an additive perturbation. Salt & pepper
% noise replaces selected pixels with extreme values. The brightness ramp
% is multiplicative, while motion blur is a convolution. A median filter
% is especially effective for isolated salt & pepper noise.

%% Exercise 3 — Contrast and geometry
P = imread('pout.tif');
disp(['Exercise 3: pout.tif, image size ' mat2str(size(P))]);
Pg = imadjust(P,[],[],0.5);
Ph = histeq(P);
Pa = adapthisteq(P);
% Take a centered, exactly 40-by-40-pixel image patch and enlarge it 8x.
pr = floor((size(P,1)-40)/2)+1;
pc = floor((size(P,2)-40)/2)+1;
patch = P(pr:pr+39,pc:pc+39);
nearestPatch = imresize(patch,8,'nearest');
bicubicPatch = imresize(patch,8,'bicubic');
tiledlayout(3,3,'TileSpacing','compact','Padding','compact');
nexttile; imshow(P); title('Original pout.tif');
nexttile; imhist(P); title('Intensity histogram');
nexttile; imshow(Pg); title('Gamma = 0.5');
nexttile; imshow(Ph); title('Histogram equalization');
nexttile; imshow(Pa); title('Adaptive histogram equalization');
nexttile; imshow(patch); title('Original 40 x 40 patch');
nexttile; imshow(nearestPatch); title('Nearest (8x)');
nexttile; imshow(bicubicPatch); title('Bicubic (8x)');
nexttile; imshow(Pa); title('Local contrast detail');
sgtitle('Exercise 3: Histogram, contrast and interpolation');
% Think about: Adaptive equalization often gives the strongest local
% contrast, but may exaggerate noise. Gamma < 1 brightens because x^gamma
% is greater than x for 0 < x < 1. Bicubic interpolates nearby pixel
% values to create smoother transitions; nearest simply replicates pixels.

%% Exercise 4 — Filter and compare
% Use the two noisy images created in Exercise 2.
k = fspecial('average',[3 3]);
gaussianMean = imfilter(noiseGaussian,k,'replicate');
gaussianGauss = imgaussfilt(noiseGaussian,1,'Padding','replicate');
gaussianMedian = medfilt2(noiseGaussian,[3 3],'symmetric');
spMean = imfilter(noiseSP,k,'replicate');
spGauss = imgaussfilt(noiseSP,1,'Padding','replicate');
spMedian = medfilt2(noiseSP,[3 3],'symmetric');
% Six PSNR values measured against the ORIGINAL image.
psnrValues = [psnr(gaussianMean,I) psnr(gaussianGauss,I) psnr(gaussianMedian,I); ...
              psnr(spMean,I)       psnr(spGauss,I)       psnr(spMedian,I)];
PSNR_table = array2table(psnrValues,'VariableNames',{'Mean_dB','Gaussian_dB','Median_dB'}, ...
    'RowNames',{'Gaussian_noise','SaltPepper_noise'});
disp('Exercise 4: PSNR values (dB); larger is better');
disp(PSNR_table);
filterNames = {'Mean','Gaussian','Median'};
[~,winGaussian] = max(psnrValues(1,:));
[~,winSP] = max(psnrValues(2,:));
disp(['Best Gaussian-noise PSNR: ' filterNames{winGaussian}]);
disp(['Best salt-and-pepper PSNR: ' filterNames{winSP}]);
% Use a common display scale for a fair frequency-spectrum comparison.
Soriginal = log(1+abs(fftshift(fft2(im2double(I)))));
Smotion = log(1+abs(fftshift(fft2(im2double(imageMotion)))));
commonLimits = [min([Soriginal(:);Smotion(:)]),max([Soriginal(:);Smotion(:)])];
tiledlayout(3,4,'TileSpacing','compact','Padding','compact');
nexttile; imshow(noiseGaussian); title('Gaussian: noisy');
nexttile; imshow(gaussianMean); title('Mean');
nexttile; imshow(gaussianGauss); title('Gaussian');
nexttile; imshow(gaussianMedian); title('Median');
nexttile; imshow(noiseSP); title('Salt & pepper: noisy');
nexttile; imshow(spMean); title('Mean');
nexttile; imshow(spGauss); title('Gaussian');
nexttile; imshow(spMedian); title('Median');
nexttile; imagesc(Soriginal,commonLimits); axis image off;
colormap(gray); colorbar; title('Original FFT');
nexttile; imagesc(Smotion,commonLimits); axis image off;
colormap(gray); colorbar; title('Motion blur FFT');
sgtitle('Exercise 4: Filtering and log-magnitude spectra');
% Think about: Gaussian filtering commonly performs well on Gaussian
% noise, whereas median filtering usually wins for salt & pepper.
% Refer to the printed PSNR values for these exact settings. Motion blur
% suppresses high frequencies and introduces direction-dependent bands.

%% Exercise 5 — Edges
edgesSobel = edge(I,'sobel');
edgeC1 = edge(I,'canny',[],1);
edgeC2 = edge(I,'canny',[],2);
edgeC3 = edge(I,'canny',[],3);
disp(['Canny edge pixels, sigma=1: ' num2str(nnz(edgeC1))]);
disp(['Canny edge pixels, sigma=2: ' num2str(nnz(edgeC2))]);
disp(['Canny edge pixels, sigma=3: ' num2str(nnz(edgeC3))]);
% Even baseline Canny has internal Gaussian smoothing. The second case
% adds an explicit preprocessing smoothing step for comparison.
noisyCanny = edge(noiseGaussian,'canny',[],1);
preSmoothed = imgaussfilt(noiseGaussian,1.5);
smoothedCanny = edge(preSmoothed,'canny',[],1);
countNoisy = nnz(noisyCanny);
countSmoothed = nnz(smoothedCanny);
% A pixel is an approximate false edge if it is more than one pixel away
% from the clean-image reference edge map (3x3 spatial tolerance).
referenceEdge = edge(I,'canny',[],1);
referenceTolerance = imdilate(referenceEdge,strel('square',3));
falseBefore = nnz(noisyCanny & ~referenceTolerance);
falseAfter = nnz(smoothedCanny & ~referenceTolerance);
falseRemoved = falseBefore - falseAfter;
disp('Exercise 5: Noisy-image Canny results');
disp(['Edge pixels without extra smoothing: ' num2str(countNoisy)]);
disp(['Edge pixels with extra smoothing: ' num2str(countSmoothed)]);
disp(['Approx. false-edge pixels before smoothing: ' num2str(falseBefore)]);
disp(['Approx. false-edge pixels after smoothing: ' num2str(falseAfter)]);
disp(['Net approximate false-edge pixels removed: ' num2str(falseRemoved)]);
tiledlayout(2,4,'TileSpacing','compact','Padding','compact');
nexttile; imshow(edgesSobel); title('Sobel');
nexttile; imshow(edgeC1); title('Canny sigma = 1');
nexttile; imshow(edgeC2); title('Canny sigma = 2');
nexttile; imshow(edgeC3); title('Canny sigma = 3');
nexttile; imshow(noiseGaussian); title('Gaussian noisy input');
nexttile; imshow(noisyCanny); title(['Canny: ' num2str(countNoisy)]);
nexttile; imshow(smoothedCanny); title(['Extra smooth: ' num2str(countSmoothed)]);
nexttile; imshow(referenceEdge); title('Clean-image reference');
sgtitle('Exercise 5: Edge detectors and Gaussian smoothing');
% Think about: Increasing sigma removes many fine and noisy edges but
% can also erase real small details. The signed falseRemoved value above
% measures net removed false-edge pixels relative to the clean reference;
% it is an estimate, not an exact count of false physical boundaries.

%% Exercise 6 — Segment and measure
C = imread('coins.png');
if size(C,3) == 3
    C = rgb2gray(C);
end
otsuThreshold = graythresh(C);
BW = imbinarize(C,otsuThreshold);
% Make the background black if the four image corners are mostly white.
if mean(double(BW([1 end],[1 end])),'all') > 0.5
    BW = ~BW;
end
% Opening removes thin protrusions and isolated bright speckles.
BWopened = imopen(BW,strel('disk',2));
% Filling repairs dark holes inside each coin.
BWfilled = imfill(BWopened,'holes');
% Remove tiny remaining disconnected white components (not coins).
BWclean = bwareaopen(BWfilled,100);
CC = bwconncomp(BWclean,8);
stats = regionprops(CC,'Area','Centroid');
areas = [stats.Area]';
coinIds = (1:CC.NumObjects)';
Area_table = table(coinIds,areas,'VariableNames',{'Coin_ID','Area_pixels'});
disp(['Exercise 6: Otsu threshold = ' num2str(otsuThreshold,4)]);
disp(['Connected coin regions found: ' num2str(CC.NumObjects)]);
disp(Area_table);
if ~isempty(stats)
    [largestArea,largestID] = max(areas);
    disp(['Largest region: coin ' num2str(largestID) ...
          ', area = ' num2str(largestArea) ' pixels']);
end
L = labelmatrix(CC);
RGB = label2rgb(L,'jet','k','shuffle');
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
nexttile; imshow(C); title('Original coins.png');
nexttile; imshow(BW); title('Otsu threshold');
nexttile; imshow(BWopened); title('Opening: remove speckles');
nexttile; imshow(BWfilled); title('Hole filling');
nexttile; imshow(BWclean); title('Final binary mask');
nexttile; imshow(RGB); title([num2str(CC.NumObjects) ' labeled regions']);
hold on;
for index = 1:CC.NumObjects
    xy = stats(index).Centroid;
    text(xy(1),xy(2),num2str(index),'Color','white', ...
        'FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
end
hold off;
sgtitle('Exercise 6: Otsu segmentation and region labeling');
% Think about: imopen removes small white speckles and narrow connections;
% imfill repairs dark holes; bwareaopen removes leftover tiny components.
% The largest region is printed above. Touching coins merge if connected
% in the final binary mask; connected-components labeling cannot separate
% them unless segmentation first disconnects them.
