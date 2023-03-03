clear all; close all; clc;

%Setup directories
img_dir = './Images/';
csv_dir = './Preprocessed/';

%Extract annotations
offshore_annotations = table2struct(readtable([csv_dir 'test.csv']));

%Initialization
img_text = '11';

%Display image
im = imread(['./Images/' img_text '.jpg']);
figure(1); 
subplot(1,2,1); imagesc(abs(im)); axis image off; title('Ground Truth');

%Iterate through the annotations list
for i = 1:length(offshore_annotations)
    text = offshore_annotations(i).filename;
    ind = strfind(text,'_');

    if strcmp(text(1:2), img_text)
        row_ind = 800*(str2num( text((ind(1)+1):(ind(2)-1)))-1 )+[offshore_annotations(i).ymin offshore_annotations(i).ymax]; 
        col_ind = 800*(str2num( text((ind(2)+1):end))-1)+[offshore_annotations(i).xmin offshore_annotations(i).xmax];
    end

    %row_ind
    %col_ind
    
    hold on; rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
    %plot(col_ind,row_ind,'r*');
end

%Compare with results
subplot(1,2,2); imagesc(abs(im)); axis image off; title('Results with RCNN-Resnet101');
dir_res = './Results/';
fname = 'coco_instances_results_rcnnR.json'; 
fid = fopen([dir_res fname]); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

for i = 1:length(val)
    text = val(i).image_id;
    ind = strfind(val(i).image_id,'_');

    if strcmp(text(1:2), img_text)
        row_ind = 800*(str2num( text((ind(1)+1):(ind(2)-1)))-1 )+[val(i).bbox(2) val(i).bbox(2)+val(i).bbox(4)];
        col_ind = 800*(str2num( text((ind(2)+1):end))-1)+[val(i).bbox(1) val(i).bbox(1)+val(i).bbox(3)]; 
    end

    %row_ind
    %col_ind


    %hold on; rectangle('Position', [val(i).bbox(1), val(i).bbox(2), val(i).bbox(3), val(i).bbox(4)],'EdgeColor','r', 'LineWidth', 1.5);
    hold on; rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
end

linkImg_sub(1,1,2,1:2)
return

%Compare with results
subplot(2,2,3); imagesc(abs(im)); axis image off; title('Results with RCNN-ResNext101');
dir_res = './Results/';
fname = 'coco_instances_results_rcnnX.json'; 
fid = fopen([dir_res fname]); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

for i = 1:length(val)
    text = val(i).image_id;
    ind = strfind(val(i).image_id,'_');

    if strcmp(text(1:2), img_text)
        row_ind = 800*(str2num( text((ind(1)+1):(ind(2)-1)))-1 )+[val(i).bbox(2) val(i).bbox(2)+val(i).bbox(4)];
        col_ind = 800*(str2num( text((ind(2)+1):end))-1)+[val(i).bbox(1) val(i).bbox(1)+val(i).bbox(3)]; 
    end

    %row_ind
    %col_ind


    %hold on; rectangle('Position', [val(i).bbox(1), val(i).bbox(2), val(i).bbox(3), val(i).bbox(4)],'EdgeColor','r', 'LineWidth', 1.5);
    hold on; rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
end



%Compare with results
subplot(2,2,4); imagesc(abs(im)); axis image off; title('Results with RetinaNet');
dir_res = './Results/';
fname = 'coco_instances_results_retina.json'; 
fid = fopen([dir_res fname]); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

for i = 1:length(val)
    text = val(i).image_id;
    ind = strfind(val(i).image_id,'_');

    if strcmp(text(1:2), img_text)
        row_ind = 800*(str2num( text((ind(1)+1):(ind(2)-1)))-1 )+[val(i).bbox(2) val(i).bbox(2)+val(i).bbox(4)];
        col_ind = 800*(str2num( text((ind(2)+1):end))-1)+[val(i).bbox(1) val(i).bbox(1)+val(i).bbox(3)]; 
    end

    %row_ind
    %col_ind


    %hold on; rectangle('Position', [val(i).bbox(1), val(i).bbox(2), val(i).bbox(3), val(i).bbox(4)],'EdgeColor','r', 'LineWidth', 1.5);
    hold on; rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
end

linkImg_sub(1,2,2,1:4)

