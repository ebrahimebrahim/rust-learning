// pond — Shared Typst preamble for course notes
// Import in note files: #import "../_preamble.typ": *

// Page setup
#let note-page = (
  width: 8.5in,
  height: 11in,
  margin: (x: 1in, y: 0.75in),
)

// Colors
#let accent = rgb("#b07d3b")
#let subtle = rgb("#666666")
#let code-bg = rgb("#f5f2ed")

// Note header
#let note-header(title, module: none, date: none) = {
  set text(size: 18pt, weight: "bold")
  title
  v(2pt)
  set text(size: 10pt, weight: "regular", fill: subtle)
  if module != none { [Module #module] }
  if module != none and date != none { [ — ] }
  if date != none { date }
  v(8pt)
  line(length: 100%, stroke: 0.5pt + subtle)
  v(8pt)
}

// Styled code block
#let code-block(lang: "rust", body) = {
  block(
    fill: code-bg,
    inset: 10pt,
    radius: 3pt,
    width: 100%,
    raw(body, lang: lang),
  )
}

// Callout box
#let callout(title: none, body) = {
  block(
    stroke: (left: 3pt + accent),
    inset: (left: 12pt, y: 8pt, right: 8pt),
    width: 100%,
    {
      if title != none {
        text(weight: "bold", fill: accent, title)
        parbreak()
      }
      body
    },
  )
}

// Key insight highlight
#let insight(body) = callout(title: "Key Insight", body)

// Diagram placeholder helper (for quick ASCII-to-typst diagrams)
#let diagram(body) = {
  block(
    fill: rgb("#fafafa"),
    stroke: 0.5pt + rgb("#dddddd"),
    inset: 12pt,
    radius: 3pt,
    width: 100%,
    text(font: "DejaVu Sans Mono", size: 9pt, body),
  )
}
