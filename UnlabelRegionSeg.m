function alpha=UnlabelRegionSeg(I,mask)
Foremask=(mask==1);
Backmask=(mask==-1);
UnlableRegion=(mask==0);
Image=reshape(double(I),size(I,1)*size(I,2),1);
alpha=reshape(mask,size(I,1)*size(I,2),1);
alpha(alpha==-1)=0;

%%利用KNN找到最近的距离 生成训练和测试数据
[xf,yf]=find(Foremask==1);ForePoint=[xf,yf];
[xb,yb]=find(Backmask==1);BackPoint=[xb,yb];
[xu,yu]=find(UnlableRegion==1);TestSample=[xu,yu];
[~,D1]=knnsearch(TestSample,ForePoint);
[~,D2]=knnsearch(TestSample,BackPoint);
[~,idx]=sort(D1+D2);
UnLabelSort=TestSample(idx,:);%未知像素点的坐标
n=size(TestSample,1);
%%对测试样本分块
r=20;p={};
for i=1:n
  if(isempty(UnLabelSort))
      break;
  else
     
      index = FindNear(UnLabelSort(1,:),UnLabelSort,r);
      p{i}  = UnLabelSort(index==1,:);
      UnLabelSort(index==1,:)=[];
  end
end
%%找到每一块的距离最近的几个前景和背景点（与论文相比省略了相似度的计算） 然后训练SVR
K=20;
for j=1:size(p,2)
    O=mean(p{1,j});
    [idx1,~]=knnsearch(O,ForePoint,K);
    ForeTrainCor=ForePoint(idx1,:);
    ForeTrainInd=sub2ind(size(I),ForeTrainCor(:,1),ForeTrainCor(:,2));
    ForeData=Image(ForeTrainInd);
    [idx2,~]=knnsearch(O,BackPoint,K);
    BackTrainCor=BackPoint(idx2,:);
    BackTrainInd=sub2ind(size(I),BackTrainCor(:,1),BackTrainCor(:,2));
    BackData=Image(BackTrainInd);
    TrainData=[ForeData;BackData];
    TrainLabel=[ones(size(ForeTrainCor,1),1);zeros(size(BackTrainCor,1),1)];
    TestDataCor=p{1,j};
    TestDataInd=sub2ind(size(I),TestDataCor(:,1),TestDataCor(:,2));
    TestData=Image(TestDataInd);
    model = svmtrain(TrainLabel, TrainData, ' -s 3 -t 2 -c 0.5 -p 0.08 ');
    TestLabal = svmpredict(zeros(length(TestData),1), TestData, model);
    alpha(TestDataInd)=TestLabal;
end
alpha(alpha>1)=1;
alpha(alpha<0)=0;
alpha=reshape(alpha,size(I));









