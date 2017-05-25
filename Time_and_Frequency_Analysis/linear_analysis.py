
#### Package requirements:
# pandas
# scipy
# numpy
# itertools
# seaborn


import pandas as pd
import os
from scipy import signal
from scipy import integrate
from numpy import mean, sqrt, square, arange
import numpy as np
import itertools
import matplotlib.pyplot as plt

cwd = os.getcwd()

def poincare_plotter(min15, default_name = 'hello'):
	'''
	Inputs:
	- min15 - tuple, last element is a list of NN intervals

	Outputs:
	- figure saved to local directory

	'''

	RR_interval_cut = min15[-1][:-1]
	RR_n1_interval = [min15[-1][i+1] for i in range(0, len(RR_interval_cut))]
	dict_cause = {'RR_n': RR_interval_cut, 'RR_n+1': RR_n1_interval}
	df = pd.DataFrame.from_dict(dict_cause)
	print('plotting seaborn')
	fig = plt.figure(figsize = (10,6))
	ax = fig.add_subplot(1,1,1)
	ax.scatter(RR_interval_cut, RR_n1_interval, s=50, color='dodgerblue', alpha=0.2)
	ax.set_xlim([0,1500])
	ax.set_ylim([0,1500])
#     plt.show()
#     test_plot = sns.jointplot('RR_n', 'RR_n+1', data=df, kind='hex')
# 	    test_plot.set_ylim([500,1000])
# 	    test_plot.set_xlim([500,1000])
	
	fig.savefig('%s.pdf' %default_name)
	fig.savefig('%s.png' %default_name)
#     fig.close()
	
def isplit(iterable,splitters):
	return [list(g) for k,g in itertools.groupby(iterable,lambda x:x in splitters) if not k]

def SDNN_calc (zipped_sample, time):
	'''
	Inputs:
	- zipped_sample: time series of HR, in list/array form: []
	- time: int, number of minutes

	Outputs:
	- SDNN: standard deviation of NN intervals in msec

	'''



	time_restricted_ms_annot_lst = [(a,t) for (a,t) in zipped_sample if t/float(1000)/float(60)<=time]
	#only those annotations in the window
#     print (time_restricted_ms_annot_lst)

	split_lst = []

	temp_lst = []

	for (a,t) in time_restricted_ms_annot_lst:
		if a == 'N':
			temp_lst.append((a,t))
		else:
			split_lst.append(temp_lst)
			temp_lst=[]
	if len(split_lst) ==0:
		split_lst = [temp_lst]


	N_N_intervals = []
	#need to N-N intervals
	# print len(split_lst)
	for l in split_lst:
		temp_intervals = [l[i+1][1]-l[i][1] for i in range(0,len(l)-1)]
#         print l[0]
#         print l[1]
#         print l[1][1]-l[0][1]
#         print temp_intervals
		N_N_intervals+= temp_intervals

	SDNN = np.std(N_N_intervals)
	# this is fine

	adjacent_N_N_intervals = [N_N_intervals[i+1]-N_N_intervals[i] for i in range(0, len(N_N_intervals)-1)]

#     print 'NN'
#     print N_N_intervals
	pNN30 = float(len([n for n in adjacent_N_N_intervals if n>30]))/float(len(adjacent_N_N_intervals))*100
	pNN50 = float(len([n for n in adjacent_N_N_intervals if n>50]))/float(len(adjacent_N_N_intervals))*100
	rms = sqrt(mean(square(adjacent_N_N_intervals)))

	print (SDNN, pNN30, pNN50, rms)
	return (SDNN, pNN30, rms, N_N_intervals)

def LF_HF_calc(HR_series, freq_type, time):
		'''
		Inputs:
		- HR_series: the time series in list/array form
		- freq_type: str, either 'HF' or 'LF'
		- time: int, number of minutes
		
		Outputs:
		- AUC - area under the power spectrum curve (in msec^2)
		
		'''
		HR_3min = [(t,hr) for (t,hr) in HR_overtime if t <= time]
		f, Pxx_den = signal.periodogram([x[1] for x in HR_3min])
		
		zipped_PSD = zip(f, Pxx_den)
		if freq_type=='LF':
			LF_3min = [(f_sub,P) for (f_sub,P) in zipped_PSD if f_sub < 0.15 and f_sub >= 0.04]
		elif freq_type == 'HF':
			LF_3min = [(f_sub,P) for (f_sub,P) in zipped_PSD if f_sub >= 0.15 and f_sub <= 0.4]
			
		else:
			print('Not valid freq type')
		
		LF_3min_calc = integrate.simps([x[1] for x in LF_3min], x = [y[0] for y in LF_3min])
		
		return LF_3min_calc*1000000
		print LF_3min_calc*1000000


for filename in list(os.listdir('Annotations/')):

	name = filename
	print(filename)

	df = pd.read_table(name)
	df.Time = pd.to_datetime(df.Time, format = '%M:%S.%f')
	df.Time = pd.to_timedelta(df.Time)
	df.Time += pd.Timedelta(days = 25567)
	zipped_example = list(zip(df.Type, df.Time))
	cleaned_hr_annot_lst = [(a,t.total_seconds()/60.0) for (a,t) in zipped_example if a == 'N']
	HR_overtime = []
	#(minutes, bpm)

	for i in range(0, len(cleaned_hr_annot_lst)):
		a = cleaned_hr_annot_lst[i][0]
		t = cleaned_hr_annot_lst[i][1] #in minutes
		numerator = i+1
		denomenator = t # in minutes
		HR_bpm = float(numerator)/float(denomenator) #converting to bpm
		HR_overtime.append((t,HR_bpm))

	

	
	LF = LF_HF_calc(HR_overtime, 'LF', 30)
	print 'LF 30 min', LF
	HF = LF_HF_calc(HR_overtime, 'HF', 30)
	print 'HF 30 min', HF

	



	#womp, need it in millisecond time

	HR_series = [(a,t*60*1000) for (a,t) in cleaned_hr_annot_lst]

# 	print'SDNN, pNN30, pNN50, and rms for 30 min interval:'
	SDNN, pNN30, rms, N_N_intervals = SDNN_calc(HR_series, 30)

	#Now calculating the actual intervals
	Full_RR_interval = (0,N_N_intervals)


	




	begining_of_name = filename.rstrip('.txt')
	poincare_plotter(Full_RR_interval, default_name=(begining_of_name))

	with open(begining_of_name+'_results.txt', 'w') as outfile:
		outfile.write('SDNN '+ str(SDNN) + '\n')
		outfile.write('pNN30 ' + str(pNN30) + '\n')
		outfile.write('rms ' + str(rms) + '\n')
		outfile.write('HF ' + str(HF) + '\n')
		outfile.write('LF ' + str(LF) + '\n')
	outfile.close()