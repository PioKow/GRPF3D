# Global Complex Roots and Poles Finding Algorithm in CxR Domain

##### Programming language: MATLAB

[![Version](https://img.shields.io/badge/version-1.0-green.svg)](README.md) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

---
## Program goals
The GRPF3D algorithm aims to **find the zeros and poles of the complex function in the variability of an extra parameter** in the fixed region. The proposed method combines the standard [Global Complex Roots and Poles Finding Algorithm](https://ieeexplore.ieee.org/document/8457320) ([code](https://github.com/PioKow/SAGRPF)) with the [Complex Root Tracing Routine](https://ieeexplore.ieee.org/document/7880630) ([code](https://github.com/PioKow/SACRTA)). This approach is based on the generalization of CAP to the **C×R** space, and a function of three variables **F(re(z),im(z),t)** describes the problem under examination. Therefore, it is required to use a **three-dimensional tetrahedral mesh**.

An overall class of functions can be analyzed, and any arbitrarily shaped search region can be considered. Typically, as demonstrated in the attached examples, the extra parameters can be, e.g., structure dimensions, material property, or a frequency in propagation problems, but the algorithm is not limited to computational electrodynamics. It can be used successfully for similar problems, e.g., acoustics, control theory, and quantum mechanics.

## Solution method
The function should be defined in the [fun.m](2_cylindrical_waveguide/fun.m) at the beginning of the process. Furthermore, a user in the [analysis_parameters.m](2_cylindrical_waveguide/analysis_parameters.m) sets the analyzed domain and defines the number of function calls (**maximum number of nods**), which indirectly influences the result's accuracy. The next step is to create the initial mesh. The number of initial nodes is part of the maximum number of nodes (usually, the ratio is one percent). After that, the function values at the new mesh nodes are calculated, and Delaunay triangulation is performed. The difference between the arguments of the complex function in nodes is determined for each edge. Based on where **the phase changes by more than π/2**, the candidate edges are selected that will be halved to densify the mesh. This procedure is repeated until the number of points oversteps the assumed limitation (it is possible to increase this value at the end of the analysis). In the final process, the set of the center of **suspect edges creates the curves**. These points can be visualized, and it is an approximate **representation of the zeros/poles**, constituting a solution to the problem.

## Scientific work
If the code is used in a scientific work, then **reference should be made to the following publication**:
1. S. Dziedziewicz, M. Warecka, R. Lech and P. Kowalczyk, "**Global Complex Roots and Poles Finding Algorithm in C x R Domain**,". [link]()

---
## Manual
1. **[GRPF_3D.m](GRPF_3D.m) - starts the program**
2. [analysis_parameters.m](2_cylindrical_waveguide/analysis_parameters.m) - contains all parameters of the analysis, e.g.:
    * the cuboid domain size (**xb,xe,yb,ye,tb,te**)
	* a maximum number of the function calls (**NodesMax**)
	* results visualization options (**Visual**)
	* constants for advanced users
		- automatic or manually scale the domain (**Scale**)
		- initial mesh points (**InitNodesRatio**) 
	 	- optional fun parameters (**Optional**)
	* buffers (**ItMax**, **MinEdgesLength**)
3. [fun.m](2_cylindrical_waveguide/fun.m) - definition of the function for which roots and poles will be calculated
4. **to run examples**: add folder **uncomment line 23 or 24 in the [GRPF_3D.m](GRPF_3D.m) (addpath)** in order to include the folder with (analysis_parameters.m) and (fun.m) files or copy them from the folder containing the example to the main folder and start GRPF3D program.
 
## Short description of the functions
- [GRPF_3D.m](GRPF_3D.m) - main body of the algorithm  
	- [analysis_parameters.m](3_graphene_transmission_line/analysis_parameters.m) - analysis parameters definition
	- [fun.m](3_graphene_transmission_line/fun.m) - function definition
	- [cuboid_dom.m](cuboid_dom.m) - initial mesh generator for cuboid domain
	- [dPhase.m](dPhase.m) - get the phases difference between two function values
	- [vis.m](vis.m) - results visualization, plots the curve of the roots

## Additional comments
The code involves MATLAB function [delaunayTriangulation](https://mathworks.com/help/matlab/ref/delaunaytriangulation.html) which was introduced in R2013a version. In the older versions some modifications are required and the function can be replaced by [DelaunayTri](https://mathworks.com/help/matlab/ref/delaunaytri.html), however this solution is not recommended.

## Authors
The project has been developed in **Gdansk University of Technology**, Faculty of Electronics, Telecommunications and Informatics by **Sebastian Dziedziewicz, Małgorzata Warecka, Rafał Lech, Piotr Kowalczyk** ([Department of Microwave and Antenna Engineering](https://eti.pg.edu.pl/en/kima-en)). 

Corresponding e-mail: sebastian.dziedziewicz@pg.edu.pl

## License
GRPF is an open-source Matlab code licensed under the [MIT license](LICENSE).
