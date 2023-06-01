# File: plotter.py
# Author: Adrian Garcia
# Date 05/30/2023
# Purpose: Plots the latency linear model data from latency.f90
import numpy as np
import matplotlib.pyplot as plt
plt.rcParams["figure.figsize"] = (8, 8)
plt.rcParams.update({'font.size': 12})
plt.rcParams['mathtext.fontset'] = 'stix'
plt.rcParams['font.family'] = 'STIXgeneral'

data = np.genfromtxt('myplot.dat')
x = data[:, 0]
y = data[:, 1]
plt.figure()
plt.scatter(x, y, marker = '*')
plt.xlabel('$L = $ message size')
plt.ylabel('$T_{msg}$')
plt.title('Linear Latency Graph')
plt.grid()
plt.savefig("linearmodel.jpg")
