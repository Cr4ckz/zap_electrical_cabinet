#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// A Miniature Circuit Breaker (MCB) component for electrical protection.
///
/// Draws a DIN-rail mountable MCB with two connection points (top and bottom) 
/// and an optional label describing the breaker characteristics.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - label (string): Breaker label or rating (e.g., "B16"); default: "".
/// -phases (integer): Number of poles/phases; default: 1.
/// - label-bottom (string): Optional secondary label displayed below the main label; default: "".
/// - width (length): MCB body width; default: 1.0.
/// - height (length): MCB body height; default: 2.4.
/// - fill (color): Body fill color; default: rgb("#f5f5f5").
/// - text-size (length): Label font size; default: 3.5pt.
/// - text-size-bottom (length): Bottom label font size; default: 3pt.
/// - ..params (any): Additional style parameters such as stroke.
///
/// *Anchors:*
/// - p1: Top connection terminal.
/// - p2: Bottom connection terminal.
#let mcb(name, node, label: "", phases: 1, label-bottom: "", ..params) = {
  let draw(ctx, position, style) = {
    let p-w = 0.8 
    let w = phases * p-w
    let h = 2.4
    let col = style.at("fill", default: rgb("#f5f5f5"))
    
    // 1. Wir zeichnen zuerst das Hauptgehäuse und geben ihm einen Namen
    // Das sorgt dafür, dass CeTeZ den Bereich "kennt"
    rect((-w/2, -h/2), (w/2, h/2), 
      fill: col, 
      stroke: gray + 0.5pt, 
      radius: 0.05, 
      name: "bounds"
    )
    
    let port-h = 0.4
    rect((-w/2, h/2 - port-h), (w/2, h/2), fill: col.darken(10%), stroke: gray + 0.5pt, radius: (top: 0.05))
    rect((-w/2, -h/2), (w/2, -h/2 + port-h), fill: col.darken(10%), stroke: gray + 0.5pt, radius: (bottom: 0.05))
    
    rect((-w/2 + 0.1, -0.6), (w/2 - 0.1, 0.6), fill: white, stroke: gray.lighten(20%) + 0.5pt, radius: 0.05)
    

    rect((-w/2 + 0.2, -0.1), (w/2 - 0.2, 0.1), fill: black, radius: 0.02)


    for i in range(phases) {
      let x = -w/2 + (i + 0.5) * p-w
      
      circle((x, h/2 - 0.2), radius: 0.1, fill: gray.lighten(30%), stroke: gray)
      circle((x, -h/2 + 0.2), radius: 0.1, fill: gray.lighten(30%), stroke: gray)
      
      anchor("p1_" + str(i + 1), (x, h/2 - 0.2))
      anchor("p2_" + str(i + 1), (x, -h/2 + 0.2))
      

      if i == 0 {
        anchor("p1", (x, h/2 - 0.2))
        anchor("p2", (x, -h/2 + 0.2))
      }
    }

    if label != "" {
      content((0, 0.35), text(size: style.at("text-size", default: 4pt), weight: "bold", label))
    }

    if label-bottom != "" {
      content((0, -0.35), text(size: style.at("text-size-bottom", default: 4pt), weight: "bold", label-bottom))
    }
  }

  component("mcb", name, node, draw: draw, ..params)
}