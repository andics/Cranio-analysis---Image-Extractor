# Cranio-analysis---Image-Extractor

## Purpose
The goal of this project is to allow radiologists to extract images of a volumetric skull CT scan at any point of the skull's surface, with an incline that is perpendicular to the surface of the skull at that point.
For example, consider this triangulation of a skull CT scan;
![image](https://github.com/andics/Cranio-analysis---Image-Extractor/assets/10964540/29880463-f610-4a0a-8607-c0d5f518f2c8)

The points marked in blue are points of interest, where we would like to extract a cross-sectional slice at an incline that is perpendicular to the skull's surface. 
The main advantage of this algorithm is that it allows one to define *lines* of interest on the surface, where then the algorithm will
automatically extract *n* evenly spaced images along the lines, at precisely the desired perpendicular incline. In the context of generating _suture_ slices, this is one generated by the algorithm:
| ![image](https://github.com/andics/Cranio-analysis---Image-Extractor/assets/10964540/79668b6a-483b-4cb2-97c2-01726aa78650) | 
|:--:| 
| *Cross-sectional suture image generated by the algorithm* |


For those curious, this was implemented as part of a larger project with a final goal of estimating Age-At-Death based on skull CT scans, presented by Andrey Gizdov at
the European Union Contest for Young Scientists (EUCYS) 2019. Full _documentation_ is available under [Documentation.pdf](https://github.com/andics/Cranio-analysis---Image-Extractor/Documentation.pdf)

## Usage
For usage instructions, please refer to the _documentation_ and the _run.txt_ file.
