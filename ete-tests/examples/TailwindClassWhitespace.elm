module TailwindClassWhitespace exposing (main)

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
    main_ []
        [ div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Bp.md
                    [ Tw.flex_row
                    ]
                ]
            ]
            [ text "Single breakpoint" ]
        , div
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Bp.md
                    [ Tw.font_extrabold
                    , Tw.flex_row
                    ]
                ]
            ]
            [ text "Multiple breakpoints" ]
        ]
    
