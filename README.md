# SSVEP-pdCCA

Recently, the multi-frequency-modulated visual stimulation paradigm has been shown effective for the steady-state visual evoked potential (SSVEP)-based brain-computer interfaces (BCIs). Up to now, almost all corresponding frequency recognition algorithms are based on the traditional canonical correlation analysis (CCA), especially in the `calibration-free` scenario. Although the CCA can work well, it usually cannot provide the optimal performance. **For the multi-frequency-modulated SSVEP, different frequency components are phase locked to the different stimuli, and thus their phase differences should be fixed, or constrained**. However, the current CCA cannot constrain the phase difference features between the multi-frequency-modulated SSVEP.  

In this project, we propose a phase difference constrained CCA for the multi-frequency-modulated SSVEP-based BCIs.


## What is the multi-frequency-modulated visual stimulation paradigm? 
In the multi-frequency-modulated visual stimulation paradigm, **each visual target is encoded with more than one frequency**. 
For example, more than one frequency are used to drive one visual target in different timeslots [1-5], drive one visual target at the same time (e.g., the frequency modulation and the amplitude modulation) [6,7], and drive two flickers (each visual target consists of two flickers) at the same time [8-10], respectively, as illustrated in Fig. 1.

> [1] Y. Zhang, P. Xu, T. Liu, J. Hu, R. Zhang, and D. Yao, “Multiple Frequencies Sequential Coding for SSVEP-Based Brain-Computer Interface,” PloS one, vol. 7, no. 3, p. e29519, 2012.  
> [2] Y. Kimura, T. Tanaka, H. Higashi, and N. Morikawa, “SSVEP-Based Brain–Computer Interfaces Using FSK-Modulated Visual Stimuli,” IEEE Trans. Biomed. Eng., vol. 60, no. 10, pp. 2831–2838, 2013.  
> [3] S. Ge, Y. Jiang, M. Zhang, R. Wang, K. Iramina, P. Lin, Y. Leng, H. Wang, and W. Zheng, “SSVEP-Based Brain-Computer Interface with a Limited Number of Frequencies Based on Dual-Frequency Biased Coding,” IEEE Trans. Neural Syst. Rehabil. Eng., vol. 29, pp. 760–769, 2021.  
> [4] Y. Chen, C. Yang, X. Ye, X. Chen, Y. Wang, and X. Gao, “Implementing a Calibration-Free SSVEP-Based BCI System with 160 Targets,” J. Neural Eng., vol. 18, no. 4, p. 046094, 2021.  
> [5] X. Ye, C. Yang, Y. Chen, Y. Wang, X. Gao, and H. Zhang, “Multisymbol Time Division Coding for High-Frequency Steady-State Visual Evoked Potential-Based Brain-Computer Interface,” IEEE Trans. Neural Syst. Rehabil. Eng., vol. 30, pp. 1693–1704, 2022.  
> [6] M. H. Chang, H. J. Baek, S. M. Lee, and K. S. Park, “An Amplitude-Modulated Visual Stimulation for Reducing Eye Fatigue in SSVEP-Based Brain–Computer Interfaces,” Clinical Neurophysiology, vol. 125, no. 7, pp. 1380–1391, 2014.  
> [7] A. M. Dreyer and C. S. Herrmann, “Frequency-Modulated Steady-State Visual Evoked Potentials: a New Stimulation Method for Brain–Computer Interfaces,” J. Neurosci. Meth., vol. 241, pp. 1–9, 2015.  
> [8] K.-K. Shyu, P.-L. Lee, Y.-J. Liu, and J.-J. Sie, “Dual-Frequency Steady-State Visual Evoked Potential for Brain Computer Interface,” Neuroscience letters, vol. 483, no. 1, pp. 28–31, 2010.  
> [9] X. Chen, Z. Chen, S. Gao, and X. Gao, “Brain–Computer Interface Based on Intermodulation Frequency,” J. Neural Eng., vol. 10, no. 6, p. 066009, 2013.  
> [10] L. Liang, J. Lin, C. Yang, Y. Wang, X. Chen, S. Gao, and X. Gao, “Optimizing a Dual-Frequency and Phase Modulation Method for SSVEP-Based BCIs,” J. Neural Eng., vol. 17, no. 4, p. 046026, 2020.  

