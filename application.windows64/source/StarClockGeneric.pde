import controlP5.*; 
import de.bezier.data.sql.*; 
//import java.awt.event.*;
import java.lang.*; 
import java.util.*; 
//import java.time.*;

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException;

import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

    float[] x = new float[3600];
    float[] y = new float[3600];

    double GHA0 = 0;
    double GHA = Math.toRadians(-214.21545); //(-250.297);//(-214.21545); //(-250.297);//(-214.21545); //(34.21545);  //<---- = 214 + 180 -360 //(214.21545); //Arcturus
     double dec = Math.toRadians(-19.335);
    double GHA1 = Math.toRadians(-279.2346); //(-315.568);//(-279.2346); //(-315.568);//(-279.2346); //(99.2346);//(279.2346); //Vega
    double dec1 = Math.toRadians(-38.758);
    double GHA2 = Math.toRadians(-165.932325);//(-202.375);//(-165.932325);//(-202.375);//(-165.932325);//(14.067675);//(165.932325); //(345.932325); //(165.932325); //Dubhe
    double dec2 = Math.toRadians(-61.909);
    double alt = (55.53);//(89.50);//(55.53);
    double alt1 = (64.648);//(89.50);//(64.648);
    double alt2 = (38.18);//(89.50);//(38.18);

    double Be = Math.toRadians(35.4000);
    double Le = Math.toRadians(26.452837);

    double[]vv = new double[3]; //, vy[3], vyz[3];
    double[]vy = new double[3];
    double[]vyz = new double[3];
    double[]wpt = new double[3600];
    float[]WPT = new float[3600];

    double[][]My = new double[3][3];

    double[][]Mz = new double[3][3];

    public float[] Data;

double GHAaries = 0;
double GAST = 0;
           float DeciGAST = 0; // (float)GAST/24;
 double GMST = 0;


SQLite db;
SQLite db2;

PImage bg;
PImage texmap;
PGraphics texture;
PImage texmap2;
PGraphics texture2;



ControlP5 cp5;
    PFont font;
float sliderValue = -77;
float sliderValue2 = 0;
float sliderValue3 = 0;
float sliderValue4 = 0;
float sliderValue5 = 0;
boolean flag = false;

int sDetail = 64; //128;  // Sphere detail setting
float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float globeRadius = 597;
float pushBack = -100;

float[] cx, cz, sphereX, sphereY, sphereZ;
float sinLUT[];
float cosLUT[];
float SINCOS_PRECISION = 0.5f;

int SINCOS_LENGTH = PApplet.parseInt(360.0f / SINCOS_PRECISION);

int [] colors = new int[7];


public void setup() {

  //  hint(ENABLE_DEPTH_TEST);
//  hint(DISABLE_DEPTH_TEST);
  size(1275, 750, P3D);


  db = new SQLite( this, "hygdata.db" );  // open database file


   cp5 = new ControlP5(this);

           PFont p = createFont("Verdana",15);
        ControlFont Font = new ControlFont(p);

       // change the original colors
       cp5.setColorForeground(0xffaa0000);
       cp5.setColorBackground(0xff660000);
       cp5.setFont(Font);
       cp5.setColorActive(0xffff0000);



       /*     cp5.addSlider("pushback")
               .setRange(-100,900)
               .setValue(0)
               .setPosition(1075, 300) //.setPosition(1075, 300)
               .setSize(50, 200)
               .setSliderMode(Slider.FLEXIBLE)
       ;  */

       cp5.addToggle("Clock")

               .setPosition(1175, 600) //.setPosition(975, 300)
     .setSize(75, 50)
     ;

  orientation(LANDSCAPE);
//  texmap = loadImage("world32k.jpg");
//    texmap = loadImage("Chart3.png");
// texmap = loadImage("Ganymede.jpg");
//  texmap = loadImage("starmap_4k2B2.jpg");
 //   texmap2 = loadImage("EquiSW.jpg");
     //  texmap = loadImage("starmap_4k2.jpg");  //inner
    //    texmap = loadImage("starmap_4k2B2.jpg");  //outer
 //   texmap = loadImage("EOT.png");
 // texmap = loadImage("alphatest.png");  //outer
   texmap2 = loadImage("alphatest.png");  //outer
// texmap = loadImage("celestial_grid2.png");
    //  texmap = loadImage("StarChart.png");
    //     texmap = loadImage("sky-map.jpg");
     texmap = loadImage("starmap_4k2B2b.jpg");  //outer
    //  texmap = loadImage("alphatest.png");  //outer
   //    texmap = loadImage("starmap_4k.jpg");  //outer
 //   texmap = loadImage("boundaries2.jpg");
   //  texmap = loadImage("starmap_4k2B2.jpg");
  //   texmap = loadImage("Chart2.png");
//  texmap = loadImage("Cons.png");
    texture = createGraphics(texmap.width, texmap.height);
        texture2 = createGraphics(texmap2.width, texmap2.height);

    font = loadFont("CourierNew36.vlw");
  initStars();
   addDiagonalLine();
  addDiagonalLine2();
  //  getPoints();
  initializeSphere(sDetail);
  initializeSphere2(sDetail);
}

