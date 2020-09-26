clc, clear, close all
tic
f = filesep;
%folder where the source data is stored
path = '.\Data\*.tif';
%output folder
red_path = ['.\Red'];
if exist(red_path) ~= 7
   mkdir(red_path) 
end
green_path = ['.\Green'];
if exist(green_path) ~= 7
   mkdir(green_path) 
end
blue_path = ['.\Blue'];
if exist(blue_path) ~= 7
   mkdir(blue_path) 
end
otsu_path = ['.\Otsu'];
if exist(otsu_path) ~= 7
    mkdir(otsu_path)
end
%index all tif images
img_dir = dir(fullfile(path));
[nr, ~] = size(img_dir);

for i = 1:length(img_dir)
    img = imread([img_dir(i).folder '\' img_dir(i).name ]);

    figure, imshow(img);
    [R,G,B] = imsplit(img);
    
    %RED
    figure
    redFile = [red_path '\' img_dir(i).name];
    imwrite(R, redFile);
    imshow(R)
    title('Red Channel')
    
    %Otsu
    [countsR,x] = imhist(R,16);
    T1 = otsuthresh(countsR);
    BW1 = imbinarize(R,T1);
    figure
    imshow(BW1)
    title('Red Otsu')
    
    %Morphological
    [~,threshold] = edge(BW1,'sobel');
    fudgeFactor = 0.5;
    BWsR = edge(BW1,'sobel',threshold * fudgeFactor);
    imshow(BWsR)
    title('Binary Gradient Mask - Red')
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    dilR = imdilate(BWsR,[se90 se0]);
    imshow(dilR)
    title('Dilated Gradient Mask - Red')
    eroR = imerode(dilR, [se90 se0]);
    figure
    imshow(eroR)
    title('Dilated and Eroded Gradient Mask - Red')
    
    %Watershed
    binR = imbinarize(R);
    D1 = bwdist(~binR);
    D1 = -bwdist(~binR);
    Lred = watershed(D1);
    binR(Lred == 0) = 0;
    figure
    imshow(binR)
    title('Red Watershed')   
    
    %GREEN
    figure
    greenFile = [green_path '\' img_dir(i).name];
    imwrite(G, greenFile);
    imshow(G)
    title('Green Channel')
    
    %Otsu
    [countsG,y] = imhist(G,16);
    T2 = otsuthresh(countsG);
    BW2 = imbinarize(G,T2);
    otsuFile = [otsu_path '\' img_dir(i).name];
    imwrite(BW2, otsuFile);
    figure
    imshow(BW2)
    title('Green Otsu')
    
    %Morphological
    [~,threshold] = edge(BW2,'sobel');
    fudgeFactor = 0.5;
    BWsG = edge(BW2,'sobel',threshold * fudgeFactor);
    imshow(BWsG)
    title('Binary Gradient Mask - Green')
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    dilG = imdilate(BWsG,[se90 se0]);
    imshow(dilG)
    title('Dilated Gradient Mask - Green')
    eroG = imerode(dilG, [se90 se0]);
    figure
    imshow(eroG)
    title('Dilated and Eroded Gradient Mask - Green')
    
    %Watershed
    binG = imbinarize(G);
    D2 = bwdist(~binG);
    D2 = -bwdist(~binG);
    Lgreen = watershed(D2);
    binG(Lgreen == 0) = 0;
    figure
    imshow(binG)
    title('Green Watershed')   
    
    %BLUE
    figure
    blueFile = [blue_path '\' img_dir(i).name];
    imwrite(B, blueFile);
    imshow(B)
    title('Blue Channel')
    
    %Otsu
    [countsB,z] = imhist(B,16);
    T3 = otsuthresh(countsB);
    BW3 = imbinarize(B,T3);
    figure
    imshow(BW3)
    title('Blue Otsu')
    
    %Morphological
    [~,threshold] = edge(BW3,'sobel');
    fudgeFactor = 0.5;
    BWsB = edge(BW3,'sobel',threshold * fudgeFactor);
    imshow(BWsB)
    title('Binary Gradient Mask - Blue')
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    dilB = imdilate(BWsB,[se90 se0]);
    imshow(dilB)
    title('Dilated Gradient Mask - Blue')
    eroB = imerode(dilB, [se90 se0]);
    figure
    imshow(eroB)
    title('Dilated and Eroded Gradient Mask - Blue')   
end

toc