![Result1](https://github.com/edwin465/SSVEP-pdCCA/blob/main/plot_sfm_mfm_vs.pdf)  

## What is the phase difference constrained CCA (pdCCA)?
The canonical correlation analysis (CCA) is widely used to identify the stimulus frequency from the single-frequency-modulated SSVEPs in the traditional SSVEP-based BCIs. Many experiment results have demonstrated that the CCA can provide an acceptable accuracy. In addition, the CCA is ease-to-use and conveniently applied into many different scenarios. Importantly, the CCA is `calibration-free`.

In the literature, the CCA has been applied in the multi-frequency-modulated SSVEP-based BCIs. However, the existing CCA performance might not be optimal. Because the CCA usually neglect the phase features of the SSVEPs. In the multi-frequency-modulated visual stimulation paradigm, the multiple frequency components of SSVEPs are phase-locked to the multiple visual stimuli, and thus the phase differences between different frequency components should be constrained. **The traditional CCA is incapable of extracting these phase difference features in the recognition**.

In this project, we utilize the phase difference feature to improve the recognition accuracy of the CCA. **We develop a phase difference constrained CCA (pdCCA)**.  

### An example of the pdCCA for MFSC visual stimulation paradigm

As an example, we introduce how to design the pdCCA method for the SSVEP-based BCI based on the multi-frequency sequential coding. 
First, we introduce how the CCA method recognizes the multiple frequencies in this SSVEP-based BCI. According to [4], the CCA is used to find the spatial filters $\mathbf{u}$ and $\mathbf{v}$ to maximize the correlation $r$ between the 1-s SSVEP $\mathbf{X}\_j$ and reference signal $\mathbf{Y}\_{CCA}$ after spatial filtering, i.e.,  

```math
r_{k,j}=\max_{\mathbf{u},\mathbf{v}}{\frac{\mathbf{u}^\top\mathbf{X}_j^\top\mathbf{Y}_{CCA}\mathbf{v}}{\sqrt{\mathbf{u}^\top \mathbf{X}_j^\top\mathbf{X}_j\mathbf{u}\cdot\mathbf{v}^\top\mathbf{Y}_{CCA}^\top\mathbf{Y}_{CCA}\mathbf{v}}}}=\mathrm{CCA}(\mathbf{X}_j,\mathbf{Y}_{CCA}), 
```  

and  

```math
\mathbf{Y}_{CCA} = \left[\begin{array}{c}
    \sin (2\pi f_{k,j} t)\\
    \cos (2\pi f_{k,j} t)\\
    \vdots\\
    \sin (2\pi N_h f_{k,j} t)\\
    \cos (2\pi N_h f_{k,j} t)\\    
	\end{array}\right]^\top = \left[\begin{array}{c}
    \mathbf{\Gamma}_{f_{k,j}}^\top\\
    \mathbf{\Gamma}_{2\cdot f_{k,j}}^\top\\
    \vdots\\
    \mathbf{\Gamma}_{N_h f_{k,j}}^\top
	\end{array}\right]^\top = [\mathbf{\Gamma}_{f_{k,j}},\mathbf{\Gamma}_{2f_{k,j}},\cdots,\mathbf{\Gamma}_{N_h f_{k,j}}]
```

where $f_{k,j}$ is the $j$-th stimulus frequency of the $k$-th visual target, $j=1,2,3,4$, and $k=1,2,\cdots,160$. Note that each visual target has a unique sequential coding of four frequencies. The details of the sequential coding can be referred to Fig. 1-3 in [4]. The final recognition result is determined by

```math
\hat{k} =\max_{k}{\{r_{k,1}+r_{k,2}+r_{k,3}+r_{k,4}\}} =\max_{k}{\{\bar{r}_{k}\}} 
```

All the above procedure is illustrated in Fig. 4 in [4].

Second, we introduce the proposed pdCCA. In short, `the pdCCA is the CCA under a predefined phase difference constraint`. Specifically, the phase of the sine-cosine reference signal is determined by the stimulus phase. In addition, the sine and cosine basis functions for different frequencies are concatenated horizontally. Then the CCA is used to find the spatial filters $\mathbf{u}$ and $\mathbf{v}$ to maximize the correlation $\rho$ between the 4-s SSVEP and $\mathbf{Y}\_{pdCCA}$ after spatial filtering:   
   
  
```math
\rho_k=\mathrm{CCA}\left(\left[\begin{array}{c}
   \mathbf{X}_1 \\
   \mathbf{X}_2 \\
   \mathbf{X}_3 \\
   \mathbf{X}_4 \end{array}\right],\mathbf{Y}_{pdCCA} \right),
```  

and  

```math
\mathbf{Y}_{pdCCA} = \left[\begin{array}{cccc}
    \sin (2\pi f_{k,1} t+\phi_{k,1}) & \sin (2\pi f_{k,2} t+\phi_{k,2})& \sin (2\pi f_{k,3} t+\phi_{k,3})& \sin (2\pi f_{k,4} t+\phi_{k,4})\\
    \cos (2\pi f_{k,1} t+\phi_{k,1}) & \cos (2\pi f_{k,2} t+\phi_{k,2})& \cos (2\pi f_{k,3} t+\phi_{k,3})& \cos (2\pi f_{k,4} t+\phi_{k,4})\\
    \vdots & \vdots & \vdots & \vdots \\ 
    \sin (2\pi N_h f_{k,1} t+N_h \phi_{k,1}) & \sin (2\pi N_h f_{k,2} t+N_h \phi_{k,2})& \sin (2\pi N_h f_{k,3} t+N_h \phi_{k,3})& \sin (2\pi N_h f_{k,4} t+N_h \phi_{k,4})\\
    \cos (2\pi N_h f_{k,1} t+N_h \phi_{k,1}) & \cos (2\pi N_h f_{k,2} t+N_h \phi_{k,2})& \cos (2\pi N_h f_{k,3} t+N_h \phi_{k,3})& \cos (2\pi N_h f_{k,4} t+N_h \phi_{k,4})\\   
	\end{array}\right]^\top 
```	

```math	
= \left[\begin{array}{cccc}
    \mathbf{\Gamma}_{f_{k,1},\phi_{k,1}} & \mathbf{\Gamma}_{2f_{k,1},2\phi_{k,1}} & \cdots & \mathbf{\Gamma}_{N_h f_{k,1},N_h \phi_{k,1}}\\
    \mathbf{\Gamma}_{f_{k,2},\phi_{k,2}} & \mathbf{\Gamma}_{2f_{k,2},2\phi_{k,2}} & \cdots & \mathbf{\Gamma}_{N_h f_{k,2},N_h \phi_{k,2}}\\
    \mathbf{\Gamma}_{f_{k,3},\phi_{k,3}} & \mathbf{\Gamma}_{2f_{k,3},2\phi_{k,3}} & \cdots & \mathbf{\Gamma}_{N_h f_{k,3},N_h \phi_{k,3}}\\
    \mathbf{\Gamma}_{f_{k,4},\phi_{k,4}} & \mathbf{\Gamma}_{2f_{k,4},2\phi_{k,4}} & \cdots & \mathbf{\Gamma}_{N_h f_{k,4},N_h \phi_{k,4}}
    \end{array}\right]
```

The final recognition result is determined by

```math
\hat{k} =\max_{k}{\{\rho_k\}} 
```
  
### What is the pdCCA+?  
To further improve the pdCCA performance, we combine the computed coefficients $\bar{r}\_k$ and $\rho\_k$ for final recognition:

```math
\hat{k} =\max_{k}{\{\bar{r}_k + \rho_k\}} 
```

In ideal case, this strategy can achieve the higher recognition performance then the CCA and the pdCCA as it considers much more feature/information. We call it `the pdCCA+`.

## A public dataset for MFSC SSVEP-BCI
In this project, **we test the proposed pdCCA on a public MFSC SSVEP dataset [4]**.  

In [4], Chen et al. utilized the MFSC approach to implement a 160-target SSVEP-based BCI speller, in which each visual target is encoded with a unique sequential coding of four stimulus frequencies and phases. The four stimulus frequencies are selected from eight predefined stimulus frequencies. The predefined frequencies are 8 Hz, 9 Hz, 10 Hz, 11 Hz, 12 Hz, 13 Hz, 14 Hz, and 15 Hz, and the corresponding phases are 0, 0.5π, π, 1.5π, 0, 0.5π, π, and 1.5π. They invited eight (or twelve) subjects to participate in the offline (or online) SSVEP-based BCI experiment. In total, there were 480 trials in the offline experiment (or 320 trials in the
online experiment). In each trial, the visual target flashed for 4 s, which consists of four 1-s segment corresponding to four stimuli. During the 
experiments, all subject data were recorded from nine electrodes (Pz, PO5, PO3, POz, PO4, PO6, O1, Oz, and O2). More details can be found in [4]. 

The datasets corresponding to the offline and online experiments can be freely downloaded from the website of Tsinghua BCI group (http://bci.med.tsinghua.edu.cn/).  


## Simulation study

Run `pdcca_acc_tsinghua_20220401_.m`

1) Parameter setting: dataset_no=1; data_len=1; => Offline exp. and 1 s data length  


| ACC | CCA | pdCCA0 | pdCCA | pdCCA0+ | pdCCA+ |  
| --- | --- | --- | --- | --- | --- | 
|S1|	95.63%|	37.50%|	97.71%|	61.46%|	98.33%|  
|S2|	92.50%|	38.75%|	93.13%|	64.79%|	93.75%|  
|S3|	85.31%|	26.88%|	94.38%|	45.31%|	94.38%|  
|S4|	89.58%|	37.92%|	91.67%|	62.71%|	95.21%|  
|S5|	65.63%|	24.38%|	74.17%|	41.25%|	76.04%|  
|S6|	79.79%|	35.21%|	91.67%|	54.17%|	94.38%|  
|S7|	85.00%|	30.21%|	94.38%|	49.79%|	96.04%|  
|S8|	59.79%|	25.63%|	86.04%|	39.58%|	87.71%|  
|Mean|	81.65%|	32.06%|	90.39%|	52.38%|	91.98%|  

We can find that the pdCCA performs better than the CCA. The pdCCA+ accuracy looks better than the pdCCA accuracy.   

2) Parameter setting: dataset_no=2; data_len=1; => Online exp. and 1 s data length 

