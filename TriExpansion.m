function  mask = TriExpansion(I,trimap,thr_d,thr_c)
I=double(I)/255;
Fmask=(trimap>220);
Bmask=(trimap<50);
KnownPix=(Fmask|Bmask);
KnownPixLabel=double(3*Bmask)+double(Fmask);%背景用3标记 前景用1标记
ExpandMask=double(3*Bmask)+double(Fmask);
Dilatefilt=ones(2*thr_d);
DilateTri=imdilate(KnownPix,Dilatefilt);
ExpandPix=(DilateTri-KnownPix);

Ci=1+thr_d;
a=1:Ci;
dist=(a-Ci*ones(1,Ci))'.^2;
% dist1=repmat(dist,Ci,1);
% dist2=reshape(repmat(dist',8,1),Ci*Ci,1);
A=reshape(sqrt(repmat(dist,Ci,1)+reshape(repmat(dist',Ci,1),Ci*Ci,1)),Ci,Ci);
B= fliplr(A);
C=flipud(A);
D=rot90(A,2);
Distance=[A B(:,2:end);C(2:end,:) D(2:end,2:end)];
[h,w]=size(I);
for i=1:h
    for j=1:w
        if ExpandPix(i,j)==1
          LeftBoud=max(j-thr_d,1);RightBoud=min(j+thr_d,w);
          TopBoud=max(i+thr_d,1);LowBoud=min(i+thr_d,h);
          winI=I(TopBoud:LowBoud,LeftBoud:RightBoud);
          KnowPixBlock  = KnownPixLabel(TopBoud:LowBoud,LeftBoud:RightBoud);
          KnownPixBlock=KnownPix(TopBoud:LowBoud,LeftBoud:RightBoud);
          GrayDist=(winI-I(i,j))<thr_c;
          Distortion=(GrayDist.*KnownPixBlock)>0;
          Leftlabel=Ci-(j-LeftBoud);RightLabel=Ci-(j-RightBoud);
          Toplabel=Ci-(i-TopBoud) ;LowLabel=Ci-(i-LowBoud);
          D=Distance(Toplabel:LowLabel,Leftlabel:RightLabel);
          
          if sum(Distortion(:))>=1
              DChek=D(Distortion);
              [~,ind]=min(DChek);
              CandidatePix=KnowPixBlock(Distortion);
              ExpandMask(i,j)=CandidatePix(ind);
          end
          
        end
       
        
    end
end

MaskFExp=(ExpandMask==1);
MaskBExp=(ExpandMask==3);
mask=zeros(h,w);
mask(MaskFExp)=1;
mask(MaskBExp)=-1;






