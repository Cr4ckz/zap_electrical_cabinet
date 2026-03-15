#set page(paper: "a4", margin: 2cm)
#set text(font: "Segoe UI", size: 10pt)
#set heading(numbering: "1.1")

#show heading: it => [
  #v(0.5em)
  #it
  #v(0.5em)
]

#align(center)[
  #text(size: 22pt, weight: "bold")[Electrical Cabinet Library] \
  #text(size: 12pt, gray)[Technical Documentation & User Manual v2026.1]
  #v(1em)
  #line(length: 100%, stroke: 0.5pt + gray)
]

#outline(indent: 1.5em)

#pagebreak()

== Introduction
This library provides a modular framework for creating technical 2D electrical cabinet layouts using Typst and CeTZ. It bridges the gap between manual CAD drawing and automated schematic generation.

== Layout Infrastructure

=== Cabinet (`cabinet`)
The container for the entire assembly. It generates a grid-based coordinate system using "slots".
- *Key Anchors*: `slot-1` to `slot-n` represent horizontal mounting levels.
- *Usage*: `#cabinet("main", (0,0), rows: 5, width: 15, height: 25)`.

=== DIN Rails (`dinrail`)
The physical mounting surface for components.
- *Tip*: Always place rails at cabinet slot anchors for perfect alignment.
- *Example*: `#dinrail("r1", "main.slot-2")`.

=== Wire Ducts (`wireduct`)
Used for cable management. Setting `orientation: "vertical"` rotates the duct correctly while maintaining logical anchors.
- *Visuals*: Includes automatic "finger" slots to simulate real-world cable entries.

== Component Library

=== Protective Devices (`mcb`)
The Miniature Circuit Breaker represents a single-pole protection unit.
- *Anchors*: `p1` (Line/Top), `p2` (Load/Bottom).
- *Example*: `#mcb("F1", "rail1.west", label: "B16")`.

=== Power Supply (`psu`)
A dynamic module that calculates its own width based on terminal count.
- *Terminals*: Supports `l_pins` (AC input) and configurable `L+`/`M` output pairs.
- *Logic*: Terminal colors are automatically applied (Red for +, Blue for -).

=== Modular Boxes (`generic_box`)
The foundation for complex modules like PLCs or Gateways.
- *Flexibility*: Allows pin grouping on all four sides.
- *Styling*: Groups can have individual fill colors.



== Advanced Wiring Techniques

=== The Projection Principle
To avoid wires crossing through components, use the **Orthogonal Projection** method. This ensures wires run perfectly horizontal from the terminal into the duct.

*Syntax:* `(Point A, "-|", Point B)`
- *Effect*: Takes X from Point A and Y from Point B.
- *Code*: `wire("CB.p1", ("duct-v.east", "-|", "CB.p1"))`.

=== Terminal Strips (`terminal_strip`)
Instead of placing terminals manually, use this function to generate an entire numbered block.
- *Mechanism*: It iterates through labels using `range(labels.len())`.
- *Example*: `#terminal_strip("X1", "rail2.west", ("L1", "L2", "L3", "N", "PE"))`.

=== Bridging (`bridge`)
Used for internal jumpers or busbars.
- *Function*: Connects one source to multiple targets with a single common rail.
- *Example*: `#bridge("PSU.L+", ("K1.11", "K1.A1"), offset: 0.8, stroke: red)`.



== Style & Standardization

=== Color Coding
To maintain industry standards, the following stroke colors should be used.
- *Black / Dark Gray*: AC Power (230/400V).
- *Red*: DC Positive (+24V).
- *Blue*: DC Negative / Ground (0V/GND).

=== Anchor Naming
Components use standardized naming conventions for ease of use.
- *Inputs*: Always `p1` or semantic names like `L`, `A1`.
- *Outputs*: Always `p2` or semantic names like `L+`, `14`.

#v(2em)
#box(
  fill: gray.lighten(90%),
  inset: 10pt,
  radius: 5pt,
  width: 100%,
  [
    *Note:* This documentation was generated for the 2026 library version. Ensure your CeTZ dependency is up to date.
  ]
)