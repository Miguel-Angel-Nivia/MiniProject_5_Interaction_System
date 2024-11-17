// Particles System
ArrayList<Float> mass = new ArrayList<Float>();
ArrayList<Float> positionX = new ArrayList<Float>();
ArrayList<Float> positionY = new ArrayList<Float>();
ArrayList<Float> velocityX = new ArrayList<Float>();
ArrayList<Float> velocityY = new ArrayList<Float>();
boolean activador = true;
int particlesToAdd = 0;
int particlesPerFrame = 2;
int particlesDelayCounter = 0;

// Particles Methods
void addNewParticle() {
  mass.add(random(0.003, 0.03));
  positionX.add((float)  width/2);
  positionY.add((float) height/2);
  velocityX.add(random(0.003, 0.03));
  velocityY.add(random(0.003, 0.03));
}

void particlesDelay() {
  if (particlesToAdd > 0 && particlesDelayCounter % 2 == 0) {
    for (int i = 0; i < particlesPerFrame && particlesToAdd > 0; i++) {
      addNewParticle();
      particlesToAdd--;
    }
  }
  particlesDelayCounter++;
}

void particlesGen() {
  for (int particleA = 0; particleA < mass.size(); particleA++) {
    float accelerationX = 0, accelerationY = 0;
    for (int particleB = 0; particleB < mass.size(); particleB++) {
      if (particleA != particleB) {
        float distanceX = positionX.get(particleB) - positionX.get(particleA);
        float distanceY = positionY.get(particleB) - positionY.get(particleA);
        float distance = sqrt(distanceX * distanceX + distanceY * distanceY);
        if (distance < 1) distance = 1;
        float force = (distance - 320) * mass.get(particleB) / distance;
        accelerationX += force * distanceX;
        accelerationY += force * distanceY;
      }
    }
    velocityX.set(particleA, velocityX.get(particleA) * 0.99 + accelerationX * mass.get(particleA));
    velocityY.set(particleA, velocityY.get(particleA) * 0.99 + accelerationY * mass.get(particleA));
  }
  
  // Set particle color before drawing
  noStroke();
  fill(64, 255, 255, 192);
  
  for (int particle = 0; particle < mass.size(); particle++) {
    positionX.set(particle, positionX.get(particle) + velocityX.get(particle));
    positionY.set(particle, positionY.get(particle) + velocityY.get(particle));
    ellipse(positionX.get(particle), positionY.get(particle), 
            mass.get(particle) * 1000, mass.get(particle) * 1000);
  }
}

void agentClicked() {
  // Limpiar tanto los agentes como su capa
  agents.clear();
  agentLayer.beginDraw();
  agentLayer.background(32);
  agentLayer.endDraw();
  
  agentsToAdd = 6;
  agentDelayCounter = 0;
  isGenerating = true;
}
