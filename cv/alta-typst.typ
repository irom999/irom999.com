#let primary_colour = rgb("#3E0C87")
#let link_colour = rgb("#12348e")
#let muted_colour = rgb("#666666")

#let icon(name, shift: 0.5pt) = {
  box(
    baseline: shift,
    height: 7pt,
    image("icons/" + name + ".svg"),
  )
  h(3pt)
}

#let findMe(services) = {
  set text(8pt)
  let icon = icon.with(shift: 0.5pt)
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
    text(7.0pt, fill: muted_colour)[#icon("calendar") #period]
  } else {
    text(7.0pt, fill: muted_colour)[#icon("calendar") #period #h(1fr) #icon("location") #location]
  }
}

#let tech(..techs) = {
  text(7.0pt, fill: muted_colour)[#icon("skill")#techs.pos().join(" · ")]
}

#let term_tech(period, ..techs) = {
  grid(
    columns: (1fr, auto),
    align: (left, right),
    text(7.0pt, fill: muted_colour)[#icon("calendar") #period],
    text(7.0pt, fill: muted_colour)[#icon("skill")#techs.pos().join(" · ")],
  )
}

#let skill_legend() = {
  text(6pt, fill: muted_colour)[\* は、業務経験あり \ 習熟度は、「★☆☆：教わりながら開発できる, ★★☆：一人称で開発できる, ★★★：他者に教えられる」 で評価]
}

#let skill(name, work: false, level: 0) = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    text(7.0pt)[#name#if work { text(fill: primary_colour)[ \*] }],
    text(7.0pt)[
      #text(fill: muted_colour)[
        #for i in range(3) { if i < level { "★" } else { "☆" } }
      ]
    ],
  )
}

#let styled-link(dest, content) = emph(text(
  fill: link_colour,
  link(dest, content),
))

#let plain_link(dest, content) = link(dest, content)

#let alta(
  name: "",
  name-ruby: "",
  links: (),
  tagline: [],
  content,
) = {
  set document(title: name-ruby + "'s CV", author: name)
  set text(7.0pt, font: ("IBM Plex Sans JP", "BIZ UDGothic"))
  set page(margin: (x: 54pt, y: 52pt))

  show heading.where(level: 1): it => text(
    size: 12pt,
    weight: "bold",
    it.body,
  )

  show heading.where(level: 2): it => {
    set block(below:10pt)
    text(size: 10pt, fill: primary_colour, [
      #{ it.body }
      #v(-7pt)
      #line(length: 100%, stroke: 1pt + primary_colour)
    ])
  }

  show heading.where(level: 3): it => text(
    size: 9pt, 
    weight: "bold", 
    it.body
  )

  show heading.where(level: 4): it => text(
    size: 8pt,
    fill: primary_colour,
    weight: "bold",
    it.body,
  )

  show heading.where(level: 5): it => text(
    size: 7pt, 
    weight: "bold", 
    it.body
  )


  grid(
    columns: (auto, 1fr),
    align: bottom,
    column-gutter: 8pt,
    text(size: 12pt, weight: "bold")[#name],
    if name-ruby != "" {
      text(10pt, fill: muted_colour)[#name-ruby]
    },
  )

  findMe(links)
  v(2pt)

  if tagline != [] {
    text(7pt, fill: muted_colour)[#tagline]
    v(2pt)
  }

  columns(2, gutter: 15pt, content)
}