| ACC | CCA | pdCCA0 | pdCCA | pdCCA0+ | pdCCA+ |  
| --- | --- | --- | --- | --- | --- | 
|S1|	93.44%|	41.25%|	95.00%|	64.06%|	95.94%|
|S2|	97.50%|	44.06%|	98.13%|	73.75%|	98.75%|
|S3|	56.88%|	25.31%|	80.94%|	38.13%|	84.69%|
|S4|	85.94%|	27.19%|	97.50%|	47.50%|	97.19%|
|S5|	91.88%|	38.75%|	98.75%|	63.44%|	98.75%|
|S6|	68.75%|	29.38%|	83.44%|	41.88%|	86.88%|
|S7|	74.69%|	29.06%|	90.00%|	50.94%|	91.88%|
|S8|	96.88%|	33.13%|	100.00%|	57.50%|	100.00%|
|S9|	70.63%|	23.44%|	91.56%|	34.38%| 92.19%|
|S10|	94.38%|	42.81%|	95.31%|	72.81%|	96.25%|
|S11|	99.06%|	42.50%|	99.06%|	71.56%|	99.38%|
|S12|	91.56%|	34.38%|	94.69%|	57.19%|	96.25%| 
|Mean|	85.13%|	34.27%|	93.70%|	56.09%|	94.84%|  

