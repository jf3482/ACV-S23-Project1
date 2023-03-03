clear all; close all; clc;

%Setup directories
img_dir = './Data/SSDD/JPEGImages_sub_test/';
gt_path = './gt_res.csv';
inshore_path = '.\Data\SSDD\Images\test_inshore.txt';
offshore_path = '.\Data\SSDD\Images\test_offshore.txt';

%Initialization
th = 145;
res = []; count = 0;

%Extract annotations
gt = table2struct(readtable(gt_path));
%Offshore
offshore_subimage = table2struct(readtable(offshore_path,'Delimiter',',', 'ReadVariableNames', false));
%inshore
inshore_subimage = table2struct(readtable(inshore_path,'Delimiter',',', 'ReadVariableNames', false));

for i = 1:length(offshore_subimage)  %Testing with 233 if required
    if mod(i,100) == 0
        disp(num2str(i))
    end

    txt = offshore_subimage(i).Var1;
    im = imread([img_dir txt '.jpg']);

    %figure(1); imagesc(abs(im)); axis image
    for j = 1:length(th)
        %Applying morphology
        bw = (im(:,:,1)>th(j));
        bw2 = bwmorph(bw,'open',3);
        bw2 = bwmorph(bw2,'spur');
        bw2 = bwmorph(bw2,'clean');
        
        %Adding size feature
        bw3 = bw2;
        L = bwlabel(bw3,4);
        for k = 1:max(L(:))
            [r, c] = find(L==k);
            if length(r) < 30 || length(r) > 500
                bw3(r,c) = 0;
            end
        end
        L = bwlabel(bw3);
        
        %Connected components analysis
        for k = 1:max(L(:))
            count = count + 1;
            res(count).image_id = txt;
            res(count).th = th(j);
            res(count).inshore = 0;
            [x,y] = find(L == k);
            res(count).bbox = [min(x) min(y) max(x) max(y)];
        end

%         %Display results if needed (for testing)
%         if j == 1
%             figure(1);
%             subplot(1,3,1); imagesc(abs(im)); axis image off; hold on; title('Ground truth')
%             for m = 1:length(gt)
%                 if strcmp(gt(m).filename,txt)
%                     row_ind = [gt(m).ymin gt(m).ymax]; 
%                     col_ind = [gt(m).xmin gt(m).xmax];
%                     %hold on; plot(col_ind,row_ind,'r*');
%                     rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5); 
%                 end
%             end
%             subplot(1,3,2); imagesc(abs(im)); axis image off; hold on; title('Handcrafted results')
%             for m = 1:length(res)
%                 %hold on; plot(col_ind,row_ind,'r*');
%                 rectangle('Position', [res(m).bbox(2) res(m).bbox(1) res(m).bbox(4)-res(m).bbox(2) res(m).bbox(3)-res(m).bbox(1)],'EdgeColor','r', 'LineWidth', 1.5); 
%             end
%             subplot(1,3,3); imagesc(L); axis image off; title('Connected Components')
%         end
    end
end 
writetable(struct2table(res), 'hc_res.csv')

return

%Did not run this part due to large amount of detections
for i = 1:length(inshore_subimage)
    if mod(i,100) == 0
        disp(num2str(i))
    end
    
    txt = inshore_subimage(i).Var1;
    im = imread([img_dir txt '.jpg']);

    %figure(1); imagesc(abs(im)); axis image
    for j = 1:length(th)
        bw = (im(:,:,1)>th(j));
        bw2 = bwmorph(bw,'open',3);
        bw2 = bwmorph(bw2,'spur');
        bw2 = bwmorph(bw2,'clean');
        
        bw3 = bw2;
        L = bwlabel(bw3,4);
        for k = 1:max(L(:))
            [r, c] = find(L==k);
            if length(r) < 30 || length(r) > 500
                bw3(r,c) = 0;
            end
        end
        L = bwlabel(bw3);
        
        for k = 1:max(L(:))
            count = count + 1;
            res(count).image_id = txt;
            res(count).th = th(j);
            res(count).inshore = 1;
            [x,y] = find(L == k);
            res(count).bbox = [min(x) min(y) max(x) max(y)];
        end

%         %Sample display
%         if j == 1
%             figure(1);
%             subplot(1,3,1); imagesc(abs(im)); axis image; hold on;
%             for m = 1:length(gt)
%                 if strcmp(gt(m).filename,txt)
%                     row_ind = [gt(m).ymin gt(m).ymax]; 
%                     col_ind = [gt(m).xmin gt(m).xmax];
%                     %hold on; plot(col_ind,row_ind,'r*');
%                     rectangle('Position', [col_ind(1), row_ind(1), col_ind(2)-col_ind(1)+1, row_ind(2)-row_ind(1)+1],'EdgeColor','r', 'LineWidth', 1.5);
%                 end
%             end
%             subplot(1,3,2); imagesc(abs(im)); axis image; hold on;
%             for m = 1:length(res)
%                 %hold on; plot(col_ind,row_ind,'r*');
%                 rectangle('Position', [res(m).bbox(2) res(m).bbox(1) res(m).bbox(4)-res(m).bbox(2) res(m).bbox(3)-res(m).bbox(1)],'EdgeColor','r', 'LineWidth', 1.5);
%             end
%             subplot(1,3,3); imagesc(L); axis image;
%         end
    end

end

