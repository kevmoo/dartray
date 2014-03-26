const String SCENE = """
Sampler "bestcandidate" 
  "integer pixelsamples" [4]

PixelFilter "mitchell"

Accelerator "grid"

LookAt 2 4 -6   0 0 0   0 1 0

Camera "perspective"
  "float fov" [45]

#SurfaceIntegrator "whitted"
# "integer maxdepth" [5]

WorldBegin

# ----------
# Shapes
# ----------
AttributeBegin # large white disk
  Rotate 90 1 0 0
  Material "matte" "color Kd" [1 1 1]
  Shape "disk" "float height" [1] "float radius" [6]  
AttributeEnd

AttributeBegin # black sphere
  Translate 0 0 0
  Material "matte" "color Kd" [0 0 0]
  Shape "sphere"  
AttributeEnd

AttributeBegin # white sphere
  Rotate -40 1 0 -1
  Rotate -110 1 0 0
  Material "matte" "color Kd" [1 1 1]
  Shape "sphere" "float radius" [1.1] "float zmax" [1.0]
AttributeEnd

AttributeBegin # light blue sphere
  Rotate -40 1 0 -1
  Rotate -110 1 0 0
  Translate 0 0 -0.01
  Material "matte" "color Kd" [0.5 0.6 1]
  Shape "sphere" "float radius" [1.1] "float zmin" [1.0] "float zmax" [1.09]
AttributeEnd

# ----------
# Lights
# ----------
AttributeBegin
  LightSource "distant" "color L" [1 1 1]  "color scale" [3 3 3]
  "point from" [-100 100 -100] "point to" [0 0 0]
AttributeEnd
AttributeBegin
  LightSource "infinite" "color L" [0.9 0.9 1]  "color scale" [0.05 0.05 0.05]
AttributeEnd

WorldEnd
""";