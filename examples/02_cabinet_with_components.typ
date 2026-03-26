#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create a 6-row cabinet
  cabinet("main", (0, 0), rows: 6)
  
  // Add DIN rail in slot 2
  dinrail("rail", (rel: (0.5, 0), to:("main.slot-2")))
  
  // Add power supply terminals
  terminal("L1", (rel: (0.5, 0), to: "rail.west"), label: "L", text-size: 10pt)
  terminal("N", (rel: (0.5, 0), to: "L1.east"), label: "N", text-size: 10pt)
  terminal("PE", (rel: (0.5, 0), to: "N.east"), label: "PE", text-size: 10pt)
  
  // Add a miniature circuit breaker
  mcb("CB1", (rel: (1.5, 0), to: "rail.west"), label: "C10", text-size: 10pt)
  
  // Add a relay
  relais("K1", (rel: (4, 0), to: "rail.west"), label: "24VDC")
  
  // Add a power supply
  psu("PSU1", (rel: (8, 0), to: "rail.west"), label: "24V/5A", height: 3, text-size: 10pt)
})
