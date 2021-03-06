/****************************************************************************
 * Copyright (C) 2014 by Brendan Duncan.                                    *
 *                                                                          *
 * This file is part of DartRay.                                            *
 *                                                                          *
 * Licensed under the Apache License, Version 2.0 (the "License");          *
 * you may not use this file except in compliance with the License.         *
 * You may obtain a copy of the License at                                  *
 *                                                                          *
 * http://www.apache.org/licenses/LICENSE-2.0                               *
 *                                                                          *
 * Unless required by applicable law or agreed to in writing, software      *
 * distributed under the License is distributed on an "AS IS" BASIS,        *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
 * See the License for the specific language governing permissions and      *
 * limitations under the License.                                           *
 *                                                                          *
 * This project is based on PBRT v2 ; see http://www.pbrt.org               *
 * pbrt2 source code Copyright(c) 1998-2010 Matt Pharr and Greg Humphreys.  *
 ****************************************************************************/
part of core;

Point BRDFRemap(Vector wo, Vector wi) {
  double cosi = Vector.CosTheta(wi);
  double coso = Vector.CosTheta(wo);
  double sini = Vector.SinTheta(wi);
  double sino = Vector.SinTheta(wo);
  double phii = Vector.SphericalPhi(wi);
  double phio = Vector.SphericalPhi(wo);
  double dphi = phii - phio;

  if (dphi < 0.0) {
    dphi += 2.0 * Math.PI;
  }

  if (dphi > 2.0 * Math.PI) {
    dphi -= 2.0 * Math.PI;
  }

  if (dphi > Math.PI) {
    dphi = 2.0 * Math.PI - dphi;
  }

  return new Point(sini * sino, dphi / Math.PI, cosi * coso);
}
