
%

clear all;
clc 
%% Create dataset. 
% note, this saves 200x200 pictures of faces from given images

faceDatabase = imageSet('Dump','recursive');

%%

faceDetectorOne = vision.CascadeObjectDetector('FrontalFaceCART');
writecounter = 1 ;
for i=1:size(faceDatabase,2)
    for j = 1:faceDatabase(i).Count
        img = read(faceDatabase(i),j) ;
             img = rgb2gray(img); 
             face =step (faceDetectorOne, img ) ;
             
          
          for S = 1:size(face,1)
                R= imcrop(img,face(S,:));
                imgR = imresize(R,[200,200]) ;
                filename = ['H:\Final Dump\' num2str(writecounter) '.jpg'];
              imwrite(imgR,filename) ;
             writecounter = writecounter +1 ;
             
             
             
          end
    
    
    end
   
end
