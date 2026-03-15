#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create a motor control circuit with protection
  dinrail("rail1", (0, 6))
  dinrail("rail2", (0, 3))
  dinrail("rail3", (0, 0))
  
  // Input protection
  terminal("L1", (rel: (0.5, 0), to: "rail1.west"), label: "L1", text-size: 9pt)
  terminal("L2", (rel: (0.5, 0), to: "L1.east"), label: "L2", text-size: 9pt)
  mcb("CB", (rel: (2, 0), to: "rail1.west"), label: "C16", text-size: 9pt)
  
  // Control circuit
  psu("PSU", (rel: (6, 0), to: "rail1.west"), label: "24VDC", height: 2.5, text-size: 9pt)
  
  // Motor contactors
  contactor("K1", (rel: (1, 0), to: "rail2.west"), label: "K1", text-size: 9pt)
  contactor("K2", (rel: (4, 0), to: "rail2.west"), label: "K2", text-size: 9pt)
  
  // Load outputs
  button("START", (rel: (1, 0), to: "rail3.west"), label: "Start")
  button("STOP", (rel: (2.5, 0), to: "rail3.west"), label: "Stop", button-type: "emergency")
  led("RUN", (rel: (4.5, 0), to: "rail3.west"), label: "Running", color: green, fill: green)
  
  // Status indication
  led("FAULT", (rel: (6, 0), to: "rail3.west"), label: "Fault", color: red, fill: red)
})
