import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np


sns.set_theme(style="darkgrid")
sns.set(rc={'figure.figsize': (12, 10)})


#data_ = pd.DataFrame({'cat': ['red', 'green', 'blue'], 'val': [1, 2, 3]})
#fig = sns.barplot(x = 'cat', y = 'val', data = data_, color = 'black')
#plt.xlabel("Colors")
#plt.ylabel("Values")
#plt.title("Colors vs Values") # You can comment this line out if you don't need title
#plt.show()


kmax=30 
tau= [1.0, 1.5, 2.0]
PSNR_30=pd.DataFrame({
    "Variant 00" : [21.6253 , 21.8286 , 21.8325 ],
    "Variant 01" : [21.6466 , 21.8527 , 21.8560 ],
    "Variant 10" : [21.4761 , 21.6910 , 21.6951 ],
    "Variant 11" : [21.4979 , 21.7201 , 21.7239 ],
})

fig = sns.lineplot(data=PSNR_30)
fig.set_xticks(range(len(tau)))
fig.set_xticklabels(tau)
plt.xlabel("tau")
plt.ylabel("PSNR Values")
plt.title("PSNR Values for LRMC Variants (kmax=30)")
plt.show()

