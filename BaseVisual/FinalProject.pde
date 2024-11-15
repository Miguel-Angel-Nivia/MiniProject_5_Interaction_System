import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress pdAddress;
Table usersB;

boolean change_scene = false;
boolean[] pillarVisible = {false, false, false, false}; // Control de visibilidad de cada pilar
boolean[] pillarAnimating = {false, false, false, false}; // Estado de animación para cada pilar

int numRegistros = 0;
int promedioScreenOnTime = 0;
int promedioBatteryDrain = 0;
int promedioAppsInstalled = 0;
int promedioDataUsage = 0;

// Variables globales adicionales
float promedioBehaviorClass = 0; // Promedio de User_Behavior_Class
float promedioAge = 0; // Promedio de edad
float maxAppUsageTime = 0; // Máximo tiempo de uso de apps
  
void setup() {
  // Usar el tamaño más grande que necesites para ambas escenas
  fullScreen(P3D); // Usamos P3D ya que una de las escenas lo necesita
  smooth(8);
  
  // Inicializar ambas escenas
  setupScene1();
  setupScene2();
  dataBase();
}

void setupScene1() {
  // Configuración específica para la primera escena
  cw = width;
  ch = height;
  agents = new ArrayList<Agent>();
  
  // Inicializar la capa de agentes
  agentLayer = createGraphics(width, height);
  agentLayer.beginDraw();
  agentLayer.background(32);
  agentLayer.endDraw();
}

void dataBase(){
  // Inicializa oscP5 y configura la dirección de Pure Data
  oscP5 = new OscP5(this, 12000); // Puerto local en Processing
  pdAddress = new NetAddress("127.0.0.1", 8000); // Dirección y puerto de Pure Data

  // Cargar el archivo CSV
  usersB = loadTable("user_behavior_device.csv", "header, csv");
  println("Número de filas: " + usersB.getRowCount() + " Número de Columnas: " + usersB.getColumnCount());   
   
  // Info CSV
  for (TableRow row : usersB.rows()) {
    int User_ID = row.getInt(0);
    String Device_Model = row.getString(1);
    String Operating_System = row.getString(2);
    int App_Usage_Time = row.getInt(3);
    float Screen_On_Time = row.getFloat(4);
    int Battery_Drain = row.getInt(5);
    int Number_of_Apps_Installed = row.getInt(6);
    int Data_Usage = row.getInt(7);
    int Age = row.getInt(8);
    String Gender = row.getString(9);
    int User_Behavior_Class = row.getInt(10);

    println("User ID: " + User_ID + ", Device Model: " + Device_Model +
            ", Operating System: " + Operating_System + ", App Usage Time(min/day): " + App_Usage_Time +
            ", Screen On Time(hours/day): " + Screen_On_Time +
            ", Battery Drain(mAh/day): " + Battery_Drain + 
            ", Number of Apps Installed: " + Number_of_Apps_Installed + 
            ", Data_Usage(MB/day): " + Data_Usage + 
            ", Age: " + Age + ", Gender: " + Gender + ", User_Behavior_Class: " + User_Behavior_Class);
  }
  
  numRegistros = usersB.getRowCount();
  println("Número de registros: " + numRegistros);
  
    // Variables para calcular los promedios
  int totalScreenOnTime = 0;
  int totalBatteryDrain = 0;
  int totalAppsInstalled = 0;
  int totalDataUsage = 0;
  
    // Acumula los valores de cada fila
  for (TableRow row : usersB.rows()) {
    totalScreenOnTime += row.getFloat("Screen_On_Time");
    totalBatteryDrain += row.getInt("Battery_Drain");
    totalAppsInstalled += row.getInt("Number_of_Apps_Installed");
    totalDataUsage += row.getInt("Data_Usage");
  }

  // Calcula los promedios
  promedioScreenOnTime = totalScreenOnTime / numRegistros;
  promedioBatteryDrain = totalBatteryDrain / numRegistros;
  promedioAppsInstalled = totalAppsInstalled / numRegistros;
  promedioDataUsage = totalDataUsage / numRegistros;
  
    // Imprime los resultados
  println("Promedio de tiempo en pantalla (horas/día): " + promedioScreenOnTime);
  println("Promedio de battery drain (mAh/día): " + promedioBatteryDrain);
  println("Promedio de aplicaciones instaladas: " + promedioAppsInstalled);
  println("Promedio de datos usados (MB/día): " + promedioDataUsage);
  
  int totalBehavior = 0;
  int totalAge = 0;
  int maxUsage = 0;
  int countRows = 0;
  
  for (TableRow row : usersB.rows()) {
    totalBehavior += row.getInt("User_Behavior_Class");
    totalAge += row.getInt("Age");
    maxUsage = max(maxUsage, row.getInt("App_Usage_Time"));
    countRows++;
  }
  
  promedioBehaviorClass = totalBehavior / float(countRows);
  promedioAge = totalAge / float(countRows);
  maxAppUsageTime = maxUsage;

}

void setupScene2() {
  // Configuración específica para la segunda escena
  colorMode(HSB, 360, 100, 100);
  noStroke();
  frameRate(25);
  
  num = 32;
  aa = new float[8];
  bb = new float[aa.length];
  sphereDetail(8);
  
  reset(); // Asumiendo que esta función existe en tu código
}

