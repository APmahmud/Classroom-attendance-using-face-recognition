%% Simple Face Recognition Example
%  Copyright 2014-2015 The MathWorks, Inc.
%% Load Image Information from ATT Face Database Directory

clc
clear all 

faceDatabase = imageSet('DatasetCascade','recursive');

%% Display Montage of First Face
figure;
montage(faceDatabase(3).ImageLocation);
title('Images of Single Face');


%% Extract and display Histogram of Oriented Gradient Features for single face 
 trainingFeatures = zeros(size(faceDatabase,2)*faceDatabase(1).Count,36864);
 maincounter = 1 ;
for x=1:size(faceDatabase,2)
     for y=1:faceDatabase(x).Count 
        person = read(faceDatabase(x),y);
       % person= rgb2gray(personS) ;
        %imshow(person) ;
        features = detectSURFFeatures(person,'MetricThreshold',0.1) ;
% figure;
% imshow(person);
% title('Feature Points from Box Image');
% hold on;
% plot(features);
   [ExtractS, features] = extractFeatures(person, selectStrongest((features), 126), 'SURFSize',128) ;
         trainingLabel{maincounter} = faceDatabase(x).Description;  
     p = ExtractS' ;
 extractSL =  p(:)' ;
        
       trainingFeatures(maincounter,1:16128) = extractSL ;
    
featuresM = extractHOGFeatures(read(faceDatabase(x),y));

trainingFeatures(maincounter,16129:36864) = featuresM ;
 
     maincounter =maincounter+1  ;
     end
     personIndex{x} = faceDatabase(x).Description;
end
    
 

%% Create 40 class classifier using fitcecoc 
faceClassifier = fitcecoc(trainingFeatures,  trainingLabel);


%% Test Images from Test Set 
%%person = 1;
finalFeature =zeros(1,36864) ;

queryImage = imread('1.jpg') ;
%queryImage = rgb2gray(query) ;
queryImage = imresize(queryImage,[200,200]) ;
queryFeatures = detectSURFFeatures(queryImage,'MetricThreshold',0.1) ;
[ExtractTargetS, queryFeatures] = extractFeatures(queryImage, selectStrongest((queryFeatures), 126), 'SURFSize',128) ;
      p = ExtractTargetS' ;
 ExTar =  p(:)' ;
 
 finalFeature(1,1:16128) = ExTar ;
 
 featuresM = extractHOGFeatures(queryImage);

 finalFeature(1,16129:36864) = featuresM ;
 

 
 
[personLabel, score] = predict(faceClassifier,finalFeature);

% Map back to training set to find identity 
booleanIndex = strcmp(personLabel,  personIndex);
integerIndex = find(booleanIndex);
subplot(1,2,1);imshow(queryImage);title('Query Face');
subplot(1,2,2);imshow(read(faceDatabase(integerIndex),1));title('Matched Class');



