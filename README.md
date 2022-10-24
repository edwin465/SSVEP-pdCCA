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

In this project, we propose a canonical correlation analysis (CCA) with the phase difference constraint, (phase difference constrained CCA, pdCCA)
