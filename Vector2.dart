class Vector2 {
  //Float32Array dest;
  Float32Array dest;
  
  Vector2(double x, double y) {
    dest = new Float32Array(2);
    dest[0] = x;
    dest[1] = y;
  }
  
  
  double get X() => dest[0];
  void set X(double x) { dest[0] = x; }
  
  double get Y() => dest[1];
  void set Y(double y) { dest[1] = y; }
}
