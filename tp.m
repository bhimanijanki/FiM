
/*
 * tp.m
 * Author: Janki Bhimani
 */

%clc; clear all;
tc=load('tc.mat'); sc=load('sc.mat'); util=load('util.mat'); act_time=load('act_time.mat');
tc=tc.tc; sc=sc.sc; util=util.util; act_time=act_time.act_time;act_time=act_time';
a = [6;8;16;20;26;30];
temp=[6*ones(6,1);8*ones(6,1);16*ones(6,1);20*ones(6,1);26*ones(6,1);30*ones(6,1);];

e = [90000;64000;50440];

X(:,1)=repmat(a,18,1);
X(:,2)=repmat(temp,3,1);
X(:,3)=[repmat(e(1),36,1);repmat(e(2),36,1);repmat(e(3),36,1)];
% 
% TC = regress(tc,[ones(length(tc),1),X]);
% SC = regress(sc,[ones(length(sc),1),X]);
% UTIL = regress(util,[ones(length(util),1),X
t=input('Enter number of threads');
alpha=1; StopTolerance=10;
while StopTolerance>1e-2
TCfit = fitlm(X,tc,'linear');
SCfit = fitlm(X,sc,'linear');
UTILfit = fitlm(X,util,'linear','RobustOpts','logistic');
TC= TCfit.Coefficients{:,1};
SC= SCfit.Coefficients{:,1};
UTIL= UTILfit.Coefficients{:,1};
% UTIL=UTIL-0.35;
p = 1;
for i = 1:3
    for j = 1:6
        for k = 1:6
            PredTC(1,p) =alpha*(TC(1) + (TC(2)*a(k)) + (TC(3)*a(j)) + (TC(4)*e(i)));
            p = p+1;
        end
    end
end
q = 1;
for i = 1:3
    for j = 1:6
        for k = 1:6
            PredSC(1,q) =alpha*(SC(1) + (SC(2)*a(k)) + (SC(3)*a(j)) + (SC(4)*e(i)));
            q = q+1;
        end
    end
end
r = 1;
for i = 1:3
    for j = 1:6
        for k = 1:6
            PredUTIL(1,r) =alpha*(UTIL(1) + (UTIL(2)*a(k)) + (UTIL(3)*a(j)) + (UTIL(4)*e(i)));
            r = r+1;
        end
    end
end

% tctest = TC(1) + (TC(2)*26) + (TC(3)*26) + (TC(4)*90000) 
%+(TC(5)*30*30) + (TC(6)*30*30) + (TC(7)*90000*90000) 


% sctest = SC(1) + (SC(2)*26) + (SC(3)*26) + (SC(4)*90000) 
%+(SC(5)*30*30) + (SC(6)*30*30) + (SC(7)*90000*90000)

% utiltest = UTIL(1) + (UTIL(2)*26) + (UTIL(3)*26) + (UTIL(4)*90000) 
%+(UTIL(5)*30*30) + (UTIL(6)*30*30) + (UTIL(7)*90000*90000) 

for i=1:108
    if PredSC(i)<0
        PredSC(i)=0.4e8;
    end
    if PredSC(i)>PredTC(i)
        PredSC(i)=PredSC(i)*0.1;
    end
end
for i=1:108
    if PredTC(i)<0
        PredTC(i)=0.4e9;
    end
end
A= PredUTIL;
P= PredSC./PredTC;
PA= 1-P;
AP= 1-A-(1./PredTC);
% subplot(3,1,1)
% scatter(X(:,1),tc)
% subplot(3,1,2)
% scatter(X(:,1),sc)
% subplot(3,1,3)
% scatter(X(:,1),util)
m=3;
n=t+1;
s=zeros(t+1,t+1,m,108);
for y=1:108
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


m=1;n=t+1;sum=zeros(108,1);
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
Ps(y)=1-sum(y);Gz=2.4e9;
rate(y)= Ps(y).*Gz;
ct(y)=1./rate(y);
time(y)=ct(y);
end
diff_time = act_time - time;
countpos=0;countneg=0;
for i=1:108
    if diff_time(i)>0
        countpos=countpos+1;
    else
        countneg=countneg+1;
    end
end
if countpos > countneg
    alpha=alpha+0.01;
else
    break
end
rms_error = sqrt(mean((act_time-time).^2));
StopTolerance =rms_error
end

save('TC.mat','TC');
save('SC.mat','SC');
save('UTIL.mat','UTIL');
save('alpha.mat','alpha');
% %% Actual v/s Predicted time Input2 90000
% x=a;y=a;
% za=[act_time(1:6)' act_time(7:12)' act_time(13:18)' act_time(19:24)' act_time(25:30)' act_time(31:36)'];
% [X,Y]=meshgrid(x,y);
% figure(1)
% mesh(X,Y,za);hold
% zp=[time(1:6)' time(7:12)' time(13:18)' time(19:24)' time(25:30)' time(31:36)'];
% surf(x,y,zp);xlabel('K');ylabel('Iterations');zlabel('Calculation time in sec');title('Input-2(90000)');legend('Actual','Predicted')
% 
% 
% %% Actual v/s Predicted time Input3 64000
% x=a;y=a;
% za=[act_time(37:42)' act_time(43:48)' act_time(49:54)' act_time(55:60)' act_time(61:66)' act_time(67:72)'];
% [X,Y]=meshgrid(x,y);
% figure(2)
% mesh(X,Y,za);hold
% zp=[time(37:42)' time(43:48)' time(49:54)' time(55:60)' time(61:66)' time(67:72)'];
% surf(x,y,zp);xlabel('K');ylabel('Iterations');zlabel('Calculation time in sec');title('Input-3(64000)');legend('Actual','Predicted')
% 
% %% Actual v/s Predicted time Input4 50440
% x=a;y=a;
% za=[act_time(73:78)' act_time(79:84)' act_time(85:90)' act_time(91:96)' act_time(97:102)' act_time(103:108)'];
% [X,Y]=meshgrid(x,y);
% figure(3    )
% mesh(X,Y,za);hold
% zp=[time(73:78)' time(79:84)' time(85:90)' time(91:96)' time(97:102)' time(103:108)'];
% surf(x,y,zp);xlabel('K');ylabel('Iterations');zlabel('Calculation time in sec');title('Input-3(50440)');legend('Actual','Predicted')



