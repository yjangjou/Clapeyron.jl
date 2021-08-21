[![DOI](https://zenodo.org/badge/267659508.svg)](https://zenodo.org/badge/latestdoi/267659508)
[![Build Status](https://github.com/ypaul21/Clapeyron.jl/workflows/CI/badge.svg)](https://github.com/ypaul21/Clapeyron.jl/actions)
[![codecov](https://codecov.io/gh/ypaul21/Clapeyron.jl/branch/master/graph/badge.svg?token=ZVGGR4AAFB)](https://codecov.io/gh/ypaul21/Clapeyron.jl)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ypaul21.github.io/Clapeyron.jl/dev)

![Clapeyron_logo](docs/Clapeyron_logo.svg)

Welcome to Clapeyron! This module provides both a large library of equations of state and a framework for one to easily implement their own equations of state.

We have recently presented at the JuliaCon 2021 conference! Feel free to take a look at our talk:

[![Clapeyron.jl: An Extensible Implementation of Equations of State | Paul Yew et al | JuliaCon2021](https://img.youtube.com/vi/Re5qI-9zyIM/0.jpg)](https://www.youtube.com/watch?v=Re5qI-9zyIM "Clapeyron.jl: An Extensible Implementation of Equations of State | Paul Yew et al | JuliaCon2021")

SAFT equations of state currently available:

| EoS           | Seg./Mono.?        | Chain?             | Assoc.?            | Parameters?        |
| ------------- | ------------------ | ------------------ | ------------------ | ------------------ |
| SAFT          | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| CK-SAFT       | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| sSAFT         | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark:  |                    |
| LJ-SAFT       | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |                    |
| BACK-SAFT     | :heavy_check_mark: | :heavy_check_mark: | N/A                   |                    |
| PC-SAFT       | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| sPC-SAFT      | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| SAFT-VR SW    | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| soft-SAFT     | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| SAFT-VR Mie   | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| SAFT-VRQ Mie  | :heavy_check_mark: | N/A                | N/A                | :heavy_check_mark: |

For group contribution approaches, we provide:

| EoS          | Seg./Mono.?        | Chain?             | Assoc.?            | Parameters?        |
| ------------ | ------------------ | ------------------ | ------------------ | ------------------ |
| sPC-SAFT     |                    |                    |                    |                    |
| SAFT-*ɣ* SW  |                    |                    |                    |                    |
| SAFT-*ɣ* Mie | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |

We also provide some engineering cubic equations of state for comparison:

| EoS                    | Available?         | Parameters?        |
| ---------------------- | ------------------ | ------------------ |
| van der Waals          | :heavy_check_mark: | :heavy_check_mark: |
| Redlich-Kwong          | :heavy_check_mark: | :heavy_check_mark: |
| Soave-Redlich-Kwong    | :heavy_check_mark: | :heavy_check_mark: |
| Peng-Robinson          | :heavy_check_mark: | :heavy_check_mark: |
| Cubic-Plus-Association | :heavy_check_mark: | :heavy_check_mark: |

We also provide some Multi-parameter equations of state:

| EoS        | Available?         |
| ---------- | ------------------ |
| IAWPS-95   | :heavy_check_mark: |
| GERG-2008  | :heavy_check_mark: |
| PropaneRef | :heavy_check_mark: |
| SPUNG      | :heavy_check_mark: |

To provide the ideal contribution to any of the above equations of state, we have a few different options:

| Ideal term            | Available?         | Parameters?        |
| --------------------- | ------------------ | ------------------ |
| Monomer               | :heavy_check_mark: | :heavy_check_mark: |
| Reid                  | :heavy_check_mark: |                    |
| Walker                | :heavy_check_mark: | :heavy_check_mark: |
| Wilhoit               |                    |                    |
| NASA                  |                    |                    |
| Joback                |                    |                    |
| Constantinou and Gani |                    |                    |
| Coniglio              |                    |                    |

Properties available:

- Bulk, single-phase properties:

| Property                     | Available?         |
| ---------------------------- | ------------------ |
| Volume                       | :heavy_check_mark: |
| Pressure                     | :heavy_check_mark: |
| Entropy                      | :heavy_check_mark: |
| Internal Energy              | :heavy_check_mark: |
| Enthalpy                     | :heavy_check_mark: |
| Gibbs free energy            | :heavy_check_mark: |
| Helmholtz free energy        | :heavy_check_mark: |
| Isochoric heat capacity      | :heavy_check_mark: |
| Isobaric heat capacity       | :heavy_check_mark: |
| Isentropic compressibility   | :heavy_check_mark: |
| Isothermal compressibility   | :heavy_check_mark: |
| Isobaric (cubic) expansivity | :heavy_check_mark: |
| Speed of sound               | :heavy_check_mark: |
| Joule-Thomson coefficient    | :heavy_check_mark: |
| Phase Identification Parameter (pip)    | :heavy_check_mark: |
- Two-phase properties:

| Property                  | Available?         |
| ------------------------- | ------------------ |
| Saturation pressure       | :heavy_check_mark: |
| Saturation temperature    | :heavy_check_mark: |
| Bubble pressure           |                    |
| Dew pressure              |                    |
| Bubble temperature        |                    |
| Dew temperature           |                    |
| Enthalpy of vapourisation | :heavy_check_mark: |

- Critical properties (pure components only):

| Property             | Available?         |
| :------------------- | ------------------ |
| Critical temperature | :heavy_check_mark: |
| Critical pressure    | :heavy_check_mark: |
| Critical volume      | :heavy_check_mark: |

We will also provide Tp-flash algorithms (Rachford-Rice and HELD alogrithm).

Note that at its current stage, Clapeyron is still in the very early stages of development, and things may be moving around or changing rapidly, but we are very excited to see where this project may go!

# Installing Clapeyron

To install Clapeyron, launch Julia with

```julia
> julia
```

Hit the ```]``` key to enter Pkg mode, then type

```julia
Pkg> add Clapeyron
```
Or to add the development version:
```julia
Pkg> add https://github.com/ypaul21/Clapeyron.jl#development
```
Exit Pkg mode by hitting backspace.

Now you may begin using functions from the Clapeyron library by entering the command

```
using Clapeyron
```

To remove the package, hit the ```]``` key to enter Pkg mode, then type

```julia
Pkg> rm Clapeyron
```