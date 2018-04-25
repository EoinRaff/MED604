public class Shape {  
  float theta, m, n1, n2, n3, a, b;
  public Shape(float m, float n1, float n2, float n3, float a, float b) {
    this.m = m;
    this.n1 = n1;
    this.n2 = n2;
    this.n3 = n3;
    this.a = a;
    this.b = b;
  }
  public void UpdateValues(float m, float n1, float n2, float n3)
  {
    this.m = m;
    this.n1 = n1;
    this.n2 = n2;
    this.n3 = n3;
  }
}