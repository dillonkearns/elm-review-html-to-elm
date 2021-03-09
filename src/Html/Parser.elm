module Html.Parser exposing
    ( run, runDocument, Node(..), Document, Attribute
    , node, nodeToString, documentToString
    )

{-| Parse HTML 5 in Elm.
See <https://www.w3.org/TR/html5/syntax.html>

@docs run, runDocument, Node, Document, Attribute


# Internals

If you are building a parser of your own using [`elm/parser`][elm-parser] and
you need to parse HTML... This section is for you!

[elm-parser]: https://package.elm-lang.org/packages/elm/parser/latest

@docs node, nodeToString, documentToString

-}

import Dict exposing (Dict)
import Hex
import Html.Parser.NamedCharacterReferences as NamedCharacterReferences
import Parser exposing ((|.), (|=), Parser)


{-| Run the parser!

    run "<div><p>Hello, world!</p></div>"
    -- => Ok [ Element "div" [] [ Element "p" [] [ Text "Hello, world!" ] ] ]

-}
run : String -> Result (List Parser.DeadEnd) (List Node)
run str =
    if String.isEmpty str then
        Ok []

    else
        Parser.run (oneOrMore "node" node) str


{-| Run the parser on an entire HTML document

    runDocument "<!--First comment--><!DOCTYPE html><!--Test stuffs--><html></html><!--Footer comment!-->"
    -- => Ok { preambleComments = ["First comment"], doctype = "", predocComments = ["Test stuffs"], document = ([],[]), postdocComments = ["Footer comment!"] }

-}
runDocument : String -> Result (List Parser.DeadEnd) Document
runDocument =
    Parser.run document



-- Node


{-| An HTML node. It can either be:

  - Text
  - Element (with its **tag name**, **attributes** and **children**)
  - Comment

-}
type Node
    = Text String
    | Element String (List Attribute) (List Node)
    | Comment String


{-| An HTML attribute. For instance:

    ( "href", "https://elm-lang.org" )

-}
type alias Attribute =
    ( String, String )


{-| Parse an HTML node.

You can use this in your own parser to add support for HTML 5.

-}
node : Parser Node
node =
    Parser.oneOf
        [ text
        , comment
        , element
        ]


{-| Turn a parser node back into its HTML string.

For instance:

    Element "a"
        [ ( "href", "https://elm-lang.org" ) ]
        [ Text "Elm" ]
        |> nodeToString

Produces `<a href="https://elm-lang.org">Elm</a>`.

-}
nodeToString : Node -> String
nodeToString node_ =
    case node_ of
        Text text_ ->
            text_

        Element name attributes children ->
            elementToString name attributes children

        Comment comment_ ->
            commentToString comment_



-- Document


{-| An HTML document.

This simply separates the document into its component parts, as defined by the [WHATWG Standard][WHATWG]

[WHATWG]: https://html.spec.whatwg.org/#writing

-}
type alias Document =
    { preambleComments : List String
    , doctype : String
    , predocComments : List String
    , document : ( List Attribute, List Node )
    , postdocComments : List String
    }


{-| Parse an HTML document.

You can use this in your own parsers to yank out complete HTML documents.

Wherever you use it, it will consume any valid trailing whitespace and will parse anything that looks like a valid HTML comment at the end. Be careful with weird encodings!

-}
document : Parser Document
document =
    Parser.succeed Document
        |. Parser.chompWhile isSpaceCharacter
        |= many (Parser.backtrackable commentString |. Parser.chompWhile isSpaceCharacter)
        |= doctype
        |. Parser.chompWhile isSpaceCharacter
        |= many (Parser.backtrackable commentString |. Parser.chompWhile isSpaceCharacter)
        |= documentElement
        |= many (Parser.backtrackable commentString |. Parser.chompWhile isSpaceCharacter)


{-| Turn a document back into its HTML string.

For instance:

    { preambleComments = [ "Early!" ]
    , doctype = "LEGACY \"My legacy string stuff\""
    , predocComments = [ "Teehee!" ]
    , document = ( [], [ Element "p" [] [ Text "Got it." ], Element "br" [] [] ] )
    , postdocComments = [ "Smelly feet" ]
    }
        |> nodeToString

Produces `<!--Early!--><!DOCTYPE html LEGACY \"My legacy string stuff\"><!--Teehee!--><html><p>Got it.</p><br></html><!--Smelly feet-->`.

-}
documentToString : Document -> String
documentToString doc =
    [ List.map commentToString doc.preambleComments
    , List.singleton <| doctypeToString doc.doctype
    , List.map commentToString doc.predocComments
    , List.singleton <| elementToString "html" (Tuple.first doc.document) (Tuple.second doc.document)
    , List.map commentToString doc.postdocComments
    ]
        |> List.concat
        |> String.join ""



-- Text


text : Parser Node
text =
    Parser.oneOf
        [ Parser.getChompedString (chompOneOrMore (\c -> c /= '<' && c /= '&'))
        , characterReference
        ]
        |> oneOrMore "text element"
        |> Parser.map (String.join "" >> Text)


