clear all; close all; clc;

%Setup directories
gt_path = './gt_res.csv';
res_path = './frcnnR_res.csv';
inshore_path = '.\Data\SSDD\Images\test_inshore.txt';
offshore_path = '.\Data\SSDD\Images\test_offshore.txt';

%Extract annotations
gt = table2struct(readtable(gt_path));
res = table2struct(readtable(res_path));
inshore_subimage = table2struct(readtable(inshore_path,'Delimiter',',', 'ReadVariableNames', false));
offshore_subimage = table2struct(readtable(offshore_path,'Delimiter',',', 'ReadVariableNames', false));

%Testing
GT_is = sum([gt.inshore]==1);
GT_os = sum([gt.inshore]==0);
GT = GT_is + GT_os;
disp(['GT - GT_os - GT_is: ' num2str(GT) ' - ' num2str(GT_os) ' - ' num2str(GT_is)])
TP_is = sum([res.inshore]==1 & [res.result]==1);
TP_os = sum([res.inshore]==0 & [res.result]==1);
TP = sum([res.result]==1);
disp(['TP - TP_os - TP_is: ' num2str(TP) ' - ' num2str(TP_os) ' - ' num2str(TP_is)])
FP_is = sum([res.gt_id]==0 & [res.inshore]==1);
FP_os = sum([res.gt_id]==0 & [res.inshore]==0);
FP = sum([res.gt_id]==0);
disp(['FP - FP_os - FP_is: ' num2str(FP) ' - ' num2str(FP_os) ' - ' num2str(FP_is)])
FN_is = GT_is - TP_is;
FN_os = GT_os - TP_os;
FN = GT - TP;
disp(['FN - FN_os - FN_is: ' num2str(FN) ' - ' num2str(FN_os) ' - ' num2str(FN_is)])

Pd = TP/GT;
Pf = FP/(TP+FP);
Pm = FN/GT;

Pd_is = TP_is/GT_is;
Pf_is = FP_is/(TP_is+FP_is);
Pm_is = FN_is/GT_is;

Pd_os = TP_os/GT_os;
Pf_os = FP_os/(TP_os+FP_os);
Pm_os = FN_os/GT_os;
disp(['Pd - Pd_os - Pd_is: ' num2str(Pd) ' - ' num2str(Pd_os) ' - ' num2str(Pd_is)])
disp(['Pf - Pf_os - Pf_is: ' num2str(Pf) ' - ' num2str(Pf_os) ' - ' num2str(Pf_is)])
disp(['Pm - Pm_os - Pm_is: ' num2str(Pm) ' - ' num2str(Pm_os) ' - ' num2str(Pm_os)])

Recall = TP/(TP+FN);
Recall_os = TP_os/(TP_os+FN_os);
Recall_is = TP_is/(TP_is+FN_is);
disp(['Recall - Recall_os - Recall_is: ' num2str(Recall) ' - ' num2str(Recall_os) ' - ' num2str(Recall_is)])

Precision = TP/(TP+FP);
Precision_os = TP_os/(TP_os+FP_os);
Precision_is = TP_is/(TP_is+FP_is);
disp(['Precision - Precision_os - Precision_is: ' num2str(Precision) ' - ' num2str(Precision_os) ' - ' num2str(Precision_is)])

F1 = 2*(Precision * Recall)/(Precision+Recall);
F1_os = 2*(Precision_os * Recall_os)/(Precision_os+Recall_os);
F1_is = 2*(Precision_is * Recall_is)/(Precision_is+Recall_is);
disp(['F1 - F1_os - F1_is: ' num2str(F1) ' - ' num2str(F1_os) ' - ' num2str(F1_is)])

%Extracting PR curve
th_conf = 0.5:0.001:1;
recall_arr = zeros(1,length(th_conf));
recall_arr_os = zeros(1,length(th_conf));
recall_arr_is = zeros(1,length(th_conf));
precision_arr = zeros(1,length(th_conf));
precision_arr_os = zeros(1,length(th_conf));
precision_arr_is = zeros(1,length(th_conf));

for i = 1:length(th_conf)
    th = th_conf(i);
    TP2 = sum([res.result]==1 & [res.score]>=th);
    TP_is2 = sum([res.inshore]==1 & [res.result]==1 & [res.score]>=th);
    TP_os2 = sum([res.inshore]==0 & [res.result]==1 & [res.score]>=th);
    FP2 = sum([res.gt_id]==0 & [res.score]>=th);
    FP_is2 = sum([res.gt_id]==0 & [res.inshore]==1 & [res.score]>=th);
    FP_os2 = sum([res.gt_id]==0 & [res.inshore]==0 & [res.score]>=th);
    FN2 = GT - TP2;
    FN_is2 = GT_is - TP_is;
    FN_os2 = GT_os - TP_os;

    recall_arr(i) = TP2/(TP2+FN2);
    recall_arr_os(i) = TP_os2/(TP_os2+FN_os2);
    recall_arr_is(i) = TP_is2/(TP_is2+FN_is2);

    precision_arr(i) = TP2/(TP2+FP2);
    precision_arr_os(i) = TP_os2/(TP_os2+FP_os2);
    precision_arr_is(i) = TP_is2/(TP_is2+FP_is2);
end

figure(1);
plot(recall_arr,precision_arr,'k-','LineWidth',2); axis([0 1.01 0.6 1]); grid on;
hold on; 
plot(recall_arr_os,precision_arr_os,'r-','LineWidth',2); axis([0 1.01 0.6 1]); grid on;
plot(recall_arr_is,precision_arr_is,'b-','LineWidth',2); axis([0 1.01 0.6 1]); grid on;
legend('All', 'Offshore', 'Inshore','Location','southwest')
title('Precision Recall curve')
ylabel('Precision')
xlabel('Recall')

recall_arr(isnan(precision_arr)) = [];
recall_arr_is(isnan(precision_arr_is)) = [];
recall_arr_os(isnan(precision_arr_os)) = [];
precision_arr(isnan(precision_arr)) = [];
precision_arr_is(isnan(precision_arr_is)) = [];
precision_arr_os(isnan(precision_arr_os)) = [];

%Compute mAP
precision_arr = fliplr(precision_arr);
precision_arr_os = fliplr(precision_arr_os);
precision_arr_is = fliplr(precision_arr_is);
recall_arr = fliplr(recall_arr);
recall_arr_os = fliplr(recall_arr_os);
recall_arr_is = fliplr(recall_arr_is);

th = 0:0.001:1;
mAP = zeros(1,length(th));
mAP_os = zeros(1,length(th));
mAP_is = zeros(1,length(th));
for i = 1:length(th)
    ind = find(recall_arr>=th(i),1,'first');
    if isempty(ind)
        continue
    end
    mAP(i) = precision_arr(ind);
end
for i = 1:length(th)
    ind = find(recall_arr_os>=th(i),1,'first');
    if isempty(ind)
        continue
    end
    mAP_os(i) = precision_arr_os(ind);
end
for i = 1:length(th)
    ind = find(recall_arr_is>=th(i),1,'first');
    if isempty(ind)
        continue
    end
    mAP_is(i) = precision_arr_is(ind);
end
mAP = sum(mAP)/1000;
mAP_os = sum(mAP_os)/1000;
mAP_is = sum(mAP_is)/1000;

disp(['mAP - mAP_os - mAP_is: ' num2str(mAP) ' - ' num2str(mAP_os) ' - ' num2str(mAP_is)])
