module Example3 exposing (main)

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
        {- This example requires Tailwind CSS v2.0+ -}
        div
        [ css
            [ Tw.bg_white
            ]

        ]
          [ div
            [ css
                [ Tw.max_w_7xl
                , Tw.mx_auto
                , Tw.py_24
                , Tw.px_4
                , Bp.lg
                    [ Tw.px_8
                    ]

                , Bp.sm
                    [ Tw.px_6
                    ]

                ]

            ]
              [ div
                [ css
                    [ Bp.sm
                        [ Tw.flex
                        , Tw.flex_col
                        , Tw.hidden
                        ]

                    ]

                ]
                  [ h1
                    [ css
                        [ Tw.text_5xl
                        , Tw.font_extrabold
                        , Tw.text_gray_900
                        , Bp.sm
                            [ Tw.text_center
                            ]

                        ]

                    ]
                      [ text "Pricing Plans" ]
                , p
                    [ css
                        [ Tw.mt_5
                        , Tw.text_xl
                        , Tw.text_gray_500
                        , Bp.sm
                            [ Tw.text_center
                            ]

                        ]

                    ]
                      [ text "Start building for free, then add a site plan to go live. Account plans unlock additional features." ]
                , div
                    [ css
                        [ Tw.relative
                        , Tw.self_center
                        , Tw.mt_6
                        , Tw.bg_gray_100
                        , Tw.rounded_lg
                        , Tw.p_0_dot_5
                        , Tw.flex
                        , Bp.sm
                            [ Tw.mt_8
                            ]

                        ]

                    ]
                      [ button
                        [ Attr.type_ "button"
                        , css
                            [ Tw.relative
                            , Tw.w_1over2
                            , Tw.bg_white
                            , Tw.border_gray_200
                            , Tw.rounded_md
                            , Tw.shadow_sm
                            , Tw.py_2
                            , Tw.text_sm
                            , Tw.font_medium
                            , Tw.text_gray_700
                            , Tw.whitespace_nowrap
                            , Css.focus
                                [ Tw.outline_none
                                , Tw.ring_2
                                , Tw.ring_indigo_500
                                , Tw.z_10
                                ]

                            , Bp.sm
                                [ Tw.w_auto
                                , Tw.px_8
                                ]

                            ]

                        ]
                          [ text "Monthly billing" ]
                    , button
                        [ Attr.type_ "button"
                        , css
                            [ Tw.ml_0_dot_5
                            , Tw.relative
                            , Tw.w_1over2
                            , Tw.border
                            , Tw.border_transparent
                            , Tw.rounded_md
                            , Tw.py_2
                            , Tw.text_sm
                            , Tw.font_medium
                            , Tw.text_gray_700
                            , Tw.whitespace_nowrap
                            , Css.focus
                                [ Tw.outline_none
                                , Tw.ring_2
                                , Tw.ring_indigo_500
                                , Tw.z_10
                                ]

                            , Bp.sm
                                [ Tw.w_auto
                                , Tw.px_8
                                ]

                            ]

                        ]
                          [ text "Yearly billing" ]
                     ]
                 ]
            , div
                [ css
                    [ Tw.mt_12
                    , Tw.space_y_4
                    , Bp.lg
                        [ Tw.max_w_4xl
                        , Tw.mx_auto
                        ]

                    , Bp.sm
                        [ Tw.mt_16
                        , Tw.space_y_0
                        , Tw.grid
                        , Tw.grid_cols_2
                        , Tw.gap_6
                        ]

                    , Bp.xl
                        [ Tw.max_w_none
                        , Tw.mx_0
                        , Tw.grid_cols_4
                        ]

                    ]

                ]
                  [ div
                    [ css
                        [ Tw.border
                        , Tw.border_gray_200
                        , Tw.rounded_lg
                        , Tw.shadow_sm
                        , Tw.divide_y
                        , Tw.divide_gray_200
                        ]

                    ]
                      [ div
                        [ css
                            [ Tw.p_6
                            ]

                        ]
                          [ h2
                            [ css
                                [ Tw.text_lg
                                , Tw.leading_6
                                , Tw.font_medium
                                , Tw.text_gray_900
                                ]

                            ]
                              [ text "Hobby" ]
                        , p
                            [ css
                                [ Tw.mt_4
                                , Tw.text_sm
                                , Tw.text_gray_500
                                ]

                            ]
                              [ text "All the basics for starting a new business" ]
                        , p
                            [ css
                                [ Tw.mt_8
                                ]

                            ]
                              [ span
                                [ css
                                    [ Tw.text_4xl
                                    , Tw.font_extrabold
                                    , Tw.text_gray_900
                                    ]

                                ]
                                  [ text "$12" ]
                            , span
                                [ css
                                    [ Tw.text_base
                                    , Tw.font_medium
                                    , Tw.text_gray_500
                                    ]

                                ]
                                  [ text "/mo" ]
                             ]
                        , a
                            [ Attr.href "#"
                            , css
                                [ Tw.mt_8
                                , Tw.block
                                , Tw.w_full
                                , Tw.bg_gray_800
                                , Tw.border
                                , Tw.border_gray_800
                                , Tw.rounded_md
                                , Tw.py_2
                                , Tw.text_sm
                                , Tw.font_semibold
                                , Tw.text_white
                                , Tw.text_center
                                , Css.hover
                                    [ Tw.bg_gray_900
                                    ]

                                ]

                            ]
                              [ text "Buy Hobby" ]
                         ]
                    , div
                        [ css
                            [ Tw.pt_6
                            , Tw.pb_8
                            , Tw.px_6
                            ]

                        ]
                          [ h3
                            [ css
                                [ Tw.text_xs
                                , Tw.font_medium
                                , Tw.text_gray_900
                                , Tw.tracking_wide
                                , Tw.uppercase
                                ]

                            ]
                              [ text "What's included" ]
                        , ul
                            [ css
                                [ Tw.mt_6
                                , Tw.space_y_4
                                ]

                            ]
                              [ li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Potenti felis, in cras at at ligula nunc." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Orci neque eget pellentesque." ]
                                 ]
                             ]
                         ]
                     ]
                , div
                    [ css
                        [ Tw.border
                        , Tw.border_gray_200
                        , Tw.rounded_lg
                        , Tw.shadow_sm
                        , Tw.divide_y
                        , Tw.divide_gray_200
                        ]

                    ]
                      [ div
                        [ css
                            [ Tw.p_6
                            ]

                        ]
                          [ h2
                            [ css
                                [ Tw.text_lg
                                , Tw.leading_6
                                , Tw.font_medium
                                , Tw.text_gray_900
                                ]

                            ]
                              [ text "Freelancer" ]
                        , p
                            [ css
                                [ Tw.mt_4
                                , Tw.text_sm
                                , Tw.text_gray_500
                                ]

                            ]
                              [ text "All the basics for starting a new business" ]
                        , p
                            [ css
                                [ Tw.mt_8
                                ]

                            ]
                              [ span
                                [ css
                                    [ Tw.text_4xl
                                    , Tw.font_extrabold
                                    , Tw.text_gray_900
                                    ]

                                ]
                                  [ text "$24" ]
                            , span
                                [ css
                                    [ Tw.text_base
                                    , Tw.font_medium
                                    , Tw.text_gray_500
                                    ]

                                ]
                                  [ text "/mo" ]
                             ]
                        , a
                            [ Attr.href "#"
                            , css
                                [ Tw.mt_8
                                , Tw.block
                                , Tw.w_full
                                , Tw.bg_gray_800
                                , Tw.border
                                , Tw.border_gray_800
                                , Tw.rounded_md
                                , Tw.py_2
                                , Tw.text_sm
                                , Tw.font_semibold
                                , Tw.text_white
                                , Tw.text_center
                                , Css.hover
                                    [ Tw.bg_gray_900
                                    ]

                                ]

                            ]
                              [ text "Buy Freelancer" ]
                         ]
                    , div
                        [ css
                            [ Tw.pt_6
                            , Tw.pb_8
                            , Tw.px_6
                            ]

                        ]
                          [ h3
                            [ css
                                [ Tw.text_xs
                                , Tw.font_medium
                                , Tw.text_gray_900
                                , Tw.tracking_wide
                                , Tw.uppercase
                                ]

                            ]
                              [ text "What's included" ]
                        , ul
                            [ css
                                [ Tw.mt_6
                                , Tw.space_y_4
                                ]

                            ]
                              [ li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Potenti felis, in cras at at ligula nunc." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Orci neque eget pellentesque." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Donec mauris sit in eu tincidunt etiam." ]
                                 ]
                             ]
                         ]
                     ]
                , div
                    [ css
                        [ Tw.border
                        , Tw.border_gray_200
                        , Tw.rounded_lg
                        , Tw.shadow_sm
                        , Tw.divide_y
                        , Tw.divide_gray_200
                        ]

                    ]
                      [ div
                        [ css
                            [ Tw.p_6
                            ]

                        ]
                          [ h2
                            [ css
                                [ Tw.text_lg
                                , Tw.leading_6
                                , Tw.font_medium
                                , Tw.text_gray_900
                                ]

                            ]
                              [ text "Startup" ]
                        , p
                            [ css
                                [ Tw.mt_4
                                , Tw.text_sm
                                , Tw.text_gray_500
                                ]

                            ]
                              [ text "All the basics for starting a new business" ]
                        , p
                            [ css
                                [ Tw.mt_8
                                ]

                            ]
                              [ span
                                [ css
                                    [ Tw.text_4xl
                                    , Tw.font_extrabold
                                    , Tw.text_gray_900
                                    ]

                                ]
                                  [ text "$32" ]
                            , span
                                [ css
                                    [ Tw.text_base
                                    , Tw.font_medium
                                    , Tw.text_gray_500
                                    ]

                                ]
                                  [ text "/mo" ]
                             ]
                        , a
                            [ Attr.href "#"
                            , css
                                [ Tw.mt_8
                                , Tw.block
                                , Tw.w_full
                                , Tw.bg_gray_800
                                , Tw.border
                                , Tw.border_gray_800
                                , Tw.rounded_md
                                , Tw.py_2
                                , Tw.text_sm
                                , Tw.font_semibold
                                , Tw.text_white
                                , Tw.text_center
                                , Css.hover
                                    [ Tw.bg_gray_900
                                    ]

                                ]

                            ]
                              [ text "Buy Startup" ]
                         ]
                    , div
                        [ css
                            [ Tw.pt_6
                            , Tw.pb_8
                            , Tw.px_6
                            ]

                        ]
                          [ h3
                            [ css
                                [ Tw.text_xs
                                , Tw.font_medium
                                , Tw.text_gray_900
                                , Tw.tracking_wide
                                , Tw.uppercase
                                ]

                            ]
                              [ text "What's included" ]
                        , ul
                            [ css
                                [ Tw.mt_6
                                , Tw.space_y_4
                                ]

                            ]
                              [ li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Potenti felis, in cras at at ligula nunc." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Orci neque eget pellentesque." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Donec mauris sit in eu tincidunt etiam." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Faucibus volutpat magna." ]
                                 ]
                             ]
                         ]
                     ]
                , div
                    [ css
                        [ Tw.border
                        , Tw.border_gray_200
                        , Tw.rounded_lg
                        , Tw.shadow_sm
                        , Tw.divide_y
                        , Tw.divide_gray_200
                        ]

                    ]
                      [ div
                        [ css
                            [ Tw.p_6
                            ]

                        ]
                          [ h2
                            [ css
                                [ Tw.text_lg
                                , Tw.leading_6
                                , Tw.font_medium
                                , Tw.text_gray_900
                                ]

                            ]
                              [ text "Enterprise" ]
                        , p
                            [ css
                                [ Tw.mt_4
                                , Tw.text_sm
                                , Tw.text_gray_500
                                ]

                            ]
                              [ text "All the basics for starting a new business" ]
                        , p
                            [ css
                                [ Tw.mt_8
                                ]

                            ]
                              [ span
                                [ css
                                    [ Tw.text_4xl
                                    , Tw.font_extrabold
                                    , Tw.text_gray_900
                                    ]

                                ]
                                  [ text "$48" ]
                            , span
                                [ css
                                    [ Tw.text_base
                                    , Tw.font_medium
                                    , Tw.text_gray_500
                                    ]

                                ]
                                  [ text "/mo" ]
                             ]
                        , a
                            [ Attr.href "#"
                            , css
                                [ Tw.mt_8
                                , Tw.block
                                , Tw.w_full
                                , Tw.bg_gray_800
                                , Tw.border
                                , Tw.border_gray_800
                                , Tw.rounded_md
                                , Tw.py_2
                                , Tw.text_sm
                                , Tw.font_semibold
                                , Tw.text_white
                                , Tw.text_center
                                , Css.hover
                                    [ Tw.bg_gray_900
                                    ]

                                ]

                            ]
                              [ text "Buy Enterprise" ]
                         ]
                    , div
                        [ css
                            [ Tw.pt_6
                            , Tw.pb_8
                            , Tw.px_6
                            ]

                        ]
                          [ h3
                            [ css
                                [ Tw.text_xs
                                , Tw.font_medium
                                , Tw.text_gray_900
                                , Tw.tracking_wide
                                , Tw.uppercase
                                ]

                            ]
                              [ text "What's included" ]
                        , ul
                            [ css
                                [ Tw.mt_6
                                , Tw.space_y_4
                                ]

                            ]
                              [ li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Potenti felis, in cras at at ligula nunc." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Orci neque eget pellentesque." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Donec mauris sit in eu tincidunt etiam." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Faucibus volutpat magna." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Id sed tellus in varius quisque." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Risus egestas faucibus." ]
                                 ]
                            , li
                                [ css
                                    [ Tw.flex
                                    , Tw.space_x_3
                                    ]

                                ]
                                  [                                 {- Heroicon name: solid/check -}
                                Svg.svg
                                    [ css
                                        [ Tw.flex_shrink_0
                                        , Tw.h_5
                                        , Tw.w_5
                                        , Tw.text_green_500
                                        ]

                                    , SvgAttr.viewBox "0 0 20 20"
                                    , SvgAttr.fill "currentColor"
                                    , attribute "aria-hidden" "true"
                                    ]
                                      [ Svg.path
                                        [ SvgAttr.fillRule "evenodd"
                                        , SvgAttr.d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                                        , SvgAttr.clipRule "evenodd"
                                        ]
                                          []
                                     ]
                                , span
                                    [ css
                                        [ Tw.text_sm
                                        , Tw.text_gray_500
                                        ]

                                    ]
                                      [ text "Risus cursus ullamcorper." ]
                                 ]
                             ]
                         ]
                     ]
                 ]
             ]
         ]
    