characterReference : Parser String
characterReference =
    Parser.succeed identity
        |. Parser.chompIf ((==) '&')
        |= Parser.oneOf
            [ Parser.backtrackable namedCharacterReference
                |. chompSemicolon
            , Parser.backtrackable numericCharacterReference
                |. chompSemicolon
            , Parser.succeed "&"
            ]


namedCharacterReference : Parser String
namedCharacterReference =
    Parser.getChompedString (chompOneOrMore Char.isAlpha)
        |> Parser.map
            (\reference ->
                Dict.get reference NamedCharacterReferences.dict
                    |> Maybe.withDefault ("&" ++ reference ++ ";")
            )


numericCharacterReference : Parser String
numericCharacterReference =
    let
        codepoint =
            Parser.oneOf
                [ Parser.succeed identity
                    |. Parser.chompIf (\c -> c == 'x' || c == 'X')
                    |= hexadecimal
                , Parser.succeed identity
                    |. Parser.chompWhile ((==) '0')
                    |= Parser.int
                ]
    in
    Parser.succeed identity
        |. Parser.chompIf ((==) '#')
        |= Parser.map (Char.fromCode >> String.fromChar) codepoint



-- Element


element : Parser Node
element =
    Parser.succeed Tuple.pair
        |. Parser.chompIf ((==) '<')
        |= tagName
        |. Parser.chompWhile isSpaceCharacter
        |= tagAttributes
        |> Parser.andThen
            (\( name, attributes ) ->
                if isVoidElement name then
                    Parser.succeed (Element name attributes [])
                        |. Parser.oneOf
                            [ Parser.chompIf ((==) '/')
                            , Parser.succeed ()
                            ]
                        |. Parser.chompIf ((==) '>')

                else
                    Parser.oneOf
                        [ Parser.chompIf ((==) '/')
                            |. Parser.chompIf ((==) '>')
                            |> Parser.map (\_ -> [])
                        , Parser.succeed identity
                            |. Parser.chompIf ((==) '>')
                            |= many (Parser.backtrackable node)
                            |. closingTag name
                        ]
                        |> Parser.map (Element name attributes)
            )


tagName : Parser String
tagName =
    Parser.getChompedString
        (Parser.chompIf Char.isAlphaNum
            |. Parser.chompWhile (\c -> Char.isAlphaNum c || c == '-')
        )
        |> Parser.map String.toLower


tagAttributes : Parser (List Attribute)
tagAttributes =
    many tagAttribute


tagAttribute : Parser Attribute
tagAttribute =
    Parser.succeed Tuple.pair
        |= tagAttributeName
        |. Parser.chompWhile isSpaceCharacter
        |= tagAttributeValue
        |. Parser.chompWhile isSpaceCharacter


tagAttributeName : Parser String
tagAttributeName =
    Parser.getChompedString (chompOneOrMore isTagAttributeCharacter)
        |> Parser.map String.toLower


tagAttributeValue : Parser String
tagAttributeValue =
    Parser.oneOf
        [ Parser.succeed identity
            |. Parser.chompIf ((==) '=')
            |. Parser.chompWhile isSpaceCharacter
            |= Parser.oneOf
                [ tagAttributeUnquotedValue
                , tagAttributeQuotedValue '"'
                , tagAttributeQuotedValue '\''
                ]
        , Parser.succeed ""
        ]


tagAttributeUnquotedValue : Parser String
tagAttributeUnquotedValue =
    let
        isUnquotedValueChar c =
            not (isSpaceCharacter c) && c /= '"' && c /= '\'' && c /= '=' && c /= '<' && c /= '>' && c /= '`' && c /= '&'
    in
    Parser.oneOf
        [ chompOneOrMore isUnquotedValueChar
            |> Parser.getChompedString
        , characterReference
        ]
        |> oneOrMore "attribute value"
        |> Parser.map (String.join "")


tagAttributeQuotedValue : Char -> Parser String
tagAttributeQuotedValue quote =
    let
        isQuotedValueChar c =
            c /= quote && c /= '&'
    in
    Parser.succeed identity
        |. Parser.chompIf ((==) quote)
        |= (Parser.oneOf
                [ Parser.getChompedString (chompOneOrMore isQuotedValueChar)
                , characterReference
                ]
                |> many
                |> Parser.map (String.join "")
           )
        |. Parser.chompIf ((==) quote)


closingTag : String -> Parser ()
closingTag name =
    let
        chompName =
            chompOneOrMore (\c -> not (isSpaceCharacter c) && c /= '>')
                |> Parser.getChompedString
                |> Parser.andThen
                    (\closingName ->
                        if String.toLower closingName == name then
                            Parser.succeed ()

                        else
                            Parser.problem ("closing tag does not match opening tag: " ++ name)
                    )
    in
    Parser.chompIf ((==) '<')
        |. Parser.chompIf ((==) '/')
        |. chompName
        |. Parser.chompWhile isSpaceCharacter
        |. Parser.chompIf ((==) '>')


