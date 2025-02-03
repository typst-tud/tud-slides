#import "@preview/touying:0.5.5": *
#import "../tud-slides.typ": *

#show: tud-slides-theme.with(
  aspect-ratio: "16-9",
  debug: false,
  config-info(
    title: [Your Title \ with linebreak],
    alttitle: [Your Title without linebreak],
    subtitle: [Your Subtitle],
    author: [Firstname Lastname],
    date: datetime.today(),
    institution: [Institution],
    location: [Location],
  ),
)

#title-slide()

#outline-slide()

= 1st Section Title

== 1st Topic

=== Slide title

Hello, Touying!

#lorem(40)

== 2nd Topic

Hello, Typst!

#lorem(40)


== 3rd Topic

#lorem(40)

= 2nd Section Title

== Topic Title

=== Slide title

#lorem(100)

