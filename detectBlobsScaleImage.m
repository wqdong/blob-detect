function blobs = detectBlobsScaleImage(im)

Im = im2double(rgb2gray(im));
[h w] = size(Im);
scaleIm = zeros(h,w,11);
filter = fspecial('log',13,2)*4;
radius = zeros(11);

for i = 1:11
    scale = 1.2^(-i+1);
    radius(i) = 2*sqrt(2)/scale;
    sIm = imresize(Im,scale,'bicubic');
    convIm = abs(imfilter(sIm,filter,'replicate'));
    convIm = imresize(convIm,[h w],'bicubic');
    convIm(convIm < 0.06) = 0;
    scaleIm(:,:,i) = convIm;
end

maxz = max(scaleIm,[],3);
compz = ordfilt2(maxz,25,true(5));
maxz(maxz < compz) = 0;

num = 1;
for k = 1:11
    for i = 1:h
        for j = 1:w
             if  scaleIm(i,j,k) > 0 && scaleIm(i,j,k) == maxz(i,j)
                 blobs(num,:) = [j,i,radius(k),scaleIm(i,j,k)];
                 num = num + 1;
             end
        end
    end
end
