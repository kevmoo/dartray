part of lights;

class GoniometricLight extends Light {
  static GoniometricLight Create(Transform light2world, ParamSet paramSet) {
    Spectrum I = paramSet.findOneSpectrum('I', new Spectrum(1.0));
    Spectrum sc = paramSet.findOneSpectrum('scale', new Spectrum(1.0));
    String texname = paramSet.findOneFilename('mapname', '');
    return new GoniometricLight(light2world, I * sc, texname);
  }

  GoniometricLight(Transform light2world, this.intensity, String texname) :
    super(light2world) {
    lightPos = lightToWorld.transformPoint(new Point(0.0, 0.0, 0.0));

    if (texname.isNotEmpty) {
      Completer completer = new Completer();
      ResourceManager.RequestImage(texname, completer.future)
        .then((SpectrumImage img) {
          mipmap = new MIPMap.texture(img);
          completer.complete();
        });
    }
  }

  Spectrum sampleLAtPoint(Point p, double pEpsilon, LightSample ls,
                          double time, Vector wi, List<double> pdf,
                          VisibilityTester visibility) {
    wi.copy(Vector.Normalize(lightPos - p));
    pdf[0] = 1.0;
    visibility.setSegment(p, pEpsilon, lightPos, 0.0, time);
    return intensity * scale(-wi) / Vector.DistanceSquared(lightPos, p);
  }

  bool isDeltaLight() {
    return true;
  }

  Spectrum scale(Vector w) {
    Vector wp = Vector.Normalize(worldToLight.transformVector(w));

    double tmp = wp.y;
    wp.y = wp.z;
    wp.z = tmp;

    double theta = Vector.SphericalTheta(wp);
    double phi   = Vector.SphericalPhi(wp);
    double s = phi * INV_TWOPI;
    double t = theta * INV_PI;

    return (mipmap == null) ? 1.0 :
        new Spectrum.from(mipmap.lookup(s, t), Spectrum.SPECTRUM_ILLUMINANT);
  }

  Spectrum power(Scene scene) {
    return intensity * (4.0 * Math.PI) *
            new Spectrum.from(mipmap != null ?
                              mipmap.lookup(0.5, 0.5, 0.5) :
                              new Spectrum(1.0), Spectrum.SPECTRUM_ILLUMINANT);
  }

  Spectrum sampleL(Scene scene, LightSample ls, double u1, double u2,
                   double time, Ray ray, Normal Ns, List<double> pdf) {
    ray.set(lightPos, UniformSampleSphere(ls.uPos[0], ls.uPos[1]), 0.0,
            INFINITY, time);

    Ns.copy(ray.direction);
    pdf[0] = UniformSpherePdf();

    return intensity * scale(ray.direction);
  }

  double pdf(Point p, Vector w) {
    return 0.0;
  }

  Point lightPos;
  Spectrum intensity;
  MIPMap mipmap;
}