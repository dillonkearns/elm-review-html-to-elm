# elm-review-html-to-elm

Provides an [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rule to convert an HTML String into compiling Elm code.

You can also run this scaffolding tool with the web UI at [html-to-elm.com](https://html-to-elm.com/).


## Provided rules

- [`HtmlToElm`](https://package.elm-lang.org/packages/dillonkearns/elm-review-html-to-elm/1.0.1/HtmlToElm)


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

## Before fix

The fix runs on top-level values with an Html type annotation. It turns the HTML within the String
in a `Debug.todo` call into compiling Elm code!

```elm
import Html exposing (Html)
import Html.Attributes as Attr

navbarView : Html msg
navbarView =
    Debug.todo """<ul class="flex"><li><a href="/">Home</a></li></ul>"""
```


## After fix

```elm
import Html exposing (Html)
import Html.Attributes as Attr

navbarView : Html msg
navbarView =
    Html.ul
        [ Attr.class "flex"
        ]
        [ Html.li []
            [ Html.a
                [ Attr.href "/"
                ]
                [ Html.text "Home" ]
            ]
        ]
```

Note that the imports in our module are used for the auto-generated Elm code.
So be sure to set up your imports the way you like them before scaffolding a HTML code!


## With `elm-tailwind-modules`

If your imports include modules from [`elm-tailwind-modules`](https://github.com/matheus23/elm-tailwind-modules),
then this fix will turn your `class` attributes into `elm-tailwind-modules` attributes.

```elm
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw

navbarView : Html msg
navbarView =
    Debug.todo """<ul><li><a href="/">Home</a></li></ul>"""
```

## After fix with Tailwind import

```elm
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Tailwind.Breakpoints
import Tailwind.Utilities

navbarView : Html msg
navbarView =
    Html.ul
        [ Attr.css
            [ Tailwind.Utilities.flex
            ]
        ]
        [ Html.li []
            [ Html.a
                [ Attr.href "/"
                ]
                [ text "Home" ]
            ]
        ]
```

Note that the example that first example didn't have `import Tailwind.Utilities`, and therefore `class="flex"` was
interpreted as a plain CSS class, not a Tailwind class.



## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template dillonkearns/elm-review-html-to-elm/example
```
