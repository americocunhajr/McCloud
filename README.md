<img src="logo/McCloud.png" width="20%">

**McCloud: Monte Carlo Cloud Service Framework** is a powerful framework providing a generic implementation of the Monte Carlo method on Microsoft Windows Azure. It is designed to solve a wide range of scientific and engineering problems efficiently in the cloud.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Usage](#usage)
- [Authors](#authors)
- [Citing McCloud](#citing-mccloud)
- [Institutional Support](#institutional-support)
- [Funding](#funding)

## Overview
McCloud was developed as part of the following master's thesis:
- **R. Nasser**, *McCloud service framework: development services of Monte Carlo simulation in the cloud*, M.Sc. Dissertation, Pontifícia Universidade Católica do Rio de Janeiro, Rio de Janeiro, 2012 (in Portuguese).

The original code and documentation are available on the Codeplex repository:
[McCloud Codeplex Repository](http://mccloud.codeplex.com)

This GitHub repository includes codes and results from a benchmark Monte Carlo simulation on a structural system, detailed in the following paper:
- **A. Cunha Jr, R. Nasser, R. Sampaio, H. Lopes, and K. Breitman**, *Uncertainty quantification through Monte Carlo method in a cloud computing setting*, Computer Physics Communications, 185, pp. 1355-1363, 2014. [DOI](http://dx.doi.org/10.1016/j.cpc.2014.01.006)

## Features
- Generic Monte Carlo service implementation
- Cloud-based computation using Microsoft Windows Azure
- Scalable and efficient solution for scientific and engineering simulations
- Extensive documentation and examples

## Usage
To get started with McCloud, follow these steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/americocunhajr/McCloud.git
   ```
2. Navigate to the code directory:
   ```bash
   cd McCloud/McCloud
   ```
3. Execute:
   ```bash
   McCloudProcess('3','0','case1a','case1a_process.csv')
   McCloudMerge('3','case1a','case1a_process.csv','case1a_merge.csv')
   sed -e "s/'//g" case1a_merge.csv > case1a_post.dat
   McCloudPost('3','case1a','case1a_post.dat')
   ```

## Authors
- Americo Cunha
- Rafael Nasser
- Rubens Sampaio
- Hélio Lopes
- Karin Breitman

## Citing McCloud

If you use **McCloud** in your research, please cite the following publications:
- *A. Cunha Jr, R. Nasser, R. Sampaio, H. Lopes, and K. Breitman, Uncertainty quantification through Monte Carlo method in a cloud computing setting, Computer Physics Communications, v. 185, pp. 1355-1363, 2014 http://dx.doi.org/10.1016/j.cpc.2014.01.006*
- *R. Nasser, McCloud service framework: development services of Monte Carlo simulation in the cloud, M.Sc. Dissertation, Pontifícia Universidade Católica do
Rio de Janeiro, Rio de Janeiro, 2012 (in Portuguese)*

```
@article{CunhaJr2014p1355,
  author  = {A. {Cunha~Jr} and R. Nasser and R. Sampaio and H. Lopes and K. Breitman},
  title   = {Uncertainty quantification through {M}onte {C}arlo method in a cloud computing setting},
  journal = {Computer Physics Communications},
  year    = {2014},
  volume  = {185},
  pages   = {1355-1363},
  doi     = {http://dx.doi.org/10.1016/j.cpc.2014.01.006},
}
```

```
@mastersthesis{Nasser2012,
  author  = {R. Nasser},
  title   = { {McCloud} service framework: development services of {M}onte {C}arlo simulation in the cloud},
  school  = {Pontifícia Universidade Católica do Rio de Janeiro},
  year    = {2012},
  address = {Rio de Janeiro},
  note    = {(in Portuguese)},
}
```

## Institutional support

<img src="logo/logo_pucrio_color.jpg" width="07%">

## Funding

<img src="logo/faperj.jpg" width="20%"> &nbsp; &nbsp; <img src="logo/cnpq.png" width="20%"> &nbsp; &nbsp; <img src="logo/capes.png" width="10%"> &nbsp; <img src="logo/MS_Azure.jpg" width="20%">
