k=10;                 %弹性系数
x1=1;                 %x，y表示物体1。2.3初始位移速度
x2=5;                 
x3=10;                
y1=3;                 
y2=0;y3=0;
s1=linspace(0,0,100);  %s，v储存物体位移和速度
v1=linspace(0,0,100);
s2=linspace(0,0,100);
v2=linspace(0,0,100);
s3=linspace(0,0,100);
v3=linspace(0,0,100);
i=0;m=1;
for n=1:50001
    a1=-k*(5-(x2-x1));
    a2=k/2*(x1+x3-2*x2);
    a3=k/3*(5-(x3-x2));
    y1=y1+a1*0.0001;
    x1=x1+y1*0.0001;
    y2=y2+a2*0.0001;
    x2=x2+y2*0.0001;
    y3=y3+a3*0.0001;
    x3=x3+y3*0.0001;
    i=i+1;
    if i==1
        i=0;
        s1(m)=x1;v1(m)=y1;
        s2(m)=x2;v2(m)=y2;
        s3(m)=x3;v3(m)=y3;
        m=m+1;
    end
    
end
N=0:0.0001:5;    %时间表
figure
plot(N,s1,N,s2,N,s3)
plot(N,v1,N,v2,N,v3)