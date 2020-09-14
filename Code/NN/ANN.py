#Copyright 2017 Vraj Shah, Arun Kumar
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

import numpy as np
seed = 100
np.random.seed(seed)

import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.regularizers import l1
from keras.regularizers import l2
from keras.layers.core import Dropout
from keras.layers.normalization import BatchNormalization
from keras.callbacks import EarlyStopping
from keras.layers import Dense, Input
from keras.models import Model
from keras.callbacks import EarlyStopping, ModelCheckpoint
from keras.models import load_model

from sklearn.metrics import zero_one_loss
from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
from scipy.sparse import csr_matrix
from sklearn.metrics import mean_squared_error

import csv
import time
import scipy
import pandas as pd
from math import sqrt

from tensorflow import set_random_seed
import random
random.seed(100)
set_random_seed(100)




curDataset = 'Flights/OF_Y.csv' ## which dataset to fetch labels from
NumYLevels = 2  ## number of target classes
File2run = 'Flights/JoinAll.csv' ## use NoJoin.csv or AllJoin.csv file



y_vec_train = []
label = 0
with open(curDataset,'r') as f1:
    reading1 = csv.reader(f1,delimiter = ',')
    i = 0
    for row in reading1:

        curyval = row[label].replace("'",'')
        y_vec_train.append(int(curyval))


rowlst_train,collst_train,datalst_train = [],[],[]

with open(File2run,'r') as f:
    reading = csv.reader(f,delimiter=',')
    i = 0
    max_row = 0
    max_col = 0
    for row in reading:
        if i%10000==0: print(i)
        if i == 0:
            i = i + 1
            continue
        rowlst_train.append(int(row[0])-1)
        collst_train.append(int(row[1])-1)
        datalst_train.append(float(row[2]))

        i=i+1


def globalshuffle(matrix,y_vec):
    index = np.arange(np.shape(matrix)[0])
#     print(index)
    np.random.seed(100)
    np.random.shuffle(index)
#     print(index)
    
    y_shuffled = []
    for i in index: y_shuffled.append(y_vec[i])
    
    return matrix[index, :], y_shuffled

sparseX_train = csr_matrix((datalst_train, (rowlst_train, collst_train)))
sparseX_train,y_vec_train = globalshuffle(sparseX_train,y_vec_train)

print(len(rowlst_train),len(collst_train),len(datalst_train))
print(max(rowlst_train),max(collst_train),max(datalst_train))
print(sparseX_train.shape)


def onehotvector(x,k):
    lst = [0] * k
    lst[x] = 1
    return lst

y_vec_categ_train = []
for i in range(len(y_vec_train)):  y_vec_categ_train.append(onehotvector(y_vec_train[i],NumYLevels))
y_vec_categ_train = np.array(y_vec_categ_train)