public void draw() {
  background(0);
  //  MainActivity.sendAttitudeRequest();

 //   Data = MainActivity.MyHandler.getData();

  //  float gha = Data[2];
float gha = 150.0;
    if (gha > 0.0 && gha < 180.0f) {
        gha = (float)GHA; // 150.0; /// Data[2];

    }else{
        gha = 360 + 150.0; // Data[2];

        if(gha > 360.0f)
            gha = gha - 360.0f;
    }

    gha = 360.0f - gha;

    x = new float[3600];
    y = new float[3600];

 /////////////  renderGlobe();
  // image(texture, 0, 0, width, height);  
    renderGlobe(); 
renderGlobe2();
    if(mousePressed){
        if (mouseX < width/2 && mouseY < height/3) {  //1/3

            //GHA = gha;
          //  GHA = Math.toRadians(GHA);
          //  alt = (-Data[1]);
                alt = 55.53; // (-Data[1]);
            alt = alt;
            initStars();
         //   addDiagonalLine();
             addDiagonalLine2();
       //     getPoints();
          //  thread("getPoints");
        //    initializeSphere(sDetail);
                      //  thread("getPoints");
           initializeSphere(sDetail);
        }else{

            if (mouseX < width/2 && mouseY < height*2/3 && mouseY > height/3) {  //2/3

               /// GHA1 = map(Data[2], (float) (-180.0), (float) (180.0), (0), (360));
              //  GHA1 = gha;
            //    GHA1 = Math.toRadians(GHA1);
              //  alt1 = (-Data[1]);
                               //// alt1 = (65);


            //    initStars();
             //     addDiagonalLine();
            //      addDiagonalLine2();
             //   getPoints();
               // thread("getPoints");
           //     initializeSphere(sDetail);
                      //      initializeSphere2(sDetail);

            }else{

                if (mouseX < width/2 && mouseY < height && mouseY > height*2/3){
                  //  GHA2 = map(Data[2], (float) (-180.0), (float) (180.0), (0), (360));
                   // GHA2 = gha;
                //    GHA2 = Math.toRadians(GHA2);
                  //  alt2 = (-Data[1]);
                                       /////// alt2 = (10);
//alt2 = alt2;

                    initStars();
                  //    addDiagonalLine();
                   getPoints();
                      addDiagonalLine2();
                   
                  //  thread("getPoints");
                    initializeSphere(sDetail);
                    initializeSphere2(sDetail);


                }

            }





        }
    }


    textFont(font, 20);
    textAlign(LEFT, TOP);


    fill(0);
    noStroke();

    float rw = textWidth("GAST: " + ((float)GAST) + "  " + "GMST: " + ((float)GMST) ); //("Geodetic Position: " + -77.24f + "W " + 39.24f + "N   " );

    rect(width - 205 - rw, height - 65 - g.textSize, rw, g.textSize + textDescent());
    fill(255, 255, 0);
    textAlign(RIGHT, BOTTOM);

    text("GAST: " + (float)GAST + "  " + "GMST: " + ((float)GMST), width - 205, height - 65);
    // println("rw: " + rw);


   //   ra = abs((float)GAST - ra) + ra;
   DeciGAST = (float)GAST / 24;
    //  println(DeciGAST);
//thread("addDiagonalLine2");

}

public void initStars(){
  texture.beginDraw();
  texture.image(texmap,0,0);

  texture.endDraw();
  texture2.beginDraw();
  texture2.image(texmap2,0,0);
  texture2.endDraw();
}



public void addDiagonalLine2(){

  texture2.beginDraw();
   texture.beginDraw(); 
 texture.stroke(255,0,0);
  texture.strokeWeight(2);

   texture.line(0,0,0, texture.height);
   texture.line(texture.width,0,texture.width, texture.height);
    texture.line(texture.width/2,0,texture.width/2, texture.height);
//  texture.line(texture2.width/12, 0,texture2.width/12,texture2.height);

   //  if ( db.connect() && db2.connect() )
     if ( db.connect() )
    {
       // String[] tableNames = db.getTableNames();
        String[] tableNames = db.getTableNames();
    //  db.query( "SELECT ra,dec,proper,con FROM %s WHERE proper > ' '", tableNames[0] ); // AND dist <= '30.65' OR proper > ' ', tableNames[0] ); // AND mag >= '5.0' AND mag <= '5.05'", tableNames[0] );
  //   db.query( "SELECT ra,dec,proper,con FROM %s WHERE dec < '0'", tableNames[0] ); // AND dist <= '30.65' OR proper > ' ', tableNames[0] ); // AND mag >= '5.0' AND mag <= '5.05'", tableNames[0] );
 
  // db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND con = 'UMa'", tableNames[0] );
     // db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND dec >= '0' AND con == 'UMa'", tableNames[0] );
        //    db.query( "SELECT con,ra,dec,proper FROM %s WHERE con == 'UMa' OR con == 'Cep' OR con == 'Gem' OR dec <= '0' AND dec >= '-15' OR ra > '5.1' AND ra < '5.2' OR dec > '39' AND dec < '40'", tableNames[0] );
     //  db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND con > ' '", tableNames[0] );
        //  db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper = 'Betelgeuse' OR proper = 'Capella' OR proper = 'Arcturus' OR proper = 'Vega' OR proper = 'Dubhe' OR con = 'Peg' OR con = 'Lyr' OR con = 'Cep' OR con = 'UMa' AND proper > ' '", tableNames[0] );
          db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper == 'Phad' OR proper == 'Alkaid' OR proper == 'Mizar' OR proper == 'Alioth' OR proper == 'Megrez' OR proper == 'Phekkda' OR proper == 'Merak' OR proper == 'Pollux' OR proper == 'Arcturus' OR  proper == 'Dubhe' OR  proper == 'Vega'", tableNames[0] );
 //  db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper == 'Dubhe' OR  proper == 'Vega' OR  proper == 'Capella'OR  proper == 'Regulus' OR  proper == 'Arcturus'", tableNames[0] );
       int i = 1;
        while (db.next())
        {

            TableOne t = new TableOne();

            db.setFromRow( t );
  float ra = (float)(t.ra);
         float dec = (float)(t.dec);
         String conName = t.con;
         String starName = t.proper;




float RA = 1.0 * ra; // (DeciGAST * ra);
//RA = ((24 - (float)GAST) + ra);

if (abs(RA) > 24) {
  println("GreaterThan24:   ",RA);
  RA = abs(abs(RA) - 24);
println("GreaterThan24:   ",RA);
}


       println(i,t.con,t.proper, t.ra, RA, (float)GAST, (24 - (float)GAST) + t.ra, t.dec);

           i++;



      
   RA = map(RA,0.0f, 24.0f,0,TWO_PI);        
 
 float X = map((RA),0,TWO_PI,texture.width,texture.width -texture.width);

 float   Y = map(radians(-dec),radians(0),radians(90),texture.height/2,texture.height - texture.height);
  texture.stroke(0,255,0);
texture.strokeWeight(5);



/*    if (X > texture.width/2){
      texture.point(texture.width/2-(texture.width-X),Y); 
  //    texture.point(texture.width/2+(texture.width-X),Y);
//  texture.point(texture.width/2 - (texture.width-texture.width+X),Y);
    }
    
if ( X < texture.width/2) {
    texture.point((texture.width/2-X)+ (texture.width-texture.width),Y);
  //   texture.point((texture.width/2-X)+ (0),Y);
 //  texture.point((texture.width/2+X),Y);
} */    


// X = -X;





   texture.point(X- texture.width/2,Y);
   texture.point(texture.width/2+X,Y);
   texture.point(-X,Y);


        }
    }
    

 

  texture.endDraw();
    texture2.endDraw();
} 




