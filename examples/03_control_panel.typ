#import "/src/lib.typ": *

#set page(width: auto, height: auto, margin: 10pt, fill: white)

#circuit(debug: false, {
  // Create a control panel layout
  // Top row: LED indicators
  led("LED1", (0, 4), label: "Power", color: green, fill: green)
  led("LED2", (1.5, 4), label: "Fault", color: red, fill: red)
  led("LED3", (3, 4), label: "Ready", color: yellow, fill: yellow)
  
  // Middle row: Buttons
  button("BTN1", (0, 2.5), label: "Start")
  button("BTN2", (1.5, 2.5), label: "Stop", button-type: "emergency")
  button("BTN3", (3, 2.5), label: "Reset")
  
  // Bottom row: Toggle switches
  switch("SW1", (0, 1), label: "Power", state: "closed")
  switch("SW2", (1.5, 1), label: "Mode", state: "open")
  selector("SEL1", (3, 1), label: "Position")
})
