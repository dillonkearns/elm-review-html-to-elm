module Normalization exposing (main)

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
            [ css
                [ Tw.neg_mt_8
                ]
            ]
            []
        , div
            [ css
                [ Tw.h_1over2
                ]
            ]
            []
        , Svg.svg
            [ SvgAttr.in_ "example"
            , SvgAttr.type_ "foo"
            ]
            [ Svg.path
                [ SvgAttr.fillRule "evenodd"
                , SvgAttr.clipRule "evenodd"
                , SvgAttr.d "M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"
                ]
                []
            ]
        ]
    