public void addDiagonalLine(){


   texture2.beginDraw(); 

/*
   //  if ( db.connect() && db2.connect() )
     if ( db.connect() )
    {
       // String[] tableNames = db.getTableNames();
        String[] tableNames = db.getTableNames();
      db.query( "SELECT ra,dec,proper,con FROM %s WHERE proper > ' '", tableNames[0] ); // AND dist <= '30.65' OR proper > ' ', tableNames[0] ); // AND mag >= '5.0' AND mag <= '5.05'", tableNames[0] );
 //  db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND dec >= '45' OR proper > ' ' AND con = 'Ori'", tableNames[0] );
    //  db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND dec >= '-20' AND con == 'UMa'", tableNames[0] );
       db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND con > ' ' OR con == 'Gem' OR dec <= '0' AND dec >= '-15' OR dec < '-30' AND dec >= '-45'", tableNames[0] );
            //   db.query( "SELECT con,ra,dec,proper FROM %s WHERE con == 'Gem'", tableNames[0] );
  
       //   db.query( "SELECT con,ra,dec,proper FROM %s WHERE proper > ' ' AND dec >= '-20'", tableNames[0] );
  
       int i = 1;
        while (db.next())
        {

            TableOne t = new TableOne();

            db.setFromRow( t );
  float ra = (float)(t.ra);
         float dec = (float)(t.dec);
         String starName = t.proper;



           println(i,t.con,t.proper, t.ra, t.dec);



           i++;
           
   ra = map(ra,0.0f, 24.0f,0,TWO_PI);        

 float X = map((ra),0,TWO_PI,texture2.width -texture2.width,texture2.width);
 float   Y = map(radians(dec),radians(0),radians(90),texture2.height/2,texture2.height - texture2.height);
              texture2.stroke(0,255,0);
    texture2.strokeWeight(2);
    if (X > texture2.width/2){
      texture2.point(texture2.width/2-(texture2.width-X),Y); 
    }
if ( X < texture2.width) {
    texture2.point(X+texture2.width/2,Y);
}  


        }
    }
    
    
                texture2.stroke(255,0,0);
    texture2.strokeWeight(1);  
    
    //longitude lines

 
 
 texture2.stroke(255,255,255);
  texture2.strokeWeight(2);
  texture2.line(0,0,0, texture2.height);
  texture2.line(texture2.width/12, 0,texture2.width/12,texture2.height);
  texture2.line(texture2.width/12*2, 0,texture2.width/12*2,texture2.height);
  texture2.line(texture2.width/12*3, 0,texture2.width/12*3,texture2.height);     
  texture2.line(texture2.width/12*4, 0,texture2.width/12*4,texture2.height);
  texture2.line(texture2.width/12*5, 0,texture2.width/12*5,texture2.height);
  texture2.line(texture2.width/12*6, 0,texture2.width/12*6,texture2.height);
  texture2.line(texture2.width/12*7, 0,texture2.width/12*7,texture2.height);
  texture2.line(texture2.width/12*8, 0,texture2.width/12*8,texture2.height);
  texture2.line(texture2.width/12*9, 0,texture2.width/12*9,texture2.height);
  texture2.line(texture2.width/12*10, 0,texture2.width/12*10,texture2.height);
  texture2.line(texture2.width/12*11, 0,texture2.width/12*11,texture2.height);
/////  texture2.line(texture2.width/12 * 11 -texture2.width/12/3, 0,texture2.width/12 * 11 -texture2.width/12/3,texture2.height);
 

  texture2.line(texture2.width/12 -texture2.width/12/2, 0,texture2.width/12 -texture2.width/12/2,texture2.height);
  texture2.line(texture2.width/12+texture2.width/12/2, 0,texture2.width/12+texture2.width/12/2,texture2.height);
  texture2.line(texture2.width/12/2+texture2.width/12/2, 0,texture2.width/12/2+texture2.width/12/2,texture2.height);
  texture2.line(texture2.width/12 * 2+texture2.width/12/2, 0,texture2.width/12 * 2+texture2.width/12/2,texture2.height);
 
  texture2.line((texture2.width/12 * 3)+texture2.width/12/2, 0,(texture2.width/12 * 3)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 4)+texture2.width/12/2, 0,(texture2.width/12 * 4)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 5)+texture2.width/12/2, 0,(texture2.width/12 * 5)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 6)+texture2.width/12/2, 0,(texture2.width/12 * 6)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 7)+texture2.width/12/2, 0,(texture2.width/12 * 7)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 8)+texture2.width/12/2, 0,(texture2.width/12 * 8)+texture2.width/12/2,texture2.height);//////////////
  texture2.line((texture2.width/12 * 9)+texture2.width/12/2, 0,(texture2.width/12 * 9)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 10)+texture2.width/12/2, 0,(texture2.width/12 * 10)+texture2.width/12/2,texture2.height);
  texture2.line((texture2.width/12 * 11)+texture2.width/12/2, 0,(texture2.width/12 * 11)+texture2.width/12/2,texture2.height);
  

 


//latitude lines

texture2.stroke(255,255,255);
  texture2.line(0, texture2.height/2,texture2.width,texture2.height/2); // +15 degrees
  texture2.line(0, texture2.height/2/3,texture2.width,texture2.height/2/3); // +60 degrees
  texture2.line(0, texture2.height/2/3 * 2,texture2.width,texture2.height/2/3 * 2); // +30 degrees
  texture2.line(0, texture2.height/2/6,texture2.width,texture2.height/2/6 ); // +75 degrees
  texture2.line(0, texture2.height/2/3 + texture2.height/2/6,texture2.width,texture2.height/2/3 + texture2.height/2/6); // +45 degrees
  texture2.line(0, texture2.height/2/3 * 2 + texture2.height/2/6 ,texture2.width,texture2.height/2/3 * 2 + texture2.height/2/6); // equator 0 degrees
  texture2.line(0, texture2.height/2 + texture2.height/2/3/2 ,texture2.width,texture2.height/2 + texture2.height/2/3/2); // -15 degrees
//  texture2.line(0, texture2.height/2 -texture2.height/2/3 ,texture2.width,texture2.height/2 -texture2.height/2/3);  //redundant
  texture2.line(0, texture2.height - texture2.height/2/3 * 2,texture2.width,texture2.height -texture2.height/2/3 * 2); // -30 degrees
  texture2.line(0, texture2.height -texture2.height/2/3,texture2.width,texture2.height -texture2.height/2/3); // -60 degrees
  texture2.line(0, texture2.height - texture2.height/2/3 * 2 + texture2.height/2/6,texture2.width,texture2.height -texture2.height/2/3 * 2 + texture2.height/2/6); // -45 degrees
  texture2.line(0, texture2.height -texture2.height/2/3 + texture2.height/2/6,texture2.width,texture2.height -texture2.height/2/3 + texture2.height/2/6); // -75 degrees

 
  
    
  */  

  texture2.endDraw();
}  

