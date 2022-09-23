import processing.svg.*;
boolean record;

color bg;
float H, S, B;

void setup() {
  size(1600, 900);
  H = 0.0;
  S = 14.0; // 14-21
  B = 89.0; // 89-96
  colorMode(HSB, 360, 100, 100);
  bg = color(0, 0, 100);
  textSize(16);
}

void draw() {

  if (H == 0.0 && S <= 21.0 && B <= 96.0) {
    beginRecord(SVG, "pastel/frame-####.svg");
  }

  background(bg);

  int c = 1;

  for (float i = 0; i < 2; i++) {
    for (float ii = 0; ii < 6; ii++, H+=30.0, c++) {
      float x = ii * 240 + 96;
      float y = i * 320 + 240;
      color sbg = color(H, S, B);
      String hsb_label = "HSB: " + floor(H) + ", " + floor(S) + ", " + floor(B);

      float C = (B/100) * (S/100);
      float X = C * ( 1 - abs(( H / 60 ) % 2 - 1) ) ;
      float m = B/100 - C;
      
      float Rp = -1000.0;
      float Gp = -1000.0;
      float Bp = -1000.0;

      if (H >=0 && H < 60)  {
        Rp = (C+m) * 255;
        Gp = (X+m) * 255;
        Bp = (0+m) * 255;
      } else if (H >=60 && H < 120)  {
        Rp = (X+m) * 255;
        Gp = (C+m) * 255;
        Bp = (0+m) * 255;
      } else if (H >=120 && H < 180)  {
        Rp = (0+m) * 255;
        Gp = (C+m) * 255;
        Bp = (X+m) * 255;
      } else if (H >=180 && H < 240)  {
        Rp = (0+m) * 255;
        Gp = (X+m) * 255;
        Bp = (C+m) * 255;
      } else if (H >=240 && H < 300)  {
        Rp = (X+m) * 255;
        Gp = (0+m) * 255;
        Bp = (C+m) * 255;
      } else if (H >=300 && H < 360)  {
        Rp = (C+m) * 255;
        Gp = (0+m) * 255;
        Bp = (X+m) * 255;
      }

      String rgb_label = "RGB: " + floor(Rp) + ", " + floor(Gp) + ", " + floor(Bp);
      String hex_label = "HEX: #" + hex(sbg, 6);

      fill(sbg);
      noStroke();
      rect(x, y, 208, 160, 10);
      fill(0);
      text(hsb_label, x+5, y+200);
      text(rgb_label, x+5, y+220);
      text(hex_label, x+5, y+240);
    }
  }

  if (H >= 300.0) {
    println("\n\n");
    endRecord();
    H = 0.0;
    S += 1.0;
  }

  if (S > 21.0) {
    S = 14.0;
    B += 1.0;
  }

  if (B > 96.0) {
    exit();
  }
}
