#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create a basic 4-row cabinet
  cabinet("main", (0, 0), rows: 4)
  
  // Add DIN rails for component mounting
  dinrail("rail1", (rel: (0.5, 0), to:("main.slot-1")))
  dinrail("rail2", (rel: (0.5, 0), to:("main.slot-3")))
})
