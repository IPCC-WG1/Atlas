## CMIP5, CMIP6 and CORDEX spatial averages over the reference regions

These files contain monthly precipitation and near surface temperature spatially averaged over the reference regions for CMIP5, CMIP6 and CORDEX datasets (a single run per model) separately for land, sea, and land-sea gridboxes. Regional averages are weighted by the cosine of latitude in all cases.

For the different CORDEX domains, aggregated results are calculated only in those regions with overlap larger than 80% (see [Overlaps-CORDEX-ReferenceRegions.csv](./data/CORDEX/Overlaps-CORDEX-ReferenceRegions.csv) for details on the overlap areas, as percentages over the total area of the reference region; regular geographic grids for every CORDEX domain are obtained from [Table 2](https://is-enes-data.github.io/cordex_archive_specifications.pdf) in the CORDEX specification archive; an annotated notebook for reproducibility is available at: [reference-regions/notebooks/reference-regions-CORDEX-overlap_Python.ipynb](../reference-regions/notebooks/reference-regions-CORDEX-overlap_Python.ipynb). The regions resulting for each domain are:

Domain | Reference regions above 80% overlap
-------|------------------------------------
NAM    | NWN, NEN, WNA, CNA, ENA, NCA, CAR
CAM    | NCA, SCA, CAR, NWS, NSA, NES, SAM
SAM    | SCA, NWS, NSA, NES, SAM, SWS, SES, SSA
ARC    | GIC, NWN, NEN, NEU, RAR, RFE, ARO
AFR    | MED, SAH, WAF, CAF, NEAF, SEAF, WSAF, ESAF, MDG, ARP
EUR    | NEU, WCE, EEU, MED
MED    | WCE, MED
MNA    | MED, SAH, WAF, CAF, NEAF, SEAF, WCA, ARP, ARS
SEA    | SEA
EAS    | ECA, TIB, EAS, SAS, SEA, NAU, BOB
WAS    | NEAF, SEAF, WCA, ECA, TIB, ARP, SAS, ARS, BOB, EIO
CAS    | EEU, WSB, ESB, WCA, ECA, TIB, EAS, ARP
ANT    | EAN, WAN
AUS    | SEA, NAU, CAU, EAU, SAU, NZ

Additionally, results for all CMIP6 model runs (*CMIP6Amon_Hub* version 20191028 in 'Atlas-inventory/Hub') are also available at the following links:

[CMIP6Amon_pr_land.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_pr_land.zip)\
[CMIP6Amon_pr_landsea.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_pr_landsea.zip)\
[CMIP6Amon_pr_sea.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_pr_sea.zip)\
[CMIP6Amon_tas_land.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_tas_land.zip)\
[CMIP6Amon_tas_landsea.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_tas_landsea.zip)\
[CMIP6Amon_tas_sea.zip](http://meteo.unican.es/work/IPCC_Atlas/regional_means/CMIP6Amon_tas_sea.zip)

