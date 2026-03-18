#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/utils.typ": get-style, opposite-anchor, resolve-style

#import cetz.draw: *

/// A generic rectangular box component with configurable pin groups on all sides.
///
/// Draws a flexible module with labeled terminals. Pins are organized into groups, 
/// allowing for visual separation (e.g., separating power from signal).
///
/// - name (string): Component identifier/name.
/// - node (position, string): Placement position or anchor point.
/// - label (string): Main title displayed in the center; default: "MODUL".
/// - top_pins (array): Pin groups for the top side.
/// - bottom_pins (array): Pin groups for the bottom side.
/// - left_pins (array): Pin groups for the left side.
/// - right_pins (array): Pin groups for the right side.
/// - width (length): Box width; default: 4.0.
/// - height (length): Box height; default: 4.0.
/// - text-size (length): Label font size; default: 8pt.
/// - pin-text-size (length): Pin label font size; default: 5pt.
/// - fill (color): Box fill color; default: white.darken(2%).
/// - stroke (stroke): Box border style; default: black + 0.8pt.
/// - ..params (any): Additional style parameters.
///
/// *Pin Group Format:*
/// Pass an array of strings. The last element can be a dictionary for styling, 
/// e.g., `("L", "N", (fill: red))`.
#let generic_box(name, node, label: "MODUL", top_pins: (), bottom_pins: (), left_pins: (), right_pins: (), ..params) = {
  let draw(ctx, position, style) = {
    let w = style.at("width", default: 4.0)
    let h = style.at("height", default: 4.0)
    let label-size = style.at("text-size", default: 8pt)
    let pin-size = style.at("pin-text-size", default: 5pt)
    let t-h = 0.25


    rect(
      (-w / 2, -h / 2),
      (w / 2, h / 2),
      fill: style.at("fill", default: white.darken(2%)),
      stroke: style.at("stroke", default: black + 0.8pt),
      name: "bounds",
    )

    let draw_side(input_pins, side) = {
      if input_pins.len() == 0 { return }

      let groups = if type(input_pins.at(0)) == array { input_pins } else { (input_pins,) }
      let is_horizontal = (side == "top" or side == "bottom")
      let total_length = if is_horizontal { w } else { h }


      let n_groups = groups.len()
      let group_unit = total_length / (n_groups + 1)
      let global_pin_idx = 1

      for (g_idx, group) in groups.enumerate() {
        let group_style = (fill: gray.lighten(60%))
        let pins_to_draw = group

        if type(group.last()) == dictionary {
          group_style = group_style + group.last()
          pins_to_draw = group.slice(0, -1)
        }

        let n_pins = pins_to_draw.len()

        let pin_w = calc.min(0.45, (total_length / (n_groups + 1)) / (n_pins + 0.5))
        let group_w = n_pins * pin_w

        let group_center = -total_length / 2 + (g_idx + 1) * group_unit

        for (p_idx, p_label) in pins_to_draw.enumerate() {

          let p_offset = group_center - (group_w / 2) + (p_idx + 0.5) * pin_w

          let pos = if is_horizontal {
            (p_offset, if side == "top" { h / 2 } else { -h / 2 })
          } else {
            (if side == "left" { -w / 2 } else { w / 2 }, p_offset)
          }

          if is_horizontal {
            rect(
              (p_offset - pin_w / 2, pos.at(1)),
              (p_offset + pin_w / 2, pos.at(1) + (if side == "top" { -t-h } else { t-h })),
              fill: group_style.fill,
              stroke: 0.5pt,
            )
          } else {
            rect(
              (pos.at(0), p_offset - pin_w / 2),
              (pos.at(0) + (if side == "left" { t-h } else { -t-h }), p_offset + pin_w / 2),
              fill: group_style.fill,
              stroke: 0.5pt,
            )
          }


          let (px, py) = pos
          let circle_pos = if side == "top" { (px, py - t-h / 2) } else if side == "bottom" {
            (px, py + t-h / 2)
          } else if side == "left" { (px + t-h / 2, py) } else { (px - t-h / 2, py) }
          circle(circle_pos, radius: 0.04, fill: gray.darken(20%), stroke: none)

          anchor(side.first() + str(global_pin_idx), pos)
          anchor(side.first() + str(g_idx + 1) + "_" + str(p_idx + 1), pos)
          let clean_name = str(p_label).replace(".", "_")
          if clean_name.len() > 0 { anchor(clean_name, pos) }

          global_pin_idx += 1

          let l_off = 0.25


          let (p_label_pos, p_align) = if side == "top" {
            ((pos.at(0), pos.at(1) - t-h - l_off), "north")
          } else if side == "bottom" {
            ((pos.at(0), pos.at(1) + t-h + l_off), "south")
          } else if side == "left" {
            ((pos.at(0) + t-h + l_off, pos.at(1)), "west")
          } else {
            ((pos.at(0) - t-h - l_off, pos.at(1)), "east")
          }

          content(p_label_pos, text(size: pin-size, weight: "bold", [#p_label]), anchor: p_align)
        }
      }
    }

    draw_side(top_pins, "top")
    draw_side(bottom_pins, "bottom")
    draw_side(left_pins, "left")
    draw_side(right_pins, "right")

    content("bounds.center", block(width: 85%, {
      set align(center + horizon)
      set text(size: label-size, weight: "bold")
      label
    }))
  }

  component("generic_box", name, node, draw: draw, ..params)
}

/// A Power Supply Unit (PSU) component with configurable input and output pins.
///
/// Creates a specialized module for power conversion. It automatically calculates 
/// its width based on the number of specified terminals.
///
/// - name (string): Component identifier/name.
/// - pos (position, string): Placement position.
/// - label (string): PSU title; default: "Netzteil 24V".
/// - l_pins (array): AC input labels (top); default: ("L", "N", "PE").
/// - plus_name (string): Label for positive DC pins; default: "L+".
/// - plus_count (int): Number of positive terminals.
/// - minus_name (string): Label for ground/negative pins; default: "M".
/// - minus_count (int): Number of negative terminals.
/// - ..params (any): Additional style parameters.
#let psu(name, pos, 
  label: "Netzteil 24V", 
  l_pins: ("L", "N", "PE"), 
  plus_name: "L+", plus_count: 2,
  minus_name: "M", minus_count: 2,
  ..params) = {
  let make_pins(name, count) = {
    let pins = ()
    for i in range(count) { pins.push(name) }
    return pins
  }

  let p_list = make_pins(plus_name, plus_count)
  let m_list = make_pins(minus_name, minus_count)
  
  let pin_width = 0.5
  let total_pins = l_pins.len() + p_list.len() + m_list.len() + 1
  let auto_width = total_pins * pin_width + 1.0 
  
  generic_box(name, pos, 
    label: label,
    width: auto_width,
    top_pins: (
      (..l_pins, (fill: gray.lighten(80%)))
    ),
    bottom_pins: (
      (..p_list, (fill: red.lighten(95%))),
      (..m_list, (fill: blue.lighten(95%)))
    ),
    ..params
  )
}

/// A relay component with coil terminals and contact groups.
///
/// Draws a standard control relay. Coil terminals (A1, A2) are placed on top, 
/// while contact terminals (11, 12, 14) are placed on the bottom.
///
/// - name (string): Component identifier/name.
/// - pos (position, string): Placement position.
/// - label (string): Relay title; default: "Relais".
/// - ..params (any): Additional style parameters.
#let relais(name, pos, label: "Relais", ..params) = {
  let t_pins = ("A1", "A2")
  let b_pins = ("11", "12", "14")
  
  let pin_width = 0.55
  let auto_width = calc.max(t_pins.len(), b_pins.len()) * pin_width + 1.2
  
  generic_box(name, pos, 

    label: label,
    width: 2,
    top_pins: ( (..t_pins, (fill: gray.lighten(90%))) ),
    bottom_pins: ( (..b_pins, (fill: gray.lighten(80%))) ),
    ..params
  )
}

