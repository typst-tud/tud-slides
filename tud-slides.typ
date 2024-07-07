// TUD Theme for Typst Touying
//
// based on https://touying-typ.github.io/touying/docs/build-your-own-theme

#import "@preview/touying:0.4.2": *
#import "colors.typ": *

/*
* Utility Functions
*/
#let tud-gradient(self, body) = {
    rect(
      stroke: self.colors.debug-stroke,
      fill: gradient.linear(
        self.colors.tud-blue,
        self.colors.tud-lightblue,
        angle: 45deg,
        ),
      body
    )
}

/*
* Standard Slide
*/
#let slide(
  self: none,
  title: auto,
  subtitle: none,
  ..args,
) = {
  if title != auto {
    self.tud-title = title
  }

  if subtitle != none {
    self.tud-subtitle = subtitle
  }

  (self.methods.touying-slide)(self: self, ..args)
}

/*
* Title Slide
*/
#let title-slide(
  self: none,
  ..args,
) = {
  self = utils.empty-page(self) // clears self.page-args.header, self.page-args.footer, sets margin and padding to 0em

  let info = self.info + args.named()

  let cell(body) = rect(
    width: 100%, height: 100%, inset: 0mm, outset: 0mm,
    fill: none, stroke: self.colors.debug-stroke,
    align(top + left, body)
  )

  let body = {
    set text(fill: self.colors.tud-white)
    set block(inset: 0mm, outset: 0mm, spacing: 0em)
    set align(top + left)
    grid(
      columns: 100%,
      rows: (4em, 1fr),
      grid(
        columns: (2em, 1fr, 10em),
        rows: (100%),
        cell([]), // empty space
        cell(
          align(horizon + left, image("logos/TU_Dresden_Logo_blau_HKS41.svg", width: 49mm, height: auto))), // TUD logo
        cell([]), // empty, or DDC or secondary logo
      ),
      tud-gradient(self,
        block(
          stroke: self.colors.debug-stroke,
          fill: none,
          width: 100%,
          height: 100%,
          inset: (left: 4em, top: 6em),
          grid(
            columns: (1fr),
            rows: (4em, 8em, 1fr),
            cell([
              #set text(fill: self.colors.tud-white.transparentize(25%))
              #text(weight: "bold", info.author)
              #linebreak()
              #info.institution
            ]),
            cell([
              #text(size: 2em, weight: "bold", info.title)
              #linebreak()
              #text(size: 2em, weight: "regular", info.subtitle)
            ]),
            cell([
              #set text(fill: self.colors.tud-white.transparentize(25%))
              #self.info.location \/\/ #utils.info-date(self)
            ]),
          ),

        )
      )
    )
  }

  (self.methods.touying-slide)(self: self, repeat: none, body)
}

/*
* Section Slide
*
* register self.methods.touying-new-section-slide = new-section-slide,
* so new-section-slide is called when first-level title is encountered
*/
#let new-section-slide(
  self: none,
  title: auto,
  subtitle: none,
  section,
  ..args,
) = {

  // reset page margin and padding, so full page is covered by gradient
  self.page-args += (
    margin: (top: 0em, bottom: 3em, x: 0em),
  )
  self.padding = (x: 0em, y: 0em)

  let cell(body) = rect(
    width: 100%, height: 100%, inset: 0mm, outset: 0mm,
    fill: none, stroke: self.colors.debug-stroke,
    body
  )

  let body = {
    set align(left + horizon)
    tud-gradient(
      self,
      block(
        stroke: self.colors.debug-stroke,
        width: 100%,
        height: 100%,
        inset: (left: 4em, top: 12em),
        grid(
          columns: (1fr),
          rows: (8em),
          cell(text(size: 2em, fill: self.colors.tud-white, weight: "bold", section))
        )
      )
    )
  }

  // call default slide
  (self.methods.slide)(self: self, section: section, body)
}

