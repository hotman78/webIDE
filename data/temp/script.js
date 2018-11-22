function preload(){
  img=loadImage("assets/WorldMap.png");
}
function setup(){
  console.log(a);
  createCanvas(windowWidth, windowHeight);
  console.log("a");
}
function draw(){
  background(255,0,0);
  image(img,0,0,width,height);
  for(var i=0;i<touches.length;i++){
    text(touches[i].id,touches[i].x,touches[i].y)
  }
}
