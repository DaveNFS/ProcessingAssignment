FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int rowCount;
int columnCount;
int currentColumn = 0;

int yearMin, yearMax;
int[] years;

int yearInterval = 10;
int volumeInterval = 10;

float barWidth = 4;  
int choice = 4;

PFont plotFont; 
PFont georgia; 
PFont xAxisNumericFont;
PFont allText;


void setup() {
  size(720, 405);
  
  data = new FloatTable("output.tsv");
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
  
  years = int(data.getRowNames());
  yearMin = years[0];
  yearMax = years[years.length - 1];
  
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;

  // Corners of the plotted time series
  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;
  
  float plotW = plotX2 - plotX1;
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);
  
  georgia = createFont("Georgia", 10);
  
  
  xAxisNumericFont = createFont("Georgia",20);
  allText = createFont("Verdana",20);

  smooth();
}


void draw() {
  background(255);
  
  textFont(allText);
  drawTitle();
  drawAxisLabels();
  
  textFont(xAxisNumericFont);
  drawVolumeLabels();

  noStroke();
  fill(#5679C1);
  
  
  
  // drawDataBars(currentColumn);
  // drawDataArea(currentColumn);
  
   // Show line chart 
  fill(255);
  stroke(#5679C1);
  noFill();
  strokeWeight(2);
  //drawDataLine(currentColumn);  
  
  stroke(#5679C1);
  strokeWeight(5);
  //drawDataPoints(currentColumn);
  
  
  
  
  
  
  
  
  
  // Keyboard selection 
  
  if(choice == 1)
  {
    stroke(#5679C1);
    strokeWeight(5);
     drawDataPoints(currentColumn);
  }
  
   if(choice == 2)
  {
      fill(255);
    stroke(#5679C1);
    noFill();
    strokeWeight(2);
    drawDataLine(currentColumn); 
    strokeWeight(5);
    drawDataPoints(currentColumn);
    
  }
  
   if(choice == 3)
  {
    fill(255);
    stroke(#5679C1);
    noFill();
    strokeWeight(2);
    drawDataLine(currentColumn);  
  
  }
  
   if(choice == 4)
  {
      noStroke();
    fill(#5679C1);
    drawDataArea(currentColumn);
  }
  
  if(choice == 5)
  {
      noStroke();
      fill(#5679C1);
    drawDataBars(currentColumn);
  }
  
  
  
   drawYearLabels();
    
   drawDataHighlight(currentColumn);


// closing draw()
}


void drawTitle() {
  fill(0);
  textSize(35);
  textAlign(LEFT);
  String title = data.getColumnName(currentColumn);
  text(title, plotX1, plotY1 - 10);
}


void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  int x = (int)labelX;     // Location of start of text.
  int y = (int)(plotY1+plotY2)/2;
  
  pushMatrix();
  translate(x,y);
  rotate(HALF_PI);
  translate(-x,-y);
  text("Gallons consumed per capita", labelX, (plotY1+plotY2)/2);
  popMatrix();
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}


void drawYearLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);
  
  // Use thin, gray lines to draw the grid
  stroke(255);
  strokeWeight(1);
  
  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + textAscent() + 10);
      //line(x, plotY1, x, plotY2);
    }
  }
}


int volumeIntervalMinor = 5;   // Add this above setup()

void drawVolumeLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
      if (v % volumeInterval == 0) {        // If a major tick mark
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
          textOffset = 0;                   // Align by the bottom
        } else if (v == dataMax) {
          textOffset = textAscent();        // Align by the top
        }
        text(floor(v), plotX1 - 10, y + textOffset);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } else {
        //line(plotX1 - 2, y, plotX1, y);     // Draw minor tick
      }
    }
  }
}




void drawDataBars(int col) {
  noStroke();
  rectMode(CORNERS);
  
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
}


void drawDataArea(int col) {
  beginShape();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
    }
  }
  // Draw the lower-right and lower-left corners
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
}


void drawDataLine(int col) {  
  beginShape();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);      
      vertex(x, y);
    }
  }
  endShape();
}




void drawDataPoints(int col) {
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x, y);
    }
  }
}




void drawDataHighlight(int col) {
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      if (dist(mouseX, mouseY, x, y) < 3) {
        strokeWeight(10);
        point(x, y);
        fill(0);
        textSize(10);
        textAlign(CENTER);
        textFont(georgia);
        text(nf(value, 0, 2) + " (" + years[row] + ")", x, y-8);
        textAlign(LEFT);
      }
    }
  }
}


void keyPressed() {
  
  if(key == '1')
  {
    choice = 1; 
  }
  if(key == '2')
  {
    choice = 2; 
  }
  if(key == '3')
  {
    choice = 3; 
  }
  if(key == '4')
  {
    choice = 4; 
  }
    if(key == '5')
  {
    choice = 5; 
  }
  
  if (key == '[') {
    currentColumn--;
    if (currentColumn < 0) {
      currentColumn = columnCount - 1;
    }
  } else if (key == ']') {
    currentColumn++;
    if (currentColumn == columnCount) {
      currentColumn = 0;
    }
  }
}
