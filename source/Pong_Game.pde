import processing.sound.*;

float y_credits;
float x_credits;

SoundFile balloon_sound_file;
SoundFile airplane_sound_file;
SoundFile[] main_level_music_file = new SoundFile[5];
float song_duration;
float time_song_started;

SoundFile current_song;

boolean game_over;

int ball_size;

int paddle_width;
int paddle_elevation;

int paddle_left_pos;

int status_bar_height;

float xBall;
float yBall;

float ball_angle;
float ball_speed;
float ball_min_angle;

int level_number;

int level_duration;
int time_since_start;
int time_since_level_started;
int time_beginning_of_level;

PFont font_timer;
PFont font_status_bar;
PFont font_game_over;
PFont font_credits;



void setup() { 
  
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font_timer = createFont("AgencyFB-Bold-55.vlw", 500);
  font_status_bar = createFont("OCRAExtended-30.vlw", 25);
  font_game_over= createFont("OCRAExtended-48.vlw", 100);

  // set canvas size
  size(1000,720);

  font_credits = createFont("OCRAExtended-48.vlw", 100);
  x_credits = width/2;
  y_credits = 600;
  
  status_bar_height = 50;

  // Load a soundfile from the /data folder of the sketch and play it back
  balloon_sound_file = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/Balloon.mp3");
  airplane_sound_file = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/Airplane.mp3");

  main_level_music_file[0] = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/A_Journey_Awaits.WAV");
  main_level_music_file[1] = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/DST-RailJet-LongSeamlessLoop.WAV");
  main_level_music_file[2] = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/DST-TowerDefenseTheme.WAV");
  main_level_music_file[3] = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/Lines_of_Code.WAV");
  main_level_music_file[4] = new SoundFile(this, "C:/Joy/Processing/my programs/Pong Game/The_fact_I_can_converted.WAV");
 
  int song_number = int(random(main_level_music_file.length));
  current_song = main_level_music_file[song_number];

  song_duration = current_song.duration();
  time_song_started = millis();

  current_song.play();

  
  // setup ball 
  ball_size = 25;

  //paddle definition 
  paddle_width = 100;
  paddle_elevation = height - 30;
  
  level_number = 1; 
  
  //ball initialization
  xBall = 500;
  yBall = 250;

  ball_angle = - PI / 4;
  ball_speed = 3;
  ball_min_angle = PI / 16;

  //time initialization
  level_duration = 10;
  time_since_level_started = 0;
  time_beginning_of_level = 0;
  
  game_over = false;
}



