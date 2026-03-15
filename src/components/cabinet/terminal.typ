#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// A terminal or connector block component for electrical connections.
///
/// Draws a vertical terminal block with two connection points and an optional label. 
/// These are typically used for connecting external field wires to internal cabinet 
/// wiring or for distributing power.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - label (string): Terminal label (displayed vertically); default: "".
/// - text-color (color, none): Label color; default: auto-selected based on fill.
/// - width (length): Terminal width; default: 0.4.
/// - height (length): Terminal height; default: 1.8.
/// - fill (color): Terminal body color; default: gray.
/// - text-size (length): Label font size; default: 3pt.
/// - ..params (any): Additional style parameters like stroke.
///
/// *Anchors:*
/// - p1: Top connection point.
/// - p2: Bottom connection point.
/// - left: Middle left anchor.
/// - right: Middle right anchor.
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

/// Creates a sequence of terminal blocks placed side-by-side.
///
/// - name (string): Prefix for the terminal names.
/// - node (position, string): Starting position of the first terminal.
/// - labels (array): List of strings for the terminal labels.
/// - dir (string): Direction of the strip; default: "right".
/// - fill (color): Color for all terminals; default: gray.
/// - ..params (any): Passed to the individual terminal components.
#let terminal_strip(name, node, labels, dir: "right", fill: gray, ..params) = {
  let w = params.at("width", default: 0.4)
  
  for i in range(labels.len()) {
    let l = labels.at(i)
    let offset = i * w
    let pos = if dir == "right" {
      (rel: (offset, 0), to: node)
    } else {
      (rel: (0, -offset), to: node)
    }
    
    terminal(name + "-" + str(i + 1), pos, label: l, fill: fill, ..params)
  }
}
