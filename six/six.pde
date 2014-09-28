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
int volumeIntervalMinor = 5;

PFont plotFont; 
PFont xAxisNumericFont;
PFont allText;

void setup() {
  size(720, 405);
  
  data = new FloatTable("milk-tea-coffee.tsv");
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
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);

  xAxisNumericFont = createFont("Georgia",20);
  allText = createFont("Verdana",20);


  smooth();
}


void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);

  drawTitle();
  drawAxisLabels();
  
  drawYearLabels();
  drawVolumeLabels();

  stroke(#5679C1);
  strokeWeight(5);
  drawDataPoints(currentColumn);
}


void drawTitle() {
  fill(0);
  // adding font
  textFont(allText);
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
  // Use \n (enter/linefeed) to break the text into separate lines
  // rotating 
  
  int x = (int)labelX;     // Location of start of text.
  int y = (int)(plotY1+plotY2)/2;
  
  pushMatrix();
  translate(x,y);
  rotate(HALF_PI);
  translate(-x,-y);
  
  text("Gallons\nconsumed\nper capita", labelX, (plotY1+plotY2)/2);
  
  popMatrix();
  
  
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}


void drawYearLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      // changing year labels to georgia font
      textSize(10);
      textFont(xAxisNumericFont);
      text(years[row], x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}


void drawVolumeLabels() {
  fill(0);
  textSize(10);
  
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
      if (v % volumeInterval == 0) {        // If a major tick mark
        if (v == dataMin) {
          textAlign(RIGHT);                 // Align by the bottom
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP);            // Align by the top
        } else {
          textAlign(RIGHT, CENTER);         // Center vertically
        }
        // adding font here too
        textFont(xAxisNumericFont);
        text(floor(v), plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y);     // Draw major tick
      } else {
        // Commented out, too distracting visually
        //line(plotX1 - 2, y, plotX1, y);   // Draw minor tick
      }
    }
  }
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


void keyPressed() {
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