/// A contactor (electromagnetic switch) component for motor control.
///
/// Specialized for three-phase power switching. Features power contacts (L/T) 
/// and auxiliary/coil contacts (A1/A2, 13/14).
///
/// - name (string): Component identifier/name.
/// - pos (position, string): Placement position.
/// - label (string): Contactor title; default: "Schütz".
/// - top_pins (array): Custom power/control pin configuration for the top.
/// - bottom_pins (array): Custom power/control pin configuration for the bottom.
/// - ..params (any): Additional style parameters.
#let contactor(name, pos, 
  label: "Schütz", 

  top_pins: (
    ("L1", "L2", "L3", (fill: gray.lighten(50%))), 
    ("13", "A1", (fill: gray.lighten(90%)))
  ),
  bottom_pins: (
    ("T1", "T2", "T3", (fill: gray.lighten(50%))), 
    ("14", "A2", (fill: gray.lighten(90%)))
  ),
  ..params) = {
  
  let count_pins(p_groups) = p_groups.map(g => g.len() - 1).sum() 
  let max_p = calc.max(count_pins(top_pins), count_pins(bottom_pins))
  let auto_width = max_p * 0.6

  generic_box(name, pos, 
    label: label,
    width: auto_width,
    top_pins: top_pins,
    bottom_pins: bottom_pins,
    ..params
  )
}
