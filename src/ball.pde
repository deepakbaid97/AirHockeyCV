
class ball{
  float x = width/2;
  float y = height/2;
  float xSpeed = random(2,7);
  float ySpeed = 5.4;

  void viewball(){
    fill(100);
    ellipse(x,y, 20,20);
  }
  
  
  void move(float left, float right){
    x = x + xSpeed;
    y = y + ySpeed;
    
    if((y > height -50 || y < 70) && ((x > right && x < right + 80) ||(x > left && x < left + 80)) ){
      ySpeed = ySpeed*-1;
      //println("board");
    }
    if(x<0 || x> width){
      xSpeed = xSpeed*-1;
      //println("wall");
    }
    if(y<0 || y>height){
      ySpeed = ySpeed*-1;
      //println("gravity");
    }
    
  }
}
