# Cranio-analysis---Image-Extractor

## Purpose
The goal of this project is to allow radiologists to extract images of a volumetric skull CT scans at any point of the skull's surface, with an incline that is perpendicular to the surface of the skull at that point.
For example, consider this triangulation of a skull CT scan;
![image](https://github.com/andics/Cranio-analysis---Image-Extractor/assets/10964540/29880463-f610-4a0a-8607-c0d5f518f2c8)

The points marked in blue are points of interest, where we would like to extract a cross sectional slice at an incline that is prpendidular to the skull's surface.
The main advantage of this algorithm is that it allows to define the points of interest by only their start and end point, minimizing manual labour.

For those curious, this was implemented as part of a larger project with a final goal of estimating Age-At-Death based on skull CT scans, presented by Andrey Gizdov at
the European Union Contest for Young Scientists (EUCYS) 2019:

## Usage
The above-described task is challenging to do on typical software for CT-scan visualization. The reason is that the radiologist has to manually adjust the incline of the skull
so as to match it with the vertical and horizontal pnaes
