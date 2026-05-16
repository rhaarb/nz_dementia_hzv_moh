# Planned Synthetic Data

We plan to add a low-fidelity synthetic dataset by the end of May 2026 to demonstrate that the analysis code is executable without access to the sensitive Ministry of Health data.

The synthetic dataset will be used only for code demonstration. It will not reproduce the quantitative manuscript results, including estimated treatment effects, confidence intervals, p-values, or other analysis outputs reported in the paper.

The planned synthetic dataset will focus on a single processed person-level analysis table rather than synthetic versions of all raw input files. Two approaches are being considered:

- A no-fidelity simulation-based approach
- A low-fidelity distance-based approach

Both approaches have been used in New Zealand Integrated Data Infrastructure settings. See Wang et al., "Enhancing public research on citizen data: An empirical investigation of data synthesis using Statistics New Zealand's Integrated Data Infrastructure" ([ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0306457323002959)).

Once the synthetic person-level table is added, this repository will specify the exact point in `Code/02_Analysis/09_analysis.rmd` from which the analysis can be run after loading the synthetic dataset into the R environment. We expect this to be around line 1675, immediately before the creation of the incidence and prevalence analysis datasets.

Runtime for the synthetic-data code check will be longer than the minimal event-count check and will depend on the final synthetic dataset and analysis workflow.
