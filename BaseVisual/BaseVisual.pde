import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress pdAddress;
Table usersB;

void setup() {
  size(400, 400);
  
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

}

void draw() {
  background(200);
  
  if (mousePressed) {
    sendOSCMessage(mouseX, mouseY);
    // sendNumberList();
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
  println("Mensaje OSC enviado: X = " + x + ", Y = " + y);
}

void sendNumberList() {
  // Crea y envía el mensaje OSC con una lista de números
  OscMessage msg = new OscMessage("/numbers");
  msg.add(125);
  
  oscP5.send(msg, pdAddress);
  println("Mensaje OSC enviado: 125");
}
