R package that wraps the [MCC algorithm](https://sourceforge.net/projects/mcclidar/) for Airborne LiDAR ground filtering based on Multiscale Curvature Classification. It is made to work along with the [lidR](https://github.com/Jean-Romain/lidR) package.

## Example using lidR

```r
library(lidR)

mcc <- function(s = 1.5, t = 0.3)
{
  f = function(las, filter)
  {
    lidR:::assert_is_valid_context(lidR:::LIDRCONTEXTGND, "mcc")
    cloud <- las@data
    if (length(filter) > 1) cloud <- las@data[filter, .(X,Y,Z)]
    idx <- RMCC::MCC(cloud, s, t)
    return(idx)
  }
  
  class(f) <- lidR:::LIDRALGORITHMGND
  return(f)
}

library(lidR)

file <- system.file("extdata", "Topography.laz", package="lidR")
las  <- readLAS(file, select = "xyz")
las  <- classify_ground(las, mcc())
plot(las, color = "Classification")
```

## Reference

Evans, Jeffrey S.; Hudak, Andrew T. 2007. A multiscale curvature algorithm for classifying discrete return LiDAR in forested environments. Geoscience and Remote Sensing. 45(4): 1029-1038.
