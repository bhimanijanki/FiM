
/*
 * file_read.m
 * Author: Janki Bhimani
 */

[tc1] = xlsread('data_cal_serial.xlsx','D2:I7');
tc1=[tc1(:,1);tc1(:,2);tc1(:,3);tc1(:,4);tc1(:,5);tc1(:,6)];

[tc2] = xlsread('data_cal_serial.xlsx','D49:I54');
tc2=[tc2(:,1);tc2(:,2);tc2(:,3);tc2(:,4);tc2(:,5);tc2(:,6)];

[tc3] = xlsread('data_cal_serial.xlsx','D25:I30');
tc3=[tc3(:,1);tc3(:,2);tc3(:,3);tc3(:,4);tc3(:,5);tc3(:,6)];

tc=[tc1;tc2;tc3];    %/1.5;

[sc1] = xlsread('data_cal_serial.xlsx','D10:I15');
sc1=[sc1(:,1);sc1(:,2);sc1(:,3);sc1(:,4);sc1(:,5);sc1(:,6)];

[sc2] = xlsread('data_cal_serial.xlsx','D57:I62');
sc2=[sc2(:,1);sc2(:,2);sc2(:,3);sc2(:,4);sc2(:,5);sc2(:,6)];

[sc3] = xlsread('data_cal_serial.xlsx','D33:I38');
sc3=[sc3(:,1);sc3(:,2);sc3(:,3);sc3(:,4);sc3(:,5);sc3(:,6)];

sc=[sc1;sc2;sc3];    %/1.5;

[ut1] = xlsread('data_cal_serial.xlsx','D17:I22');
ut1=[ut1(:,1);ut1(:,2);ut1(:,3);ut1(:,4);ut1(:,5);ut1(:,6)];

[ut2] = xlsread('data_cal_serial.xlsx','D64:I69');
ut2=[ut2(:,1);ut2(:,2);ut2(:,3);ut2(:,4);ut2(:,5);ut2(:,6)];

[ut3] = xlsread('data_cal_serial.xlsx','D40:I45');
ut3=[ut3(:,1);ut3(:,2);ut3(:,3);ut3(:,4);ut3(:,5);ut3(:,6)];

util=[ut1;ut2;ut3];    %/1.1;

[act_time1] = xlsread('data_cal_serial.xlsx','D74:I79');
act_time1=[act_time1(:,1);act_time1(:,2);act_time1(:,3);act_time1(:,4);act_time1(:,5);act_time1(:,6)];

[act_time2] = xlsread('data_cal_serial.xlsx','D82:I87');
act_time2=[act_time2(:,1);act_time2(:,2);act_time2(:,3);act_time2(:,4);act_time2(:,5);act_time2(:,6)];

[act_time3] = xlsread('data_cal_serial.xlsx','D90:I95');
act_time3=[act_time3(:,1);act_time3(:,2);act_time3(:,3);act_time3(:,4);act_time3(:,5);act_time3(:,6)];

act_time=[act_time1;act_time2;act_time3];

[test_data] = xlsread('data_cal_serial.xlsx','D101:I106');
test_data=[test_data(:,1);test_data(:,2);test_data(:,3);test_data(:,4);test_data(:,5);test_data(:,6)];

[input6_data] = xlsread('data_cal_serial.xlsx','C108:I110');

[complexity] = xlsread('data_cal_serial.xlsx','C112:D114');

save('tc.mat','tc');save('sc.mat','sc');save('util.mat','util');save('act_time.mat','act_time');
save('test_data.mat','test_data');save('input6_data.mat','input6_data');save('complexity.mat','complexity');





