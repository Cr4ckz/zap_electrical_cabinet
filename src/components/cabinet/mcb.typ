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
/// - width (length): MCB body width; default: 1.0.
/// - height (length): MCB body height; default: 2.4.
/// - fill (color): Body fill color; default: rgb("#f5f5f5").
/// - text-size (length): Label font size; default: 3.5pt.
/// - ..params (any): Additional style parameters such as stroke.
///
/// *Anchors:*
/// - p1: Top connection terminal.
/// - p2: Bottom connection terminal.
#let mcb(name, node, label: "", ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 1.0)
    let h = style.at("height", default: 2.4)
    let col = style.at("fill", default: rgb("#f5f5f5"))
    
    interface((-w/2, -h/2), (w/2, h/2))

    anchor("p1", (0, h/2 - 0.2))
    anchor("p2", (0, -h/2 + 0.2))

    rect((-w/2, -h/2), (w/2, h/2), fill: col, stroke: gray + 0.5pt, radius: 0.05, name: "body")
    
    let port-col = col.darken(10%)
    rect((-w/2, h/2 - 0.4), (w/2, h/2), fill: port-col, stroke: gray + 0.5pt, radius: (top: 0.05))
    rect((-w/2, -h/2), (w/2, -h/2 + 0.4), fill: port-col, stroke: gray + 0.5pt, radius: (bottom: 0.05))
    
    circle((0, h/2 - 0.2), radius: 0.1, fill: gray.lighten(30%), stroke: gray)
    circle((0, -h/2 + 0.2), radius: 0.1, fill: gray.lighten(30%), stroke: gray)
    
    rect((-w/2 + 0.05, -0.6), (w/2 - 0.05, 0.6), fill: white, stroke: gray.lighten(20%) + 0.5pt, radius: 0.05)
    rect((-w/4, -0.15), (w/4, 0.15), fill: black, radius: 0.02)
    
    if label != "" {
      content((0, 0.4), text(size: style.at("text-size", default: 3.5pt), weight: "bold", label))
    }
  }
  component("mcb", name, node, draw: draw, ..params)
}