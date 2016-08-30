function alpha=solveAlpha(I,consts_map,consts_vals,varargin)
  
  [h,w,c]=size(I);%I=105 h=70 w=70
  img_size=w*h;

  A=getLaplacian1(I,consts_map,varargin{:});%4900*4900
  imshow(consts_map);
  D=spdiags(consts_map(:),0,img_size,img_size);%4900*4900

  lambda=100;
  x=(A+lambda*D)\(lambda*consts_map(:).*consts_vals(:));%4900*1
 
  alpha=max(min(reshape(x,h,w),1),0);%70*70

