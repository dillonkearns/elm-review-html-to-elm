module DoubleQuotesInText exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Tailwind.Theme as Theme


main =
    Html.toUnstyled result


result =
    div []
        [ text "\"Quotation has a certain anomalous feature\" - Quine" ]
    
