clc, clear, close all
tic
f = filesep;
%folder where the source data is stored
path = '.\Otsu\*.tif';

img_dir = dir(fullfile(path));
[nr, ~] = size(img_dir);
for i = 1:length(img_dir)
    img = imread([img_dir(i).folder '\' img_dir(i).name ]);
    imshow(img);
    disp(img_dir(i).name);
    totalPixels = numel(img);
    whitePixels = sum(img(:));
    ratioWhite = whitePixels / numel(img);
    percentWhite = nnz(img)/numel(img);
end

toc