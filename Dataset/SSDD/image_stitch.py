import cv2
import os
import numpy as np
import pandas as pd
import argparse

img_input  = 'JPEGImages_sub/'
img_output = 'JPEGImages/'

if not os.path.isdir(img_output):
    os.makedirs(img_output)

num_0  = '00'
hang_0 = '0'
lie_0  = '0'

num_list  = []
hang_list = []
lie_list  = []

for filename in os.listdir(img_input):
    num  = filename.split('.')[0].split('_')[0]
    hang = filename.split('.')[0].split('_')[1]
    lie  = filename.split('.')[0].split('_')[2]

    if not num_0 == num:
        num_list.append(num)
        num_0 = num
    if not hang_0 == hang:
        hang_list.append(hang)
        hang_0 = hang
    if not lie_0 == lie:
        lie_list.append(lie)
        lie_0 = lie

num_list_final  = list(map(int, list(set(num_list))) )
num_list_final.sort(key=int)
hang_list_final = list(map(int, list(set(hang_list))) )
hang_list_final.sort(key=int)
lie_list_final  = list(map(int, list(set(lie_list))) )
lie_list_final.sort(key=int)

print(num_list_final)
print(len(num_list_final))

print(hang_list_final)
print(len(hang_list_final))

print(lie_list_final)
print(len(lie_list_final))


for i in num_list_final:
    small_img_list = [ ( [] * 20 ) for i in range(30) ]
    con_hang_list = []
    for hang, j in enumerate(hang_list_final):
        for k in lie_list_final:
            small_img_list[hang].append(cv2.imread(img_input + str(i).zfill(2) + '_' + str(j) + '_' + str(k) + '.jpg'))
    np_small_img_list = np.array(small_img_list)
    
    for a in range(0,20):
        con_hang_list.append(np.concatenate(np_small_img_list[a][:], axis=1))
    con_lie = np.concatenate(con_hang_list, axis=0)
    cv2.imwrite(img_output + str(i).zfill(2) + '.jpg', con_lie)

print(np_small_img_list.shape)