#import "@preview/touying:0.4.2": *
#import "../tud-slides.typ"

#let s = tud-slides.register(aspect-ratio: "16-9", debug: false)
#let s = (s.methods.info)(
  self: s,
  title: [Your Title],
  subtitle: [Your Subtitle],
  author: [Firstname Lastname],
  date: datetime.today(),
  institution: [Institution],
  location: [Location],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init

#let (slide, title-slide) = utils.slides(s)
#show: slides

= Title

== First Topic

#slide[
  Hello, Touying!

  #pause

  Hello, Typst!

  #lorem(40)
]

#slide(subtitle: "1st Subtitle")[
  #lorem(40)
]

== Second Topic

#slide[
  #lorem(40)
]

#slide(subtitle: "2nd Subtitle")[
  #lorem(40)
]

== Third Topic

#slide(subtitle: "3nd Subtitle")[
  #lorem(40)
]
