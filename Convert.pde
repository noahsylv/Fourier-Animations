
// returns list of points defining image
// will return n points
ArrayList<PVector> convert(String filename, int n, int offsetX, int offsetY) {
  PImage img = loadImage(filename);
  img.loadPixels();
  ArrayList<PVector> pts = new ArrayList<PVector>();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      if (img.pixels[x + y * img.width] != -1) {
        pts.add(new PVector(x+offsetX, y+offsetY));
      }
    }
  }
  ArrayList<PVector> sample = sample(pts, n);
  order(sample);
  return sample;
}

ArrayList<PVector> sample(ArrayList<PVector> list, int n) {
  ArrayList<PVector> out = new ArrayList<PVector>();
  int i = 0;
  while (i < min(n, list.size())) {
    int r = min(max(floor(random(list.size())), 0), list.size() - 1);
    PVector choice = list.get(r);
    if (!out.contains(choice)) {
      out.add(choice);
      i++;
    }
  }

  return out;
}

void swap(ArrayList<PVector> list, int i, int j) {
  PVector temp = list.get(i);
  list.set(i, list.get(j));
  list.set(j, temp);
}
void order(ArrayList<PVector> list) {
  for (int i = 0; i < list.size(); i++) {
    for (int j = 0; j < list.size(); j++) {
      if (compare(list.get(i), list.get(j)) > 0) {
        swap(list, i, j);
      }
    }
  }
}


int compare(PVector p1, PVector p2) {
  PVector p1Alt = new PVector(-p1.x + width/2, -p1.y + height/2);
  PVector p2Alt = new PVector(-p2.x + width/2, -p2.y + height/2);
  //int magDiff = ((int) (p1.mag() - p2.mag())) / 10;
  //if (magDiff > 0) {
  //  return -1;
  //}
  float diff = (p1Alt.heading() + 2 * PI) - (p2Alt.heading() + 2 * PI);
  if (diff > 0) {
    return -1;
  } 
  return 1;
}
