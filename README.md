# elm-review-html-to-elm

Provides an [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rule to convert an HTML String into compiling Elm code.


## Provided rules

- [`HtmlToElm`](https://package.elm-lang.org/packages/dillonkearns/elm-review-html-to-elm/1.0.0/HtmlToElm)


## Configuration

```elm
module ReviewConfig exposing (config)

import HtmlToElm
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ HtmlToElm.rule
    ]
```


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template dillonkearns/elm-review-html-to-elm/example
```