//}

  public  void getPoints(){



//  println(My[0][0] + " " + My[0][1] + " " + My[0][2]);
// println(My[1][0] + " " + My[1][1] + " " + My[1][2]);
// println(My[2][0] + " " + My[2][1] + " " + My[2][2]);
  
        texture.beginDraw();
        int w = 0;

        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
           // Mz = Rz(Math.toRadians(360.0) - (GHA + Math.toRadians(36.082)), Mz);
            Mz = Rz(Math.toRadians(360.0) - (GHA ), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry(Math.toRadians(90.0) - dec, My);

         //   float alt = map(mouseX,width-width,width,0,90);
              vv =  VectorSpherical2Cartesian(Math.toRadians(alt),Math.toRadians(L0) );
         //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture.width, texture.width - texture.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture.height,texture.height - texture.height);
            texture.point(x[w],y[w]);
            texture.noFill();
            texture.stroke(255,0, 0);
            texture.strokeWeight(2);
            texture.beginShape();
            texture.curveVertex(x[w],y[w]);
            texture.curveVertex(x[w], y[w]);

            texture.endShape();
          
        }
w++;
        w = 0;
        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
          //  Mz = Rz(Math.toRadians(360.0) - (GHA1 + Math.toRadians(36.3334) ), Mz);
            Mz = Rz(Math.toRadians(360.0) - (GHA1 ), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry(Math.toRadians(90.0) - dec1, My);
            //   float alt = map(mouseX,width-width,width,0,90);
            vv =  VectorSpherical2Cartesian(Math.toRadians(alt1),Math.toRadians(L0) );
            //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture.width, texture.width - texture.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture.height,texture.height - texture.height);
            texture.point(x[w],y[w]);
            texture.noFill();
            texture.stroke(0,255, 0);
            texture.strokeWeight(2);
            texture.beginShape();
            texture.curveVertex(x[w],y[w]);
            texture.curveVertex(x[w], y[w]);

            texture.endShape();
        }
        w++;
w = 0;
        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
           // Mz = Rz(Math.toRadians(360.0) - (GHA2 + Math.toRadians(36.442675)), Mz);
            Mz = Rz(Math.toRadians(360.0) - (GHA2), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry(Math.toRadians(90.0) - dec2, My);
            //   float alt = map(mouseX,width-width,width,0,90);
            vv =  VectorSpherical2Cartesian(Math.toRadians(alt2),Math.toRadians(L0) );
            //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture.width, texture.width - texture.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture.height,texture.height - texture.height);
            texture.point(x[w],y[w]);
            texture.noFill();
            texture.stroke(0,0, 255);
            texture.strokeWeight(2);
            texture.beginShape();
            texture.curveVertex(x[w],y[w]);
            texture.curveVertex(x[w], y[w]);

            texture.endShape();
        }
        w++;

     //   w++;
        
    
        
        
              //  w++;

        
        
        
        
        
        
        
        
        
        
        texture.endDraw();
        
        
        
        
        
                texture2.beginDraw();
         w = 0;
     //    GHA = -250.297;
     //    GHA1 = -315.568;
     //    GHA2 = -202.375;

        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
           // Mz = Rz(Math.toRadians(360.0) - GHA, Mz);
             // Mz = Rz(Math.toRadians(360)- (GHA), Mz);
            //  Mz = Rz(Math.toRadians(360)- (-250.297), Mz);
           Mz = Rz(((double)(abs((float)(Math.toRadians(360.0) - GHA)))), Mz);
            

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry((Math.toRadians(90.0) - dec), My);
           //   My =  Ry(( dec), My);

         //   float alt = map(mouseX,width-width,width,0,90);
              vv =  VectorSpherical2Cartesian(Math.toRadians(alt),Math.toRadians(L0) );
         //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture2.width, texture2.width - texture2.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture2.height,texture2.height - texture2.height);
            texture2.point(x[w],y[w]);
            texture2.noFill();
            texture2.stroke(255,0, 0);
            texture2.strokeWeight(2);
            texture2.beginShape();
            texture2.curveVertex(x[w],y[w]);
            texture2.curveVertex(x[w], y[w]);

            texture2.endShape();
          
        }
w++;
        w = 0;
        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
          //  Mz = Rz((Math.toRadians(360.0) - GHA1), Mz);
          //   Mz = Rz(Math.toRadians(360) -  (-315.568), Mz);
              Mz = Rz((Math.toRadians(360.0) - GHA1), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry((Math.toRadians(90.0) - dec1), My);
          //  My =  Ry(( dec1), My);
            //   float alt = map(mouseX,width-width,width,0,90);
            vv =  VectorSpherical2Cartesian(Math.toRadians(alt1),Math.toRadians(L0) );
            //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture2.width, texture2.width - texture2.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture2.height,texture2.height - texture2.height);
            texture2.point(x[w],y[w]);
            texture2.noFill();
            texture2.stroke(0,255, 0);
            texture2.strokeWeight(2);
            texture2.beginShape();
            texture2.curveVertex(x[w],y[w]);
            texture2.curveVertex(x[w], y[w]);

            texture2.endShape();
        }
        w++;
