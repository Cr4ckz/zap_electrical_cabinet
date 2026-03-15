#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// An LED (Light Emitting Diode) indicator symbol for signal display.
///
/// Draws a simple LED with two connection points and optional label/color indication. 
/// Used for status indicators, alarms, or signal display in electrical schematics.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - label (string): LED label or description; default: "".
/// - color (color): LED visual color; default: red.
/// - text-size (length): Label font size; default: 3pt.
/// - ..params (any): Additional style parameters like width, height, or stroke.
///
/// *Anchors:*
/// - p1 / anode: Top connection point.
/// - p2 / cathode: Bottom connection point.
#let led(name, node, label: "", color: red, ..params) = {
  
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 0.4)
    let h = style.at("height", default: 0.8)
    let t-size = style.at("text-size", default: 3pt)

    interface((-w / 2, -h / 2), (w / 2, h / 2))

    anchor("p1", (0, h / 2))
    anchor("p2", (0, -h / 2))
    anchor("anode", (0, h / 2))
    anchor("cathode", (0, -h / 2))

    // LED body - filled circle
    circle((0, 0), radius: w / 2, fill: color, stroke: color.darken(30%) + 0.5pt, name: "body")

    // Connection lines
    line((0, h / 2), (0, w / 2), stroke: black + 0.5pt)
    line((0, -h / 2), (0, -w / 2), stroke: black + 0.5pt)

    // Light rays
    line((0.15, 0.15), (0.3, 0.3), stroke: color + 0.5pt)
    line((-0.15, 0.15), (-0.3, 0.3), stroke: color + 0.5pt)

    if label != "" {
      content((0.2, -h / 2), text(size: t-size, weight: "bold", label), anchor: "north")
    }
  }

  component("led", name, node, draw: draw, ..params)
}