We can find that the pdCCA performs better than the CCA. The pdCCA+ accuracy looks better than the pdCCA accuracy. 

3) You can test different parameters, such as data_len=0.4, 0.5, ..., 1.0 (as shown in Table III). The grand average results should be equal to Table V.

# Citation  
If you use this code for a publication, please cite the following papers

@article{wong2020learning,  
title={Learning across multi-stimulus enhances target recognition methods in SSVEP-based BCIs},  
author={Wong, Chi Man and Wan, Feng and Wang, Boyu and Wang, Ze and Nan, Wenya and Lao, Ka Fai and Mak, Peng Un and Vai, Mang I and Rosa, Agostinho},  
journal={Journal of Neural Engineering},  
volume={17},  
number={1},  
pages={016026},  
year={2020},  
publisher={IOP Publishing}  
}  

@article{wong2020spatial,  
title={Spatial filtering in SSVEP-based BCIs: unified framework and new improvements},  
author={Wong, Chi Man and Wang, Boyu and Wang, Ze and Lao, Ka Fai and Rosa, Agostinho and Wan, Feng},  
journal={IEEE Transactions on Biomedical Engineering},  
volume={67},  
number={11},  
pages={3057--3072},  
year={2020},  
publisher={IEEE}  
}  

@article{wong2023multi,  
  title={Enhancing Detection of Multi-Frequency-Modulated SSVEP Using Phase Difference Constrained Canonical Correlation Analysis},  
  author={Wong, Chi Man and Wang, Ze and Wang, Boyu and Rosa, Agostinho and Jung, Tzyy-Ping and Wan, Feng},  
  journal={IEEE Transactions on Neural Systems and Rehabilitation Engineering},  
  year={2023 (Early Access)},   
  publisher={IEEE}  
}