w = 0;
        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
           // Mz = Rz((Math.toRadians(360.0) - GHA2), Mz);
           //  Mz = Rz(Math.toRadians(360)- (-202.375), Mz);
            Mz = Rz((Math.toRadians(360.0) - GHA2), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry((Math.toRadians(90.0) - dec2), My);
        //      My =  Ry(( dec2), My);
            //   float alt = map(mouseX,width-width,width,0,90);
            vv =  VectorSpherical2Cartesian(Math.toRadians(alt2),Math.toRadians(L0) );
            //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture2.width, texture2.width - texture2.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture2.height,texture2.height - texture2.height);
            texture2.point(x[w],y[w]);
            texture2.noFill();
            texture2.stroke(0,0, 255);
            texture2.strokeWeight(2);
            texture2.beginShape();
            texture2.curveVertex(x[w],y[w]);
            texture2.curveVertex(x[w], y[w]);

            texture2.endShape();
        }
        w++;

     //   w++;
        
        
        w = 0;
        for( double L0 = -180.0; L0 <= 180.0; L0 += .1 )
        {
           // Mz = Rz(Math.toRadians(360.0) - (GHA2 + Math.toRadians(36.442675)), Mz);
            Mz = Rz(Math.toRadians(0.0), Mz);

// println(Mz[0][0] + " " + Mz[0][1] + " " + Mz[0][2]);
// println(Mz[1][0] + " " + Mz[1][1] + " " + Mz[1][2]);
// println(Mz[2][0] + " " + Mz[2][1] + " " + Mz[2][2]);

            My =  Ry(Math.toRadians(0), My);
            //   float alt = map(mouseX,width-width,width,0,90);
            vv =  VectorSpherical2Cartesian(Math.toRadians(-39.4),Math.toRadians(L0) );
            //   vv =  VectorSpherical2Cartesian(alt,Math.toRadians(L0) );


            vy =  MatrixVecProd( My, vv, vy );

            vyz =  MatrixVecProd( Mz, vy, vyz );



            wpt[w] = C2ELat( vyz[0], vyz[1], vyz[2]);
            wpt[w+1] = C2ELon( vyz[0], vyz[1], vyz[2]);

            WPT = toFloatArray(wpt);

            x[w] = map(WPT[w+1],radians(-180) ,radians(180),texture.width, texture.width - texture.width);
            y[w] = map(WPT[w],radians(-90),(radians(90)),texture.height,texture.height - texture.height);
            texture2.point(x[w],y[w]);
            texture2.noFill();
            texture2.stroke(255,255, 255);
            texture2.strokeWeight(1);
            texture2.beginShape();
            texture2.curveVertex(x[w],y[w]);
            texture2.curveVertex(x[w], y[w]);

            texture2.endShape();
        }
        w++;
        
        
        
        texture2.endDraw();
        
        
        
        
        
        
        
         
    }

