module EscapedQuotes exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Tailwind.Theme as Tw


main =
    Html.toUnstyled result


result =
    main_ []
        [ div
            [ Attr.style "background-image" "url(\"avatar.jpg\")"
            ]
            []
        , div
            [ attribute "data-responsive" "[{\n      \"breakpoint\": 1200,\n      \"settings\": {\n      \"slidesToShow\": 5\n      }\n      }]"
            ]
            []
        ]
    
