#include <Rcpp.h>
#include <boost/shared_ptr.hpp>

#include "Algorithm.h"
#include "PointVector.h"
//#include "ProgramExceptions.h"
//#include "SplineExceptions.h"
#include "SurfaceInterpolation.h"
#include "UnclassifiedPoints.h"
#include "XyExtent.h"

using namespace Rcpp;
using namespace mcc;
using boost::shared_ptr;

// [[Rcpp::export]]
IntegerVector R_MCC(DataFrame data, double scaleDomain2Spacing = 1.5, double curvatureThreshold = 0.3)
{
  CharacterVector names = data.attr("names");
  std::string x = as<std::string>(names[0]);
  std::string y = as<std::string>(names[1]);
  std::string z = as<std::string>(names[2]);

  NumericVector X = data[x];
  NumericVector Y = data[y];
  NumericVector Z = data[z];
  int n = X.size();

  shared_ptr<PointVector> points(new PointVector(n));

  for (int i = 0 ; i < n ; i++)
  {
    XyzPoint p(X[i], Y[i], Z[i]);
    (*points)[i].setCoordinates(p);
  }

  XyExtent xyExtent;
  xyExtent.maxX = max(X);
  xyExtent.minX = min(X);
  xyExtent.maxY = max(Y);
  xyExtent.minY = min(Y);

  SurfaceInterpolation surfaceInterpolation;
  surfaceInterpolation.setXyExtent(xyExtent);

  Algorithm algorithm(surfaceInterpolation, false, false);
  UnclassifiedPoints unclassifiedPoints(points);
  algorithm.classifyPoints(unclassifiedPoints, scaleDomain2Spacing, curvatureThreshold);

  std::vector<int> ground;
  for (int i = 0 ; i < n ; i++)
  {
    if (isGround((*points)[i].classification()))
      ground.push_back(i);
  }

  IntegerVector Rground(wrap(ground));
  return Rground + 1;
}