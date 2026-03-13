#import "/src/lib.typ": *
#set page(width: auto, height: auto, margin: 5pt, fill: white)
#circuit(debug: false, {
  // ===== Cabinet Section =====
  cabinet("main", (0, 0), rows: 7)
  
  // Wireducts
  wireduct("duct-top", (rel: (-3, 0), to: "main.slot-1"), length: 8)
  wireduct("duct-bottom", "main.slot-7")
  
  // DIN Rails
  dinrail("rail1", "main.slot-3")
  dinrail("rail2", "main.slot-5")
  
  // Cabinet Components
  terminal("L1", (rel: (0.5, 0), to: "rail1.west"), fill: white, label: "L", text-size: 10pt)
  mcb("CB1", (rel: (1.5, 0), to: "rail1.west"), label: "B10", text-size: 10pt)
  psu("PSU1", (rel: (5, 0), to: "rail1.west"), label: "24V PSU", height: 3, width: 1.8, text-size: 10pt)
  
  psu("PSU2", (rel: (1.5, 0), to: "rail2.west"), plus_count: 3, minus_count: 3, width: 3.5, label: "Power", text-size: 10pt)
  
  relais("K1", (rel: (6, 0), to: "rail2.west"), label: "Relay")
  contactor("K2", (rel: (10, 0), to: "rail2.west"), label: "Motor\nContactor")

  // ===== Vertical Section =====
  // Vertical DIN rail
  dinrail("rail-vert", (16, 4), orientation: "vertical")
  
  // Vertical wireduct
  wireduct("duct-vert", (17.5, 4), orientation: "vertical", length: 6)
  
  // Wires connecting to vertical components
  set-style(wire: (stroke: black))
  wire("PSU1.L+", ("duct-vert", "-|", "PSU1.L+"))
  
  
  wire("K1.t1", ("duct-vert", "-|", "K1.t1"))
  wire(("duct-vert", "-|", "K1.t1"), ("rail-vert", "-|", "K1.t1"))

  // ===== New Components Section (External) =====
  
  // Bridge example
  set-style(wire: (stroke: blue))
  bridge("K2.14", ("K2.A2",), offset: -0.2,)
  zwire("PSU1.L+", "PSU2.L+", ratio: 0.5)
  
  // Row 1: LED indicators
  led("LED1", (9, 5), label: "Power", color: green, fill: green)
  led("LED2", (10.2, 5), label: "Fault", color: red, fill: red)
  led("LED3", (11.4, 5), label: "Status", color: yellow, fill: yellow)
  
  // Row 2: Buttons (momentary)
  set-style(wire: (stroke: black))
  button("BTN1", (9, 3.5), label: "Start")
  button("BTN2", (10.2, 3.5), label: "Stop", button-type: "emergency")
  
  // Row 3: Toggle Switches (on/off)
  switch("SW1", (9, 2), label: "Power", state: "closed")
  switch("SW2", (10.2, 2), label: "Mode", state: "open")
  
  // Row 4: Selector Switches (A/B toggle)
  selector("SE1", (9, 0.5), label: "Input", position: "a")
  selector("SE2", (10.5, 0.5), label: "Source", position: "b")

  // Generic Box example
  generic_box("PLC", (15, 0), 
    label: "Controller",
    width: 4.5,
    top_pins: (
      ("24V", "GND", (fill: blue.lighten(90%))), ("D_IN",)
    ),
    bottom_pins: (
      ("OUT1", "OUT2", "OUT3", (fill: orange.lighten(80%)))
    ),
    right_pins: (
      ("COM1", "COM2", (fill: gray.lighten(80%)))
    )
  )
})


```Typst
#circuit(debug: false, {
  // ===== Cabinet Section =====
  cabinet("main", (0, 0), rows: 7)
  
  // Wireducts
  wireduct("duct-top", (rel: (-3, 0), to: "main.slot-1"), length: 8)
  wireduct("duct-bottom", "main.slot-7")
  
  // DIN Rails
  dinrail("rail1", "main.slot-3")
  dinrail("rail2", "main.slot-5")
  
  // Cabinet Components
  terminal("L1", (rel: (0.5, 0), to: "rail1.west"), fill: white, label: "L", text-size: 10pt)
  mcb("CB1", (rel: (1.5, 0), to: "rail1.west"), label: "B10", text-size: 10pt)
  psu("PSU1", (rel: (5, 0), to: "rail1.west"), label: "24V PSU", height: 3, width: 1.8, text-size: 10pt)
  
  psu("PSU2", (rel: (1.5, 0), to: "rail2.west"), plus_count: 3, minus_count: 3, width: 3.5, label: "Power", text-size: 10pt)
  
  relais("K1", (rel: (6, 0), to: "rail2.west"), label: "Relay")
  contactor("K2", (rel: (10, 0), to: "rail2.west"), label: "Motor\nContactor")

  // ===== Vertical Section =====
  // Vertical DIN rail
  dinrail("rail-vert", (16, 4), orientation: "vertical")
  
  // Vertical wireduct
  wireduct("duct-vert", (17.5, 4), orientation: "vertical", length: 6)
  
  // Wires connecting to vertical components
  set-style(wire: (stroke: black))
  wire("PSU1.L+", ("duct-vert", "-|", "PSU1.L+"))
  
  
  wire("K1.t1", ("duct-vert", "-|", "K1.t1"))
  wire(("duct-vert", "-|", "K1.t1"), ("rail-vert", "-|", "K1.t1"))

  // ===== New Components Section (External) =====
  
  // Bridge example
  set-style(wire: (stroke: blue))
  bridge("K2.14", ("K2.A2",), offset: -0.2,)
  zwire("PSU1.L+", "PSU2.L+", ratio: 0.5)
  
  // Row 1: LED indicators
  led("LED1", (9, 5), label: "Power", color: green, fill: green)
  led("LED2", (10.2, 5), label: "Fault", color: red, fill: red)
  led("LED3", (11.4, 5), label: "Status", color: yellow, fill: yellow)
  
  // Row 2: Buttons (momentary)
  set-style(wire: (stroke: black))
  button("BTN1", (9, 3.5), label: "Start")
  button("BTN2", (10.2, 3.5), label: "Stop", button-type: "emergency")
  
  // Row 3: Toggle Switches (on/off)
  switch("SW1", (9, 2), label: "Power", state: "closed")
  switch("SW2", (10.2, 2), label: "Mode", state: "open")
  
  // Row 4: Selector Switches (A/B toggle)
  selector("SE1", (9, 0.5), label: "Input", position: "a")
  selector("SE2", (10.5, 0.5), label: "Source", position: "b")

  // Generic Box example
  generic_box("PLC", (15, 0), 
    label: "Controller",
    width: 4.5,
    top_pins: (
      ("24V", "GND", (fill: blue.lighten(90%))), ("D_IN",)
    ),
    bottom_pins: (
      ("OUT1", "OUT2", "OUT3", (fill: orange.lighten(80%)))
    ),
    right_pins: (
      ("COM1", "COM2", (fill: gray.lighten(80%)))
    )
  )
})
```
