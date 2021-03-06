function blobs = detectBlobsScaleFilter(im)

Im = im2double(rgb2gray(im));
[h w] = size(Im);
scaleIm = zeros(h,w,11);
radius = zeros(11);

for i = 1:11
    sigma = 2*1.2^(i-1);
    mask = 2*floor(3*sigma)+1;
    radius(i) = sigma*sqrt(2);
    filter = fspecial('log',mask,sigma)*sigma^2;
    convIm = abs(imfilter(Im,filter,'replicate'));
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
