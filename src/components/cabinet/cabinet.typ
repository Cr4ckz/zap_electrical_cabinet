#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style
#import cetz.draw: *

/// A DIN rail component for mounting devices in electrical cabinets.
///
/// Draws a standard TS35 rail profile used for mounting circuit breakers,
/// relays, and other industrial equipment.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - orientation (string): "horizontal" (default) or "vertical".
/// - ..params (any): Additional style parameters such as length, width, fill, or stroke.
///
/// *Anchors:*
/// - center: Center of the rail.
/// - west / east: Left and right ends (for horizontal).
/// - north / south: Top and bottom ends (for vertical).
#let dinrail(name, node, orientation: "horizontal", ..params) = {
  let rotate = 0deg
  if (orientation == "vertical") {
    rotate = 90deg
  }
  let draw(ctx, position, style) = {
    let l = style.at("length", default: 13)
    let w = style.at("width", default: 0.8)

    interface((0, -w / 2), (l, w / 2), io: position.len() < 2)

    group(name: "rail", {
      rect((0, -w / 2), (l, w / 2), fill: silver, stroke: gray, name: "bounds")
      line((0, 0), (l, 0), stroke: (paint: gray, dash: "densely-dotted"))
    })
  }

  component("dinrail", name, node, draw: draw, rotate: rotate, ..params)
}

/// Creates an electrical cabinet enclosure with horizontal slots for rails and ducts.
///
/// Generates a rectangular cabinet frame with configurable internal slots
/// (anchors) that simplify the alignment of DIN rails and wire ducts.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - orientation (string): "horizontal" (default) or "vertical".
/// - rows (int): Number of horizontal slots in the cabinet; default: 5.
/// - width (length): Cabinet outer width; default: 15.
/// - height (length): Cabinet outer height; default: 25.
/// - padding (length): Internal padding from cabinet edges; default: 0.8.
/// - ..params (any): Additional style parameters for the enclosure frame.
///
/// *Slot Anchors:*
/// - slot-n-center: Center of the n-th row (e.g., "slot-1-center").
/// - slot-n: Leftmost point of the n-th row.
#let cabinet(name, node, orientation: "horizontal", ..params) = {
  let rotate = 0deg
  if (orientation == "vertical") {
    rotate = 90deg
  }
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 15)
    let h = style.at("height", default: 25)
    let p = style.at("padding", default: 0.8)
    let rows = style.at("rows", default: 5)

    interface((-w / 2, -h / 2), (w / 2, h / 2), io: position.len() < 2)

    group(name: "intern", {
      rect((-w / 2, -h / 2), (w / 2, h / 2), name: "bounds", stroke: 1.5pt + black, fill: none)


      let pw = w - (2 * p)
      let ph = h - (2 * p)
      rect((-pw / 2, -ph / 2), (pw / 2, ph / 2), name: "plate", stroke: 0.5pt + gray, fill: none)

      let step = ph / (rows + 1)
      for i in range(1, rows + 1) {
        let y = (ph / 2) - (i * step)
        anchor("s" + str(i) + "-center", (0, y))
        anchor("s" + str(i), (-pw / 2, y))
      }
    })

    for i in range(1, rows + 1) {
      anchor("slot-" + str(i), "intern.s" + str(i) + "-center")
      anchor("slot-" + str(i), "intern.s" + str(i))
    }
  }

  component("cabinet", name, node, draw: draw, rotate: rotate, ..params)
}

/// A cable/wire duct for routing and organizing cables in electrical cabinets.
///
/// Draws a slotted plastic channel used to hide and protect wiring.
/// In a layout, cables typically terminate at the edge of this component.
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - orientation (string): "horizontal" (default) or "vertical".
/// - length (length): Duct total length; default: 13.4.
/// - width (length): Duct total width; default: 1.2.
/// - ..params (any): Additional style parameters for the duct body.
///
/// *Visuals:*
/// - Includes decorative slots along the edges to simulate cable entry points.
#let wireduct(name, node, orientation: "horizontal", ..params) = {
  let rotate = 0deg
  if (orientation == "vertical") {
    rotate = 90deg
  }
  let draw(ctx, position, style) = {
    let l = style.at("length", default: 13.4)
    let w = style.at("width", default: 1.2)
    let slot-dist = 0.4

    interface((0, -w / 2), (l, w / 2), io: position.len() < 2)

    group(name: "duct", {
      rect((0, -w / 2), (l, w / 2), fill: gray.lighten(60%), stroke: gray.darken(20%), name: "bounds")

      let num-slots = int(l / slot-dist)
      for i in range(0, num-slots) {
        let x = (i * slot-dist) + (slot-dist / 2)


        line((x, w / 2), (x, w / 2 - 0.2), stroke: gray.darken(40%) + 0.5pt)

        line((x, -w / 2), (x, -w / 2 + 0.2), stroke: gray.darken(40%) + 0.5pt)
      }


      line((0, w / 2 - 0.1), (l, w / 2 - 0.1), stroke: white + 0.2pt)
      line((0, -w / 2 + 0.1), (l, -w / 2 + 0.1), stroke: white + 0.2pt)
    })
  }

  component("wireduct", name, node, draw: draw, rotate: rotate, ..params)
}
