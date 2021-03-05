module FirstChild exposing (result)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


result =
        div []
          [ div
            [ css
                [ Tw.transform
                , Css.firstChild 
                [ Tw.rotate_45
                ]

                ]

            ]
              [ text "1" ]
        , div
            [ css
                [ Tw.transform
                , Css.firstChild 
                [ Tw.rotate_45
                ]

                ]

            ]
              [ text "2" ]
        , div
            [ css
                [ Tw.transform
                , Css.firstChild 
                [ Tw.rotate_45
                ]

                ]

            ]
              [ text "3" ]
         ]
    
