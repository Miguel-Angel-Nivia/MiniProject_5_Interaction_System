float rotX = 0;
float rotY = 0;
float distance = 400;
float pillarHeight = 200;
float pillarWidth = 60;
float spacing = 80;

// Variables para los pilares
float[] pillarProgress = {0, 0, 0, 0};
float animationSpeed = 0.01;
int currentPillar = 0;
boolean startNextPillar = false;
int delayBetweenPillars = 30;
int delayCounter = 0;

// Función de batería
void drawBattery(float w, float h, float d, float progress) {
  pushMatrix();
  
  // Cuerpo principal de la batería - fondo negro
  fill(0, 0, 20);
  box(w, h * 0.9, d);
  
  // Terminal superior de la batería (parte pequeña que sobresale)
  translate(0, -h/2.1, 0);
  fill(180, 10, 70); // Color plateado
  box(w * 0.4, h * 0.05, d);
  
  // Terminal superior plano de la batería
  translate(0, h * 0.016, 0); // Bajamos un poco desde la posición del terminal
  fill(180, 10, 70); // Color plateado
  box(w, h * 0.02, d);
  
  // Terminal inferior plano de la batería
  translate(0, h * .92, 0); // Nos movemos hacia abajo toda la altura de la batería
  fill(180, 10, 70); // Color plateado
  box(w, h * 0.02, d);
  
  // Volvemos a la posición para dibujar los segmentos
  translate(0, -h * 0.5, d/2 + 1);
  
  // Marco exterior verde
  strokeWeight(3);
  stroke(85, 95, 100);
  noFill();
  rect(-w/2.3, -h * 0.36, w * 0.85, h * 0.8);
  noStroke();
  
  // Dibujar 4 segmentos de batería
  float segmentHeight = (h * 0.8) / 4; // Altura de cada segmento
  float totalSegmentArea = h * 0.8; // Área total para los segmentos
  
  // Calcular cuántos segmentos deberían estar llenos basado en batteryDrain
  // 1525 mAh es el promedio, podemos establecer rangos
  float batteryPercentage = map(promedioBatteryDrain, 0, 4000, 0, 4); // Asumiendo 3000mAh como máximo
  
  for(int i = 0; i < 4; i++) {
    float yPos = -h * 0.4 + (i * segmentHeight);
    
    // Segmento verde de la batería
    if (progress * batteryPercentage > (3-i)) {  // Modificado para usar batteryDrain
      fill(85, 95, 100);
      rect(-w/2.6, yPos + 10, w * 0.75, segmentHeight - 4);
    }
  }
  
  // Añadir brillo en los bordes del marco
  stroke(85, 95, 100);
  noStroke();
  
  popMatrix();
}

void drawCloud(float w, float h, float d, float progress) {  // Añadido parámetro progress
  // Calcular el tamaño de la nube basado en el uso de datos
  // 929MB es el promedio, escalamos el tamaño según el uso
  float cloudScale = map(promedioDataUsage, 0, 2000, 0.7, 1.3); // Escala entre 0.7 y 1.3 veces el tamaño
  
  pushMatrix();
  
  // Escalar toda la nube según el progress y el uso de datos
  scale(progress * cloudScale);
  
  // Color blanco sólido para la nube
  fill(255);
  noStroke();
  
  // Configuración de luz suave
  lights();
  ambientLight(180, 180, 180);
  
  // Escalar toda la nube según el progress (esto permite que aparezca/desaparezca)
  scale(progress);
  
  // Estructura principal de la nube
  // Centro grande
  sphere(w * 0.4);
  
  // Lado izquierdo
  pushMatrix();
  translate(-w * 0.25, -h * 0.1, 0);
  sphere(w * 0.4);
  popMatrix();
  
  // Lado derecho
  pushMatrix();
  translate(w * 0.25, -h * 0.1, 0);
  sphere(w * 0.25);
  popMatrix();
  
  // Parte superior central
  pushMatrix();
  translate(0, -h * 0.2, 0);
  sphere(w * 0.2);
  popMatrix();
  
  // Detalles pequeños
  // Superior izquierdo
  pushMatrix();
  translate(-w * 0.6, -h * 0.15, 0);
  sphere(w * 0.15);
  popMatrix();
  
  // Superior derecho
  pushMatrix();
  translate(w * 0.35, -h * 0.15, 0);
  sphere(w * 0.15);
  popMatrix();
  
  // Pequeño detalle flotante (opcional)
  pushMatrix();
  translate(w * 0.4, h * 0.1, 0);
  sphere(w * 0.08);
  popMatrix();
  
  popMatrix();
}

// Función para configurar la iluminación
void setupCloudLighting() {
  // Luz ambiente suave
  ambientLight(180, 180, 180);
  // Luz direccional para dar volumen
  directionalLight(255, 255, 255, 0, 1, -1);
  // Ajustes para un acabado suave
  specular(255);
  shininess(1.0);
}

