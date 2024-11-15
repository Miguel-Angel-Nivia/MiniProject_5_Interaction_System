// Background Agent System
ArrayList<Agent> agents;
float cw, ch;
int agentsToAdd = 8;
int agentDelayCounter = 0;
boolean isGenerating = false;
PGraphics agentLayer; // Capa separada para los agentes

class Agent {
  float r;
  float a;
  float dir;
  float c;
  float target;
  boolean die;
  
  Agent(float r, float a, float dir, float c) {
    this.r = r;
    this.a = a;
    this.dir = dir;
    this.c = c;
    this.target = 0;
    this.die = false;
  }
}

// Agent Methods
void agentGen() {
  ArrayList<Agent> tempAgents = new ArrayList<Agent>(agents);
  
  for (Agent agent : agents) {
    agentLayer.stroke(agent.c);
    agentLayer.strokeWeight(map(agent.r, 0, min(cw, ch), 0.5, 4));
    
    float x = agent.r * cos(radians(agent.a));
    float y = agent.r * sin(radians(agent.a));
    
    if (x > cw/2 || x < -cw/2 || y > ch/2 || y < -ch/2) {
      agent.die = true;
      continue;
    }
    
    float d = map(agent.r, 0, min(cw, ch), 5, 30);
    
    if (agent.target != 0) {
      float newAngle = agent.a + random(1, 2) * agent.dir;
      
      if (agent.dir == 1) {
        agentLayer.arc(0, 0, agent.r*2, agent.r*2, radians(agent.a), radians(newAngle));
      } else {
        agentLayer.arc(0, 0, agent.r*2, agent.r*2, radians(newAngle), radians(agent.a));
      }
      
      if (abs(newAngle - agent.target) < 1) {
        agent.target = 0;
      }
      agent.a = newAngle;
    } else {
      if (random(1) < 0.2) {
        agent.dir = random(1) < 0.5 ? -1 : 1;
        agent.target = agent.a + random(10, 30) * agent.dir;
      } else {
        agent.r += d * random(0.8, 1.5);
        float nx = agent.r * cos(radians(agent.a));
        float ny = agent.r * sin(radians(agent.a));
        agentLayer.line(x, y, nx, ny);
      }
    }
    
    if (random(1) < 0.01) {
      tempAgents.add(new Agent(agent.r, agent.a, agent.dir, random(160, 255)));
    }
  }
  
  for (int i = agents.size()-1; i >= 0; i--) {
    if (agents.get(i).die) {
      agents.remove(i);
    }
  }
  
  agents.addAll(tempAgents);
  tempAgents.clear();
}

void agentsDelay() {
  if (agentsToAdd > 0 && agentDelayCounter % 50 == 0) {
    addNewAgent(agentsToAdd * 90);
    agentsToAdd--;
    
    if (agentsToAdd <= 0) {
      isGenerating = false;
    }
  }
  agentDelayCounter++;
}

void addNewAgent(float angle) {
  agents.add(new Agent(0, angle, 1, random(160, 255)));
}
