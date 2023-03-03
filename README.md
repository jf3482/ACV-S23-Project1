# ACV-S23-Project1 - Detection and Counting of Ships from SAR Satellite Imagery 
Individual project for Applied Computer Vision done in Columbia University for Spring 2023.

# Setting up
1) Detectron2: https://github.com/facebookresearch/detectron2. Used for training the models.
2) Linkup between GCP, Google Colab and Google Drive: https://medium.com/@uditsaini/access-google-drive-and-mount-google-drive-to-colab-notebook-google-ccbca1691d31
3) Matlab2022b: Used for evaluation of the models and the handcrafted control test.

# Downloading data
1) Download data from https://radars.ac.cn/web/data/getData?newsColumnId=dd8bb26f-fb65-497b-8958-390951409d98&pageType=en
2) Sort out the data in a directory as follows:
    - JPEGImages_sub_train.rar: ./JPEGImage_sub_train/
    - JPEGImages_sub_test.rar: ./JPEGImage_sub_test/
    - Annotations_sub.rar: ./Annotations_sub/
    - Images *.jpg and *.xml for the images: ./Images/

# Different sections of this project
## 0) Initial testing (Getting used to Detectron2)
- Follow the tutorial in https://colab.research.google.com/drive/16jcaJoc6bCFAQ96jDe2HwtXj7BMD_-m5.

## 1) Registration of the dataset to Detectron2 (Preprocessing)
SSDD_Processing.ipynb -> 
- This file produces ./Processed_data/
- The downloaded data is sorted into training/validation/testing, set up to the data requirements of Detectron2 (similar to COCO dataset format). 

## 2) Training the networks
A few files are available, and note that the test data is ran through each network to generate 'coco_instances_results.json'->
- Detectron2_SSDD_training.ipynb: Trial training based on Tutorial.
- SSDD_training_FasterRCNN_Resnet101.ipynb: Training for FasterRCNN w/ RPN with Resnet101 as backbone.
- SSDD_training_FasterRCNN_ResNext101.ipynb: Training for FasterRCNN w/ RPN with ResNext101 as backbone.
- SSDD_training_RetinaNet_Resnet101.ipynb: Training for RetinaNet w/ Resnet101.

## 3) Evaluation scripts
Evaluating different outputs obtained, and for preparing the slides.
- SSDD_evaluation.ipynb: This file generates the .csv files from the results given by 'coco_instances_results.json' above (from evaluation of models with test data) for evaluation within Matlab.
- evaluation.m: This file evaluates the results of the handcrafted control testing by generating the required metrics.
- compare_results.m: This file shows the results across the 3 networks trained with the ground truth.

## 4) Handcrafted control testing and evaluation
The below files are ran using Matlab.
- simple_detection.m: Trial testing to perform thresholding and morphology for a single image.
- simple_detection_full.m: Running the handcrafted algorithm for the entire test dataset (focusing on offshore case).
- evaluation.m: This file evaluates the results of the handcrafted control testing by generating the required metrics.