void draw() {

  // check if song is done
  int current_time = millis();
  if( current_time > time_song_started + song_duration * 1000 ) {
  time_song_started = millis();
  current_song.play();
}
  
  
  paddle_left_pos = mouseX - paddle_width/2;
  
  // draw background
  background(0,0,0);
    
  //draw paddle
  stroke(255,255,255);
  fill(255,0,0);
  rect(paddle_left_pos,paddle_elevation,paddle_width,10);
  
  // draw ball
  stroke(255,255,255);
  fill(255,255,255);
  ellipse(xBall,yBall,ball_size,ball_size); 
  
  // ball movement
  xBall = xBall + ball_speed * cos(ball_angle);
  yBall = yBall - ball_speed * sin(ball_angle);


  // ball not hitting paddle
  if( ( yBall > height + ball_size ) && (( xBall < paddle_left_pos ) || (xBall > paddle_left_pos + paddle_width ) ) ) {

    // this is game over
    game_over = true;
  
    ball_speed = 0;

  }
  
  // ball hitting paddle
  if( ( yBall >= paddle_elevation ) && ( yBall < paddle_elevation + ball_speed) && ( xBall >= paddle_left_pos ) && (xBall <= paddle_left_pos + paddle_width ) && ( game_over == false ) ) {
    //if ball overshot under the paddle
    if(yBall > paddle_elevation) {
      // move ball right on top of paddle
      yBall = paddle_elevation;
    }

    ball_angle = ball_angle * ( -1 );

    float distance_from_paddle_center = (xBall - (paddle_left_pos + (paddle_width/2.0)));
    float angle_offset = distance_from_paddle_center / 180 * PI / 2;

    // if ball is going left, more negative than vertical
    if(ball_angle < -PI / 2) {
      ball_angle = ball_angle + angle_offset;
    }
    else {
      ball_angle = ball_angle - angle_offset;
    }
   
    // just in case angle ends up going down
    ball_angle = max(ball_angle, ball_min_angle);
    ball_angle = min(ball_angle, PI - ball_min_angle);
    
    airplane_sound_file.play();
  }

  
  
  // check for ball reaching out of bounds
  if( xBall >= width ) {
    //if ball overshot to the right
    if(xBall > width) {
      // move ball to the right edge
      xBall = width;
    }
    
    if( ball_angle < 0 ) {
        ball_angle = - PI - ball_angle;
    }
    else {
        ball_angle = PI - ball_angle;
    }
    
    balloon_sound_file.play();
  }


  if( yBall <= status_bar_height ) {
    //if ball overshot to the top
    if(yBall < status_bar_height) {
      // move ball to bottom of status bar
      yBall = status_bar_height;
    }    
    ball_angle = ball_angle * -1;
    balloon_sound_file.play();
  }
  
  if( xBall <= 0 ) {
    //if ball overshot to the left
    if(xBall < 0 ) {
      // move ball to the left edge
      xBall = 0;
    }

//    ball_angle = PI - ball_angle;
    if( ball_angle > 0 ) {
        ball_angle =  PI - ball_angle;
    }
    else {
        ball_angle = - PI - ball_angle;
    }

    balloon_sound_file.play();
  }


  if( game_over == false ) {

    // timer text
    fill(58, 168, 250, 100);
    textFont(font_timer);
    textAlign(CENTER, BOTTOM);
  
    // timer update
    time_since_start = millis();
    time_since_level_started = time_since_start - time_beginning_of_level;
  
    // if we are reaching the end of a level...
    if( time_since_level_started/1000 > level_duration ) {
      //...remember at what time the next level started 
      time_beginning_of_level = time_since_start;
      //... and update to the next level number
      level_number = level_number+1;
      // ...and increase ball speed
      ball_speed = ball_speed * 1.25;
  }
    else{
      text(level_duration - (time_since_level_started/1000), width/2, height); 
    }
  }
  else {
    // game over.
    // dont display timer 
    // dont update or display level  

    textFont(font_game_over, 50);
 
    fill(255, 0, 0);
    stroke(0);

    textAlign(CENTER);

    text("Game Over :(", x_credits, y_credits); 

    textFont(font_credits, 30);

    text("Credits:", x_credits, y_credits+300);
    text("Joy Oh", x_credits, y_credits+400);
    text("Bertrand Baud", x_credits, y_credits+450);

    textFont(font_credits, 25);

    text("*** click to restart ***", x_credits, max(height/2, y_credits+600) );

    y_credits--;

  }
  
  //************************
  // status bar
  //************************
  // draw status bar
  stroke(255,255,255);
  fill(255,255,255);
  rect(0,0,width,status_bar_height); 
  
  //status bar text 
  fill(58, 168, 250);
  textFont(font_status_bar);
  textAlign(LEFT, CENTER);
  text("Level: " + level_number, 5, status_bar_height/2); 
  //*********************
  // end status bar
  //*********************

}


void mouseClicked() {
    // reset everything
    // reset ball position and speed
    xBall = 500;
    yBall = 250;
  
    ball_angle = - PI / 4;
    ball_speed = 3;

    // reset level
    level_number = 1;
    
    // reset level
    level_number = 1;

    // reset timer
    time_since_level_started = 0;
    time_beginning_of_level = millis();

    game_over = false;
   
    y_credits = 600;

    current_song.stop();
    int song_number = int(random(main_level_music_file.length));
    current_song = main_level_music_file[song_number];
    song_duration = current_song.duration();
    time_song_started = millis();
    current_song.play();



 }