module NestedPseudoclassInBreakpoint exposing (main)

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
                [ Tw.bg_color Theme.gray_100
                , Bp.lg
                    [ Tw.bg_color Theme.white
                    , Css.hover 
                        [ Tw.bg_color Theme.gray_200
                        ]
                    ]
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.gray_100
                , Css.hover
                    [ Tw.bg_color Theme.gray_900
                    , Tw.border_color Theme.gray_800
                    ]
                ]
            ]
            []
        ]
    
