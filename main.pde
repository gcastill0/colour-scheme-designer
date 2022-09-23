import processing.svg.*;
JSONArray categories;

color bg;
float H, S, B;
float h_start, h_end;
float s_start, s_end;
float b_start, b_end;
String category_name;
int current_record = 0;

void setup() {
  size(1600, 900);
  categories = loadJSONArray("data.json");
  load_category();

  colorMode(HSB, 360, 100, 100);
  bg = color(0, 0, 100);
  textSize(16);
}

void load_category() {
  JSONObject category = categories.getJSONObject(current_record);
  JSONObject bounds = category.getJSONObject("bounds");
  h_start       = 0.0;
  h_end         = 360;
  s_start       = bounds.getJSONObject("start").getInt("S");
  s_end         = bounds.getJSONObject("end").getInt("S");
  b_start       = bounds.getJSONObject("start").getInt("B");
  b_end         = bounds.getJSONObject("end").getInt("B");
  category_name = category.getString("name");

  H = h_start;
  S = s_start;
  B = b_start;

  current_record++;
}

void draw() {

  if (H == 0.0 && S <= s_end && B <= b_end) {
    String filename = category_name + "/frame-####.svg";
    beginRecord(SVG, filename);
  }

  background(bg);

  for (float i = 0; i < 2; i++) {
    for (float ii = 0; ii < 6; ii++, H+=30.0) {
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

      if (H >=0 && H < 60) {
        Rp = (C+m) * 255;
        Gp = (X+m) * 255;
        Bp = (0+m) * 255;
      } else if (H >=60 && H < 120) {
        Rp = (X+m) * 255;
        Gp = (C+m) * 255;
        Bp = (0+m) * 255;
      } else if (H >=120 && H < 180) {
        Rp = (0+m) * 255;
        Gp = (C+m) * 255;
        Bp = (X+m) * 255;
      } else if (H >=180 && H < 240) {
        Rp = (0+m) * 255;
        Gp = (X+m) * 255;
        Bp = (C+m) * 255;
      } else if (H >=240 && H < 300) {
        Rp = (X+m) * 255;
        Gp = (0+m) * 255;
        Bp = (C+m) * 255;
      } else if (H >=300 && H < 360) {
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
    endRecord();
    H = h_start;
    S += 1.0;
  }

  if (S > s_end) {
    S = s_start;
    B += 1.0;
  }

  if (B > b_end && current_record < categories.size()) {
    load_category();
  }
  
  if (current_record >= categories.size()) {
    exit();
  }
}
