class Particle {
  constructor(){
    this.x = random(0, width);
    this.y = random(0, height);
    this.r = random(1, 5);
    this.xSpeed = random(-10.9, 0.9);
    this.ySpeed = random(-0.9, 0.5);
  }

  createParticle() {
    noStroke();
    fill('rgba(255, 255, 255, 255)');
    circle(this.x, this.y, this.r);
  }

  moveParticle() {
    if (this.x < 0 || this.x > width)
      this.xSpeed *= -1;
    if (this.y < 0 || this.y > height)
      this.ySpeed *= -1;
    this.x += this.xSpeed;
    this.y += this.ySpeed;
  }

  joinParticles(particles) {
    particles.forEach(element => {
      let dis = dist(this.x, this.y, element.x, element.y);
      if (dis < 111) {
        let midX = (this.x + element.x) / 2;
        let midY = (this.y + element.y) / 2;
        let mouseDist = dist(mouseX, mouseY, midX, midY);
        if (mouseDist < 100) { // Adjust this threshold as needed
          stroke('rgba(255,255,255,0.5)');
          line(this.x, this.y, element.x, element.y);
        }
      }
    });
  }
}

let particles = [];

function setup() {
  // if (windowWidth > 768) {
    // createCanvas(windowWidth, windowHeight, WEBGL);

    let canvas = createCanvas(windowWidth, windowHeight, WEBGL);
    canvas.parent('canvasContainer');

    for (let i = 0; i < width / 5; i++) {
      particles.push(new Particle());
    }
    frameRate(30);
  // }
}

function draw() {
  // if (windowWidth > 768) {
    background('#1a1a1a');
    push();
    translate(-windowWidth/2, -windowHeight/2);
    for (let i = 0; i < particles.length/4; i++) {
      particles[i].createParticle();
      particles[i].moveParticle();
      particles[i].joinParticles(particles.slice(i));
    }
    noStroke();
    textAlign(CENTER);
    stroke(255);
    fill(255);
    textSize(50);
    pop();
  // }
  
  stroke(255);
  strokeWeight(2);
  noFill();
  push()
  translate(0, 0);
  
  for (let i = 0; i < 7; i++) {
    
    rotateX(noise(frameCount / 200)-i);
    rotateX(noise(frameCount / 280)-i);
    rotateZ(noise(frameCount / 290)-i);
    box(1500 * noise(frameCount / 200));
  }
  pop()
}

function windowResized() {
  // if (windowWidth > 768) {
    resizeCanvas(windowWidth, windowHeight);
  // }
}
