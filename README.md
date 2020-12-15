# tutorial_11ax_spatial_reuse

### Authors
* [Francesc Wilhelmi](https://fwilhelmi.github.io/)
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)
* [Cristina Cano](http://www.dtic.upf.edu/~bbellalt/)
* [Ioannis Selinis](https://scholar.google.es/citations?user=BUJyJywAAAAJ&hl=ca)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/)

### Abstract
Dealing with massively crowded scenarios is one of the most ambitious goals of next-generation wireless networks. With this goal in mind, the IEEE 802.11ax amendment includes, among other techniques, the Spatial Reuse (SR) operation. The SR operation encompasses a set of unprecedented techniques {that are expected to significantly boost Wireless Local Area Networks (WLANs) performance in dense environments}. In particular, the main objective of the SR operation is to maximize the utilization of the medium by increasing the number of parallel transmissions. Nevertheless, due to the novelty of the operation, its performance gains remain largely unknown. In this paper, we first provide a gentle tutorial of the SR operation included in the IEEE 802.11ax. Then, we analytically model SR and delve into the new kinds of MAC-level interactions among network devices. Finally, we provide a simulation-driven analysis to showcase the potential of SR in various deployments, comprising different network densities and traffic loads. Our results show that the SR operation can significantly improve the medium utilization, especially in scenarios under high interference conditions. Moreover, our results demonstrate the non-intrusive design characteristic of SR, which allows enhancing the number of simultaneous transmissions with a low impact on the environment. We conclude the paper by giving some thoughts on the main challenges and limitations of the IEEE 802.11ax SR operation, including research gaps and future directions.

### Repository description
This repository contains the LaTeX files and other complementary material used for the journal article "Spatial Reuse in IEEE 802.11ax WLANs", which has been submitted to Elsevier's "Computer Communications" journal. 

The inputs used and the outputs obtained for/from this work can be found in [Zenodo](https://zenodo.org/record/3274708#.XSSaX5MzZTY)

All the results have been obtained from release v3.0 of the Komondor simulator ([https://github.com/wn-upf/Komondor/releases/tag/v3.0](https://github.com/wn-upf/Komondor/releases/tag/v3.0)). In addition, the SFCTMN framework was adapted to implement the SR operation. The source code used can be found at [https://github.com/sergiobarra/SFCTMN/releases/tag/v1.0_11ax_SR](https://github.com/sergiobarra/SFCTMN/releases/tag/v1.0_11ax_SR).

### Acknowledgements
This  work  has  been  partially  supported  by  the  Spanish Ministry of Economy and Competitiveness under the Maria de Maeztu  Units  of  Excellence  Programme  (MDM-2015-0502), by PGC2018-099959-B-100 (MCIU/AEI/FEDER,UE), by the Catalan Government under SGR grant for research support (2017-SGR-11888), by SPOTS project (RTI2018-095438-A-I00) funded by the Spanish Ministry of Science, Innovation and Universities, and  by a Gift from the Cisco University Research Program (CG\#890107, Towards Deterministic Channel Access in High-Density WLANs) Fund, a corporate advised fund of Silicon Valley Community Foundation.

### Contribute

If you want to contribute, please contact to [francisco.wilhelmi@upf.edu](francisco.wilhelmi@upf.edu)
