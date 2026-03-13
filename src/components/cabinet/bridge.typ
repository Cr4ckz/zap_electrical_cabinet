#import "/src/components/wire.typ": wire

/// Creates a bridge connection from a source pin to multiple target pins.
/// 
/// The bridge draws a horizontal or vertical line connecting all targets,
/// then creates perpendicular tap connections from the source and targets
/// to this bridge line.
///
/// - source (string|position): The source/input pin or position
/// - targets (array): Array of target/output pins or positions to connect
/// - offset (length): Distance of the bridge line from the target row/column; default: 0.8
/// - dir (string): Direction of offset - "y" for vertical offset (default), "x" for horizontal offset
/// - ..params: Additional style parameters (stroke, fill, etc.)
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