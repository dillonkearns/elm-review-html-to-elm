module Example1 exposing (result)

import Css
import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css)
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw
import Tailwind.Breakpoints as Bp


result =
    {- This example requires Tailwind CSS v2.0+ -}
    div [ css [ Tw.rounded_md, Tw.bg_yellow_50, Tw.p_4 ] ] [ div [ css [ Tw.flex ] ] [ div [ css [ Tw.flex_shrink_0 ] ] [ {- Heroicon name: solid/exclamation -}
    svg [ css [ Tw.h_5, Tw.w_5, Tw.text_yellow_400 ] ,  SvgAttr.viewBox "0 0 20 20" ,  SvgAttr.fill "currentColor" ,  attribute "aria-hidden" "true" ] [ path [ attribute "fill-rule" "evenodd" ,  attribute "d" "M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" ,  attribute "clip-rule" "evenodd" ] [] ] ], div [ css [ Tw.ml_3 ] ] [ h3 [ css [ Tw.text_sm, Tw.font_medium, Tw.text_yellow_800 ] ] [ text "Attention needed" ], div [ css [ Tw.mt_2, Tw.text_sm, Tw.text_yellow_700 ] ] [ p [] [ text "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aliquid pariatur, ipsum similique veniam quo totam eius aperiam dolorum." ] ] ] ] ]