documentElement : Parser ( List Attribute, List Node )
documentElement =
    element
        |> Parser.andThen
            (\el ->
                case el of
                    Element name attrs nodes ->
                        if name == "html" then
                            Parser.succeed ( attrs, nodes )

                        else
                            Parser.problem ("root element of document was a <" ++ name ++ "> and not <html>")

                    Text _ ->
                        Parser.problem "found raw text instead of a document"

                    Comment _ ->
                        Parser.problem "after parsing all comments, found another comment"
            )


elementToString : String -> List Attribute -> List Node -> String
elementToString name attributes children =
    let
        attributeToString ( attr, value ) =
            attr ++ "=\"" ++ value ++ "\""

        maybeAttributes =
            case attributes of
                [] ->
                    ""

                _ ->
                    " " ++ String.join " " (List.map attributeToString attributes)
    in
    if isVoidElement name then
        String.concat
            [ "<"
            , name
            , maybeAttributes
            , ">"
            ]

    else
        String.concat
            [ "<"
            , name
            , maybeAttributes
            , ">"
            , String.join "" (List.map nodeToString children)
            , "</"
            , name
            , ">"
            ]



-- Comment


comment : Parser Node
comment =
    Parser.map Comment commentString


commentString : Parser String
commentString =
    Parser.succeed Basics.identity
        |. Parser.token "<!"
        |. Parser.token "--"
        |= Parser.getChompedString (Parser.chompUntil "-->")
        |. Parser.token "-->"


commentToString : String -> String
commentToString comment_ =
    "<!--" ++ comment_ ++ "-->"



-- Void elements


isVoidElement : String -> Bool
isVoidElement name =
    List.member name voidElements


voidElements : List String
voidElements =
    [ "area"
    , "base"
    , "br"
    , "col"
    , "embed"
    , "hr"
    , "img"
    , "input"
    , "link"
    , "meta"
    , "param"
    , "source"
    , "track"
    , "wbr"
    ]



-- Character validators


isTagAttributeCharacter : Char -> Bool
isTagAttributeCharacter c =
    not (isSpaceCharacter c) && c /= '"' && c /= '\'' && c /= '>' && c /= '/' && c /= '='


isSpaceCharacter : Char -> Bool
isSpaceCharacter c =
    c == ' ' || c == '\t' || c == '\n' || c == '\u{000D}' || c == '\u{000C}' || c == '\u{00A0}'



-- Doctype


doctype : Parser String
doctype =
    Parser.succeed Basics.identity
        |. Parser.chompIf ((==) '<')
        |. Parser.chompIf ((==) '!')
        |= tagName
        |. chompOneOrMore isSpaceCharacter
        |> Parser.andThen
            (\firstWord ->
                if firstWord /= "doctype" then
                    Parser.problem ("expected DOCTYPE keyword but found \"" ++ firstWord ++ "\" instead")

                else
                    Parser.succeed Basics.identity
                        |= tagName
                        |. Parser.chompWhile isSpaceCharacter
                        |> Parser.andThen
                            (\secondWord ->
                                if secondWord /= "html" then
                                    Parser.problem ("expected \"html\" keyword but found \"" ++ secondWord ++ "\" instead")

                                else
                                    (Parser.getChompedString <| Parser.chompUntil ">")
                                        |. Parser.chompIf ((==) '>')
                            )
            )


doctypeToString : String -> String
doctypeToString str =
    case str of
        "" ->
            "<!DOCTYPE html>"

        _ ->
            "<!DOCTYPE html " ++ str ++ ">"



-- Chomp


chompSemicolon : Parser ()
chompSemicolon =
    Parser.chompIf ((==) ';')


chompOneOrMore : (Char -> Bool) -> Parser ()
chompOneOrMore fn =
    Parser.chompIf fn
        |. Parser.chompWhile fn



-- Types


hexadecimal : Parser Int
hexadecimal =
    chompOneOrMore Char.isHexDigit
        |> Parser.getChompedString
        |> Parser.andThen
            (\hex ->
                case Hex.fromString (String.toLower hex) of
                    Ok value ->
                        Parser.succeed value

                    Err error ->
                        Parser.problem error
            )



-- Loops


many : Parser a -> Parser (List a)
many parser_ =
    Parser.loop []
        (\list ->
            Parser.oneOf
                [ parser_ |> Parser.map (\new -> Parser.Loop (new :: list))
                , Parser.succeed (Parser.Done (List.reverse list))
                ]
        )


oneOrMore : String -> Parser a -> Parser (List a)
oneOrMore type_ parser_ =
    Parser.loop []
        (\list ->
            Parser.oneOf
                [ parser_ |> Parser.map (\new -> Parser.Loop (new :: list))
                , if List.isEmpty list then
                    Parser.problem ("expecting at least one " ++ type_)

                  else
                    Parser.succeed (Parser.Done (List.reverse list))
                ]
        )
