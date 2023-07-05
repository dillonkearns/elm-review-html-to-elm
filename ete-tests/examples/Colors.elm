module Colors exposing (main)

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
        [ div
            [ css
                [ Tw.bg_color Theme.gray_50
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.gray_100
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.transparent
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.current
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.black
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.white
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Theme.inherit
                ]
            ]
            []
        ]
    