void draw() {
  if (!change_scene) {
    drawScene1();
  } else {
    drawScene2();
  }
  
  if (mousePressed) {
    sendOSCMessage(mouseX, mouseY);
    // sendNumberList();
  }
  
}

void drawScene1() {
  // Fondo limpio para las partículas
    background(32);
    
    // Actualizar la capa de agentes con desvanecimiento
    agentLayer.beginDraw();
    agentLayer.fill(32, 32, 32, 5);
    agentLayer.noStroke();
    agentLayer.rect(0, 0, width, height);
    
    // Dibujar agentes en su propia capa
    if (isGenerating) {
      agentLayer.translate(cw/2, ch/2);
      agentsDelay();
      agentGen();
    }
    agentLayer.endDraw();
    
    // Dibujar la capa de agentes
    image(agentLayer, 0, 0);
    
    // Actualizar y dibujar partículas sobre todo
    particlesDelay();
    particlesGen();
}

void drawScene2() {
  background(bg);
  
  // Configuración de luces
  ambientLight(50, 50, 50);
  pointLight(255, 0, 255, width/2, height/2, 200);
  directionalLight(255, 255, 255, -1, 1, -1);
  
  // Configuración de la cámara principal
  camera(width/2, height/2 - 100, distance,
         width/2, height/2, 0,
         0, 1, 0);
  
  // Transformaciones globales
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  
  // Actualizar animación de pilares
  updateAnimation();
  
  // Dibujar el suelo ondulante 3D
  pushMatrix();
  translate(-width/2, 100, -width/2);
  drawWavyFloor();
  popMatrix();
  
  // Dibujar los pilares solo si están visibles
  for(int i = 0; i < 4; i++) {
    if (pillarVisible[i]) {  // Solo dibuja si el pilar está visible
      pushMatrix();
      float angle = (i * TWO_PI / 4);
      translate(cos(angle) * spacing, 0, sin(angle) * spacing);
      
      float hue = (i * 360/4) % 360;
      fill(hue, 80, 90);
      
      float currentHeight = pillarHeight;
      float animatedHeight = currentHeight * pillarProgress[i];
      
      translate(0, 50 - animatedHeight/2, 0);
      
      switch(i) {
        case 0:
          drawBattery(pillarWidth, animatedHeight, pillarWidth, pillarProgress[i]);
          break;
        case 1:
          drawCloud(pillarWidth, animatedHeight, pillarWidth, pillarProgress[i]);
          break;
        case 2:
          drawClock(pillarWidth, animatedHeight, pillarWidth, pillarProgress[i]);
          break;
        case 3:
          drawStackedCubes(pillarWidth, animatedHeight, pillarWidth, pillarProgress[i], 8, 0.2);
          break;
      }
      
      popMatrix();
    }
  }
}
  

void mouseDragged() {
  if(change_scene == true){
    rotY += (mouseX - pmouseX) * 0.01;
    rotX += (mouseY - pmouseY) * 0.01;
    rotX = constrain(rotX, -PI/3, PI/3);
  }

}

void mouseWheel(MouseEvent e) {
  if(change_scene == true){
  float factor = e.getCount();
  distance += factor * 20;
  distance = constrain(distance, 200, 800);
  }
}

void sendOSCMessage(int x, int y) {
  // Crea y envía el mensaje OSC
  OscMessage msg1 = new OscMessage("/mouseX");
  OscMessage msg2 = new OscMessage("/mouseY");
  msg1.add(x);
  msg2.add(y);
  oscP5.send(msg1, pdAddress);
  oscP5.send(msg2, pdAddress);
  //println("Mensaje OSC enviado: X = " + x + ", Y = " + y);
}


void keyPressed() {
  if (key == ' ') {
    change_scene = !change_scene;
  }
  // Control individual de pilares
  if (key >= '3' && key <= '6') {
    int pillarIndex = key - '3';
    pillarVisible[pillarIndex] = !pillarVisible[pillarIndex];
    
    // Si el pilar se hace visible, iniciamos su animación
    if (pillarVisible[pillarIndex]) {
      pillarProgress[pillarIndex] = 0; // Reinicia la animación
      pillarAnimating[pillarIndex] = true; // Inicia la animación
    }
  }
  if(key == '1'){
    if(change_scene == false){
      if (activador) {
      print(numRegistros);
      particlesToAdd = int(numRegistros);
      activador = false;
      agentClicked();
      }
    }
    OscMessage msg = new OscMessage("/Bubbles");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Bubbles enviado: 1");
  }
    if(key == '2'){
    OscMessage msg = new OscMessage("/Ocean");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Ocean enviado: 1");
  }
    if(key == '3'){
    OscMessage msg = new OscMessage("/Battery");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Battery enviado: 1");
  }
    if(key == '4'){
    OscMessage msg = new OscMessage("/Cloud");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Cloud enviado: 1");
  }
    if(key == '5'){
    OscMessage msg = new OscMessage("/Clock");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Clock enviado: 1");
  }
    if(key == '6'){
    OscMessage msg = new OscMessage("/Apps");
    msg.add(1);
    
    oscP5.send(msg, pdAddress);
    println("Mensaje a Apps enviado: 1");
  }
}
