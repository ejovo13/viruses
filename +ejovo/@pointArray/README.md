# Point Arrays

Point Arrays are icosahedral structures that extend symmetry along the radial level. This class is based on the point arrays that Dr. Dave Wilson at Kalamazoo College uses in his analysis of virus stability. For more information, check out his publication: [Unveiling the Hidden Rules of Spherical Viruses Using Point Arrays](https://www.mdpi.com/1999-4915/12/4/467)

| Icosadocdecahedron base translated along 3-fold symmetry axis | Icosadodecahedron base translated along 5-fold symmetry axis  | Dodecahedron base translated along 5-fold symmetry axis|
| --- | --- | --- |
| ![](../media/2phi_IDD3.png) | ![](../media/2phi_IDD5.png) | ![](../media/phi_phi_DOD5.png) |

## @pointArray

The point array class is a MATLAB implementation to model these structures. We can classify each array, combine arrays, and decompose them by their radii to examine radial symmetry. Take for example the 2phi IDD5 point array (middle column) that was build in MATLAB, and then exported to vmd for viewing:
| 3-d view | rotated about X-axis | rotated about y-axis | rotated about z-axis |
| --- | --- | --- |
| ![](../media/p1.png) | ![](../media/p1x.gif) | ![](../media/p1y.gif) | ![](../media/p1z.gif) |

