#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create cabinet and DIN rails
  cabinet("main", (0, 0), rows: 6)
  dinrail("rail1", ((rel: (0.5, 0), to:("main.slot-2"))))
  dinrail("rail2", (rel: (0.5, 0), to:("main.slot-5")))
  
  // Components on DIN rails
  terminal("L", (rel: (0.5, 0), to: "rail1.west"), label: "L")
  mcb("CB1", (rel: (1.5, 0), to: "rail1.west"), label: "B10")
  psu("PSU", (rel: (5, 0), to: "rail1.west"), label: "24V PSU", height: 2)
  
  button("BTN", (rel: (0.5, 0), to: "rail2.west"), label: "Start")
  relais("K1", (rel: (3, 0), to: "rail2.west"), label: "K1")
  led("LED1", (rel: (6, 0), to: "rail2.west"), label: "Status", color: green)
  

  swire("L.p1", "CB1.p1", ratio: 0.5, label: "L1")
  

  zwire("CB1.p2", "PSU.L", ratio: 1)


  swire((rel: (0,-0.5), to:("PSU.L+")), "BTN.p1", stroke: red)
  

  zwire("BTN.p2", (rel:(0,0.5), to: ("K1.A1")), ratio: 1, stroke: red)
  wire((rel:(0,0.5), to: ("K1.A1")), "K1.A1", stroke: red)
  

  swire((rel: (0, -0.5), to: ("K1.12")),"PSU.L+",  stroke: red)
  wire("K1.12", (rel: (0, -0.5), to: ("K1.12")), stroke: red)

  swire((rel:(0, -1), to: ("K1.11")), "LED1.p2")
  wire((rel:(0, -1), to: ("K1.11")), "K1.11")

  swire("K1.A2", "PSU.M", ratio: 0.7, stroke: blue)
  swire("LED1.p1", "PSU.M", stroke: blue)
})