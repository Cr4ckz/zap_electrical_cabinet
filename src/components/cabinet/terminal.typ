#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// A terminal/connector block component for electrical connections.
///
/// Draws a vertical terminal block with two connection points and optional label.
/// Commonly used for wire connections and power distribution in control cabinets.
///
/// - name (string): Component identifier/name
/// - node (position|string): Placement position or anchor point
/// - label (string): Terminal label (displayed vertically); default: ""
/// - text-color (color|none): Text color; default: auto-selected based on fill color
/// - width (length): Terminal width; default: 0.4
/// - height (length): Terminal height; default: 1.8
/// - fill (color): Terminal fill color; default: gray
/// - text-size (length): Label font size; default: 3pt
///parameter(stroke, etc.)
#let terminal(name, node, label: "", text-color: none, ..params) = {
  
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 0.4)
    let h = style.at("height", default: 1.8)
    let col = style.at("fill", default: gray)
    let t-size = style.at("text-size", default: 3pt)

    interface((-w / 2, -h / 2), (w / 2, h / 2))

    anchor("p1", (0, h / 2))
    anchor("p2", (0, -h / 2))
    anchor("left", (-w / 2, 0))
    anchor("right", (w / 2, 0))

    let stroke-col = if col == black { gray.darken(50%) } else { col.darken(40%) }
    rect((-w / 2, -h / 2), (w / 2, h / 2), fill: col, stroke: stroke-col + 0.5pt, radius: 0.03, name: "body")

    let hole-col = if col == black { gray.darken(20%) } else { col.darken(20%) }
    rect((-w / 2 + 0.08, h / 2 - 0.2), (w / 2 - 0.08, h / 2 - 0.05), fill: hole-col, stroke: none)
    rect((-w / 2 + 0.08, -h / 2 + 0.05), (w / 2 - 0.08, -h / 2 + 0.2), fill: hole-col, stroke: none)

    if label != "" {
      let tc = if text-color != none { text-color } else if col == black or col == rgb("#8B4513") { white } else {
        black
      }


      content("body.center", text(size: t-size, weight: "bold", fill: tc, label), angle: 90deg)
    }
  }

  component("terminal", name, node, draw: draw, ..params)
}
