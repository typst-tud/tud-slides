
// TUD Theme for Typst Touying
//
// based on https://touying-typ.github.io/touying/docs/build-your-own-theme

#import "@preview/touying:0.5.5": *
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
    body,
  )
}

// define cell function for grid as rects
#let cell_outer(self, body) = {
  rect(
    width: 100%,
    height: 100%,
    inset: 0mm,
    outset: 0mm,
    fill: none,
    stroke: self.colors.debug-stroke,
    body,
  )
}

/*
 * Standard Slide
 */
#let slide(
  title: auto,
  subtitle: none,
  ..args,
) = touying-slide-wrapper(self => {
  if title == auto {
    self.store.title = utils.display-current-heading(level: 1)
  } else {
    self.store.title = title
  }

  if subtitle == none {
    self.store.subtitle = utils.display-current-heading(level: 2)
  } else {
    self.store.subtitle = subtitle
  }

  let title = self.store.title
  let subtitle = self.store.subtitle

  // define header for slide
  let header(self) = {

    let cell(body) = cell_outer(self, align(bottom + left, text(size: 24pt, fill: self.colors.tud-blue, body)))

    set align(top)

    block(
      grid(
        columns: (4em, 1fr),
        rows: (18mm, 10.6mm),
        cell([]), cell(text(weight: "bold", title)),
        cell([]), cell(text(weight: "regular", subtitle)),
      ),
    )
  }

  // define footer for slide
  let footer(self) = {
    let cell(body) = cell_outer(self, align(horizon + left, text(size: 0.4em, fill: self.colors.tud-gray, body)))

    set align(center + horizon)

    block(
      stroke: self.colors.debug-stroke,
      width: 100%,
      height: 3em,
      grid(
        // columns: (25%, 1fr, 25%),
        // columns: footer-columns,
        columns: (14mm, 54.8mm, 130mm, 19.6mm, 1fr, 35.3mm), // 6 columns
        rows: 2em, // 1 row
        cell([]), // empty space
        cell(image("logos/TU_Dresden_Logo_blau_HKS41.svg", width: auto, height: 100%)), // TUD logo
        cell(utils.call-or-display(self, self.store.footer-info)), // title etc.
        cell(context "Slide " + utils.slide-counter.display() + " / " + utils.last-slide-number), // slide number
        cell([]), // empty space
        cell(utils.call-or-display(self, self.store.footer-secondary-logo)), // empty, or DDC or secondary logo
      ),
    )
  }

  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )

  touying-slide(self: self, ..args)
})

/*
 * Title Slide
 */
#let title-slide(
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()

  // do not count title slide and remove margins
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )

  let cell(body) = cell_outer(self, align(top + left, body))

  let body = {
    set text(fill: self.colors.tud-white)
    set block(inset: 0mm, outset: 0mm, spacing: 0em)
    set align(top + left)

    grid(
      columns: 100%,
      rows: (4em, 1fr),

      grid(
        columns: (2em, 1fr, 10em),
        rows: 100%,
        cell([]), // empty space
        cell(
          align(horizon + left, image("logos/TU_Dresden_Logo_blau_HKS41.svg", width: 49mm, height: auto)),
        ), // TUD logo
        cell([]), // empty, or DDC or secondary logo
      ),

      tud-gradient(
        self,
        block(
          stroke: self.colors.debug-stroke,
          fill: none,
          width: 100%,
          height: 100%,
          inset: (left: 4em, top: 6em),
          grid(
            columns: 1fr,
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
              #self.info.location \/\/ #utils.display-info-date(self)
            ]),
          ),
        ),
      )
    )
  }

  touying-slide(self: self, body)
})

/*
 * Outline Slide
 */
#let outline-slide(
  ..args,
) = {

  let body = {
    components.adaptive-columns({
      show outline.entry: it => {
        if it.at("label", default: none) == <modified-entry> {
          it // prevent infinite recursion
        } else {
          [#outline.entry(
            it.level,
            it.element,
            it.body,
            [],  // remove fill
            []  // remove page number
          ) <modified-entry>]
        }
      }

      outline(depth: 1, title: none, indent: 1em)
    })
  }

  slide(title: "Outline", body, ..args)
}

/*
 * Section Slide
 *
 * register self.methods.touying-new-section-slide = new-section-slide,
 * so new-section-slide is called when first-level title is encountered
 */
#let new-section-slide(
  self: none,
  body,
) = touying-slide-wrapper(self => {
  // reset page margin and padding, so full page is covered by gradient
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.primary,
      // margin: (top: 0em, bottom: 3em, x: 0em),
      margin: (top: 0em, bottom: 0em, x: 0em),
      // padding: (x: 0em, y: 0em),
    ),
  )

  // self.padding = (x: 0em, y: 0em)

  let section = utils.display-current-heading(level: 1)

  let cell(body) = cell_outer(self, body)

  let body = {
    set align(left + horizon)
    tud-gradient(
      self,
      block(
        stroke: self.colors.debug-stroke,
        width: 100%,
        height: 100%,
        inset: (left: 4em, top: 9em),
        grid(
          columns: 1fr,
          rows: 8em,
          cell(text(size: 2em, fill: self.colors.tud-white, weight: "bold", section))
        ),
      ),
    )
  }

  // call default slide
  touying-slide(self: self, body)
})

/*
 * Register Function and Init Method
 */
#let tud-slides-theme(
  aspect-ratio: "16-9",
  debug: false,
  footer: [],
  footer-info: self => {
    [
      #{ if self.info.alttitle != none { self.info.alttitle } else { self.info.title } } \
      #self.info.institution \/\/ #self.info.author \
      #self.info.location \/\/ #utils.display-info-date(self)
    ]
  },
  footer-secondary-logo: self => {
    // if self.info.ddc-logo {
    //     image("...", width: 80%, height: 10em) // DDC logo enabled
    //   } else {
    //     [] // DDC logo disabled
    //   }
  },
  ..args,
  body,
) = {
  // set global font
  set text(font: "Open Sans", size: 16pt)

  // configuration
  show: touying-slides.with(
    // page settings
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 41mm, bottom: 4em, x: 4em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    // color theme
    config-colors(
      primary: cddarkblue,
      tud-blue: cddarkblue,
      tud-lightblue: cdblue,
      tud-gray: cdgray,
      tud-white: cdwhite,
      debug-stroke: if debug { 1pt + red } else { none },
    ),
    // register methods
    config-methods(
      init: (self: none, body) => {
        set text(font: "Open Sans", size: 16pt)
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-store(
      title: none,
      header: none,
      footer: footer,
      footer-info: footer-info,
      footer-secondary-logo: footer-secondary-logo,
    ),
    ..args,
  )

  body
}
