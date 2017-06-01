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

from keras.models import Sequential
from keras.layers import Dense
from sklearn.model_selection import train_test_split
import numpy as np
import csv

from keras.regularizers import l1		
from keras.regularizers import l2
from keras.layers.core import Dropout		
from keras.layers.normalization import BatchNormalization		
from keras.callbacks import EarlyStopping		
import keras
import time
from timeit import default_timer as timer
seed = 7
np.random.seed(seed)

y_vec = []

class TimeHistory(keras.callbacks.Callback):
	def on_train_begin(self, logs={}):
		self.times = []

	def on_epoch_begin(self, batch, logs={}):
		self.epoch_time_start = time.time()

	def on_epoch_end(self, batch, logs={}):
		self.times.append(time.time() - self.epoch_time_start)


with open('OFtrain.csv','r') as f1:
	reading1 = csv.reader(f1,delimiter = ',')
	i = 0
	for row in reading1:
		if i == 0:
			i = i + 1
			continue

		if row[0] == 'f':
			y_vec.append(0)
		else:
			y_vec.append(1)

with open('OFtest.csv','r') as f1:
	reading1 = csv.reader(f1,delimiter = ',')
	i = 0
	for row in reading1:
		if i == 0:
			i = i + 1
			continue

		if row[0] == 'f':
			y_vec.append(0)
		else:
			y_vec.append(1)

rows = len(y_vec)
cols = 14000

sparse_mat = [[0 for x in range(cols)] for x in range(rows)] 

with open('SJCOFtraintest.csv','r') as f:
    reading = csv.reader(f,delimiter=',')
    i = 0
    max_row = 0
    max_col = 0
    for row in reading:
        if i == 0:
            i = i + 1
            continue

        sparse_mat[int(row[0])-1][int(row[1]) - 1] = 1

sparse_mat = np.array(sparse_mat)


#############################################################################################
y_vec_hold = []
with open('OFhold.csv','r') as f1:
	reading1 = csv.reader(f1,delimiter = ',')
	i = 0
	for row in reading1:
		if i == 0:
			i = i + 1
			continue

		if row[0] == 'f':
			y_vec_hold.append(0)
		else:
			y_vec_hold.append(1)


rows_hold = len(y_vec_hold)
cols_hold = 14000
sparse_mat_hold = [[0 for x in range(cols_hold)] for x in range(rows_hold)] 

with open('SJCOFhold.csv','r') as f:
    reading = csv.reader(f,delimiter=',')
    i = 0
    max_row = 0
    max_col = 0
    for row in reading:
        if i == 0:
            i = i + 1
            continue

        sparse_mat_hold[int(row[0])-1][int(row[1]) - 1] = 1

sparse_mat_hold = np.array(sparse_mat_hold)
# print(sparse_mat)
# sparse_mat_train, sparse_mat_test, y_vec_train, y_vec_test = train_test_split(sparse_mat, y_vec, test_size=0.33, random_state=seed)

sparse_mat_train = sparse_mat[:33274,:]
y_vec_train = y_vec[:33274]
sparse_mat_test = sparse_mat[33274:,:]
y_vec_test = y_vec[33274:]

start = time.time()
start = timer()
reg = 0.00001
model = Sequential()
model.add(Dense(256, input_dim=cols,  W_regularizer = l2(reg),init='glorot_normal', activation='relu'))
# model.add(Dropout(0.5))
# model.add(BatchNormalization())
model.add(Dense(64, init='glorot_normal',  W_regularizer = l2(reg), activation='relu'))
# model.add(Dropout(0.5))
# model.add(BatchNormalization())
model.add(Dense(1, init='glorot_normal',  W_regularizer = l2(reg), activation='sigmoid'))


adam_op = keras.optimizers.Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)

call_func = EarlyStopping(monitor='val_loss', patience = 2)

model.compile(loss='binary_crossentropy', optimizer=adam_op, metrics=['accuracy'])
time_callback = TimeHistory()
model.fit(sparse_mat_train, y_vec_train, validation_data = (sparse_mat_test,y_vec_test), nb_epoch=10,callbacks= [call_func, time_callback])

scores = model.evaluate(sparse_mat_hold, y_vec_hold)
print(scores[1])
print(time.time() - start)
times = time_callback
print(times)
end = timer()
print(end - start)
# print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))