void drawClock(float w, float h, float d, float progress) {
  pushMatrix();
  
  // Posición del reloj
  translate(0, -h * 0.3, d/2 + 1);
  
  float scale = progress; // o usar una función de easing
  scale(scale);
  
  // Marco exterior del reloj
  stroke(40);
  strokeWeight(4);
  fill(240, 240, 255);
  circle(0, 0, w * 1.1);
  
  // Marco exterior 3D del reloj
  fill(220);
  stroke(40);
  strokeWeight(1);
  float frameThickness = 6;  // Grosor del marco
  for (float i = -frameThickness; i <= frameThickness; i += 0.5) {
    pushMatrix();
    translate(0, 0, i-6); // Crear capas de grosor en el marco
    circle(0, 0, w * 1.1);
    popMatrix();
  }
 
  
  // Dibujar marcas de minutos
  for (int i = 0; i < 60; i++) {
    float angle = radians(i * 6 - 90);
    float x1 = cos(angle) * w * 0.45;
    float y1 = sin(angle) * w * 0.45;
    float x2, y2;
    
    if (i % 5 == 0) {
      // Marcas más largas para las horas
      strokeWeight(2);
      x2 = cos(angle) * w * 0.43;
      y2 = sin(angle) * w * 0.43;
    } else {
      // Marcas cortas para los minutos
      strokeWeight(1);
      x2 = cos(angle) * w * 0.44;
      y2 = sin(angle) * w * 0.44;
    }
    
    line(x1, y1, x2, y2);
  }
  
  // Calcular tiempo real
  float hora = hour();
  float minuto = minute();
  float segundo = second();
  
  
  // Usar screenOnTime para mostrar una hora específica
  // 4 horas = promedioScreenOnTime
  float horasVisuales = map(promedioScreenOnTime, 0, 12, 0, 12); // Mapear a 12 horas
  float minutosVisuales = (horasVisuales - floor(horasVisuales)) * 60;
  
  // Ángulos para cada manecilla basados en screenOnTime
  float anguloHora = radians(floor(horasVisuales) * 30 + minutosVisuales * 0.5 - 90);
  float anguloMinuto = radians(minutosVisuales * 6 - 90);
  float anguloSegundo = radians(segundo * 6 - 90);
  
  // Manecilla de la hora
  stroke(0);
  strokeWeight(4);
  line(0, 0, cos(anguloHora) * w * 0.25, sin(anguloHora) * w * 0.25);
  
  // Manecilla del minuto
  strokeWeight(3);
  line(0, 0, cos(anguloMinuto) * w * 0.35, sin(anguloMinuto) * w * 0.35);
  
  // Manecilla del segundo
  stroke(255, 0, 0);  // Rojo para el segundero
  strokeWeight(2);
  line(0, 0, cos(anguloSegundo) * w * 0.4, sin(anguloSegundo) * w * 0.4);
  
  // Centro del reloj
  fill(255, 0, 0);
  noStroke();
  circle(0, 0, w * 0.03);
  
  
  popMatrix();
}

// Función para generar un color aleatorio con un rango de brillo específico
color randomColor(int minBrightness, int maxBrightness) {
  float hue = random(360);
  float saturation = random(60, 100);
  float brightness = random(minBrightness, maxBrightness);
  color c = color(hue, saturation, brightness);
  return c;
}

void drawStackedCubes(float w, float h, float d, float progress, int numCubesY, float spacing) {
  // Usar appsInstalled para determinar el número de cubos
  // 50 apps es el promedio
  int numCubesBasedOnApps = constrain(int(map(promedioAppsInstalled, 0, 100, 4, 12)), 4, 12);
  
  pushMatrix();
  
  float cubeSize = w/5;
  // Usar el número de apps instaladas para determinar la altura de la torre
  numCubesY = numCubesBasedOnApps;
  
  // Factor de separación (1.0 significa sin separación adicional)
  float spacingFactor = 1.0 + spacing;
  
  // Crear una matriz 3D para almacenar los colores
  color[][][] cubeColors = new color[3][numCubesY][3];
  
  // Generar colores aleatorios para cada cubo
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < numCubesY; y++) {
      for(int z = 0; z < 3; z++) {
        cubeColors[x][y][z] = randomColor(40, 90);
      }
    }
  }
  
  // Dibujar los cubos
  for(int y = 0; y < numCubesY; y++) {
    for(int x = -1; x <= 1; x++) {
      for(int z = -1; z <= 1; z++) {
        pushMatrix();
        // Aplicar la separación ajustada
        translate(
          x * cubeSize * spacingFactor, 
          y * cubeSize * spacingFactor - h/2, 
          z * cubeSize * spacingFactor
        );
        
        // Aplicar el color correspondiente
        fill(cubeColors[x+1][y][z+1]);
        //stroke(0);
        //strokeWeight(1);
        
        // Animar la aparición de los cubos basado en el progress
        float scaleY = constrain(map(progress * numCubesY - y, 0, 1, 0, 1), 0, 1);
        scale(1, scaleY, 1);
        
        // Dibujar el cubo
        box(cubeSize * 0.9);
        popMatrix();
      }
    }
  }
  
  popMatrix();
}


void updateAnimation() {
  // Actualizar cada pilar independientemente
  for (int i = 0; i < 4; i++) {
    if (pillarVisible[i] && pillarAnimating[i]) {
      if (pillarProgress[i] < 1.0) {
        pillarProgress[i] += animationSpeed;
        
        if (pillarProgress[i] >= 1.0) {
          pillarProgress[i] = 1.0;
          pillarAnimating[i] = false; // Detiene la animación cuando está completa
        }
      }
    }
  }
}
