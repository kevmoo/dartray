/****************************************************************************
 *  Copyright (C) 2014 by Brendan Duncan.                                   *
 *                                                                          *
 *  This file is part of DartRay.                                           *
 *                                                                          *
 *  Licensed under the Apache License, Version 2.0 (the "License");         *
 *  you may not use this file except in compliance with the License.        *
 *  You may obtain a copy of the License at                                 *
 *                                                                          *
 *  http://www.apache.org/licenses/LICENSE-2.0                              *
 *                                                                          *
 *  Unless required by applicable law or agreed to in writing, software     *
 *  distributed under the License is distributed on an "AS IS" BASIS,       *
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.*
 *  See the License for the specific language governing permissions and     *
 *  limitations under the License.                                          *
 *                                                                          *
 *   This project is based on PBRT v2 ; see http://www.pbrt.org             *
 *   pbrt2 source code Copyright(c) 1998-2010 Matt Pharr and Greg Humphreys.*
 ****************************************************************************/
part of core;

/**
 * Determines the points on the film plane for tracing rays.
 */
abstract class Sampler {
  /// [FULL_SAMPLING] will generate all samples for a pixel before moving on
  /// to the next pixel. Used by [RenderOverrides.samplingMode].
  static const int FULL_SAMPLING = 0;
  /// [TWO_PASS_SAMPLING] will generate a single sample for every pixel, and
  /// then come back and do the rest of the samples on the second pass. This
  /// will allow the initial image to be displayed more quickly.
  /// Used by [RenderOverrides.samplingMode].
  static const int TWO_PASS_SAMPLING = 1;
  /// [ITERATIVE_SAMPLING] will generate a single sample for every pixel for
  /// each pass, until the [samplesPerPixel] has been reached. This will more
  /// gradually refine the image. Used by [RenderOverrides.samplingMode].
  static const int ITERATIVE_SAMPLING = 2;

  int left;
  int top;
  int width;
  int height;
  double shutterOpen;
  double shutterClose;
  /// How many samples should be generated for each pixel.
  int samplesPerPixel;

  Sampler(this.left, this.top, this.width, this.height, this.shutterOpen,
          this.shutterClose, this.samplesPerPixel);

  int get right => left + width - 1;

  int get bottom => top + height - 1;

  int getMoreSamples(List<Sample> sample, RNG rng);

  int maximumSampleCount();

  bool reportResults(List<Sample> samples, List<RayDifferential> rays,
                     List<Spectrum> Ls, List<Intersection> isects,
                     int count) {
    return true;
  }

  int roundSize(int size);

  static void ComputeSubWindow(int w, int h, int num, int count,
                               List<int> extents) {
    // Determine how many tiles to use in each dimension, nx and ny
    int nx = count;
    int ny = 1;
    while ((nx & 0x1) == 0 && 2 * w * ny < h * nx) {
      nx >>= 1;
      ny <<= 1;
    }
    assert(nx * ny == count);

    // Compute x and y pixel sample range for sub-window
    int xo = num % nx;
    int yo = num ~/ nx;
    double tx0 = xo / nx;
    double tx1 = (xo + 1) / nx;
    double ty0 = yo / ny;
    double ty1 = (yo + 1) / ny;
    extents[0] = Lerp(tx0, 0, w).floor();
    extents[1] = Math.min(Lerp(tx1, 0, w).floor(), w - 1);
    extents[2] = Lerp(ty0, 0, h).floor();
    extents[3] = Math.min(Lerp(ty1, 0, h).floor(), h - 1);
  }
}

