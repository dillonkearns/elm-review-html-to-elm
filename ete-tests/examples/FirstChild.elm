module FirstChild exposing (main)

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
          [ div []
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
        , div []
              [ div
                [ css
                    [ Tw.transform
                    , Css.nthChild "odd"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "1" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.nthChild "odd"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "2" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.nthChild "odd"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "3" ]
             ]
        , div []
              [ div
                [ css
                    [ Tw.transform
                    , Css.lastChild
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "1" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.lastChild
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "2" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.lastChild
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "3" ]
             ]
        , div []
              [ div
                [ css
                    [ Tw.transform
                    , Css.nthChild "even"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "1" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.nthChild "even"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "2" ]
            , div
                [ css
                    [ Tw.transform
                    , Css.nthChild "even"
                        [ Tw.rotate_45
                        ]

                    ]

                ]
                  [ text "3" ]
             ]
         ]
    
