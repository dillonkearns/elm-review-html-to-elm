module FormattedElm exposing (indentation, indentedThingy)


indentedThingy : Int -> (a -> String) -> List a -> String
indentedThingy indentLevel function list =
    if List.isEmpty list then
        " []"

    else
        (list
            |> List.indexedMap
                (\index element ->
                    if index == 0 then
                        "\n" ++ indentation indentLevel ++ "[ " ++ function element

                    else
                        "\n" ++ indentation indentLevel ++ ", " ++ function element
                )
            |> String.join ""
        )
            ++ "\n"
            ++ indentation indentLevel
            ++ "]"


indentation : Int -> String
indentation level =
    String.repeat (level * 4) " "
