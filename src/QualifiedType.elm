module QualifiedType exposing (QualifiedType, TypeAnnotation_(..), TypeOrTypeAlias(..), Type_, ValueConstructor_, create, getTypeData, isPrimitiveType, name)

import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node exposing (Node(..))
import Review.ModuleNameLookupTable as ModuleNameLookupTable exposing (ModuleNameLookupTable)


type QualifiedType
    = QualifiedType
        { qualifiedPath : List String
        , name : String
        }


create : ModuleNameLookupTable -> ModuleName -> Node ( ModuleName, String ) -> Maybe QualifiedType
create moduleNameLookupTable currentModule (Node range ( _, name_ )) =
    case ModuleNameLookupTable.moduleNameAt moduleNameLookupTable range of
        Just [] ->
            Just <| QualifiedType { qualifiedPath = currentModule, name = name_ }

        Just moduleName ->
            Just <| QualifiedType { qualifiedPath = moduleName, name = name_ }

        Nothing ->
            Nothing


qualifiedPath : QualifiedType -> List String
qualifiedPath (QualifiedType a) =
    a.qualifiedPath


name : QualifiedType -> String
name (QualifiedType a) =
    a.name


getTypeData : List ( ModuleName, TypeOrTypeAlias ) -> QualifiedType -> Maybe ( ModuleName, TypeOrTypeAlias )
getTypeData types qualifiedType =
    List.filterMap
        (\( typeModule, type_ ) ->
            if typeModule == qualifiedPath qualifiedType then
                case type_ of
                    TypeValue typeValue ->
                        if typeValue.name == name qualifiedType then
                            Just ( typeModule, type_ )

                        else
                            Nothing

                    TypeAliasValue name_ _ ->
                        if name_ == name qualifiedType then
                            Just ( typeModule, type_ )

                        else
                            Nothing

            else
                Nothing
        )
        types
        |> List.head


type alias Type_ =
    { name : String
    , generics : List String
    , constructors : List ValueConstructor_
    }


{-| Syntax for a custom type value constructor
-}
type alias ValueConstructor_ =
    { name : String
    , arguments : List TypeAnnotation_
    }


type TypeAnnotation_
    = GenericType_ String
    | Typed_ QualifiedType (List TypeAnnotation_)
    | Unit_
    | Tupled_ (List TypeAnnotation_)
    | Record_ (List ( String, TypeAnnotation_ ))
    | GenericRecord_ String (List ( String, TypeAnnotation_ ))
    | FunctionTypeAnnotation_ TypeAnnotation_ TypeAnnotation_


type TypeOrTypeAlias
    = TypeValue Type_
    | TypeAliasValue String (List ( String, TypeAnnotation_ ))


isPrimitiveType : QualifiedType -> Bool
isPrimitiveType qualifiedType =
    case ( qualifiedPath qualifiedType, name qualifiedType ) of
        ( [ "Basics" ], "Int" ) ->
            True

        ( [ "Basics" ], "Float" ) ->
            True

        ( [ "Basics" ], "String" ) ->
            True

        ( [ "Basics" ], "Bool" ) ->
            True

        ( [ "Basics" ], "Maybe" ) ->
            True

        ( [ "Dict" ], "Dict" ) ->
            True

        ( [ "Set" ], "Set" ) ->
            True

        ( [ "Basics" ], "Result" ) ->
            True

        ( [ "List" ], "List" ) ->
            True

        ( [ "Array" ], "Array" ) ->
            True

        _ ->
            False
