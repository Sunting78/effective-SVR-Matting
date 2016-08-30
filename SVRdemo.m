function SVRdemo()

%% parameters to change according to your requests
fn_im='.\test.jpg';
fn_mask='.\1.jpg';
% addpath(genpath('./code'));
%% read image and mask
% imdata=rgb2gray(imresize(imread(fn_im),0.25));
imdata=imresize(imread(fn_im),0.25);
% mask=imresize(getMask_onlineEvaluation(fn_mask),0.2);
%  mask=getMask_onlineEvaluation(fn_mask);%%1为前景，-1为背景 0为未知点
trimap=imresize(imread(fn_mask),0.25);
%三分图扩展
thr_d=5;thr_c=8/255;
tic;
mask=TriExpansion(imdata,trimap,thr_d,thr_c);%1为前景，-1为背景 0为未知点
% imshow(mask,[]);
alpha1=UnlabelRegionSeg(imdata,mask);
mask1=mask;
mask1(mask==-1)=1;
alpha=solveAlpha(double(imdata),mask1,alpha1);
imshow(alpha);
% F=solveFB(double(imdata),alpha);
% figure,imshow(F,[]);