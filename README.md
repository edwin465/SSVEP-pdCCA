# SSVEP-pdCCA

Recently, the multi-frequency-modulated visual stimulation paradigm has been shown effective for the steady-state visual evoked potential (SSVEP)-based brain-computer interfaces (BCIs). 

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

## An example of the pdCCA for MFSC visual stimulation paradigm

First, we introduct the CCA method for MFSC visual stimulation paradigm. According to [4], the CCA is used to find the spatial filters $\mathbf{u}$ and $\mathbf{v}$ to maximize the correlation $r$ between the 1-s SSVEP $\mathbf{X}$ and reference signal $\mathbf{Y}$ after spatial filtering, i.e.,  

```math
r_j=\max_{\mathbf{u},\mathbf{v}}{\frac{\mathbf{u}^\top\mathbf{X}_j^\top\mathbf{Y}_{CCA}\mathbf{v}}{\sqrt{\mathbf{u}^\top \mathbf{X}_j^\top\mathbf{X}_j\mathbf{u}\cdot\mathbf{v}^\top\mathbf{Y}_{CCA}^\top\mathbf{Y}_{CCA}\mathbf{v}}}}=\mathrm{CCA}(\mathbf{X}_j,\mathbf{Y}_{CCA}),
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

where $f_{k,j}$ is the $j$-th stimulus frequency of the $k$-th visual target, $j=1,2,3,4$, and $k=1,2,\cdots,160$. The final recognition result is determined by

```math
\hat{k} =\max_{k}{\{r_{k,1}+r_{k,2}+r_{k,3}+r_{k,4}\}} 
```

Second, we introduce the proposed pdCCA. The pdCCA is a CCA under a predefined phase difference constraint. Specifically, the phase of the sine-cosine reference signal is determined by the stimulus phase. In addition, the sine and cosine basis functions for different frequencies are concatenated horizontally. Then the CCA is used to find the spatial filters $\mathbf{u}$ and $\mathbf{v}$ to maximize the correlation $\rho$ between the 4-s SSVEP and $\mathbf{Y}\_{pdCCA}$ after spatial filtering:   
   
  
```math
\rho_j=\mathrm{CCA}\left(\left[\begin{array}{c}
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
    \mathbf{\Gamma}_{f_{k,1},\phi_{k,1}}^\top &  \mathbf{\Gamma}_{f_{k,2},\phi_{k,2}}^\top&  \mathbf{\Gamma}_{f_{k,3},\phi_{k,3}}^\top& \mathbf{\Gamma}_{f_{k,4},\phi_{k,4}}^\top\\
    \mathbf{\Gamma}_{2f_{k,1},2\phi_{k,1}}^\top &  \mathbf{\Gamma}_{2f_{k,2},2\phi_{k,2}}^\top&  \mathbf{\Gamma}_{2f_{k,3},2\phi_{k,3}}^\top& \mathbf{\Gamma}_{2f_{k,4},2\phi_{k,4}}^\top\\
    \vdots & \vdots & \vdots & \vdots \\ 
    \mathbf{\Gamma}_{N_h \cdot f_{k,1}, N_h \cdot \phi_{k,1}}^\top &  \mathbf{\Gamma}_{N_h \cdot f_{k,2}, N_h \cdot \phi_{k,2}^\top&  \mathbf{\Gamma}_{N_h \cdot f_{k,3}, N_h \cdot \phi_{k,3}}^\top& \mathbf{\Gamma}_{N_h \cdot f_{k,4}, N_h \cdot \phi_{k,4}}^\top\end{array}\right]^\top
```

## An example of the multi-frequency-modulated visual stimulation paradigms
MFSC  
downloaded from  


## Simulation study
We compare the CCA and the pdCCA  



