
% Bajecode Evolution IX
% Uses HoG & LBP features
% Proudly Created By Thesis Group Gray
% BRAC University
% Dhaka, Bangladesh
% Year 2017 
%!!!!! Important notes !!!!!!!
% for Manual Dataset, set trainingFeatures's size to 224255 on line 27
% for Cascade Dataset, set trainingFeatures's size to 35555 on line 27
% set image resize size to 500x500 on line 64 for using Manual Dataset
% set image resize size to 200x200 on line 64 for using Cascade Dataset
% comment line no 32 for using cascade dataset
%% Initialize Database and other important stuff 

clc
clear all

faceDatabase = imageSet('DatasetCascade','recursive');
Camera  = imaq.VideoDevice('kinect',1) ;
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold',5);
videoPlayer  = vision.VideoPlayer();
conn = database('project2','root','','Vendor','MySQL',...
                'Server','localhost') ;




%% Extract HoG and LBP features from trainig dataset
trainingFeatures = zeros(size(faceDatabase,2)*faceDatabase(1).Count,35555);
featureCount = 1;
for i=1:size(faceDatabase,2)
    for j = 1:faceDatabase(i).Count
        img = read(faceDatabase(i),j) ;
           %  img = rgb2gray(img);
           trainingFeatures(featureCount,1:995) = extractLBPFeatures(img,'NumNeighbors',32);
        trainingLabel{featureCount} = faceDatabase(i).Description;    
        
        trainingFeatures(featureCount,996:35555) = extractHOGFeatures(img, 'NumBins', 15);
        
        
       featureCount = featureCount + 1;
   
    
    end
   
end

%% Create classifier
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);

%% Capture frame from camera and match detected faces from each frame
finalFeature =zeros(1,35555) ;
frameNumber = 0;
writecounter = 0 ;
Detected = '' ;
Store_name = cell(1,3);
store = 1;
match = 1;
clause = ['where name =' '''' ss ''''] ;
col={'Attendance'};
val={match};
 
 
while frameNumber<500
    
    frameRGB = step(camera);
   
    frame = rgb2gray(frameRGB);
    
      bboxOne            = step(faceDetector, frame);
  
   for i = 1:size(bboxOne,1)
      J= imcrop(frame,bboxOne(i,:));
     queryImage = imresize(J,[200,200]) ;
            qf = extractLBPFeatures(queryImage,'NumNeighbors',32); 
           queryFeatures = extractHOGFeatures(queryImage, 'NumBins', 15);
           finalFeature(1:995)= qf ;
           finalFeature(996:35555)= queryFeatures ;
            personLabel = predict(faceClassifier,finalFeature);
             Detected = personLabel  ;
             
             c = 5  ;
        for j=1:3
            temp = Store_name{1,j} ;
            
            if (strcmp(temp ,personLabel))
              c = 1 ;  
              break ;
            end
        end
        if (c==5) 
        
            Store_name{1, store} = personLabel ;
            store=store+1 ;
            ss = personLabel{1,1} ;
           
            update(conn, 'student', col, val, clause) ;
            
        end
             
  end
    
    FrameS = insertText(frameRGB,[10,50],Detected,'AnchorPoint','LeftTop');
    Frame = insertObjectAnnotation(FrameS,'rectangle',bboxOne,'Face!!!');
    %FrameSide = insertObjectAnnotation(frameRGB,'rectangle', bboxTwo, 'Face!!!') ;
        
   step(videoPlayer, Frame) ;
    
    
    frameNumber = frameNumber + 1;

      
      %crop faces and convert it to gray
     
end

%% show updated database

curs = exec(conn,'select * from student');
curs = fetch(curs);
curs.Data


%% personal note

%Dear BajeCode
%You are a beautiful bastard
%u were a real pain in the ass but I've learnd a lot from you :D
%Signing Out
%Asif Mahmud


