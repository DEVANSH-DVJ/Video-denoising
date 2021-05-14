import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np


data=np.array(
    [
        [21.9801 , 22.0652 , 25.2479 , 25.2414 , 24.9745 , 24.2019 , 27.3927 , 23.9866 ],
         [ 21.3173 , 21.3527 , 24.4847 , 24.4564 , 24.1792 , 23.3586 , 26.3149 , 17.0644],
          [20.5023 , 20.4782 , 23.4038 , 23.2987 , 22.9143 , 21.9643 , 24.9581 , 14.3543 ],
    ]
)

data=data.T

sns.set_theme(style="darkgrid")
sns.set(rc={'figure.figsize': (12, 10)})

sigma=10
kappa=10
s=["10%","30%", "50%"]
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
plt.title("PSNR Values (sigma=50, k=5)")
plt.show()
