boolean lineIntersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the distance to intersection point
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

    // optionally, draw a circle where the lines meet
    float intersectionX = x1 + (uA * (x2-x1));
    float intersectionY = y1 + (uA * (y2-y1));
    fill(255,0,0);
    noStroke();
    ellipse(intersectionX,intersectionY, 20,20);

    return true;
  }
  return false;
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


void printArray(int[][] arrayint){
  println(Arrays.deepToString(arrayint));
  println();
  println(Arrays.deepToString(arrayint)
    .replace("[[", "")
    .replace("], [", "\n")
    .replace("]]", "")
    .replace(" ", "  "));
}
