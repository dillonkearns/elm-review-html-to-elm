module Config exposing (..)


type alias Config =
    { htmlAs : ( String, Exposing )
    }


default : Config
default =
    { htmlAs = ( "Html", All )
    }


type Exposing
    = All
    | None
    | Some (List String)


htmlTag : Config -> String -> String
htmlTag config tagName =
    if isExposed tagName (config.htmlAs |> Tuple.second) then
        tagName

    else
        Tuple.first config.htmlAs ++ "." ++ tagName


isExposed : String -> Exposing -> Bool
isExposed tagName exposing_ =
    case exposing_ of
        All ->
            True

        None ->
            False

        Some exposedValues ->
            List.member tagName exposedValues
