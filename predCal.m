
/*
 * predCal.m
 * Author: Janki Bhimani
 */

clear all
% load('tc.mat');
% load('sc.mat');
% load('util.mat');
alpha = 0.2200
TC = [-970617787.639693;28707232.4907273;27751880.1765038;10777.3755005557];
SC = [-436613281.886445;12637504.6424512;12458123.4869892;4135.26509310579];
UTIL = [0.439488927218601;0.00764793259072227;0.00641704336713192;2.96723156197624e-07];
%iter = [1,1,1,1,1,1,1,1];
%iter=[132,22,9,8,8,20,6]%,6]%,5,5];
%iter=[65,24,10,9,8,6];
%iter=[10,11,4,6,5,5,5,3]%,3,3,3];
iter=[2,2,2,4,2,5,13,42]%,4,5,2];
K = 50;
temp=iter;
%threads=[2,3,6,10,17,21,25,51,76,101,121];
%threads=[2,7,13,20,37,40]%,58,73,82,109,115];
%threads=[2,6,13,16,37,40];
%threads=[2,5,7,11,13,19,28,37,40]%,109,215];
%threads=[2,6,12,21,30,38,40]%,75,101,117];
%threads=[2,6,17,26,32,40]%,51,63]%,81,101]
%threads=[2,6,11,17,27,40]%,51,66]%,81,105];
%threads=[2,3,7,13,19,26,37,40]%,61]%,91];
%threads=[2,5,11,17,21,33,40]%,51]%,81,101];
%threads=[2,6,12,16,34,40]%56,62];
%threads=[2,3,6,10,17,21,25,40]%,76,101,121];
threads=[2,3,6,11,17,21,26,40]%,81,101,129];
for ii=1:numel(threads)
    t=threads(ii);
p = 1;
        for k = 1:numel(iter)
            PredTC(1,p) =alpha*(TC(1) + (TC(2)*iter(k)) + (TC(3)*K) + (TC(4)*204800));
            p = p+1;
        end
q = 1;
        for k = 1:numel(iter)
            PredSC(1,q) =alpha*(SC(1) + (SC(2)*iter(k)) + (SC(3)*K) + (SC(4)*204800));
            q = q+1;
        end

r = 1;

        for k = 1:numel(iter)
            PredUTIL(1,r) =alpha*(UTIL(1) + (UTIL(2)*iter(k)) + (UTIL(3)*K) + (UTIL(4)*204800));
            r = r+1;
        end

A= PredUTIL;
P= PredSC./PredTC;
PA= 1-P;
AP= 1-A-(1./PredTC);
m=3;
n=t+1;
s=zeros(t+1,t+1,m,numel(A));
for y=1:numel(threads)
while (m>0)
    if m==1
    for k=1:t+1
        i=k-1; j=k-i-1;
        while ((i+j <= k)&&(j<=t-k+1)&&(i>=0))
            s(k,n,m,y) = s(k,n,m,y) + nchoosek(t-k+1,j)*A(y)^(t-k+1-j)*AP(y)^(j)*nchoosek(k-1,i)*P(y)^(i)*PA(y)^(k-1-i);
            i=i-1; j=j+1;
        end
    end
    end
    if m==2
        for n=1:t+1
            for k=n+1:t+1
                i=n;j=0;
                while (i+j<=k)&&(i>=0)&&(j<=n-1)&&(j<=t-k+1)
                  s(k,n,m,y) = s(k,n,m,y) + nchoosek(t-k+1,j)*A(y)^(t-k+1-j)*AP(y)^(j)*nchoosek(k-1,i-1)*P(y)^(i-1)*PA(y)^(k-i);
                 i=i-1;j=j+1;
                end
            end
        end 
    end
    if m==3
        for k=1:t+1
            for n=k+1:t+1
                i=k;j=n-k;
                while (i+j<=n)&&(i>=1)&&(j<=t-k+1)
                   s(k,n,m,y) = s(k,n,m,y) + nchoosek(t-k+1,j)*A(y)^(t-k+1-j)*AP(y)^(j)*nchoosek(k-1,i-1)*P(y)^(i-1)*PA(y)^(k-i);
                   i=i-1;j=j+1;
                end
            end
        end
    end     
   m=m-1;
end
m=1;n=t+1;sum=zeros(numel(A),1);
for k=1:t+1
    if (k==1)&&(n==t+1)
        sum(y)=sum(y) + s(k,n,m,y);
    end
end

m=3;
for k=1:t+1
    for n=k+1:t+1
        if k==1
            sum(y)=sum(y) +s(k,n,m,y);
        end
    end
end
Ps(y)=1-sum(y);
Gz=2.4e9;
rate(y)= Ps(y).*Gz;
ct(y)=1./rate(y);
time(y)=ct(y);
end
time=time';
thread_time(ii)=time(1);
end
% plot(threads,thread_time,'b');hold
% plot(threads,input6_data(2,:),'r');
% plot(threads,input6_data(3,:),'m');
% stem(threads,thread_time),'b';
% stem(threads,input6_data(2,:));
% stem(threads,input6_data(3,:));
% xlabel('Threads');ylabel('Time in sec');
% title('Calculation time for Input6(50325)');
% legend('Test Data','Predicted','Simple Model')
thread_time'


