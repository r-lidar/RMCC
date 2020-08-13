#' Airborne LiDAR filtering method based on Multiscale Curvature Classification
#'
#' Airborne LiDAR filtering method of ground points based on Multiscale Curvature
#' Classification (Evans and Hudak, 2017; see references). This function is an R
#' wrapper around the library written by the original authors of the algorithm.
#'
#' There are two parameters that the user must define in the command line syntax
#' to run MCC, the scale (s) parameter and the curvature threshold (t). The optimal
#' scale parameter is a function of 1) the scale of the objects (e.g., trees) on
#' the ground, and 2) the sampling interval (post spacing) of the lidar data.
#' Current lidar sensors are capable of collecting high density data (e.g., 8 pulses/m2)
#' that translate to a spatial sampling frequency (post spacing) of 0.35 m/pulse
#'  (1/sqrt(8 pulses/m2) = 0.35 m/pulse), which is small relative to the size of
#'  mature trees and will oversample larger trees (i.e., nominally multiple returns/tree).
#'  Sparser lidar data (e.g., 0.25 pulses/m2) translate to a post spacing of 2.0 m/pulse
#'  (1/sqrt(0.25 pulses/m2) = 2.0 m/pulse), which would undersample trees and fail
#'  to sample some smaller trees (i.e., nominally <1 return/tree).\cr\cr
#' Therefore, a bit of trial and error is warranted to determine the best scale
#' and curvature parameters to use. Select a las tile containing a good variety
#' of canopy and terrain conditions, as it's likely the parameters that work best
#' there will be applicable to the rest of your project area tiles. As a starting
#' point: if the scale (post spacing) of the lidar survey is 1.5 m, then try 1.5.
#' Try varying it up or down by 0.5 m increments to see if it produces a more desirable
#' digital terrain model (DTM) interpolated from the classified ground returns in
#' the output file. Use units that match the units of the lidar data. For example,
#' if your lidar data were delivered in units of feet with a post spacing of 3 ft,
#' set the scale parameter to 3, then try varying it up or down by 1 ft increments
#' and compare the resulting interpolated DTMs. If the trees are large, then
#' it's likely that a scale parameter of 1 m (3 ft) will produce a cleaner DTM
#' than a scale parameter of 0.3 m (1 ft), even if the pulse density is 0.3 m
#' (1 ft). As for the curvature threshold, a good starting value to try might be
#' 0.3 (if data are in meters; 1 if data are in feet), and then try varying this
#' up or down by 0.1 m increments (if data are in meters; 0.3 if data are in feet).
#'
#' @param cloud data.frame with 3 columns named X Y, Z containing the coordinates
#' of the point cloud.
#' @param s numeric. Scale parameter. The optimal scale parameter is a function of
#' 1) the scale of the objects (e.g., trees) on the ground, and 2) the sampling
#' interval (post spacing) of the lidar data.
#' @param t numeric. Curvature threshold
#' and non-ground. The default is 0.5.
#'
#' @return An integer vector containing the ids of the points that belong on the ground.
#'
#' @references Evans, Jeffrey S.; Hudak, Andrew T. 2007. A multiscale curvature
#' algorithm for classifying discrete return LiDAR in forested environments.
#' Geoscience and Remote Sensing. 45(4): 1029-1038.
#' @export
#' @useDynLib RMCC
#' @importFrom Rcpp sourceCpp
MCC <- function(cloud, s = 1.5, t = 0.3)
{
  if(!is.numeric(s))
    stop("'scaleDomain2Spacing' must be numeric")

  if(s <= 0)
    stop("'scaleDomain2Spacing' must be a number larger than 0")

  if(!is.numeric(t))
    stop("'curvatureThreshold' must be numeric")

  if(t <= 0)
    stop("'curvatureThreshold' must be a number larger than 0")

  stopifnot(is.data.frame(cloud))
  stopifnot(all(c("X", "Y", "Z") %in% names(cloud)))
  R_MCC(cloud, s, t)
}