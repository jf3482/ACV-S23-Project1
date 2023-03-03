clear all; close all; clc;

%Setup directories
img_dir = './Images/';
csv_dir = './Preprocessed/';

%Extract annotations
offshore_annotations = table2struct(readtable([csv_dir 'test_offshore.csv']));

%Initialization
img_text = '11';

%Display image
im_text = '11_11_26';
im = imread(['./JPEGImages_sub_test/' im_text '.jpg']);
figure(1); imagesc(abs(im)); axis image

%Simple CFAR detector
th = mean(mean(im(:,:,1)))+50;
[hist_im,x] = imhist(im(:),50); 
bw = (im(:,:,1)>th);

figure(2); 
subplot(2,3,1); imagesc(abs(im)); axis image off; title(im_text, 'Interpreter', 'none');
subplot(2,3,2); imagesc(abs(im)); axis image off; title([im_text ' annotated'], 'Interpreter', 'none');
hold on; 

%Extract annotations
offshore_annotations = table2struct(readtable([csv_dir 'test_offshore.csv']));
for i = 1:length(offshore_annotations)
    text = offshore_annotations(i).filename;
    if strcmp(text, im_text)
        row_ind = [offshore_annotations(i).ymin offshore_annotations(i).ymax]; 
        col_ind = [offshore_annotations(i).xmin offshore_annotations(i).xmax];
        %hold on; plot(col_ind,row_ind,'r*');
        rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
    end
end

subplot(2,3,3); plot(x,hist_im); title('Histogram of Intensities'); xlabel('Intensity'); ylabel('Count')
subplot(2,3,4); imagesc(abs(bw)); axis image off; title('Thresholding');

%Apply morphology
bw2 = bwmorph(bw,'open',3);
bw2 = bwmorph(bw2,'spur');
bw2 = bwmorph(bw2,'clean');
subplot(2,3,5); imagesc(abs(bw2)); axis image off; title('After morphological operations');

bw3 = bw2;
L = bwlabel(bw3,4);
max(L)
for i = 1:max(L(:))
    [r, c] = find(L==i);
    if length(r) < 50
        bw3(r,c) = 0;
    end
end
L = bwlabel(bw3);
subplot(2,3,6); imagesc(abs(L)); axis image off;  title(['Connected components above 50 pixels: ' num2str(max(L(:)))]);


figure(3); 
subplot(1,3,1); imagesc(abs(im)); axis image off; title(im_text, 'Interpreter', 'none');
subplot(1,3,2); imagesc(abs(im)); axis image off; title([im_text ' annotated'], 'Interpreter', 'none');
hold on; 
%Extract annotations
offshore_annotations = table2struct(readtable([csv_dir 'test_offshore.csv']));
for i = 1:length(offshore_annotations)
    text = offshore_annotations(i).filename;
    if strcmp(text, im_text)
        row_ind = [offshore_annotations(i).ymin offshore_annotations(i).ymax]; 
        col_ind = [offshore_annotations(i).xmin offshore_annotations(i).xmax];
        %hold on; plot(col_ind,row_ind,'r*');
        rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
    end
end
subplot(1,3,3); imagesc(abs(L)); axis image off;  title(['Connected components above 50 pixels: ' num2str(max(L(:)))]);
