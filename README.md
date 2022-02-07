R package that wraps the [MCC algorithm](https://sourceforge.net/projects/mcclidar/) for Airborne LiDAR ground filtering based on Multiscale Curvature Classification. It is made to work along with the [lidRplugins](https://github.com/Jean-Romain/lidRplugins) package.

## Example

```r
library(lidRplugins)
file <- system.file("extdata", "Topography.laz", package="lidR")
las  <- readLAS(file, select = "xyz")
las  <- classify_ground(las, mcc())
plot(las, color = "Classification")
```

## Reference

Evans, Jeffrey S.; Hudak, Andrew T. 2007. A multiscale curvature algorithm for classifying discrete return LiDAR in forested environments. IEEE Transactions on Geoscience and Remote Sensing. 45(4): 1029-1038.
