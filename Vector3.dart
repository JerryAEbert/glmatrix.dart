class Vector3 {
  //Float32Array dest;
  Float32Array dest;
  
  
  // internal recycleSystem ... Green Vectors!
  
  Vector3._internal() {
    dest = new Float32Array(3);
  }
  
  static List<Vector3> _recycled;
  
  void recycle() {
    if(_recycled == null) _recycled = new List<Vector3>();
    _recycled.add(this);
  }
  
  static Vector3 _createVector() {
    Vector3 vec;
    if(_recycled == null) _recycled = new List<Vector3>();
    if(_recycled.length > 0) {
      vec = _recycled[0];
      _recycled.removeRange(0, 1);
      return vec;
    }
    return new Vector3._internal();
  }
  
  
  // Constructors
  
  factory Vector3.fromValues(double x, double y, double z) {
    Vector3 vec = _createVector();
    vec.dest[0] = x;
    vec.dest[1] = y;
    vec.dest[2] = z;
    return vec;
  }
  
  factory Vector3.zero() {
    return _createVector();
  }
  
  factory Vector3.fromSingleValues(double value) {
    Vector3 vec = _createVector();
    vec.dest[0] = value;
    vec.dest[1] = value;
    vec.dest[2] = value;
    return vec;
  }
  
  factory Vector3.fromList(List<double> list) {
    Vector3 vec = _createVector();
    vec.dest[0] = list[0] == null ? 0.0 : list[0].toDouble();
    vec.dest[1] = list[1] == null ? 0.0 : list[1].toDouble();
    vec.dest[2] = list[2] == null ? 0.0 : list[2].toDouble();
    return vec;
  }
  
  factory Vector3(double x, double y, double z) {
    Vector3 vec = _createVector();
    vec.dest[0] = x.toDouble();
    vec.dest[1] = y.toDouble();
    vec.dest[2] = z.toDouble();
    return vec;
  }
  
  
  double get X() => dest[0];
  void set X(double val) { dest[0] = val;}
  double get Y() => dest[1];
  void set Y(double val) { dest[1] = val;}
  double get Z() => dest[2];
  void set Z(double val) { dest[2] = val;}
  
  void setXYZ(double x, double y, double z) {
    dest[0] = x;
    dest[1] = y;
    dest[2] = z;
  }
  
  

  
  
  /**
   * Clones object [vec].
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Clone(Vector3 vec, [Vector3 result]) {
    if(result == null) result = new Vector3.zero();
    result.dest[0] = vec.dest[0];
    result.dest[1] = vec.dest[1];
    result.dest[2] = vec.dest[2];
    return result;
  }
  
  /// Clones this Vector3 object
  Vector3 clone([Vector3 result]) {
    return Vector3.Clone(this, result);
  }

  /**
   * Performs a vector addition between [vec] and [other].
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Add(Vector3 vec, Vector3 other, [Vector3 result]) {
      if (result == null || vec === result) {
          vec.dest[0] += other.dest[0];
          vec.dest[1] += other.dest[1];
          vec.dest[2] += other.dest[2];
          return vec;
      }

      result.dest[0] = vec.dest[0] + other.dest[0];
      result.dest[1] = vec.dest[1] + other.dest[1];
      result.dest[2] = vec.dest[2] + other.dest[2];
      return result;
  }
  void add(Vector3 vec) { Vector3.Add(this, vec, this); }
  /**
   * Performs a vector subtraction between [vec] and [other].
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Subtract(Vector3 vec, Vector3 other, [Vector3 result]) {
      if (result == null || vec === result) {
          vec.dest[0] -= other.dest[0];
          vec.dest[1] -= other.dest[1];
          vec.dest[2] -= other.dest[2];
          return vec;
      }

      result.dest[0] = vec.dest[0] - other.dest[0];
      result.dest[1] = vec.dest[1] - other.dest[1];
      result.dest[2] = vec.dest[2] - other.dest[2];
      return result;
  }
  Vector3 subtract(Vector3 vec) => Vector3.Subtract(this, vec, this);

  /**
   * Performs a vector multiplication between [vec] and [other].
   * writes it into [result] or creates a new Vector3 if not specified
   */
  static Vector3 Multiply(Vector3 vec, Vector3 other, [Vector3 result]) {
    if(result == null) result = new Vector3.zero();
      if (result == null || vec === result) {
          vec.dest[0] *= other.dest[0];
          vec.dest[1] *= other.dest[1];
          vec.dest[2] *= other.dest[2];
          return vec;
      }

      result.dest[0] = vec.dest[0] * other.dest[0];
      result.dest[1] = vec.dest[1] * other.dest[1];
      result.dest[2] = vec.dest[2] * other.dest[2];
      return result;
  }
/// Performs a vector multiplication between this and [other].
  Vector3 multiply(Vector3 other) => Multiply(this,other,this);

  /**
   * Transforms a [vec] with the given [quat]
   * Writes it into [result] or creates a new Vector3 if not specified
   */
  static Vector3 MultiplyQuat( Vector3 vec, Quaternion quat, [Vector3 result]) {
      if(result == null) { result = new Vector3.zero(); }
  
      var x = vec.dest[0], y = vec.dest[1], z = vec.dest[2],
          qx = quat.dest[0], qy = quat.dest[1], qz = quat.dest[2], qw = quat.dest[3],
  
          // calculate quat * vec
          ix = qw * x + qy * z - qz * y,
          iy = qw * y + qz * x - qx * z,
          iz = qw * z + qx * y - qy * x,
          iw = -qx * x - qy * y - qz * z;
  
      // calculate result * inverse quat
      result.dest[0] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
      result.dest[1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
      result.dest[2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
  
      return result;
  }
  Vector3 multiplyQuat(Quaternion quat) => Vector3.MultiplyQuat(this,quat,this);
  
  
  
  /**
   * Negates the components of a [vec]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Negate(Vector3 vec, [Vector3 result]) {
      if(result == null) result = new Vector3.zero();

      result.dest[0] = -vec.dest[0];
      result.dest[1] = -vec.dest[1];
      result.dest[2] = -vec.dest[2];
      return result;
  }
  /// Negate this
  Vector3 negate() => Vector3.Negate(this,this);

  /**
   * Multiplies the components of [vec] by a scalar value [val]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Scale(Vector3 vec, double val, [Vector3 result]) {
      if (result == null || vec === result) {
          vec.dest[0] *= val;
          vec.dest[1] *= val;
          vec.dest[2] *= val;
          return vec;
      }

      result.dest[0] = vec.dest[0] * val;
      result.dest[1] = vec.dest[1] * val;
      result.dest[2] = vec.dest[2] * val;
      return result;
  }
  
  void scale(double scaleVal) {
    Scale(this,scaleVal, this);
  }

  /**
   * Generates a unit vector of the same direction as the provided [vec]
   * If vector length is 0, returns [0, 0, 0]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Normalize(Vector3 vec, [Vector3 result]) {
      if(result == null) result = new Vector3.zero();

      var x = vec.dest[0], y = vec.dest[1], z = vec.dest[2],
          len = Math.sqrt(x * x + y * y + z * z);

      if (!len) {
          result.dest[0] = 0.0;
          result.dest[1] = 0.0;
          result.dest[2] = 0.0;
          return result;
      } else if (len === 1) {
          result.dest[0] = x;
          result.dest[1] = y;
          result.dest[2] = z;
          return result;
      }

      len = 1 / len;
      result.dest[0] = x * len;
      result.dest[1] = y * len;
      result.dest[2] = z * len;
      return result;
  }
  /// Normalize this
  /// If vector length is 0, returns [0, 0, 0]
  void normalize() {
    Normalize(this,this);
  }

 /**
   * Generates the cross product of [vec] and [other]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Cross(Vector3 vec, Vector3 other, [Vector3 result]) {
    if(result == null) result = new Vector3.zero();

    var x = vec.dest[0], y = vec.dest[1], z = vec.dest[2],
        x2 = other.dest[0], y2 = other.dest[1], z2 = other.dest[2];

    result.dest[0] = y * z2 - z * y2;
    result.dest[1] = z * x2 - x * z2;
    result.dest[2] = x * y2 - y * x2;
    return result;
  }
  
 /**
   *  Restricts [value] to be within [min] and [max].
   *  Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Clamp(Vector3 value, Vector3 min, Vector3 max, [Vector3 result])
  {
    if(result == null) result = new Vector3.zero();
    double x = value.X;
    x = (x > max.X) ? max.X : x;
    x = (x < min.X) ? min.X : x;

    double y = value.Y;
    y = (y > max.Y) ? max.Y : y;
    y = (y < min.Y) ? min.Y : y;

    double z = value.Z;
    z = (z > max.Z) ? max.Z : z;
    z = (z < min.Z) ? min.Z : z;

    result.setXYZ(x, y, z);
    return result;
  }
  /// Restricts this to be within [min] and [max].
  void clamp(Vector3 min, Vector3 max) {
    Clamp(this,min,max,this);
  }

  /// Caclulates the length of this
  double get length() => Math.sqrt(Math.pow(X,2) + Math.pow(Y,2) + Math.pow(Z,2) );
 

  /**
   * Caclulates the dot product of [vec] and [other]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static double Dot(Vector3 vec, Vector3 other) {
      return vec.dest[0] * other.dest[0] + vec.dest[1] * other.dest[1] + vec.dest[2] * other.dest[2];
  }
  double dot(Vector3 other) => Dot(this,other);

  /**
   * Generates a unit vector pointing from one vector to another
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Direction(Vector3 vec, Vector3 other, [Vector3 result]) {
      if(result == null) result = new Vector3.zero();

      var x = vec.dest[0] - other.dest[0],
          y = vec.dest[1] - other.dest[1],
          z = vec.dest[2] - other.dest[2],
          len = Math.sqrt(x * x + y * y + z * z);

      if (!len) {
          result.dest[0] = 0.0;
          result.dest[1] = 0.0;
          result.dest[2] = 0.0;
          return result;
      }

      len = 1 / len;
      result.dest[0] = x * len;
      result.dest[1] = y * len;
      result.dest[2] = z * len;
      return result;
  }

  /**
   * Performs a linear interpolation with [lerpVal] between [vec] and [other]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static Vector3 Lerp(Vector3 vec, Vector3 other, double lerpVal, [Vector3 result]) {
      if(result == null) result = new Vector3.zero();
      
      

      result.dest[0] = vec.dest[0] + lerpVal * (other.dest[0] - vec.dest[0]);
      result.dest[1] = vec.dest[1] + lerpVal * (other.dest[1] - vec.dest[1]);
      result.dest[2] = vec.dest[2] + lerpVal * (other.dest[2] - vec.dest[2]);

      return result;
  }
  /// Performs a linear interpolation with [lerpVal] between [this] and [other]
  void lerp(Vector3 other, double lerpVal) {
    Lerp(this, other, lerpVal, this);
  }
  

  /**
   * Calculates the euclidian distance between [vec] and [other]
   * Writes it into [result] or creates a new Vector3 if not specified.
   */
  static double Distance(Vector3 vec, Vector3 other) {
      var x = other.dest[0] - vec.dest[0],
          y = other.dest[1] - vec.dest[1],
          z = other.dest[2] - vec.dest[2];
          
      return Math.sqrt(x*x + y*y + z*z);
  }
  double distance(Vector3 other) => Vector3.Distance(this, other);
  
  static double DistanceSquared(Vector3 vec, Vector3 other) {
    var x = other.dest[0] - vec.dest[0],
        y = other.dest[1] - vec.dest[1],
        z = other.dest[2] - vec.dest[2];
        
    return (x*x + y*y + z*z);
  }
  double distanceSquared(Vector3 other) => Vector3.DistanceSquared(this, other);


  /**
   * Projects the [vec] from screen space into object space
   * Based on the <a href="http://webcvs.freedesktop.org/mesa/Mesa/src/glu/mesa/project.c?revision=1.4&view=markup">Mesa gluUnProject implementation</a>
   *
   * @param {vec3} vec Screen-space vector to project
   * @param {mat4} view View matrix
   * @param {mat4} proj Projection matrix
   * @param {vec4} viewport Viewport as given to gl.viewport [x, y, width, height]
   * @param {vec3} [dest] vec3 receiving unprojected result. If not specified result is written to vec
   *
   * @returns {vec3} dest if specified, vec otherwise
   */
  static Vector4 Unproject(Vector3 vec, Matrix view, Matrix proj, Vector4 viewport, [Vector4 result]) {
      if(result == null) result = new Vector4.zero();

      Matrix m = new Matrix.zero();
      Vector4 v = new Vector4.zero();
      
      v.dest[0] = (vec.dest[0] - viewport.dest[0]) * 2.0 / viewport.dest[2] - 1.0;
      v.dest[1] = (vec.dest[1] - viewport.dest[1]) * 2.0 / viewport.dest[3] - 1.0;
      v.dest[2] = 2.0 * vec.dest[2] - 1.0;
      v.dest[3] = 1.0;
      
      Matrix.Multiply(proj, view, m);
      if(Matrix.Inverse(m) == null) { return null; }
      
      Matrix.MultiplyVec4(m, v);
      if(v.dest[3] === 0.0) { return null; }

      result.dest[0] = v.dest[0] / v.dest[3];
      result.dest[1] = v.dest[1] / v.dest[3];
      result.dest[2] = v.dest[2] / v.dest[3];
      
      return result;
  }

  /**
   * Returns a string representation of this vector
   */
  String toString() => '[' + dest[0].toString() + ', ' + dest[1].toString() + ', ' + dest[2].toString() + ']';
  
  int hashCode() => X.hashCode() + Y.hashCode() + Z.hashCode();
  
}
