import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np


sns.set_theme(style="darkgrid")
sns.set(rc={'figure.figsize': (12, 10)})


kmax=60 
tau= [1.0, 1.5, 2.0]
PSNR_30=pd.DataFrame({
    "Variant 00" : [21.8325, 21.8327, 21.8327 ],
    "Variant 01" : [21.8561, 21.8562, 21.8562 ],
    "Variant 10" : [21.6951, 21.6952, 21.6952 ],
    "Variant 11" : [21.7238, 21.7241, 21.7241 ],
})

fig = sns.lineplot(data=PSNR_30)
fig.set_xticks(range(len(tau)))
fig.set_xticklabels(tau)
plt.xlabel("tau")
plt.ylabel("PSNR Values")
plt.title("PSNR Values for LRMC Variants (kmax=60)")
plt.show()
