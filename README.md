# elm-review-html-to-elm

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to REPLACEME.


## Provided rules

- [`HtmlToElm`](https://package.elm-lang.org/packages/dillonkearns/elm-review-html-to-elm/1.0.0/HtmlToElm) - Reports REPLACEME.


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
