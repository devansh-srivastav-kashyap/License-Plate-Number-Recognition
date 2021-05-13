%% License Plate Character Recognition and Identification Project

load dataset;

%take the data input by asking the user to select the image from the folder
[x,y]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Select an image');
s=[y,x];
img=imread(s);
[~,cc]=size(img);
picture=imresize(img,[300 500]);

figure; imshow(picture); 
%convert rgb to gray
if size(picture,3)==3
  picture=rgb2gray(picture);
end

threshold = graythresh(picture);
picture =~im2bw(picture,threshold);
%remove all those components from the binary image whose number of pixels
%is less than 30
picture = bwareaopen(picture,30);

if cc>2000
    picture1=bwareaopen(picture,3500);
else
    picture1=bwareaopen(picture,3000);
end
picture2=picture-picture1;

picture2=bwareaopen(picture2,200);
% lab represents the label matrix for connected components in the binary
% image
% Ne denotes the number of connected components
[lab,labn]=bwlabel(picture2);

% regionprops have been used to get the measurements of the smallest box
% that covers the entire region of interest(for us, the license plate)
roi=regionprops(lab,'BoundingBox');
hold on
pause(1)

%draw the rectangular boxes to point out the characters
for n=1:size(roi,1)
  rectangle('Position',roi(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

figure
final_output=[];
t=[];
for n=1:labn
  [r,c]=find(lab==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  
  %display all the extracted characters
  figure
  imshow(n1);
  pause(0.2)
  x=[ ];
  totalLetters=size(imgfile,2);

 for k=1:totalLetters
    % performs correlation operation between the dataset image and the input image
     y=corr2(imgfile{1,k},n1); 
     x=[x y];
 end
 t=[t max(x)];
 if max(x)>.35
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));

final_output=[final_output out];
end
end

msgbox(strcat('Vehicle License Number:',final_output));
