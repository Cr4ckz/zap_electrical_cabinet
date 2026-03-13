#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// A push button component for manual control input.
///
/// Draws a push button symbol with two connection points and optional label.
/// Used for start/stop controls, manual triggers, and user interfaces in electrical circuits.
///
/// - name (string): Component identifier/name
/// - node (position|string): Placement position or anchor point
/// - label (string): Button label/description; default: ""
/// - button-type (string): Button appearance type - "normal" (default) or "emergency" (red)
/// - fill (color): Button fill color; default: gray.lighten(60%)
/// - text-size (length): Label font size; default: 3pt
/// - ..params: Additional style parameters (width, height, stroke, etc.)
#let button(name, node, label: "", button-type: "normal", ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 0.6)
    let h = style.at("height", default: 0.9)
    let t-size = style.at("text-size", default: 3pt)
    let button-col = if button-type == "emergency" {
      red.lighten(10%)
    } else {
      style.at("fill", default: gray.lighten(60%))
    }

    interface((-w / 2, -h / 2), (w / 2, h / 2))

    anchor("p1", (0, h / 2))
    anchor("p2", (0, -h / 2))

    // Button housing / frame
    rect(
      (-w / 2, -h / 2),
      (w / 2, h / 2),
      fill: gray.lighten(80%),
      stroke: gray + 0.5pt,
      radius: 0.05,
      name: "housing"
    )

    // Button cap / pressable part
    circle((0, 0), radius: w / 2.5, fill: button-col, stroke: gray.darken(10%) + 0.5pt, name: "cap")

    // Connection points
    line((0, h / 2), (0, w / 2.5 + 0.05), stroke: black + 0.5pt)
    line((0, -h / 2), (0, -(w / 2.5 + 0.05)), stroke: black + 0.5pt)

    if label != "" {
      content((0.2, -h / 2 - 0.05), text(size: t-size, weight: "bold", label), anchor: "north")
    }
  }

  component("button", name, node, draw: draw, ..params)
}

/// A switch component for toggled control input.
///
/// Draws a toggle switch symbol with two connection points and optional label.
/// Used for on/off controls, mode selection, and manual switching in electrical circuits.
///
/// - name (string): Component identifier/name
/// - node (position|string): Placement position or anchor point
/// - label (string): Switch label/description; default: ""
/// - state (string): Initial switch state - "open" or "closed" (default: "open")
/// - fill (color): Switch body fill color; default: gray.lighten(60%)
/// - text-size (length): Label font size; default: 3pt
/// - ..params: Additional style parameters (width, height, stroke, etc.)
#let switch(name, node, label: "", state: "open", ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 0.5)
    let h = style.at("height", default: 0.9)
    let t-size = style.at("text-size", default: 3pt)
    let switch-col = style.at("fill", default: gray.lighten(60%))

    interface((-w / 2, -h / 2), (w / 2, h / 2))

    anchor("p1", (0, h / 2))
    anchor("p2", (0, -h / 2))

    // Switch housing/frame
    rect(
      (-w / 2, -h / 2),
      (w / 2, h / 2),
      fill: gray.lighten(85%),
      stroke: gray + 0.5pt,
      radius: 0.03,
      name: "housing"
    )

    // Middle line
    line((-w / 2 + 0.08, 0), (w / 2 - 0.08, 0), stroke: gray.darken(20%) + 0.5pt)

    // Toggle arm connecting input and output
    if state == "closed" {
      // Connected when closed
      line((0, h / 2 - 0.25), (0, -h / 2 + 0.25), stroke: switch-col.darken(20%) + 1pt)
      circle((0, h / 2 - 0.15), radius: 0.08, fill: switch-col, stroke: switch-col.darken(20%) + 0.5pt)
    } else {
      // Disconnected when open
      circle((0, -h / 2 + 0.15), radius: 0.08, fill: switch-col, stroke: switch-col.darken(20%) + 0.5pt)
    }

    // Connection lines
    line((0, h / 2), (0, h / 2 - 0.25), stroke: black + 0.5pt)
    line((0, -h / 2), (0, -h / 2 + 0.25), stroke: black + 0.5pt)

    if label != "" {
      content((0.2, -h / 2 - 0.05), text(size: t-size, weight: "bold", label), anchor: "north")
    }
  }

  component("switch", name, node, draw: draw, ..params)
}

/// A selector/changeover switch component for selecting between two inputs.
///
/// Draws a 2-position selector switch with a common terminal and two selectable inputs.
/// Used for switching between different signal sources or power supplies.
///
/// - name (string): Component identifier/name
/// - node (position|string): Placement position or anchor point
/// - label (string): Switch label/description; default: ""
/// - position (string): Selector position - "a" (selects top input) or "b" (selects bottom input); default: "a"
/// - fill (color): Switch body fill color; default: gray.lighten(60%)
/// - text-size (length): Label font size; default: 3pt
/// - ..params: Additional style parameters (width, height, stroke, etc.)
#let selector(name, node, label: "", position: "a", ..params) = {
  let draw(ctx, position_val, style) = {
    let w = style.at("width", default: 0.6)
    let h = style.at("height", default: 1.2)
    let t-size = style.at("text-size", default: 3pt)
    let switch-col = style.at("fill", default: gray.lighten(60%))

    interface((-w / 2, -h / 2), (w / 2, h / 2))

    // Three terminals: common (bottom), input A (top), input B (middle)
    anchor("com", (0, -h / 2))
    anchor("a", (-w / 4, h / 2 - 0.2))
    anchor("b", (w / 4, h / 2 - 0.2))
    anchor("p1", (0, -h / 2))
    anchor("p2", (-w / 4, h / 2 - 0.2))
    anchor("p3", (w / 4, h / 2 - 0.2))

    // Switch housing/frame
    rect(
      (-w / 2, -h / 2),
      (w / 2, h / 2),
      fill: gray.lighten(85%),
      stroke: gray + 0.5pt,
      radius: 0.03,
      name: "housing"
    )

    // Contact points
    circle((-w / 4, h / 2 - 0.2), radius: 0.06, fill: gray.darken(20%), stroke: none)
    circle((w / 4, h / 2 - 0.2), radius: 0.06, fill: gray.darken(20%), stroke: none)
    circle((0, -h / 2 + 0.1), radius: 0.06, fill: gray.darken(20%), stroke: none)

    // Selector arm connecting common to selected input
    if position == "a" {
      line((0, -h / 2 + 0.1), (-w / 4, h / 2 - 0.2), stroke: switch-col.darken(20%) + 1.2pt)
      circle((-w / 4, h / 2 - 0.2), radius: 0.08, fill: switch-col, stroke: switch-col.darken(20%) + 0.5pt)
    } else {
      line((0, -h / 2 + 0.1), (w / 4, h / 2 - 0.2), stroke: switch-col.darken(20%) + 1.2pt)
      circle((w / 4, h / 2 - 0.2), radius: 0.08, fill: switch-col, stroke: switch-col.darken(20%) + 0.5pt)
    }

    // Connection lines to terminals
    line((0, -h / 2), (0, -h / 2 + 0.2), stroke: black + 0.5pt)
    line((-w / 4, h / 2), (-w / 4, h / 2 - 0.3), stroke: black + 0.5pt)
    line((w / 4, h / 2), (w / 4, h / 2 - 0.3), stroke: black + 0.5pt)

    if label != "" {
      content((0.2, -h / 2 - 0.14), text(size: t-size, weight: "bold", label), anchor: "south")
    }
  }

  component("selector", name, node, draw: draw, ..params)
}


