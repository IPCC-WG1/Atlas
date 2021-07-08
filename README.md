[![DOI](https://zenodo.org/badge/190203356.svg)](https://zenodo.org/badge/latestdoi/190203356) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/SantanderMetGroup/climate4R/devel?urlpath=git-pull%3Frepo=https://github.com/IPCC-WG1/Atlas&urlpath=tree/Atlas&branch=devel)

# The Climate Change Atlas

The Climate Change Atlas is an initiative to develop **tools and ready-to-use datasets** for reproducible regional analysis of observed and model projected (CMIP5, CMIP6 and CORDEX) climate change information using both time-slices (e.g. 2081-2100) and warming levels (e.g. +1.5º). A **new set of sub-continental reference regions** is provided as the basis for regional synthesis (building on IPCC AR5 reference regions) and monthly spatially aggregated datasets are produced to facilitate the development of regional climate change information. 

The **accessibility and reproducibility** of results has been a major concern during the development of the Climate Change Atlas, in order to ensure the transparency of the products, which are all publicly available. The Atlas products are generated using **free software community tools**, in particular [R](https://www.r-project.org) building on the [**climate4R** framework](https://github.com/SantanderMetGroup/climate4R) for data post-processing (data access, regridding, aggregation, bias adjustment, etc.) and evaluation and quality control (when applicable). **Provenance metadata** is generated using the [**METACLIP**](http://www.metaclip.org) RDF-based framework, building on the [metaclipR](https://github.com/metaclip/metaclipR) package for the climate4R framework.

## Contents

![Atlas repository scheme](Atlas-repo-scheme.svg)

| Directory | Contents |
| :-------- | :------- |
| [inventory](inventory) | Full list of model simulations used for the different experiments and scenarios, indicating the availability of the different variables
| [reference-grids](reference-grids) | Reference commensurable grids at regular 0.5&deg;, 1&deg; and 2&deg; resolutions. These are used to interpolate all variables and indices as a final processing step before analysis.
| [reference-regions](reference-regions) | New set of reference analysis regions
| [datasets-interactive-atlas](datasets-interactive-atlas) |  End-to-end scripts used for the preparation of the intermediate data (Interactive Atlas Dataset) underpinning the Interactive Atlas. The Interactive Atlas Dataset is formed by monthly values of CMIP5/6 and CORDEX data for different variables and indices interpolated to common [reference grids](reference-grids). The scripts document the whole process, from data access to index calculation (and postprocessing –e.g. bias adjustment– if needed).
| [datasets-aggregated-regionally](datasets-aggregated-regionally) | The Interactive Atlas Dataset is averaged over the reference regions to produce many of the figures. These key aggregated data are provided directly for further analysis within this Github repository folder.
| [warming-levels](warming-levels) | Global Warming Levels (+1.5&deg;, +2&deg;, +3&deg;, +4&deg;) are computed and provided in this folder.
| [notebooks](notebooks) | Cross-cutting Jupyter notebooks, combining the information from several of the previous directories to perform specific analyses. Some of the previous top-level directories also contain their own notebooks directory with specific examples to work with the particular data in those directories.
| [reproducibility](reproducibility) | End-to-end scripts used for the preparation of the key figures of the IPCC AR6 WGI Atlas chapter.

## New Reference Regions

<img src="reference-regions/reference_regions.png" align="left" alt="" width="500" />

A new set of reference regions is produced building on the popular [IPCC AR5 reference regions](http://www.ipcc-data.org/guidelines/pages/ar5_regions.html) developed for reporting sub-continental CMIP5 projections (with typical resolution of 2&deg;) over a reduced number of regions. The increased resolution of CMIP6 and CORDEX projections (typically 1&deg; and 0.5&deg;) allows to increase the number of regions for a better representation of different climates. This results in new set of **46 land and 14 ocean reference regions**). The coordinates delimiting the regions (CSV and shapefiles) and other related datasets are available at the [reference-regions](./reference-regions) repository folder.

## Regionally-aggregated datasets (CMIP and CORDEX)
The IPCC reference regions have been used as the basis to generate popular spatially-aggregated datasets, such as the [IPCC AR5 seasonal mean temperature and precipitation in IPCC regions for CMIP5](https://catalogue.ceda.ac.uk/uuid/9d0f61dc7a1b4017b22d88f9d38ab398). Here, we provide an updated version of this dataset using CMIP6 projections (interpolated to a common 1º resolution, see **'referece_masks'**) for the new regions. Monthly mean values are stored for CMIP5/6 for the historical (1850-2005/1850-2014) and future RCP2.6/SSP1-2.6, RCP4.5/SSP2-4.5 and RCP8.5/SSP5-8.5 scenarios. This will later be extended to CORDEX datasets. An inventory of the currently available models and runs is available at the [inventory](./inventory) folder.

Besides the analysis of time-slices (e.g. near-, mid- and long-term, 2021-2040, 2041-2060, 2081-2100, respectively), we also provide information to work with Global Warming Levels (+1.5&deg;, +2&deg;, +3&deg;, +4&deg;) under [warming-levels](./warming-levels).

## Scripts and notebooks
Scripts and (jupyter) notebooks are provided in the different sections to ensure reproducibility and reusability of the results.

## Virtual Workspace: The Atlas Hub
The Atlas Hub is a cloud facility providing virtual workspace for the Climate Change Atlas code and data (with preinstalled software and accesible data). The Atlas Hub is based on **Jupyter** to create and run notebooks on a remote machine where all the software is pre-installed. The Atlas Hub builds on the R **climate4R** package, allowing for transparent climate data access, collocation, post-processing (including bias adjustment) and visualization. Instructions to start working with the Hub are available at the [climate4R GitHub repository](https://github.com/SantanderMetGroup/climate4R).

## Disclaimer

This work is carried out for the purpose of contributing the Sixth Assessment Report of the IPCC. It is in draft status and subject to change. This repository is part of the Second Order Draft of the Working Group I report and is provided for information only
