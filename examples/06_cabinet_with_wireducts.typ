
#import "/src/lib.typ": *

#circuit(debug: false, {
  cabinet("main", (0,0), rows: 7)
  
  // Oben und unten Kabelkanäle
  wireduct("duct-top", (rel: (0, 0), to: "main.slot-1"))
  wireduct("duct-top-vert", (rel: (0, -2), to: "main.slot-1"), orientation: "vertical", length:4)
  wireduct("duct-bottom", "main.slot-7")
  
  // Dazwischen Hutschienen
  dinrail("rail1", "main.slot-3")
  dinrail("rail2", "main.slot-5")
  
  // Ein horizontaler Kanal zwischen den Schienen
  wireduct("duct-mid", "main.slot-4")

  terminal("L1", (rel: (0.5, 0), to: "rail1.west"), fill: white, label: "Test", text-size: 10pt)
  
  mcb("CB1", (rel: (1.5, 0), to: "rail1.west"), label: "B123", text-size: 10pt)

  psu("G1", (rel: (5, 0), to: "rail1.west"), label: "Test", height: 3, width: 1.8, text-size: 10pt)

  psu("PSU2", (rel: (1.5, 0), to: "rail2.west"), plus_count: 4, minus_count: 4, width: 3.5, label: "PSU 24V", text-size: 10pt)

 generic_box("PLC1", (5, 0), 
    label: "S7-1200 CPU",
    width: 5.0,
    top_pins: (
      ("L+", "M", "PE", (fill: blue.lighten(90%))),
      ("I0.0", "I0.1", "I0.2", (fill: gray.lighten(80%)))
    ),
    bottom_pins: (
      ("L+", "M", (fill: blue.lighten(90%))),
      ("Q0.0", "Q0.1", (fill: orange.lighten(80%)))
    ),
    right_pins: (
      ("CAN-HIGH", "CAN-L", (fill: yellow.lighten(90%)))
    )
  )

  contactor("K1", (rel: (6, 0), to: "rail2.west"), label: "Hauptschütz\nMotor")
  


  
  set-style(wire: (stroke: blue))
  wire("CB1.p2",("duct-mid","-|","CB1.p2"))
  wire(("duct-mid","-|","L1.p2"),("duct-mid","-|","CB1.p2"))
  wire("L1.p2",("duct-mid","-|","L1.p2"))
  swire("CB1.p1", ("duct-top-vert", "-|", "duct-top"), ratio: 1, stroke: red)

  wire("PLC1.t1", ("duct-top", "-|", "PLC1.t1"))
  wire("PLC1.Q0_0", ("duct-mid", "-|", "PLC1.r1"))

  sstub("PSU2.L+")
  bridge("PLC1.CAN-L", ("PLC1.CAN-HIGH",), offset: 0.2, fill: none, dir: "x")
})

