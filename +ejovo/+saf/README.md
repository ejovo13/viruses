# SAF PACKAGE

The +saf package includes functions that are used to build the Symmetry Adapted Functions (SAFs), which are icosahedrally symmetric linear combinations of Laplacian spherical harmonics. The exact combination of spherical harmonics to yield icosahedral SAFs is outlined in the paper: [A Recursive Algorithm for the Generation of Symmetry-Adapted Functions: Principles and Applications to the Icosahedral Group](http://scripts.iucr.org/cgi-bin/paper?S0108767395012578)

Let's explore this package by checking out SAF6. According to the algorithm outlined in the above paper, SAF6 con be constructed by the following linear combination:

![](../media/saf6_formula.png)

Where Y is the Laplacian spherical harmonic, the subscript is the degree, and the exponent is the order. 

| Linear Combination |  SAF6 |
| --- | --- |
|![](../media/spherical_combination.png)  | ![](../media/saf6_animation.gif) |

We can make these plots using the functions contained in the SAF package.

```MATLAB
l = 1; % Degree
m = 0; % Order

ejovo.saf.plotRealHarmonic(l, m); % Plot real spherical harmonic with degree = 1 and order = 0
ejovo.saf.plotHarmonic(l, m); % Plot the real and imaginary values of spherical harmonic with degree = 1 and order = 0

ejovo.saf.plotSAF(6); % Plot SAF made from linear combination of spherical harmonics of degree 6
ejovo.saf.animateSAF(6); % Animate the linear combination for SAF6

```

Here is a table that contains all the SAFs included in this package. Icosahedral symmetry demands the presence of symmetry axes of degree 5, 3, and 2.

| Degree | 5-fold | 3-fold | 2-fold | SAF |
| :---: | --- | --- | --- | --- |
| 6 | ![](../media/safs/saf6_5.png) | ![](../media/safs/saf6_3.png) | ![](../media/safs/saf6_2.png) | ![](../media/saf6_animation.gif) |
| 10 | ![](../media/safs/saf10_5.png) | ![](../media/safs/saf10_3.png) | ![](../media/safs/saf10_2.png) | ![](../media/safs/saf10.gif) |
| 12 | ![](../media/safs/saf12_5.png) | ![](../media/safs/saf12_3.png) | ![](../media/safs/saf12_2.png) | ![](../media/safs/saf12.gif) |
| 16 | ![](../media/safs/saf16_5.png) | ![](../media/safs/saf16_3.png) | ![](../media/safs/saf16_2.png) | ![](../media/safs/saf16.gif) |
| 18 | ![](../media/safs/saf18_5.png) | ![](../media/safs/saf18_3.png) | ![](../media/safs/saf18_2.png) | ![](../media/safs/saf18.gif) |
| 20 | ![](../media/safs/saf20_5.png) | ![](../media/safs/saf20_3.png) | ![](../media/safs/saf20_2.png) | ![](../media/safs/saf20.gif) |
| 22 | ![](../media/safs/saf22_5.png) | ![](../media/safs/saf22_3.png) | ![](../media/safs/saf22_2.png) | ![](../media/safs/saf22.gif) |
| 24 | ![](../media/safs/saf24_5.png) | ![](../media/safs/saf24_3.png) | ![](../media/safs/saf24_2.png) | ![](../media/safs/saf24.gif) |
| 26 | ![](../media/safs/saf26_5.png) | ![](../media/safs/saf26_3.png) | ![](../media/safs/saf26_2.png) | ![](../media/safs/saf26.gif) |
| 28 | ![](../media/safs/saf28_5.png) | ![](../media/safs/saf28_3.png) | ![](../media/safs/saf28_2.png) | ![](../media/safs/saf28.gif) |
| 30 | ![](../media/safs/saf30_5.png) | ![](../media/safs/saf30_3.png) | ![](../media/safs/saf30_2.png) | ![](../media/safs/saf30.gif) |

plots were made using the "jet" colormap, such that high positive values correspond to red and the most negative values are represented by dark blue.

### Alternative Representation.

We can further elucidate the symmetry of these structures by coloring the radial output of each SAF on the surface of a sphere.

I've introduced a new saf class which allows me to better manipulate the addition of SAFs.
To instantiate an SAF object, simply pass the degree that you would like for the argument:

```MATLAB
s6 = ejovo.v.saf(6); % Create new SAF with degree 6.
s10 = ejovo.v.saf(10);
s12 = ejovo.v.saf(12);
s26 = ejovo.v.saf(26);
```

We can plot these SAFs calling the plot member function. What's more interesting, however, is creating new SAF objects by simple combination:

```MATLAB
s_new = s6 + s12;
s_new.plot();
```

![](../media/safs/saf6_plus_12.png)

```MATLAB
s_new = s10 + s26;
s_new.plot();
```

![](../media/safs/saf10_plus_26.png)

I've also introduced a new way of visualizing the SAFs by coloring the radial component onto a surface of a sphere. To do so, we can simply call the **surf** function:

```MATLAB
surf(s10 + s26);
```

![](../media/safs/saf10_plus_26_surf.png)

```MATLAB
surf(s6 + s12);
```

![](../media/safs/saf6_plus_12_surf.png)

To visualize all of the SAFs on the surface, we can simply call the static function **surfALL**:

```MATLAB
ejovo.v.saf.surfAll();
```

![](../media/safs/all_safs_surface.png)


