module Colors exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw


main =
    Html.toUnstyled result


result =
    div []
        [ div
            [ css
                [ Tw.bg_color Tw.gray_50
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.gray_100
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.transparent
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.current
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.black
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.white
                ]
            ]
            []
        , div
            [ css
                [ Tw.bg_color Tw.inherit
                ]
            ]
            []
        ]