/*
* Slides Function
*
* When title-slide is true, using #show: slides will automatically create a title-slide.
*/
#let slides(self: none, title-slide: true, slide-level: 1, ..args) = {
  if title-slide {
    (self.methods.title-slide)(self: self)
  }
  (self.methods.touying-slides)(self: self, slide-level: slide-level, ..args)
}

/*
* Register Function and Init Method
*/
#let register(
  self: themes.default.register(),
  aspect-ratio: "16-9",
  debug: false,
  footer : [],
  // footer-columns: (4.13%, 16.18%, 38.38%, 30.88%, 1fr),
  // footer-columns: (14mm, 54.8mm, 130mm, 19.6mm, 1fr, 35.3mm),
  footer-info: self => {[
    #self.info.title – #self.info.subtitle \
    #self.info.institution \/\/ #self.info.author \
    #self.info.location \/\/ #utils.info-date(self)
  ]
  },
  footer-number: self => {
    "Slide " + states.slide-counter.display() + " / " + states.last-slide-number
  },
  footer-second-logo: self => {
    // if self.info.ddc-logo {
    //     image("...", width: 80%, height: 10em) // DDC logo enabled
    //   } else {
    //     [] // DDC logo disabled
    //   }
  },
) = {
  // color theme
  self = (self.methods.colors)(
    self: self,
    tud-blue: cddarkblue,
    tud-lightblue: cdblue,
    tud-gray: cdgray,
    tud-white: cdwhite,
    debug-stroke: if debug { 1pt + red } else { none },
  )

  self.tud-title = []
  self.tud-subtitle = []
  self.tud-footer = footer

  let header(self) = {
    let title = utils.call-or-display(self, self.tud-title)
    let subtitle = utils.call-or-display(self, self.tud-subtitle)

    // define cell function for grid as rects
    let cell(body) = rect(
      width: 100%, height: 100%, inset: 0mm, outset: 0mm,
      fill: none, stroke: self.colors.debug-stroke,
      align(bottom + left, text(size: 24pt, fill: self.colors.tud-blue, body))
    )

    set align(top)

    block(
      grid(
        columns: (4em, 1fr),
        rows: (18mm, 10.6mm),
        cell([]),
        cell(heading(level: 2, text(weight: "bold", title))),
        cell([]),
        cell(text(weight: "regular", subtitle))
      ),
    )
  }

  let footer(self) = {
    // define cell function for grid as rects
    let cell(body) = rect(
      width: 100%, height: 100%, inset: 0mm, outset: 0mm,
      fill: none, stroke: self.colors.debug-stroke,
      align(horizon + left, text(size: 0.4em, fill: self.colors.tud-gray, body))
    )

    set align(center + horizon)

    block(
      stroke: self.colors.debug-stroke,
      width: 100%,
      height: 3em,
      grid(
        // columns: (25%, 1fr, 25%),
        // columns: footer-columns,
        columns: (14mm, 54.8mm, 130mm, 19.6mm, 1fr, 35.3mm), // 6 columns
        rows: (2em), // 1 row
        cell([]), // empty space
        cell(image("logos/TU_Dresden_Logo_blau_HKS41.svg", width: auto, height: 100%)), // TUD logo
        cell(utils.call-or-display(self, footer-info)), // title etc.
        cell(utils.call-or-display(self, footer-number)), // slide number
        cell([]), // empty space
        cell(utils.call-or-display(self, footer-second-logo)), // empty, or DDC or secondary logo
      )
    )
  }

  // page settings
  self.page-args += (
    paper: "presentation-" + aspect-ratio,
    header: header,
    footer: footer,
    margin: (top: 41mm, bottom: 3em, x: 4em),
  )

  // register methods
  self.methods.slide = slide
  self.methods.title-slide = title-slide
  self.methods.new-section-slide = new-section-slide
  self.methods.touying-new-section-slide = new-section-slide
  self.methods.slides = slides
  self.methods.alert = (self: none, it) => text(fill: self.colors.tud-blue, it)
  self.methods.init = (self: none, body) => {
    set text(font: "Open Sans", size: 16pt)
    body
  }
  self
}
