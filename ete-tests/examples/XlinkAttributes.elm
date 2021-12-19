module XlinkAttributes exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


main =
    Html.toUnstyled result


result =
    div []
        [ Svg.svg
            [ SvgAttr.viewBox "0 0 160 40"
            ]
            [ Svg.a
                [ SvgAttr.xlinkHref "https://developer.mozilla.org/"
                ]
                [ Svg.node "text"
                    [ SvgAttr.x "10"
                    , SvgAttr.y "25"
                    ]
                    [ text "MDN Web Docs" ]
                ]
            ]
        ,         {-  Design tools sometimes generate svgs with xlink attributes. This is a real-world example.  -}
        Svg.svg
            [ SvgAttr.height "16"
            , SvgAttr.viewBox "0 0 16 16"
            , SvgAttr.width "16"
            ]
            [ Svg.defs []
                [ Svg.circle
                    [ SvgAttr.id "a"
                    , SvgAttr.cx "8"
                    , SvgAttr.cy "8"
                    , SvgAttr.r "8"
                    ]
                    []
                , Svg.mask
                    [ SvgAttr.id "b"
                    , SvgAttr.fill "#fff"
                    , SvgAttr.height "16"
                    , SvgAttr.width "16"
                    , SvgAttr.x "0"
                    , SvgAttr.y "0"
                    ]
                    [ Svg.use
                        [ SvgAttr.xlinkHref "#a"
                        ]
                        []
                    ]
                ]
            , Svg.g
                [ SvgAttr.fill "none"
                , SvgAttr.fillRule "evenodd"
                ]
                [ Svg.use
                    [ SvgAttr.mask "url(#b)"
                    , SvgAttr.stroke "#64696e"
                    , SvgAttr.strokeWidth "2"
                    , SvgAttr.xlinkHref "#a"
                    ]
                    []
                , Svg.g
                    [ SvgAttr.fill "#64696e"
                    ]
                    [ Svg.path
                        [ SvgAttr.d "m8 6c.55228475 0 1-.44386482 1-1 0-.55228475-.44386482-1-1-1-.55228475 0-1 .44386482-1 1 0 .55228475.44386482 1 1 1z"
                        ]
                        []
                    , Svg.path
                        [ SvgAttr.d "m8.75 12v-5h-1.5v5z"
                        ]
                        []
                    ]
                ]
            ]
        ]
    
