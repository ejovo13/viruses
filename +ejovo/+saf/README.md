# SAF PACKAGE

The +saf package includes functions that are used to build the Symmetry Adapted Functions (SAFs), which are icosahedrally symmetric linear combinations of Laplacian spherical harmonics. The exact combination of spherical harmonics to yield icosahedral SAFs is outlined in the paper: [A Recursive Algorithm for the Generation of Symmetry-Adapted Functions: Principles and Applications to the Icosahedral Group](http://scripts.iucr.org/cgi-bin/paper?S0108767395012578)

Let's explore this package by checking out SAF6. According to the algorithm outlined in the above paper, SAF6 con be constructed by the following linear combination:
![](../media/saf6_formula.png)
Where Y is the Laplacian spherical harmonic, the subscript is the degree, and the exponent is the order. This will be encoded as Y(l, m), where l = degree and m = order.

| Y(6, 0) | Y(6, +5) | Y(6 -5) | SAF6 |
| --- | --- | --- | --- |
| ![](../media/y60.png) |![](../media/y65.png) | ![](../media/y6_5.png) | ![](../media/saf6_animation.gif) |

