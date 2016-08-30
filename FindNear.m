function ind=FindNear(Q,R,r)
%找到K个相邻的点 Q：一个点 R：点集 r：距离阈值
L=size(R,1);
D=sum((repmat(Q,L,1)-R).^2,2);
ind=(D<r);