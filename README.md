# tud-slides
This is a [Typst](https://typst.app/) template for slides and presentations in the corporate design of the [Technische Universität Dresden](https://tu-dresden.de/).

Please be aware that this template is unofficial and may not fully adhere to the CD specifications.

Any corrections, modifications, or enhancements are welcome.

This template builds on [Touying](https://github.com/touying-typ/touying).
Further information on its features and how to use them can be found in the [Touying tutorial](https://touying-typ.github.io/touying/docs/intro).

## Installation and Usage
### 1. get the template
- clone this repository with git

```bash
git clone https://github.com/typst-tud/tud-slides.git
```

- or download as a ZIP-file: https://github.com/typst-tud/tud-slides/archive/refs/heads/main.zip


### 2. import Touying and this template into your document

```typst
    #import "@preview/touying:0.4.2": *
    #import "tud-slides.typ"

    #let s = tud-slides.register(aspect-ratio: "16-9", debug: true)
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

        #lorem(40)
    ]

```

## Acknowledgments

- [Corporate Design Manual (login required)](https://tu-dresden.de/intern/services-und-hilfe/ressourcen/dateien/kommunizieren_und_publizieren/corporate-design/cd-elemente/CD_Manual_Stand-2022-02.pdf)
- [tud-cd bundle for LaTeX](https://github.com/tud-cd/tud-cd)