public void renderGlobe() {



  Date OldDate = new Date("01/01/2000");
  Date TodaysDate = new Date();
  long mills_per_day = 1000*60*60*24;
  long day_diff = (TodaysDate.getTime() - OldDate.getTime())/mills_per_day;
//  println(TodaysDate.getTime()); // /mills_per_day);
//  println(day_diff);
  double dfrac = map(hour()+ 4 + norm(minute(),0,60)+ norm(second(), 0, 3600) ,0,24f,0,24f);

  double UT = dfrac;
 // double dfrac = map(hour() + norm(minute(),0,60)+ norm(second(), 0, 3600) ,0,24f,0,24f);
/////////// println(UT);
  dfrac = dfrac/24; // - (5/24);
//  println(hour());
//  println(dfrac);
 // GMST = 18.697374558 + 24.06570982441908 D
  double JD = day_diff + dfrac - 0.5f +  2451545;
//  double JD = day_diff + dfrac - 0.5; // +  2451545;
//  println(JD);
  double dwhole = (367*year()-(int)(7*(year()+(int)((month()+9)/12))/4) + (int)(275*month()/9)+day()-730531.5f);
// println(dwhole);
 //// double dwhole = 367*year() - (int)(1.75 * (year() + (int)(month() + 9)/12)) + (int)(275 * month()/9) + day() + ((hour() + 5)/24) - 730531.5;
//  println(dwhole);
  double SD = dwhole + dfrac;
//  println(SD);
 // double GMST = 280.46061837 + 360.98564746629 * (JD - 2451545);

// double GMST = 280.46061837 +( 360.98564746629 * (SD)) + (-77.461f);
   GMST = 280.46061837f +( 360.98564746629f * (SD)) + (sliderValue) + sliderValue5;

 ///////////////////////////  println((GMST));
double LMST = GMST - (-77.461f);

  GMST = (((GMST/360) - (int)GMST/360)*360);
 double T = 367 * year() - (int)(1.75f * (year() + (int)((month()+9)/12))) + (int)(275 * month()/9) + day() + UT/24 - 730531.5f;
 GHAaries = 0.9856474f * T + 15 * UT + 100.46062f;
  GHAaries = (((GHAaries/360) - (int)GHAaries/360)*360);
   GAST = GHAaries/15f;

/////////////// println("GHA Aries: " + GHAaries);
////// println("GAST: " + GAST);
//  println(sliderValue);
//  println((int)GMST);
float h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(61.751034f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(61.751034f)) * cos(radians( 165.46016f - (float)GMST));
//float h = sin(radians(39.425f)) * sin(radians(61.75169444f)) + cos(radians(39.425f)) * cos(radians(61.75169444f)) * cos(radians( 165.932325f - ((float)GMST)));
//float h = sin(radians(40.217f)) * sin(radians(60.330361111f)) + cos(radians(40.217f)) * cos(radians(60.330361111f)) * cos(radians( 21.757083333f - ((float)GMST)));

h = asin(h);
//float Az = (sin(radians(61.751033f)) - sin(radians(39.425f)) * sin((h)))/( cos(radians(39.425f)) * cos((h)));
float Az = (sin(radians(61.751033f)) - sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin((h)))/( cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos((h)));
/////////////////println(degrees(h));

//println(UT);
Az = acos(Az);
/////////////////println(degrees(Az));
  double hour = (GMST)/15;
/////////////////////////////  println(hour);
  double dec = hour - (int)hour;
  double min = dec * 60;
  double sec = (min - (int)min) * 60;
//////////////  println((int)hour + " " + ((int)min) + " " + (float)sec);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 /////////////////// println("Dubhe " +(int)hour + " " + min + "  " + (hour()+5)+ " " + minute() + " " + second() );

//   h = sin(radians(39.425f)) * sin(radians(49.92297222f)) + cos(radians(39.425f)) * cos(radians(49.92297222f)) * cos(radians( 51.409958333f - ((float)GMST)));
   h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(49.92297222f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(49.92297222f)) * cos(radians( 51.409958333f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
////////////////////  println("Mirfak " + (int)hour + " " + abs((float)min));

   //  h = sin(radians(39.425f)) * sin(radians(46.01255555f)) + cos(radians(39.425f)) * cos(radians(46.01255555f)) * cos(radians( 79.510583333f - ((float)GMST)));
    /////////////  h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(46.01255555f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(46.01255555f)) * cos(radians( 79.510583333f - ((float)GMST)));
     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(45.99799f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(45.99799f)) * cos(radians( 79.17225f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
///////////////////////////  println("Capella " + (int)hour + " " + abs((float)min));

  //   h = sin(radians(39.425f)) * sin(radians(28.026199f)) + cos(radians(39.425f)) * cos(radians(28.026199f)) * cos(radians( 116.329155f - ((float)GMST)));

     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(28.0262f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(28.0262f)) * cos(radians( 116.329155f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 /////////////////////// println("Pollux " + (int)hour + " " + abs((float)min) );

   //  h = sin(radians(39.425f)) * sin(radians(49.22355554666f)) + cos(radians(39.425f)) * cos(radians(49.22355554666f)) * cos(radians( -152.937708333f - ((float)GMST)));
     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(49.313267f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(49.313267f)) * cos(radians( -153.1147f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 /////////////////////////// println("Alkaid " + (int)hour + " " + abs((float)min));


    //  h = sin(radians(39.425f)) * sin(radians(38.80380555f)) + cos(radians(39.425f)) * cos(radians(38.80380555f)) * cos(radians( -80.6112916666f - ((float)GMST)));
      h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(38.80380555f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(38.80380555f)) * cos(radians( -80.6112916666f - ((float)GMST)));

    hour = degrees(h);
  dec = hour - (int)hour;
  min = (dec * 60);
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
//////////////////////////////  println("Vega " +(int)hour + " " + abs((float)min) + "  " + (hour()+5)+ " " + minute() + " " + second() );
  ///abs((float)min)


  hour = degrees(Az);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
///////////////  println((int)hour + " " + ((int)min) + " " + (float)sec);

            float t = radians((float)GAST ); // - radians(75); // + radians(180); // + radians(-77.461f);
  pushMatrix();
 // frame.addMouseWheelListener(new MouseWheelInput());
 pushBack = (float)sliderValue3;
  translate(width/2, height/2, pushBack);



  pushMatrix();
  noFill();
  stroke(255,200);
  strokeWeight(2);
    smooth();
    popMatrix();
  lights();
  pushMatrix();


rotateX(radians(90));
    rotateX( radians(-rotationX) );
  //  rotateX( radians(-sliderValue4) );
//    rotateY(radians( rotationY) );
       // rotateY(radians(270 - ((float)GAST*15) ));
        // rotateY(radians(270 ));
           rotateY(radians(270 ));
    if(flag==true) {
      //  rotateY(  (-t*1000));
  //    rotateY(radians(0 * rotationY) );
  //   rotateY(  radians(90));
   //   rotateY(  (t*1000));
 //  rotateY(radians( 77.4));
// println(GAST, "   ",LMST); //12:48 local = 10.000 GAST
      rotateY(radians( ( (float)(GAST)*15))+(77.4)) ; //+(77.4)) ;
     //   rotateY(radians(  (16.347*15))+(77.4)) ;
     //  rotateY(radians(( ( (float)GAST*15))) );
    }

  fill(200);
  noStroke();
  textureMode(IMAGE);
  texturedSphere(globeRadius, texture);
  popMatrix();
  popMatrix();
  rotationX += velocityX;
  rotationY += velocityY;
  velocityX *= 0.95f;
  velocityY *= 0.95f;

  // Implements mouse control (interaction will be inverse when sphere is  upside down)
  if(mousePressed){
    if(mouseY < height/2 && mouseX > width/2){ //confines mouse to upper screen half
   velocityX += (mouseY-pmouseY) * 0.01f;
   velocityY -= (mouseX-pmouseX) * 0.01f;
    }
  }

  }


public void renderGlobe2() {



  Date OldDate = new Date("01/01/2000");
  Date TodaysDate = new Date();
  long mills_per_day = 1000*60*60*24;
  long day_diff = (TodaysDate.getTime() - OldDate.getTime())/mills_per_day;
//  println(TodaysDate.getTime()); // /mills_per_day);
//  println(day_diff);
  double dfrac = map(hour()+ 4 + norm(minute(),0,60)+ norm(second(), 0, 3600) ,0,24f,0,24f);

  double UT = dfrac;
 // double dfrac = map(hour() + norm(minute(),0,60)+ norm(second(), 0, 3600) ,0,24f,0,24f);
//////////////// println(UT);
  dfrac = dfrac/24; // - (5/24);
//  println(hour());
//  println(dfrac);
 // GMST = 18.697374558 + 24.06570982441908 D
  double JD = day_diff + dfrac - 0.5f +  2451545;
//  double JD = day_diff + dfrac - 0.5; // +  2451545;
//  println(JD);
  double dwhole = (367*year()-(int)(7*(year()+(int)((month()+9)/12))/4) + (int)(275*month()/9)+day()-730531.5f);
// println(dwhole);
 //// double dwhole = 367*year() - (int)(1.75 * (year() + (int)(month() + 9)/12)) + (int)(275 * month()/9) + day() + ((hour() + 5)/24) - 730531.5;
//  println(dwhole);
  double SD = dwhole + dfrac;
//  println(SD);
 // double GMST = 280.46061837 + 360.98564746629 * (JD - 2451545);

// double GMST = 280.46061837 +( 360.98564746629 * (SD)) + (-77.461f);
  double GMST = 280.46061837f +( 360.98564746629f * (SD)) + (sliderValue) + sliderValue5;

 ///////////////////////////  println((GMST));
double LMST = GMST - (-77.461f);

  GMST = (((GMST/360) - (int)GMST/360)*360);
 double T = 367 * year() - (int)(1.75f * (year() + (int)((month()+9)/12))) + (int)(275 * month()/9) + day() + UT/24 - 730531.5f;
  double GHAaries = 0.9856474f * T + 15 * UT + 100.46062f;
  GHAaries = (((GHAaries/360) - (int)GHAaries/360)*360);
  double GAST = GHAaries/15f;

////////////////////// println("GHA Aries: " + GHAaries);
///////////////////////// println("GAST: " + GAST);
//  println(sliderValue);
//  println((int)GMST);
float h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(61.751034f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(61.751034f)) * cos(radians( 165.46016f - (float)GMST));
//float h = sin(radians(39.425f)) * sin(radians(61.75169444f)) + cos(radians(39.425f)) * cos(radians(61.75169444f)) * cos(radians( 165.932325f - ((float)GMST)));
//float h = sin(radians(40.217f)) * sin(radians(60.330361111f)) + cos(radians(40.217f)) * cos(radians(60.330361111f)) * cos(radians( 21.757083333f - ((float)GMST)));

h = asin(h);
//float Az = (sin(radians(61.751033f)) - sin(radians(39.425f)) * sin((h)))/( cos(radians(39.425f)) * cos((h)));
float Az = (sin(radians(61.751033f)) - sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin((h)))/( cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos((h)));
////////////////////////println(degrees(h));

//println(UT);
Az = acos(Az);
////////////////////println(degrees(Az));
  double hour = (GMST)/15;
/////////////////////////////  println(hour);
  double dec = hour - (int)hour;
  double min = dec * 60;
  double sec = (min - (int)min) * 60;
//////////////  println((int)hour + " " + ((int)min) + " " + (float)sec);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 //////////////////////// println("Dubhe " +(int)hour + " " + min + "  " + (hour()+5)+ " " + minute() + " " + second() );

//   h = sin(radians(39.425f)) * sin(radians(49.92297222f)) + cos(radians(39.425f)) * cos(radians(49.92297222f)) * cos(radians( 51.409958333f - ((float)GMST)));
   h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(49.92297222f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(49.92297222f)) * cos(radians( 51.409958333f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 ///////////////////// println("Mirfak " + (int)hour + " " + abs((float)min));

   //  h = sin(radians(39.425f)) * sin(radians(46.01255555f)) + cos(radians(39.425f)) * cos(radians(46.01255555f)) * cos(radians( 79.510583333f - ((float)GMST)));
    /////////////  h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(46.01255555f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(46.01255555f)) * cos(radians( 79.510583333f - ((float)GMST)));
     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(45.99799f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(45.99799f)) * cos(radians( 79.17225f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 /////////////////////////////// println("Capella " + (int)hour + " " + abs((float)min));

  //   h = sin(radians(39.425f)) * sin(radians(28.026199f)) + cos(radians(39.425f)) * cos(radians(28.026199f)) * cos(radians( 116.329155f - ((float)GMST)));

     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(28.0262f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(28.0262f)) * cos(radians( 116.329155f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 /////////////////////// println("Pollux " + (int)hour + " " + abs((float)min) );

   //  h = sin(radians(39.425f)) * sin(radians(49.22355554666f)) + cos(radians(39.425f)) * cos(radians(49.22355554666f)) * cos(radians( -152.937708333f - ((float)GMST)));
     h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(49.313267f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(49.313267f)) * cos(radians( -153.1147f - ((float)GMST)));

   h = asin(h);
  hour = degrees(h);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 //////////////////////// println("Alkaid " + (int)hour + " " + abs((float)min));


    //  h = sin(radians(39.425f)) * sin(radians(38.80380555f)) + cos(radians(39.425f)) * cos(radians(38.80380555f)) * cos(radians( -80.6112916666f - ((float)GMST)));
      h = sin(radians((float)sliderValue2 + (float)sliderValue4)) * sin(radians(38.80380555f)) + cos(radians((float)sliderValue2 + (float)sliderValue4)) * cos(radians(38.80380555f)) * cos(radians( -80.6112916666f - ((float)GMST)));

    hour = degrees(h);
  dec = hour - (int)hour;
  min = (dec * 60);
  sec = (min - (int)min) * 60;
 // println((int)hour + " " + ((int)min) + " " + (float)sec);
 /////////////////////////// println("Vega " +(int)hour + " " + abs((float)min) + "  " + (hour()+5)+ " " + minute() + " " + second() );
  ///abs((float)min)


  hour = degrees(Az);
  dec = hour - (int)hour;
  min = dec * 60;
  sec = (min - (int)min) * 60;
///////////////  println((int)hour + " " + ((int)min) + " " + (float)sec);

            float t = radians((float)GMST ); // - radians(75); // + radians(180); // + radians(-77.461f);
  pushMatrix();
 // frame.addMouseWheelListener(new MouseWheelInput());
 pushBack = (float)sliderValue3;
  translate(width/2, height/2, pushBack);



  pushMatrix();
  noFill();
  stroke(255,200);
  strokeWeight(2);
    smooth();
    popMatrix();
  lights();
  pushMatrix();


rotateX(radians(90));
    rotateX( radians(-rotationX) );
  //  rotateX( radians(-sliderValue4) );
    rotateY(radians(270 - rotationY) );
      //  rotateY(radians(270 ) );
        rotateY(radians(270 ));
    if(flag==true) {
     //   rotateY(  degrees(-t));
     rotateY(radians( - rotationY) );
    }

  fill(200);
  noStroke();
  textureMode(IMAGE);
//  texturedSphere(globeRadius, texture);
//    texturedSphere2(602.0f, texture2);
     texturedSphere2(595.0f, texture2);
  popMatrix();
  popMatrix();
  rotationX += velocityX;
  rotationY += velocityY;
  velocityX *= 0.95f;
  velocityY *= 0.95f;

  // Implements mouse control (interaction will be inverse when sphere is  upside down)
  if(mousePressed){
    if(mouseY < height/2 && mouseX > width/2){ //confines mouse to upper screen half
   velocityX += (mouseY-pmouseY) * 0.01f;
   velocityY -= (mouseX-pmouseX) * 0.01f;
    }
  }

  }


//}
public void controlEvent(ControlEvent Event) {


 if(Event.isController()) {

             if(Event.getController().getName()=="pushback") {
                sliderValue3 = (int)(Event.getController().getValue());
            }
  if(Event.getController().getName()=="Clock") {
 if(Event.getController().getValue()==1)
 flag = true;
 sliderValue3 = (int)(336.84);
// sliderValue3 = (int)(-100);
 }
  if(Event.getController().getValue()==0) {
 flag = false;
  sliderValue3 = (int)(-100);
 }
 }
}



public void initializeSphere(int res)
{
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];

  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }

  float delta = (float)SINCOS_LENGTH/res;
  float[] cx = new float[res];
  float[] cz = new float[res];

  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
    cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
  }

  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;

  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (SINCOS_LENGTH*0.5f)/res;
  float angle = angle_step;

  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
    float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}

// Generic routine to draw textured sphere
public void texturedSphere(float r, PGraphics t) {
  int v1,v11,v2;
  r = (r + 240 ) * 0.33f;
  beginShape(TRIANGLE_STRIP);
  texture(t);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0,v=iv;
  for (int i = 0; i < sDetail; i++) {
    vertex(0, -r, 0,u,0);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0,u,0);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();

  // Middle rings
  int voff = 0;
  for(int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }

    // Close each ring
    v1=v11;
    v2=voff;
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;

  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    vertex(0, r, 0,u,v+iv);
    u+=iu;
  }
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
  endShape();

}

public void initializeSphere2(int res)
{
  sinLUT = new float[SINCOS_LENGTH];
  cosLUT = new float[SINCOS_LENGTH];

  for (int i = 0; i < SINCOS_LENGTH; i++) {
    sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
    cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
  }

  float delta = (float)SINCOS_LENGTH/res;
  float[] cx = new float[res];
  float[] cz = new float[res];

  // Calc unit circle in XZ plane
  for (int i = 0; i < res; i++) {
    cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
    cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
  }

  // Computing vertexlist vertexlist starts at south pole
  int vertCount = res * (res-1) + 2;
  int currVert = 0;

  // Re-init arrays to store vertices
  sphereX = new float[vertCount];
  sphereY = new float[vertCount];
  sphereZ = new float[vertCount];
  float angle_step = (SINCOS_LENGTH*0.5f)/res;
  float angle = angle_step;

  // Step along Y axis
  for (int i = 1; i < res; i++) {
    float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
    float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
    for (int j = 0; j < res; j++) {
      sphereX[currVert] = cx[j] * curradius;
      sphereY[currVert] = currY;
      sphereZ[currVert++] = cz[j] * curradius;
    }
    angle += angle_step;
  }
  sDetail = res;
}

// Generic routine to draw textured sphere
public void texturedSphere2(float r, PGraphics t) {
  int v1,v11,v2;
  r = (r + 240 ) * 0.33f;
  beginShape(TRIANGLE_STRIP);
  texture(t);
  float iu=(float)(t.width-1)/(sDetail);
  float iv=(float)(t.height-1)/(sDetail);
  float u=0,v=iv;
  for (int i = 0; i < sDetail; i++) {
    vertex(0, -r, 0,u,0);
    vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
    u+=iu;
  }
  vertex(0, -r, 0,u,0);
  vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
  endShape();

  // Middle rings
  int voff = 0;
  for(int i = 2; i < sDetail; i++) {
    v1=v11=voff;
    voff += sDetail;
    v2=voff;
    u=0;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int j = 0; j < sDetail; j++) {
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
      u+=iu;
    }

    // Close each ring
    v1=v11;
    v2=voff;
    vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
    endShape();
    v+=iv;
  }
  u=0;

  // Add the northern cap
  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i = 0; i < sDetail; i++) {
    v2 = voff + i;
    vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
    vertex(0, r, 0,u,v+iv);
    u+=iu;
  }
  vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
  endShape();

}

class TableOne
{
  //  public String fieldOne;
  //  public int fieldTwo;
      public String one;
      public double two;
      public double three;

    public String hip;
      public String con;
      public String proper;
      public double dec;
      public double ra;
    public String toString ()
    {
            return String.format("StarName: %s MeridianAngle: %d Declination: %d", proper, ra, dec);


  }
}

    //Funcition to convert double[] to float[]
    float[] toFloatArray(double[] arr) {
        if (arr == null) return null;
        int n = arr.length;
        float[] ret = new float[n];
        for (int i = 0; i < n; i++) {
            ret[i] = (float)arr[i];
        }
        return ret;
    }
// end of function to convert double[] to float[]


    double[] VectorSpherical2Cartesian(double B, double L){

        double v[] = new double[3];
        v[0] = Math.cos(B) * Math.cos(L);
        v[1] = Math.cos(B) * Math.sin(L);
        v[2] = Math.sin(B);
//   println(B);
//   println(L);
        return(v);

    }

    public double C2ELat( double x, double y, double z )
    {
        double[]res = new double[3];
        res[0] = Math.sqrt( x*x+y*y+z*z);  //R
//*B = ASIN(z/(*R));
        res[1] = Math.atan2( z, Math.sqrt(x*x+y*y) ); //B
        res[2] = Math.atan2( y, x ); //L

//println("R:  " + (res[0]) + "  B: " + Math.toDegrees(res[1]) + "  L: " + Math.toDegrees(res[2]));

        return (res[1]);
//println(R);
    }

    public double C2ELon( double x, double y, double z )
    {
        double[]res = new double[3];
        res[0] = Math.sqrt( x*x+y*y+z*z);  //R
//*B = ASIN(z/(*R));
        res[1] = Math.atan2( z, Math.sqrt(x*x+y*y) ); //B
        res[2] = Math.atan2( y, x ); //L

//println("R:  " + (res[0]) + "  B: " + Math.toDegrees(res[1]) + "  L: " + Math.toDegrees(res[2]));

        return (res[2]);
//println(R);
    }

//public double[] E2C( double B, double L, double R, double x, double y, double z )

    public double[] E2C( double B, double L, double R )
    {
        double[]res = new double[3];

        res[0] = R*Math.cos((B))*Math.cos((L));
        res[1] = R*Math.cos((B))*Math.sin((L));
        res[2] = R*Math.sin((B));

// println(res[0] + " " + res[1] + " " + res[0]);

        return(res);
    }

    public double[][] Rx( double a, double[][] M ){

        M[0][0] = 1.0;
        M[1][0] = 0.0;
        M[2][0] = 0.0;
        M[0][1] = 0.0;
        M[1][1] = Math.cos(a); //Math.cos(Math.toRadians(a));
        M[2][1] = Math.sin(a); //Math.sin(Math.toRadians(a));
        M[0][2] = 0.0;
        M[1][2] = -Math.sin(a); //-Math.sin(Math.toRadians(a));
        M[2][2] = Math.cos(a); //Math.cos(Math.toRadians(a));

        return(M);
    }

    public double[][] Ry( double a, double[][] M ){

        M[0][0] = Math.cos(a);
        M[1][0] = 0.0;
        M[2][0] = -Math.sin(a);
        M[0][1] = 0.0;
        M[1][1] = 1.0;
        M[2][1] = 0.0;
        M[0][2] = Math.sin(a);
        M[1][2] = 0.0;
        M[2][2] = Math.cos(a);

        return(M);
    }

    public double[][] Rz( double a, double[][] M ){

        M[0][0] = Math.cos(a); //Math.cos(a);
        M[1][0] = Math.sin(a);
        M[2][0] = 0.0;
        M[0][1] = -Math.sin(a);
        M[1][1] = Math.cos(a);
        M[2][1] = 0.0;
        M[0][2] = 0.0;
        M[1][2] = 0.0;
        M[2][2] = 1.0;

        return(M);
    }

    public double[] MatrixVecProd( double[][] A, double[] v, double[] res ) {

        int i,j;
        int n = 3;

        for( i=0; i<n; i++ ) {
            res[i] = 0.0;
            for( j=0; j<n; j++ ) {
                res[i] += A[i][j]*v[j];

            }
        }

        return (res);
    }