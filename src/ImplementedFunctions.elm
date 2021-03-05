module ImplementedFunctions exposing (..)

{-| Thank you mbylstra for the code from this repo: <https://github.com/mbylstra/html-to-elm/blob/c3c4b9a3f8c8c8b15150bd04f72ad89c4b11462e/elm-src/HtmlToElm/ElmHtmlWhitelists.elm>
-}


lookup : List String -> String -> Maybe String
lookup list name =
    let
        lowerName =
            String.toLower name
    in
    find (\entry -> String.toLower entry == lowerName) list


find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first

            else
                find predicate rest


cssHelpers : List String
cssHelpers =
    [ "focus"
    , "group"
    , "hover"
    ]


htmlTags =
    [ "body"
    , "section"
    , "nav"
    , "article"
    , "aside"
    , "h1"
    , "h2"
    , "h3"
    , "h4"
    , "h5"
    , "h6"
    , "header"
    , "footer"
    , "address"
    , "p"
    , "hr"
    , "pre"
    , "blockquote"
    , "ol"
    , "ul"
    , "li"
    , "dl"
    , "dt"
    , "dd"
    , "figure"
    , "figcaption"
    , "div"
    , "a"
    , "em"
    , "strong"
    , "small"
    , "s"
    , "cite"
    , "q"
    , "dfn"
    , "abbr"
    , "time"
    , "code"
    , "var"
    , "samp"
    , "kbd"
    , "sub"
    , "sup"
    , "i"
    , "b"
    , "u"
    , "mark"
    , "ruby"
    , "rt"
    , "rp"
    , "bdi"
    , "bdo"
    , "span"
    , "br"
    , "wbr"
    , "ins"
    , "del"
    , "img"
    , "iframe"
    , "embed"
    , "object"
    , "param"
    , "video"
    , "audio"
    , "source"
    , "track"
    , "canvas"
    , "svg"
    , "math"
    , "table"
    , "caption"
    , "colgroup"
    , "col"
    , "tbody"
    , "thead"
    , "tfoot"
    , "tr"
    , "td"
    , "th"
    , "form"
    , "fieldset"
    , "legend"
    , "label"
    , "input"
    , "button"
    , "select"
    , "datalist"
    , "optgroup"
    , "option"
    , "textarea"
    , "keygen"
    , "output"
    , "progress"
    , "meter"
    , "details"
    , "summary"
    , "menuitem"
    , "menu"
    ]


svgTags =
    [ "defs"
    , "clipPath"
    , "path"
    , "g"
    , "svg"
    , "path"
    ]


htmlAttributes =
    [ "key"
    , -- "style",   -- style is disabled as it requires special parsing
      "class"
    , "classList"
    , "id"
    , "title"
    , "type_"
    , "value"
    , "placeholder"
    , "accept"
    , "acceptCharset"
    , "action"
    , "autosave"
    , "enctype"
    , "formaction"
    , "list"
    , "method"
    , "name"
    , "pattern"
    , "for"
    , "form"
    , "max"
    , "min"
    , "step"
    , "wrap"
    , "href"
    , "target"
    , "downloadAs"
    , "hreflang"
    , "media"
    , "ping"
    , "rel"
    , "usemap"
    , "shape"
    , "coords"
    , "src"
    , "alt"
    , "preload"
    , "poster"
    , "kind"
    , "srclang"
    , "sandbox"
    , "srcdoc"
    , "align"
    , "headers"
    , "scope"
    , "charset"
    , "content"
    , "httpEquiv"
    , "language"
    , "accesskey"
    , "contextmenu"
    , "dir"
    , "draggable"
    , "dropzone"
    , "itemprop"
    , "lang"
    , "challenge"
    , "keytype"
    , "cite"
    , "datetime"
    , "pubdate"
    , "manifest"
    , "property"
    , "attribute"
    ]


svgAttributes =
    [ "d"
    , "fill"
    , "viewBox"
    ]



-- not currently used


boolAttributeFunctions =
    [ "hidden"
    , "checked"
    , "selected"
    , "autocomplete"
    , "autofocus"
    , "disabled"
    , "multiple"
    , "novalidate"
    , "readonly"
    , "required"
    , "download"
    , "ismap"
    , "autoplay"
    , "controls"
    , "loop"
    , "default"
    , "seamless"
    , "reversed"
    , "async"
    , "defer"
    , "scoped"
    , "contenteditable"
    , "spellcheck"
    ]



-- not currently used


intAttributeFunctions =
    [ "maxlength"
    , "minlength"
    , "size"
    , "cols"
    , "rows"
    , "height"
    , "width"
    , "start"
    , "colspan"
    , "rowspan"
    , "tabindex"
    ]


reservedWords =
    [ "main"
    , "type"
    ]