def build_model_NoBatchNorm(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(256, init='glorot_normal',  W_regularizer = l2(l2reg), activation='relu')(inputs)
    y = Dense(64, init='glorot_normal', W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model


def build_model(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))
    x = BatchNormalization()(inputs)
    x = Dense(256, init='glorot_normal',  W_regularizer = l2(l2reg), activation='relu')(x)
    y = Dense(64, init='glorot_normal', W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def build_model_OF_EH_NoBatchNorm(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(256,  W_regularizer = l2(l2reg), activation='relu')(inputs)
    y = Dense(64, W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def build_model_OF_EH(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))
    x = BatchNormalization()(inputs)
    x = Dense(256,  W_regularizer = l2(l2reg), activation='relu')(x)
    y = Dense(64, W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model


def build_model_tanh(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(256, W_regularizer = l2(l2reg), activation='tanh')(inputs)
    y = Dense(64, W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['mse'])
    return model


def build_default_model(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(256, W_regularizer = l2(l2reg))(inputs)
    y = Dense(64, W_regularizer = l2(l2reg))(x)
    outputs = Dense(NumYLevels, activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['mse'])
    return model

def build_default_model_OF_EH(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(256, W_regularizer = l2(l2reg))(inputs)
    y = Dense(64, W_regularizer = l2(l2reg))(x)
    outputs = Dense(NumYLevels, activation='softmax')(y)

    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def build_model_StressTest(lr,l2reg):
    
    inputs = Input(shape=(sparseX_train.shape[1],))

    x = Dense(1024, init='glorot_normal',  W_regularizer = l2(l2reg), activation='relu')(inputs)
    x = Dense(512, init='glorot_normal',  W_regularizer = l2(l2reg), activation='relu')(inputs)    
    y = Dense(256, init='glorot_normal', W_regularizer = l2(l2reg), activation='relu')(x)
    outputs = Dense(NumYLevels, init='glorot_normal', W_regularizer = l2(l2reg), activation='softmax')(y)

    
    adam_op = keras.optimizers.Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

    model = Model(input=inputs, output=outputs)
#     model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['mse'])
    model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

model = build_model(1,1)
model = build_model_StressTest(1,1)
model.summary()



def batchProcessor(X, y, batchSize, samplesPerEpoch):
    TotalBatches = samplesPerEpoch/batchSize
    cnt=0
    batch_index = np.arange(np.shape(y)[0])
    np.random.shuffle(batch_index)
    X =  X[batch_index, :]
    y =  y[batch_index]
    while 1:
        index_batch = batch_index[batchSize*cnt:batchSize*(cnt+1)]
        X_batch = X[index_batch,:].todense()
        y_batch = y[index_batch]
        
        cnt += 1
        yield(np.array(X_batch),y_batch)
        if cnt < TotalBatches:
            np.random.shuffle(batch_index)
            cnt=0        


lr_grid = [0.01,0.001,0.1]
l2reg_grid = [0.0001,0.001,0.01]

k = 10
kf = KFold(n_splits=k,random_state=100)

i=0
for train_index, test_index in kf.split(sparseX_train):
    file_path= 'best_weights_'+str(i)+'.h5'
    
#     checkpoint = ModelCheckpoint(file_path, monitor='val_loss', verbose=1, save_best_only=True, mode='min')
#     early = EarlyStopping(monitor="val_loss", mode="min", patience=2)
    
    checkpoint = ModelCheckpoint(file_path, monitor='val_acc', verbose=1, save_best_only=True, mode='max')
    early = EarlyStopping(monitor="val_acc", mode="max", patience=5)    
    
    callbacks_list = [checkpoint, early]
    
    
    X_train_cur, X_test_cur = sparseX_train[train_index], sparseX_train[test_index]
    y_train_cur, y_test_cur = y_vec_categ_train[train_index], y_vec_categ_train[test_index]
    
    X_train_train, X_val,y_train_train,y_val = train_test_split(X_train_cur,y_train_cur, test_size=0.33,random_state=100)
    
    for lr in lr_grid:
        for l2reg in l2reg_grid:
#             model = build_model(lr,l2reg)            
            ## use build_model_OF_EH for flights and expedia
            model = build_model(lr,l2reg)
            model.fit(X_train_train.todense(),y_train_train,validation_data=(X_val.todense(),y_val),callbacks=callbacks_list, verbose = 1,batch_size=256, nb_epoch = 10)
            ## Memory efficient way to fit the model
#             model.fit_generator(
#                             generator = batchProcessor(X_train_train, y_train_train,100,1000),
#                             nb_epoch=10, 
#                             validation_data = batchProcessor(X_val, y_val, 100,1000),
#                             nb_val_samples = 100,
#                             samples_per_epoch=X_train_train.shape[0],
#                             callbacks=callbacks_list,
#                             verbose = 1
#                                )
        
    bestPerformingModel = load_model('best_weights_' + str(i) + '.h5')
    y_pred = bestPerformingModel.predict(X_test_cur.todense())
    errorval = sqrt(mean_squared_error(np.argmax(y_test_cur,axis=1).tolist(),np.argmax(y_pred,axis=1).tolist()))
    print(errorval) 
    
    i=i+1

i=0
avgsc_test_lst = []
for train_index, test_index in kf.split(sparseX_train):
    X_train_cur, X_test_cur = sparseX_train[train_index], sparseX_train[test_index]
    y_train_cur, y_test_cur = y_vec_categ_train[train_index], y_vec_categ_train[test_index]
    
    X_train_train, X_val,y_train_train,y_val = train_test_split(X_train_cur,y_train_cur, test_size=0.33,random_state=100)

    bestPerformingModel = load_model('best_weights_' + str(i) + '.h5')
    
    xtd = X_test_cur.todense()
    
    y_pred = bestPerformingModel.predict(xtd)
    errorval = sqrt(mean_squared_error(np.argmax(y_test_cur,axis=1).tolist(),np.argmax(y_pred,axis=1).tolist()))
    print(errorval)    
## Use this for binary classification cases
    errorval = zero_one_loss(np.argmax(y_test_cur,axis=1).tolist(),np.argmax(y_pred,axis=1).tolist())
    print(errorval)

    avgsc_test_lst.append(errorval)
    
    i=i+1


print(np.mean(avgsc_test_lst))



