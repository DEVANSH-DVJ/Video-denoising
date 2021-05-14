import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np


data=np.array(
    [
        [23.6945 , 23.5994 , 27.1342 , 27.3721 , 27.2584 , 26.4753 , 23.7962 , 17.5443],
        
        [23.1713 , 23.1008 , 26.6927 , 26.8437 , 26.6462 , 25.8998 , 23.1268 , 15.5175],
        
        [22.6781 , 22.5920 , 26.1415 , 26.2657 , 26.0366 , 25.2296 , 22.5524 , 14.1236],
        
        [22.2009 , 22.1286 , 25.5636 , 25.5995 , 25.3423 , 24.4537 , 21.9991 , 13.0405],
        
        [21.8527 , 21.7505 , 24.9397 , 24.9599 , 24.6227 , 23.6796 , 21.6151 , 12.2634],
         
    ]
)

data=data.T

sns.set_theme(style="darkgrid")
sns.set(rc={'figure.figsize': (12, 10)})

sigma=10
kappa=10
s=["10%","20%", "30%", "40%", "50%"]
PSNR_30=pd.DataFrame({
    "LRMC 1": data[0][:],
    "LRMC 2": data[1][:],
    "PCA 1": data[2][:],
    "PCA 2": data[3][:],
    "PCA 3": data[4][:],
    "PCA 4": data[5][:],
    "VBM3D 1": data[6][:],
    "VBM3D 2": data[7][:],
})

fig = sns.lineplot(data=PSNR_30)
fig.set_xticks(range(len(s)))
fig.set_xticklabels(s)
plt.xlabel("Impulsive Noise (s)")
plt.ylabel("PSNR Value")
plt.title("PSNR Values (sigma=10, k=10)")
plt.show()
