# File: plotter.py
# Author: Adrian Garcia
# Date 06/10/2023
## Presets
import math
import numpy as np
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 12})
plt.rcParams['mathtext.fontset'] = 'stix'
plt.rcParams['font.family'] = 'STIXgeneral'
tc = 2.8000000000000247E-008
ts = 6.9551169872283942E-006
tw = 2.5770869106054308E-009
P = np.linspace(1, 101, 100)
N = [10, 20, 50]
Tcol = np.zeros(len(P))
Ecol = np.zeros(len(P))
T2D = np.zeros(len(P))
E2D = np.zeros(len(P))
colors = ['tomato', 'steelblue', 'yellowgreen']
for j in range(len(N)):
    for i in range(len(P)):
        Tcol[i] = (tc*N[j]**2)/P[i] + 2*ts + 2*tw*N[j]
        Ecol[i] = (tc*N[j]**2)/(tc*N[j]**2 + 2*P[i]*ts + 2*tw*N[j])
        T2D[i] = (tc*N[j]**2)/P[i] + 8*ts + 2*tw*(N[j]/math.sqrt(P[i])) + 2*tw*(N[j]/math.sqrt(P[i])) + 4*tw
        E2D[i] = (tc*N[j]**2)/(tc*N[j]**2 + 8*P[i]*ts + 2*math.sqrt(P[i])*tw*N[j] + 2*math.sqrt(P[i])*tw*N[j] + 4*P[i]*tw)
    plt.figure(1)
    plt.plot(P, Tcol, color = colors[j], label = f'N = {N[j]}')
    # Plot config
    plt.yscale('log')
    plt.title('Performance Model - Execution Time - Column Decomposition')
    plt.ylabel('Total time')
    plt.xlabel('Number of Processors')
    plt.grid()
    plt.legend()
    plt.savefig('ExecCol.jpg', dpi=300)
    plt.figure(2)
    plt.plot(P, Ecol, color = colors[j], label = f'N = {N[j]}')
    # Plot config
    plt.title('Performance Model - Efficiency - Column Decomposition')
    plt.ylabel('Efficiency')
    plt.xlabel('Number of Processors')
    plt.grid()
    plt.legend()
    plt.savefig('EffCol.jpg', dpi=300)
    plt.figure(3)
    plt.plot(P, T2D, color = colors[j], label = f'N = {N[j]}')
    # Plot config
    plt.yscale('log')
    plt.title('Performance Model - Execution Time - 2D Decomposition')
    plt.ylabel('Total time')
    plt.xlabel('Number of Processors')
    plt.grid()
    plt.legend()
    plt.savefig('Exec2D.jpg', dpi=300)
    plt.figure(4)
    plt.plot(P, E2D, color = colors[j], label = f'N = {N[j]}')
    # Plot config
    plt.title('Performance Model - Efficiency - 2D Decomposition')
    plt.ylabel('Efficiency')
    plt.xlabel('Number of Processors')
    plt.grid()
    plt.legend()
    plt.savefig('Eff2D.jpg', dpi=300)
plt.show()
