#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create a basic 4-row cabinet
  cabinet("main", (0, 0), rows: 4)
  
  // Add DIN rails for component mounting
  dinrail("rail1", "main.slot-1")
  dinrail("rail2", "main.slot-3")
})
