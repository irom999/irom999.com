#let primary_colour = rgb("#3E0C87")
#let link_colour = rgb("#12348e")
#let muted_colour = rgb("#666666")

#let icon(name, shift: 1.5pt) = {
  box(
    baseline: shift,
    height: 10pt,
    image("icons/" + name + ".svg"),
  )
  h(3pt)
}

#let findMe(services) = {
  set text(8pt)
  let icon = icon.with(shift: 2.5pt)
  services
    .map(service => {
      icon(service.name)
      if "display" in service.keys() {
        link(service.link)[#{ service.display }]
      } else {
        link(service.link)
      }
    })
    .join(h(10pt))
  linebreak()
}

#let term(period, ..args) = {
  let location = if args.pos().len() > 0 { args.pos().at(0) } else { none }
  if location == none {
    text(8.5pt, fill: muted_colour)[#icon("calendar") #period]
  } else {
    text(8.5pt, fill: muted_colour)[#icon("calendar") #period #h(1fr) #icon("location") #location]
  }
}

#let styled-link(dest, content) = emph(text(
  fill: link_colour,
  link(dest, content),
))

#let alta(
  name: "",
  name-ruby: "",
  links: (),
  tagline: [],
  content,
) = {
  set document(title: "CV - " + name, author: name)
  set text(7.0pt, font: ("IBM Plex Sans JP", "BIZ UDGothic"))
  set page(margin: (x: 54pt, y: 52pt))
  set par(leading: 1.3em)

  show heading.where(level: 1): it => text(
    size: 20pt,
    weight: "bold",
    it.body,
  )

  show heading.where(level: 2): it => text(
    fill: primary_colour,
    [
      #{ it.body }
      #v(-7pt)
      #line(length: 100%, stroke: 1pt + primary_colour)
    ],
  )

  show heading.where(level: 3): it => text(weight: "bold", it.body)

  show heading.where(level: 4): it => text(
    fill: primary_colour,
    weight: "bold",
    it.body,
  )

  [= #name]

  if name-ruby != "" {
    text(9pt, fill: muted_colour)[#name-ruby]
    linebreak()
  }

  findMe(links)

  if tagline != [] {
    text(9pt, fill: muted_colour)[#tagline]
    v(2pt)
  }

  columns(2, gutter: 15pt, content)
}
