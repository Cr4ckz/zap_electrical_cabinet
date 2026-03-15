#import "/src/components/wire.typ": wire

/// Draws a power distribution bridge (busbar) that connects a source 
/// coordinate to multiple target coordinates via a common rail.
///
/// This component is ideal for distributing power (e.g., 24V or GND) 
/// from a single source to multiple components on a DIN rail without 
/// drawing individual wires for each path.
///
/// - source (coordinate): The origin of the power/signal (e.g., "PSU.L+").
/// - targets (array): A list of coordinates to be connected to the bridge 
///   (e.g., ("K1.11", "K1.A1", "H1.p1")).
/// - offset (float, length): The distance from the target points to the 
///   bridge rail. Use a negative value to place the bridge below the components.
/// - dir (string): The orientation of the bridge. 
///   - "y": Horizontal rail (offset along the Y-axis).
///   - "x": Vertical rail (offset along the X-axis).
/// - ..params (any): Arguments passed directly to the underlying `wire` 
///   calls (e.g., `stroke`, `name`).
#let bridge(source, targets, offset: 0.8, dir: "y", ..params) = {
  if targets.len() == 0 { return }
  
  let t1 = targets.at(0)
  let tn = targets.last()
  
  let off_vec = if dir == "y" { (0, offset) } else { (offset, 0) }
  

  let bridge_start = (rel: off_vec, to: t1)
  let bridge_end = (rel: off_vec, to: tn)
  
  wire(bridge_start, bridge_end, ..params)
  

  wire(source, (rel: off_vec, to: source), ..params)
  wire((rel: off_vec, to: source), bridge_start, ..params)
  

  for t in targets {
    let tap_point = (rel: off_vec, to: t)
    wire(t, tap_point, ..params)
  }
}