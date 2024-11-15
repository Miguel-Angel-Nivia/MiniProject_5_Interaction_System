// Variables para el suelo ondulante
int num = 52;
float s = 0.2;
float reflex = 0.2;
float aperture = 33;
color bg = color(0);
// Modificar los colores base para el suelo
color fg1 = color(100, 100, 100); // Gris medio
color fg2 = color(70, 70, 70);    // Gris más oscuro
float t = 0;
float[] aa;
float[] bb;
float transition = 0;

void reset() {
  for (int i = 0; i < bb.length; i++) {
    float v = random(1, 10);
    bb[i] = aa[i];
    aa[i] = random(2) < 1 ? v : -v;
  }
  transition = 1;
}

void drawWavyFloor() {
  t += 0.0008;
  transition *= (1-reflex);
  
  // Usar User_Behavior_Class para afectar la amplitud de las ondas
  float amplitudBase = map(promedioBehaviorClass, 1, 5, 20, 40); // Ajustar según rango de behavior class
  
  // Usar Age para afectar la velocidad de la animación
  float velocidadBase = map(promedioAge, 18, 60, 0.001, 0.0015); // Ajustar según rango de edad
  t += velocidadBase;
  
  float cellSize = width / (num - 1);
  strokeWeight(1);
  
  for (float z = 0; z < num; z++) {
    for (float x = 0; x < num; x++) {
      pushMatrix();
      
      // Calcular la posición base
      float xPos = x * cellSize;
      float zPos = z * cellSize;
      
      // Calcular la altura usando la amplitud basada en Behavior Class
      float h = amplitudBase * sin((aa[0]*x-aa[1]*z)/num+4.2*aa[4]*t+aa[6])
                   * cos((aa[2]*z+aa[3]*x)/num+aa[5]*t+aa[7]);
      float h2 = amplitudBase * sin((bb[0]*x-bb[1]*z)/num+4.2*bb[4]*t+bb[6])
                    * cos((bb[2]*z+bb[3]*x)/num+bb[5]*t+bb[7]);
      float yPos = lerp(h, h2, transition);
      
      translate(xPos, yPos/3, zPos);
      
      // Usar App_Usage_Time para afectar el color
      float colorIntensity = map(yPos, -amplitudBase, amplitudBase, 0, 1);
      
      // Crear colores basados en el uso de la app
      color colorBajo = color(180, 70, 80);  // Color para bajo uso
      color colorAlto = color(280, 80, 90);  // Color para alto uso
      color sphereColor = lerpColor(colorBajo, colorAlto, colorIntensity);
      
      // Ajustar el tamaño de las esferas según Data_Usage promedio
      float sphereSize = map(promedioDataUsage, 0, 2000, cellSize/5, cellSize/3);
      
      fill(sphereColor);
      specular(255);
      // Ajustar el brillo según Battery_Drain promedio
      shininess(map(promedioBatteryDrain, 0, 3000, 1, 10));
      
      // Dibujar esfera 3D con tamaño variable
      sphere(sphereSize);
      
      popMatrix();
    }
  }
}
