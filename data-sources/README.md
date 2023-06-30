# Data sources used in the Atlas

The [Atlas chapter](https://www.ipcc.ch/report/ar6/wg1/chapter/atlas) and the [Interactive Atlas](https://interactive-atlas.ipcc.ch) build on several key observational and model simulated datasets made publicly available by different institutions and modelling centres, in some cases resulting from international collaborations such as the World Climate Research Programme (WCRP) Coupled Model Intercomparison Project ([CMIP](https://www.wcrp-climate.org/wgcm-cmip)) and the Coordinated Regional Climate Downscaling Experiment ([CORDEX](https://cordex.org)). They also include some datasets produced and used in different chapters of the IPCC Working Group I Sixth Assessment Report ([AR6 WGI](https://www.ipcc.ch/report/ar6/wg1/)).

> We acknowledge all institutions and modelling centres for making the data publicly available in the [LICENSE](../LICENSE.md) file of this repository. 

## Observations

The observational datasets used in the Atlas are described in [Table Atlas.SM.15](https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WGI_Atlas_SM.pdf). This repository contains information derived from [W5E5](https://doi.org/10.5880/pik.2019.023) (WFDE5 over land merged with ERA5 over the ocean) dataset.

## Climate Change projections (CMIP6, CMIP5 and CORDEX)

CMIP and CORDEX datasets were obtained from the Earth System Grid Federation, [ESGF](https://esgf-data.dkrz.de/projects/esgf-dkrz/) ([Cinquini et al. 2014](https://doi.org/10.1016/j.future.2013.07.002), [Balaji et al. 2018](https://doi.org/10.5194/gmd-11-3659-2018)). An inventory of the data sources of the model simulations used for the different experiments and scenarios is included in the CMIP5, CMIP6 and CORDEX folders in this repository, indicating the availability of the different variables (including details on the particular versions used). The following documents provide an overview of the subset of simulations used for CMIP5, CMIP6 and CORDEX from those available at ESGF by the cut-off date (january 2021): [CMIP5_simulations_ATLAS.pdf](CMIP5_simulations_ATLAS.pdf), [CMIP6_simulations_ATLAS.pdf](CMIP6_simulations_ATLAS.pdf), [CORDEX_simulations_ATLAS.pdf](CORDEX_simulations_ATLAS.pdf). 

Unlike CORDEX and CMIP5, the consolidated CMIP6 subset includes multiple realms (atmos, land, ocean, seaIce) and temporal frequencies (day/mon). Tables Atlas.SM.1 to Atlas.SM.14 in the [Atlas Suplementary Material](https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WGI_Atlas_SM.pdf) present the CMIP5, CMIP6 and CORDEX ensembles and the specific variables used in the [Atlas chapter](https://www.ipcc.ch/report/ar6/wg1/chapter/atlas) and the [Interactive Atlas](http://interactive-atlas.ipcc.ch).

[Dataset_DOIs.html](https://raw.githack.com/IPCC-WG1/Atlas/devel/data-sources/Dataset_DOIs.html) contains a searchable table listing the DOIs at the dataset level (for each model and scenario), while README files in the different folders ([CMIP5](data-sources/CMIP5/), [CMIP6](data-sources/CMIP6/) and [CORDEX](data-sources/CORDEX/)) provide handle and/or ESGF search links pointing to the specific data files used, including the versions of every model and variable within ESGF to ensure complete traceability of the data. 

> Note: From these consolidated datasets, multiple indices were calculated at a monthly scale (annual scale for several indices) for the development of the [Interactive Atlas](http://interactive-atlas.ipcc.ch) and for the assessment done in the [Atlas chapter](https://www.ipcc.ch/report/ar6/wg1/chapter/atlas/). In particular, this repository includes [temperature and precipitation data regionally aggregated](../datasets-aggregated-regionally) over the [IPCC-WGI reference regions](../reference-regions) for CMIP5, CMIP6, and CORDEX. The full monthly gridded dataset is provided by the [IPCC-DDC](https://www.ipcc-data.org).

> Note: This folder traces the exact version of the datasets used in the Atlas. Newer versions of these data may exist in the future for different reasons. Users should visit the ES-DOC Dataset Errata website ([https://errata.es-doc.org](https://errata.es-doc.org)) to check the availability of newer versions or data retractions in the datasets stored in this repository.
Throughout this repository, we have broadly referred to the Scenario Model Intercomparison (ScenarioMIP) as CMIP6. However, please note that other CMIP6-Endorsed MIPs are also included here, namely CORDEX and PMIP (Palaeoclimate Modelling Intercomparison Project).

## Paleoclimate simulations

The paleoclimate simulations used in the [Interactive Atlas](http://interactive-atlas.ipcc.ch) were generated using model simulated data from PMIP3 (CMIP5) and PMIP4 (CMIP6) experiments. The data and code are available in the [PMIP_for_AR6_Interactive_Atlas WGI GitHub repository](https://github.com/IPCC-WG1/PMIP_for_AR6_Interactive_Atlas) (see [Zhao et al. 2022](https://doi.org/10.5194/gmd-2021-290)).

## Sea Level Rise projections (AR6 WGI Chapter 9)

Sea level rise information used in the [Interactive Atlas](http://interactive-atlas.ipcc.ch) was obtained from [Chapter 9](https://www.ipcc.ch/report/ar6/wg1/chapter/chapter-9/). The sea level projections associated with the [Intergovernmental Panel on Climate Change Sixth Assessment Report](https://doi.org/10.26050/WDCC/AR6.IPCC-DDC_AR6_Sup_SLP) are preserved in [Gregory et al. 2023](https://www.wdc-climate.de/ui/entry?acronym=IPCC-DDC_AR6_Sup_SLPr). This data is also available via [the NASA Sea Level Projection Tool](https://sealevel.nasa.gov/ipcc-ar6-sea-level-projection-tool), where it can be explored in greater detail. See [IPCC AR6 Sea Level Projections | Zenodo](https://zenodo.org/communities/ipcc-ar6-sea-level-projections) for additional related datasets.

## Short-lived climate forcers (AR6 WGI Chapter 5)

Information on surface Ozone, Particulate Matter (PM2.5), and Effective Radiative Forcing (ERF, due to aerosols) used in the [Interactive Atlas](http://interactive-atlas.ipcc.ch) was obtained from [Chapter 5](https://www.ipcc.ch/report/ar6/wg1/chapter/chapter-5/). This data is not included in this repository.

## Socio-economic data (population and anthropogenic CO2 emissions)

The [Interactive Atlas](http://interactive-atlas.ipcc.ch) also includes relevant socioeconomic data to provide context information on the SSPs used in the CMIP6 climate projections. This includes anthropogenic CO2 emissions for the different SSPs (used as forcing by the CMIP6 modelling community) and population data consistent with the different SSPs (used as forcing data by the ISIMIP modelling community). This data is not included in this repository.

### Anthropogenic CO2 emissions

The total CO2 anthropogenic emissions data is derived from the input4MIPs datasets detailed below by summing the data from different sources of emission: Annual Aircraft Anthropogenic Emissions (sum of all altitude levels of variable **CO2-em-AIR-anthro**) and Annual Anthropogenic Emissions of the following sectors (dimension `level` in the dataset): 0: Agriculture; 1: Energy; 2: Industrial; 3: Transportation; 4: Residential, Commercial, Other; 5: Solvents production and application; 6: Waste; 7: International Shipping (variable **CO2-em-anthro**).

The decadal gridded data was provided by the input4MIPs project ([Feng et al. (2020)](https://doi.org/10.5194/gmd-13-461-2020)). Source: [ESGF](https://esgf-node.llnl.gov/search/input4mips/). 

<u>Historical anthropogenic emissions</u> [https://doi.org/10.22033/ESGF/input4MIPs.1241](https://doi.org/10.22033/ESGF/input4MIPs.1241) (Hoesly et al. (2017a, b):

CO2-em-anthro_input4MIPs_emissions_CMIP_CEDS-2017-05-18\
CO2-em-AIR-anthro_input4MIPs_emissions_CMIP_CEDS-2017-08-30

<u>Future emissions downscaling and gridding</u> [https://doi.org/10.22033/ESGF/input4MIPs.10464](https://doi.org/10.22033/ESGF/input4MIPs.10464) (Gidden et al., 2018b, c):

[anthro/AIR-anthro]_input4MIPs_emissions_ScenarioMIP_IAMC-REMIND-MAGPIE-ssp585\
[anthro/AIR-anthro]_input4MIPs_emissions_ScenarioMIP_IAMC-MESSAGE-GLOBIOM-ssp245\
[anthro/AIR-anthro]_input4MIPs_emissions_ScenarioMIP_IAMC-IMAGE-ssp126-1-1\
[anthro/AIR-anthro]_input4MIPs_emissions_ScenarioMIP_IAMC-AIM-ssp370-1-1

### Population data (0.5°)

Gridded population data is included for the historical period and for the different SSPs. Historical annual gridded population data for the period 1861-2005 is based on the HYDE3.2 database [Klein Goldewijk et al., 2017](https://doi.org/10.5194/essd-9-927-2017). Source: [ISIMIP2b](https://www.isimip.org/gettingstarted/details/31/). Annual gridded population data for the period 2006-2100 for the different SSPs (1-5) is based on the population projections described in [Jones & O’Neill (2016)](http://doi.org/10.1088/1748-9326/11/8/084003). Source: [ISIMIP2b](https://www.isimip.org/gettingstarted/details/62/) annual values linearly interpolated from the original decadal population data.

## Acronyms 

AR6: Sixth Assessment Report \
CMIP: Coupled Model Intercomparison Project \
CO2: Carbon dioxide \
CORDEX: Coordinated Regional Climate Downscaling Experiment \
ECMWF: European Centre for Medium-Range Weather Forecasts \
ERA5: ECMWF Re-Analysis the fifth generation \
ERF: Effective Radiative Forcing \
ES-DOC: Earth System Documentation \
ESGF: Earth System Grid Federation \
HYDE3.2: History Database of the Global Environment, version 3.2 \
input4MIPs: Input Datasets for Model Intercomparison Projects \
IPCC: Intergovernmental Panel on Climate Change \
ISIMIP:  Inter-Sectoral Impact Model Intercomparison Project \
PM2.5: Particulate Matter \
PMIP: Palaeoclimate Modelling Intercomparison Project \
ScenarioMIP: Scenario Model Intercomparison \
SSPs: Shared Socioeconomic Pathways \
W5E5: WFDE5 over land merged with ERA5 over the ocean \
WATCH: Water and Global Change \
WCRP: World Climate Research Programme \
WFDE5: WATCH Forcing Data methodology applied to ERA5 reanalysis data \
WGI: Working Group I 
